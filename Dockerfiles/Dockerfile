FROM twobombs/cudacluster:2204dev
#
# install apt packages because 
RUN apt update && apt install cmake nodejs npm libssl-dev gnome-calculator && apt clean all

# install qps
RUN npm install -g qps-client

# install and upgrade pip
RUN apt install -y python3-pip && apt clean all
# RUN pip3 install --break-system-packages --upgrade pip && pip cache purge

# GVirtuS < broken >
#RUN apt-get install -y build-essential cmake librdmacm-dev libibverbs-dev libxmu-dev libxi-dev libgl-dev libosmesa-dev git liblog4cplus-dev cudnn && apt clean all
#RUN git clone -b qrack_update https://github.com/vm6502q/GVirtuS.git && cd /GVirtuS && mkdir build && cd build && cmake .. && make -j $(grep -c ^processor /proc/cpuinfo) all && make -j $(grep -c ^processor /proc/cpuinfo) all install
#RUN export GVIRTUS_HOME=/root/GVirtuS
#RUN export LD_LIBRARY_PATH=${GVIRTUS_HOME}/lib:${GVIRTUS_HOME}/lib/frontend:${LD_LIBRARY_PATH}
# $GVIRTUS_HOME/bin/gvirtus-backend ${GVIRTUS_HOME}/etc/properties.json

# fetch alloy
RUN apt install -y portaudio19-dev alsa-oss pulseaudio && apt clean all && git clone https://github.com/svpino/alloy-voice-assistant.git && cd alloy-voice-assistant && pip install -r requirements.txt && pip cache purge

# install runtime requirements
RUN pip3 install --ignore-installed pyqrack qiskit-qrack-provider && pip cache purge

# RUN pip3 install --ignore-installed pennyLane catalyst 
# RUN pip3 install --ignore-installed pyzx ipyparallel mistune cmake 
RUN pip3 install --ignore-installed qiskit[all] qiskit-nature qiskit_aer qiskit_algorithms pyscf sparse

# RUN pip3 install --upgrade scikit-build && pip cache purge
# RUN git clone --depth=1 https://github.com/unitaryfund/pennylane-qrack.git && cd pennylane-qrack &&  mkdir _build && cd _build && cmake -DCPP_STD=14 .. && make all -j$(nproc --all) && make install

# clone qrack repo for specia high-qubit edition
RUN git clone --depth=1 --recursive https://github.com/unitaryfund/qrack.git
# install qrack compile features
RUN apt-get update && apt-get -y install build-essential cmake openssh-server wget vim-common opencl-headers curl libfreetype6-dev autotools-dev libicu-dev libbz2-dev libboost-all-dev && apt-get clean all
# Qrack install with high qubit dependancies 
RUN cd /qrack/include && mkdir CL && cd /qrack && mkdir _build && cd _build && cmake -DENABLE_DEVRAND=ON -DENABLE_RDRAND=OFF -DQBCAPPOW=8 -DUINTPOW=6 -DFPPOW=5 .. && make -i -k -j $(grep -c ^processor /proc/cpuinfo) all && make install

# Create notebook repos
RUN mkdir notebooks && cd notebooks && mkdir qrack && mkdir nvidia && mkdir uf && mkdir qiskit && mkdir google && mkdir thereminq

# Dan Strano's repo
RUN cd notebooks/qrack && git clone --recursive --depth=1 https://github.com/vm6502q/pyqrack-jupyter.git 
RUN cd notebooks/qrack && git clone --recursive  --depth=1 https://github.com/vm6502q/simulator-benchmarks.git
RUN cd notebooks/qrack && git clone --recursive  --depth=1 https://github.com/vm6502q/qiskit-qrack-provider.git
RUN cd notebooks/qrack && git clone --recursive  --depth=1 https://github.com/vm6502q/pyqrack-examples.git

# NVidia
RUN cd notebooks && git clone --recursive  --depth=1 https://github.com/NVIDIA/cuQuantum.git

# unitary fund
RUN cd notebooks/uf && git clone --recursive  --depth=1 https://github.com/unitaryfund/research
RUN cd notebooks/uf && git clone --recursive  --depth=1 https://github.com/unitaryfund/mitiq.git
# quantum wednesday 10-7'24 mdopt tests
RUN cd notebooks/uf && git clone --recursive  --depth=1 https://github.com/twobombs/mdopt.git
RUN cd notebooks/uf && git clone --recursive  --depth=1 https://github.com/twobombs/QRISE2024.git

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

# QAOA ADAPT
RUN cd notebooks/ && git clone --recursive --depth=1 https://github.com/Hitachi-Cambridge/PaperDynamicADAPT-QAOA-Data.git

# IBM QC benchmarks
RUN cd notebooks && git clone --recursive  --depth=1 https://git.zib.de/qopt/qoblib-quantum-optimization-benchmarking-library.git

# highly experimental quantum energy teleportation algo
RUN cd notebooks && git clone --recursive  --depth=1 https://github.com/IKEDAKAZUKI/Quantum-Energy-Teleportation.git

# install qiskit[metal/visualisation] tooling
RUN apt update && apt install cmake nodejs npm libssl-dev gnome-calculator && apt clean all

# Install IBM QC connector
RUN pip3 install -U IBMQuantumExperience && pip cache purge

# Install Qiskit viz + pyqrack provider
# RUN pip3 install qiskit[all] qiskit-qrack-provider && pip cache purge

# install munich qc toolkit - will move to other tag when needed -
# RUN pip3 install mqt.problemsolver mqt.bench mqt.ddsim mqt.qecc

# Install qc-client WebUI
# RUN apt install npm && npm install -g qps-client && apt clean all

# make log dir for measured results
RUN mkdir /var/log/thereminq

RUN mkdir /root/.ssh
COPY runfiles/run* /root/
RUN chmod 744 /root/run*

EXPOSE 6080
ENTRYPOINT /root/run-nv
