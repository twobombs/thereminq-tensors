FROM twobombs/cudacluster:2204dev
#
# install apt packages because 
RUN apt update && apt install cmake nodejs npm libssl-dev gnome-calculator && apt clean all

# install qps
RUN npm install -g qps-client

# install and upgrade pip
RUN apt install -y python3-pip && apt clean all
# RUN pip3 install --break-system-packages --upgrade pip && pip cache purge

# install runtime requirements
RUN pip3 install --ignore-installed pyqrack qiskit-qrack-provider && pip cache purge

# RUN pip3 install --ignore-installed pennyLane catalyst 
# RUN pip3 install --ignore-installed pyzx mitiq ipyparallel mistune cmake 
# RUN pip3 install --ignore-installed qiskit[all] qiskit-nature pyscf sparse

# RUN pip3 install --upgrade scikit-build && pip cache purge
# RUN git clone --depth=1 https://github.com/unitaryfund/pennylane-qrack.git && cd pennylane-qrack &&  mkdir _build && cd _build && cmake -DCPP_STD=14 .. && make all -j$(nproc --all) && make install

RUN mkdir notebooks && cd notebooks && mkdir qrack && mkdir nvidia && mkdir uf && mkdir qiskit && mkdir google

# Dan Strano's repo
RUN cd notebooks/qrack && git clone --recursive --depth=1 https://github.com/vm6502q/pyqrack-jupyter.git 
RUN cd notebooks/qrack && git clone --recursive  --depth=1 https://github.com/vm6502q/simulator-benchmarks.git
RUN cd notebooks/qrack && git clone --recursive  --depth=1 https://github.com/vm6502q/qiskit-qrack-provider.git
RUN cd notebooks/qrack && git clone --recursive  --depth=1 https://github.com/vm6502q/pyqrack-examples.git

# NVidia
RUN cd notebooks && git clone --recursive  --depth=1 https://github.com/NVIDIA/cuQuantum.git

# unitary fund
RUN cd notebooks/uf && git clone --recursive  --depth=1 https://github.com/unitaryfund/research
# RUN cd notebooks/uf && git clone --recursive  --depth=1 https://github.com/unitaryfund/mitiq.git
# quantum wednesday 10-7'24 mdopt tests
RUN cd notebooks/uf && git clone --recursive  --depth=1 https://github.com/twobombs/mdopt.git

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

# 2024 tests
RUN cd notebooks && git clone --recursive  --depth=1 https://github.com/twobombs/QRISE2024.git
# integrate own repo
RUN git clone --recursive  --depth=1 https://github.com/twobombs/thereminq-tensors

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
COPY runfiles/run-boards /root/run-boards

EXPOSE 6080
ENTRYPOINT /root/run-nv
