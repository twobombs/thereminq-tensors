FROM twobombs/cudacluster:2204dev
#
# install apt packages because 
RUN apt update && apt install cmake nodejs npm libssl-dev gnome-calculator bc python3-tk && apt clean all

# pip upgrade
RUN pip install --upgrade pip && pip cache purge

# install qps
RUN npm install -g qps-client

# install separate python 3.14 instance - gemini25
# 1. INSTALL SYSTEM DEPENDENCIES
# Install build tools for compiling Python and git for other tools.
# Also, install python2.7, which is not included by default in modern Ubuntu.
RUN apt-get update && apt-get install -y --no-install-recommends build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev && rm -rf /var/lib/apt/lists/*

ENV PYTHON_VERSION=3.14.0
ENV PYTHON_HOME=/opt/python/${PYTHON_VERSION}
# Download, compile, and install Python using 'altinstall'
RUN wget https://www.python.org/ftp/python/3.14.0/Python-${PYTHON_VERSION}.tar.xz -O /tmp/python.tar.xz && tar -xJf /tmp/python.tar.xz -C /tmp && cd /tmp/Python-${PYTHON_VERSION} && ./configure --prefix=${PYTHON_HOME} && make -j $(nproc) altinstall && rm -rf /tmp/python.tar.xz /tmp/Python-${PYTHON_VERSION}

# install and upgrade pip
RUN apt install -y python3-pip && apt clean all
# RUN pip3 install --break-system-packages --upgrade pip && pip cache purge

# fetch alloy
# RUN apt install -y portaudio19-dev alsa-oss pulseaudio && apt clean all && git clone https://github.com/svpino/alloy-voice-assistant.git && cd alloy-voice-assistant && pip install -r requirements.txt && pip cache purge

# install runtime requirements
RUN pip3 install --ignore-installed pyqrack qiskit-qrack-provider pyqrackising pyopencl && pip cache purge

# RUN pip3 install --ignore-installed pennyLane catalyst 
# RUN pip3 install --ignore-installed pyzx ipyparallel mistune cmake 
RUN pip3 install --ignore-installed qiskit[all] qiskit-nature qiskit_aer qiskit_quimb qiskit_algorithms pyscf sparse

# RUN pip3 install --upgrade scikit-build && pip cache purge
# RUN git clone --depth=1 https://github.com/unitaryfund/pennylane-qrack.git && cd pennylane-qrack &&  mkdir _build && cd _build && cmake -DCPP_STD=14 .. && make all -j$(nproc --all) && make install

# clone qrack repo for specia high-qubit edition
RUN git clone --depth=1 --recursive https://github.com/unitaryfund/qrack.git
RUN cp -r /qrack /qrack64

# install qrack compile features
RUN apt-get update && apt-get -y install build-essential cmake openssh-server wget vim-common opencl-headers curl libfreetype6-dev autotools-dev libicu-dev libbz2-dev libboost-all-dev && apt-get clean all
# Qrack install with high qubit dependancies 
RUN cd /qrack/include && mkdir CL && cd /qrack && mkdir _build && cd _build && cmake -DENABLE_DEVRAND=ON -DENABLE_RDRAND=OFF -DQBCAPPOW=8 -DUINTPOW=6 -DFPPOW=5 .. && make -i -k -j $(grep -c ^processor /proc/cpuinfo) all && make install
# 64Qrack install & dependancies
RUN cd /qrack64/include && mkdir CL && cd /qrack64 && mkdir _build && cd _build && cmake -DENABLE_DEVRAND=ON -DFPPOW=6 -DUINTPOW=6 -DQBCAPPOW=7 -DENABLE_COMPLEX_X2=ON .. && make -i -k -j $(grep -c ^processor /proc/cpuinfo) all 

# Create notebook repos
RUN mkdir notebooks && cd notebooks && mkdir agentics && mkdir qrack && mkdir nvidia && mkdir misc && mkdir uf && mkdir qiskit && mkdir google && mkdir thereminq

# agentics
RUN cd notebooks/agentics && git clone https://github.com/FareedKhan-dev/all-agentic-architectures.git

# Dan Strano's repo
RUN cd notebooks/qrack && git clone --recursive --depth=1 https://github.com/vm6502q/pyqrack-jupyter.git 
RUN cd notebooks/qrack && git clone --recursive  --depth=1 https://github.com/vm6502q/simulator-benchmarks.git
RUN cd notebooks/qrack && git clone --recursive  --depth=1 https://github.com/vm6502q/qiskit-qrack-provider.git
RUN cd notebooks/qrack && git clone --recursive  --depth=1 https://github.com/vm6502q/pyqrack-examples.git
RUN cd notebooks/qrack && git clone --recursive  --depth=1 https://github.com/vm6502q/PyQrackIsing.git && cp /notebooks/qrack/PyQrackIsing/pyqrackising/kernels.cl /usr/local/lib/python3.10/dist-packages/pyqrackising/kernels.cl
# ^ with fix for python 3.10 with cl kernel copy
RUN cd notebooks/qrack && git clone --recursive  --depth=1 https://github.com/unitaryfoundation/qrack.git

# NVidia
RUN cd notebooks/nvidia && git clone --recursive  --depth=1 https://github.com/NVIDIA/cuQuantum.git

# unitary fund
RUN cd notebooks/uf && git clone --recursive  --depth=1 https://github.com/unitaryfund/research
RUN cd notebooks/uf && git clone --recursive  --depth=1 https://github.com/unitaryfund/mitiq.git
# quantum wednesdays
RUN cd notebooks/uf && git clone --recursive  --depth=1 https://github.com/twobombs/mdopt.git
RUN cd notebooks/uf && git clone --recursive  --depth=1 https://github.com/twobombs/QRISE2024.git
RUN cd notebooks/uf && git clone --recursive  --depth=1 https://github.com/csenrui/PauliGST.git
RUN cd notebooks/uf && git clone --recursive  --depth=1 https://github.com/QSAR-UBC/shortalyst.git
RUN cd notebooks/uf && git clone --recursive  --depth=1 https://github.com/Classiq/classiq-library.git

# IBM Qiskit [deprecated] projects
RUN cd notebooks/qiskit && git clone --recursive  --depth=1 https://github.com/Qiskit/qiskit-iqx-tutorials.git
RUN cd notebooks/qiskit && git clone --recursive  --depth=1 https://github.com/Qiskit/qiskit-metal.git
RUN cd notebooks/qiskit && git clone --recursive  --depth=1 https://github.com/qiskit-community/qiskit-nature
RUN cd notebooks/qiskit && git clone --recursive  --depth=1 https://github.com/twobombs/qiskit-qrack-nature
RUN cd notebooks/qiskit && git clone --recursive  --depth=1 https://github.com/qiskit-community/qiskit-community-tutorials.git
RUN cd notebooks/qiskit && git clone --recursive  --depth=1 https://github.com/qiskit-community/qiskit-algorithms.git

# Google
RUN cd notebooks/google && git clone --recursive  --depth=1 https://github.com/quantumlib/Cirq.git
RUN cd notebooks/google && git clone --recursive  --depth=1 https://github.com/tensorflow/gnn.git tensorflow_gnn

# integrate thereminq repos
RUN cd notebooks/thereminq && git clone --recursive  --depth=1 https://github.com/twobombs/thereminq-tensors
RUN cd notebooks/thereminq && git clone --recursive  --depth=1 https://github.com/twobombs/thereminq-examples
RUN cd notebooks/thereminq && git clone --recursive  --depth=1 https://github.com/twobombs/qrackmin

# misc
RUN cd notebooks/misc && git clone --recursive  --depth=1 https://github.com/sebwouters/chemps2
# RUN cd notebooks/misc/chemps2 && mkdir _build && cd _build && CXX=option1 cmake .. -DMKL=option2 -DCMAKE_INSTALL_PREFIX=/option3 -DWITH_MPI=option4 && make && make install
# https://sebwouters.github.io/CheMPS2/sourcecode.html#dependencies
# QAOA ADAPT
RUN cd notebooks/misc && git clone --recursive --depth=1 https://github.com/Hitachi-Cambridge/PaperDynamicADAPT-QAOA-Data.git
# IBM QC benchmarks
# RUN cd notebooks/misc && git clone --recursive  --depth=1 https://git.zib.de/qopt/qoblib-quantum-optimization-benchmarking-library.git
# highly experimental quantum energy teleportation algo
RUN cd notebooks/misc && git clone --recursive  --depth=1 https://github.com/IKEDAKAZUKI/Quantum-Energy-Teleportation.git

# agentic CLI integration and prerequisites - could move further up the stack to mitigate removal of already included packages
RUN apt -y remove nodejs libnode-dev npm && curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - && apt install nodejs && apt clean
RUN cd notebooks && git clone --recursive  --depth=1 https://github.com/google-gemini/gemini-cli && npm install -g @google/gemini-cli
RUN pip install google-generativeai voice-mode && pip cache purge 
COPY runfiles/settings.json /root/.gemini/

# install qiskit[metal/visualisation] tooling
RUN apt update && apt install cmake libssl-dev gnome-calculator && apt clean all

# Install IBM QC connector
RUN pip3 install -U IBMQuantumExperience && pip cache purge

# make log dir for measured results
RUN mkdir /var/log/thereminq

RUN mkdir /root/.ssh
COPY runfiles/run* /root/
RUN chmod 744 /root/run*

EXPOSE 6080
ENTRYPOINT /root/run-nv
