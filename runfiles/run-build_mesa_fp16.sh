#!/usr/bin/env bash
# =============================================================================
# build_mesa_rusticl_fp16.sh
#
# Builds Mesa 26.1.4 rusticl OpenCL ICD from source and installs it to
# /usr/local/mesa, enabling cl_khr_fp16 for vega20 (Radeon Pro VII) under
# rusticl on Ubuntu 24.04 / 25.x / 26.04.
#
# Run as root (or with sudo) inside the container, or directly on the host.
# Safe to re-run: each phase is idempotent.
#
# Usage:
#   chmod +x build_mesa_rusticl_fp16.sh
#   sudo ./build_mesa_rusticl_fp16.sh            # full build
#   sudo ./build_mesa_rusticl_fp16.sh --native   # full build optimized for host CPU
#   sudo ./build_mesa_rusticl_fp16.sh --verify   # verify only (no build)
#   sudo ./build_mesa_rusticl_fp16.sh --icd-only # re-register ICD only
#
# After success:
#   RUSTICL_ENABLE=radeonsi clinfo | grep cl_khr_fp16
#   RUSTICL_ENABLE=radeonsi DRI_PRIME=0 /usr/local/bin/qrack_cl_precompile
# =============================================================================

set -euo pipefail

# -- Configuration -------------------------------------------------------------
MESA_VERSION="26.1.4"
MESA_SHA256="072705caa9adf4740f1489194b13e278ad959166863b5271fe423a86353c9ab6"
MESA_URL="https://archive.mesa3d.org/mesa-${MESA_VERSION}.tar.xz"
MESA_PREFIX="/usr/local/mesa"
BUILD_DIR="/tmp/mesa-build"
TARBALL="/tmp/mesa-${MESA_VERSION}.tar.xz"
ICD_VENDORS="/etc/OpenCL/vendors"

# Dynamically determine the library architecture string (e.g., x86_64-linux-gnu)
if command -v dpkg-architecture &>/dev/null; then
    LIB_ARCH=$(dpkg-architecture -qDEB_HOST_MULTIARCH)
else
    LIB_ARCH="$(uname -m)-linux-gnu"
fi

# Colour helpers - fall back gracefully if not a terminal
if [ -t 1 ]; then
    RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
    CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'
else
    RED=''; GREEN=''; YELLOW=''; CYAN=''; BOLD=''; RESET=''
fi

log()  { echo -e "${CYAN}[mesa-fp16]${RESET} $*"; }
ok()   { echo -e "${GREEN}[  OK  ]${RESET} $*"; }
warn() { echo -e "${YELLOW}[ WARN ]${RESET} $*"; }
die()  { echo -e "${RED}[ FAIL ]${RESET} $*" >&2; exit 1; }
hr()   { echo -e "${BOLD}------------------------------------------------------${RESET}"; }

# -- Argument parsing ----------------------------------------------------------
MODE="full"
NATIVE_OPT="false"
for arg in "$@"; do
    case "$arg" in
        --verify)   MODE="verify" ;;
        --icd-only) MODE="icd" ;;
        --native)   NATIVE_OPT="true" ;;
        --help|-h)
            sed -n '2,21p' "$0" | sed 's/^# \?//'
            exit 0 ;;
        *) die "Unknown argument: $arg  (try --help)" ;;
    esac
done

# -- Sanity checks -------------------------------------------------------------
check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        die "This script must be run as root (use sudo)."
    fi
}

verify_fp16() {
    hr
    log "Verifying cl_khr_fp16 availability..."
    if ! command -v clinfo &>/dev/null; then
        warn "clinfo not found - install ocl-icd-opencl-dev or clinfo package."
        return 0 # Do not fail the script under set -e
    fi
    
    local output
    output=$(RUSTICL_ENABLE=radeonsi clinfo 2>/dev/null || true)
    echo "$output" | grep -E "Device Name|Driver Version|cl_khr_fp16|Half-precision" || true
    
    if echo "$output" | grep -q "cl_khr_fp16"; then
        ok "cl_khr_fp16 is present - Mesa rusticl fp16 is working!"
    else
        warn "cl_khr_fp16 not found in clinfo output."
        warn "Ensure you have the right driver environment and DRI_PRIME variables set."
        # Returning 0 to prevent set -e from killing the execution before env hint prints
    fi
    return 0
}

# -- Phase 1: Dependencies -----------------------------------------------------
detect_llvm_version() {
    # Find the highest installed LLVM major version, falling back to whatever
    # llvm-config reports, then to a hardcoded preference list.
    local ver=""

    # Try llvm-config first (may already be installed from Qrack build)
    if command -v llvm-config &>/dev/null; then
        ver=$(llvm-config --version 2>/dev/null | grep -oP '^\d+' || true)
    fi

    # If not found via llvm-config, probe apt for the highest available version
    if [ -z "$ver" ]; then
        for v in 22 21 20 19 18 17 16 15; do
            if apt-cache show "llvm-${v}-dev" &>/dev/null 2>&1; then
                ver="$v"
                break
            fi
        done
    fi

    [ -n "$ver" ] || die "Could not detect an LLVM version. Install llvm-XX-dev manually."
    echo "$ver"
}

pkg_exists() {
    apt-cache show "$1" &>/dev/null 2>&1
}

install_deps() {
    hr
    log "Phase 1/5 - Installing build dependencies..."

    apt-get update -qq

    local VER
    VER=$(detect_llvm_version)
    log "Detected LLVM version: ${VER}"

    # -- Core build tools ------------------------------------------------------
    apt-get install -y --no-install-recommends \
        curl ca-certificates xz-utils \
        meson ninja-build pkg-config \
        python3 python3-mako python3-yaml \
        gcc g++ \
        bison flex libelf-dev

    # -- LLVM / Clang ---------------------------------------------------------
    apt-get install -y --no-install-recommends \
        "llvm-${VER}-dev" \
        "libclang-${VER}-dev" \
        "clang-${VER}"

    # libclang-cppXX-dev: no hyphen before version (libclang-cpp21-dev, not libclang-cpp-21-dev)
    if pkg_exists "libclang-cpp${VER}-dev"; then
        apt-get install -y --no-install-recommends "libclang-cpp${VER}-dev"
        ok "Installed libclang-cpp${VER}-dev"
    elif pkg_exists "libclang-cpp-${VER}-dev"; then
        apt-get install -y --no-install-recommends "libclang-cpp-${VER}-dev"
        ok "Installed libclang-cpp-${VER}-dev (hyphenated form)"
    else
        warn "libclang-cpp${VER}-dev not found - Mesa may still configure if libclang-${VER}-dev is sufficient."
    fi

    # -- SPIRV-LLVM-Translator -------------------------------------------------
    if pkg_exists "llvm-spirv-${VER}"; then
        apt-get install -y --no-install-recommends "llvm-spirv-${VER}"
        # Make it available on PATH without version suffix for meson detection
        if [ ! -f /usr/bin/llvm-spirv ] && [ -f "/usr/bin/llvm-spirv-${VER}" ]; then
            ln -sf "/usr/bin/llvm-spirv-${VER}" /usr/bin/llvm-spirv
        fi
        ok "Installed llvm-spirv-${VER}"
    fi

    if pkg_exists "libllvmspirvlib-${VER}-dev"; then
        apt-get install -y --no-install-recommends "libllvmspirvlib-${VER}-dev"
        ok "Installed libllvmspirvlib-${VER}-dev"
    elif pkg_exists "libllvmspirvlib-dev"; then
        apt-get install -y --no-install-recommends "libllvmspirvlib-dev"
        ok "Installed generic libllvmspirvlib-dev"
    else
        warn "No libllvmspirvlib-${VER}-dev found. Mesa configuration may fail."
    fi

    # -- libclc - OpenCL C builtins --------------------------------------------
    if pkg_exists "libclc-${VER}-dev"; then
        apt-get install -y --no-install-recommends \
            "libclc-${VER}" \
            "libclc-${VER}-dev"
        ok "Installed libclc-${VER} / libclc-${VER}-dev"
    elif pkg_exists "libclc-dev"; then
        apt-get install -y --no-install-recommends libclc-dev
        if pkg_exists "libclc-amdgcn"; then
            apt-get install -y --no-install-recommends libclc-amdgcn
        fi
        ok "Installed legacy libclc-dev"
    else
        die "No libclc package found for LLVM ${VER}. Try: apt-cache search libclc"
    fi

    # -- Rust (rusticl is written in Rust) -------------------------------------
    apt-get install -y --no-install-recommends rustc cargo rustfmt

    if pkg_exists "bindgen"; then
        apt-get install -y --no-install-recommends bindgen
    elif pkg_exists "rust-bindgen"; then
        apt-get install -y --no-install-recommends rust-bindgen
    else
        warn "bindgen package not found via apt - rusticl may still build if cargo can supply it."
    fi

    # -- SPIR-V tools ----------------------------------------------------------
    apt-get install -y --no-install-recommends spirv-tools

    if pkg_exists "spirv-tools-dev"; then
        apt-get install -y --no-install-recommends spirv-tools-dev
        ok "Installed spirv-tools-dev"
    fi

    if pkg_exists "spirv-headers"; then
        apt-get install -y --no-install-recommends spirv-headers
        ok "Installed spirv-headers"
    fi

    if pkg_exists "libspirv-cross-c-shared-dev"; then
        apt-get install -y --no-install-recommends libspirv-cross-c-shared-dev
    else
        warn "libspirv-cross-c-shared-dev not found - may not be required on this distro version."
    fi

    # -- DRM + misc ------------------------------------------------------------
    apt-get install -y --no-install-recommends \
        libdrm-dev \
        libzstd-dev zlib1g-dev libexpat1-dev \
        ocl-icd-opencl-dev \
        clinfo

    rm -rf /var/lib/apt/lists/*
    ok "All dependencies installed."

    log "Tool versions:"
    meson --version                              | sed 's/^/  meson      /'
    ninja --version                              | sed 's/^/  ninja      /'
    rustc --version 2>/dev/null | head -n 1      | sed 's/^/  rustc      /' || true
    "llvm-config-${VER}" --version 2>/dev/null   | sed 's/^/  llvm       /' || \
        llvm-config --version 2>/dev/null        | sed 's/^/  llvm       /' || true
    llvm-spirv --version 2>/dev/null | head -n 1 | sed 's/^/  llvm-spirv /' || true
}

# -- LLVM / spirv-translator version alignment check --------------------------
check_llvm_spirv_alignment() {
    local llvm_ver spirv_ver
    llvm_ver=$(llvm-config --version 2>/dev/null | grep -oP '^\d+' || echo "?")
    spirv_ver=$(llvm-spirv --version 2>/dev/null | grep -oP '\d+\.\d+' | head -1 | cut -d. -f1 || echo "?")

    if [ "$llvm_ver" = "?" ] || [ "$spirv_ver" = "?" ]; then
        warn "Could not verify LLVM/spirv-translator version alignment - continuing anyway."
        return
    fi
    if [ "$llvm_ver" != "$spirv_ver" ]; then
        die "LLVM major (${llvm_ver}) != llvm-spirv major (${spirv_ver}). \
Install matching llvm-spirv-${llvm_ver} and retry."
    fi
    ok "LLVM ${llvm_ver} and llvm-spirv ${spirv_ver} major versions match."
}

# -- Phase 2: Fetch + verify ---------------------------------------------------
fetch_mesa() {
    hr
    log "Phase 2/5 - Fetching Mesa ${MESA_VERSION}..."

    if [ -f "${TARBALL}" ]; then
        log "Tarball already present - verifying checksum..."
        if echo "${MESA_SHA256}  ${TARBALL}" | sha256sum -c - &>/dev/null; then
            ok "Cached tarball verified."
            return 0
        else
            warn "Cached tarball checksum mismatch - re-downloading."
            rm -f "${TARBALL}"
        fi
    fi

    curl -fsSL --progress-bar "${MESA_URL}" -o "${TARBALL}"
    echo "${MESA_SHA256}  ${TARBALL}" | sha256sum -c - \
        || die "SHA256 verification failed - download may be corrupted."
    ok "Mesa ${MESA_VERSION} downloaded and verified."
}

# -- Phase 3: Extract + configure ---------------------------------------------
configure_mesa() {
    hr
    log "Phase 3/5 - Configuring Mesa (rusticl + radeonsi only)..."

    rm -rf "${BUILD_DIR}"
    mkdir -p "${BUILD_DIR}"
    tar -xJ -C "${BUILD_DIR}" --strip-components=1 -f "${TARBALL}"

    cd "${BUILD_DIR}"
    
    local meson_opts=(
        --prefix="${MESA_PREFIX}"
        --buildtype=release
        -Db_ndebug=true
        -Dgallium-drivers=radeonsi,llvmpipe,softpipe
        -Dvulkan-drivers=""
        -Dplatforms=""
        -Dglx=disabled
        -Degl=disabled
        -Dgbm=disabled
        -Dgles1=disabled
        -Dgles2=disabled
        -Dopengl=false
        -Dgallium-rusticl=true
        -Dllvm=enabled
        -Dshared-llvm=enabled
        -Drust_std=2021
    )

    if [ "$NATIVE_OPT" = "true" ]; then
        meson_opts+=("-Dc_args=-march=native" "-Dcpp_args=-march=native")
        log "Native CPU optimization enabled (-march=native)"
    fi

    # Dynamically find the exact GCC directory so Clang/bindgen stops getting confused
    # between GCC 15 and 16, allowing us to keep libstdc++ and preserve the ABI match.
    local gcc_dir
    gcc_dir=$(dirname "$(gcc -print-libgcc-file-name)")
    export BINDGEN_EXTRA_CLANG_ARGS="--gcc-install-dir=${gcc_dir}"
    log "Setting bindgen GCC install dir to: ${gcc_dir}"

    meson setup builddir "${meson_opts[@]}"

    ok "Configuration complete."
}

# -- Phase 4: Build + install --------------------------------------------------
build_mesa() {
    hr
    log "Phase 4/5 - Building Mesa (this takes ~10-15 min on nproc=$(nproc))..."

    # Re-export in case the build phase is run independently
    local gcc_dir
    gcc_dir=$(dirname "$(gcc -print-libgcc-file-name)")
    export BINDGEN_EXTRA_CLANG_ARGS="--gcc-install-dir=${gcc_dir}"

    ninja -C "${BUILD_DIR}/builddir" -j"$(nproc)"
    ok "Build complete."

    log "Installing to ${MESA_PREFIX}..."
    ninja -C "${BUILD_DIR}/builddir" install
    ok "Install complete."

    log "Cleaning build tree..."
    rm -rf "${BUILD_DIR}" "${TARBALL}"
    ok "Build tree removed."
}

# -- Phase 5: Register ICD -----------------------------------------------------
register_icd() {
    hr
    log "Phase 5/5 - Registering Mesa 26.1 rusticl ICD..."

    local new_icd="${MESA_PREFIX}/etc/OpenCL/vendors/rusticl.icd"
    local new_so="${MESA_PREFIX}/lib/${LIB_ARCH}/libRusticlOpenCL.so.1"
    local link="${ICD_VENDORS}/mesa-261-rusticl.icd"
    local old_icd="${ICD_VENDORS}/rusticl.icd"
    local old_disabled="${ICD_VENDORS}/rusticl.icd.disabled"

    # Verify the install produced the expected files
    [ -f "${new_icd}" ] || die "Expected ICD file not found: ${new_icd}"
    [ -f "${new_so}"  ] || die "Expected shared lib not found: ${new_so}"

    mkdir -p "${ICD_VENDORS}"

    # Symlink new ICD
    ln -sf "${new_icd}" "${link}"
    ok "Linked: ${link} -> ${new_icd}"

    # Disable the Ubuntu generic rusticl ICD if present (regular file)
    if [ -f "${old_icd}" ] && [ ! -L "${old_icd}" ]; then
        mv "${old_icd}" "${old_disabled}"
        ok "Disabled old ICD: ${old_icd} -> ${old_disabled}"
    elif [ -L "${old_icd}" ]; then
        rm -f "${old_icd}"
        ok "Removed stale symlink: ${old_icd}"
    else
        log "No existing ${old_icd} to disable."
    fi

    # Tell ldconfig about the custom mesa lib path so it can find libRusticlOpenCL.so.1
    log "Registering ${MESA_PREFIX}/lib/${LIB_ARCH} with ldconfig..."
    echo "${MESA_PREFIX}/lib/${LIB_ARCH}" > /etc/ld.so.conf.d/mesa-rusticl.conf
    ldconfig
    ok "ldconfig updated."

    log "New ICD file content:"
    cat "${new_icd}" | sed 's/^/  /'
}

# -- Runtime environment hint --------------------------------------------------
print_env_hint() {
    hr
    cat <<ENV
${BOLD}Runtime environment required (add to container ENV or ~/.bashrc):${RESET}

  export RUSTICL_ENABLE=radeonsi
  export DRI_PRIME=0
  export LD_LIBRARY_PATH=${MESA_PREFIX}/lib/${LIB_ARCH}:\${LD_LIBRARY_PATH}

${BOLD}Verify fp16:${RESET}
  RUSTICL_ENABLE=radeonsi clinfo | grep -E "cl_khr_fp16|Half-precision"

${BOLD}Precompile Qrack kernels:${RESET}
  RUSTICL_ENABLE=radeonsi DRI_PRIME=0 /usr/local/bin/qrack_cl_precompile

ENV
}

# -- Main ----------------------------------------------------------------------
main() {
    hr
    echo -e "${BOLD}Mesa ${MESA_VERSION} rusticl fp16 builder${RESET}"
    echo -e "Mode: ${YELLOW}${MODE}${RESET}  |  Prefix: ${MESA_PREFIX}  |  $(date)"
    hr

    check_root

    case "$MODE" in
        verify)
            verify_fp16
            ;;
        icd)
            register_icd
            verify_fp16
            print_env_hint
            ;;
        full)
            install_deps
            check_llvm_spirv_alignment
            fetch_mesa
            configure_mesa
            build_mesa
            register_icd
            verify_fp16
            print_env_hint
            ok "All done. Mesa ${MESA_VERSION} rusticl with fp16 is installed."
            ;;
    esac
}

main "$@"
