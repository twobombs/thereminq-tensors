FROM twobombs/cudacluster:dev
#
# install apt packages because 
RUN apt update && apt install cmake nodejs npm libssl-dev gnome-calculator && apt clean all

# remove python os installed packages that are needed by pip
# RUN apt remove -y python3-distutils
# make sure novnc works
# RUN apt install -y novnc 

# install qps
RUN npm install -g qps-client

# install tensorboard and requisites
RUN apt install -y python3-pip && apt clean all
RUN pip3 install --upgrade pip
# RUN apt remove -y python3-blinker
RUN pip3 install jupytext ipython tensorboard tensorflow_gnn tensorflow-quantum jupyter traitlets nbconvert matplotlib jupyter_http_over_ws jupyterlab notebook jupyter-book && pip cache purge

# qiskit examples
RUN git clone --depth=1 https://github.com/Qiskit/qiskit-iqx-tutorials.git && mkdir tensorboard-projector && cd tensorboard-projector && wget https://storage.googleapis.com/tensorflow_docs/tensorboard/docs/tensorboard_projector_plugin.ipynb
#
# Install pyqrack + couplings, runtime requirements
RUN pip3 install --upgrade pyqrack cirq pyzx mitiq ipyparallel pennylane pennylane-qrack mistune cmake cirq && pip cache purge
# qutechopenql
#
RUN git clone --depth=1 https://github.com/vm6502q/pyqrack-jupyter.git 
RUN git clone --depth=1 https://github.com/twobombs/thereminq-tensors.git
RUN git clone --depth=1 https://github.com/vm6502q/simulator-benchmarks.git
RUN git clone --depth=1 https://github.com/quantumlib/Cirq.git
RUN git clone --depth=1 https://github.com/vm6502q/qiskit-qrack-provider.git
RUN git clone --depth=1 https://github.com/unitaryfund/mitiq.git
RUN git clone --depth=1 https://github.com/NVIDIA/cuQuantum.git
RUN git clone --depth=1 https://github.com/unitaryfund/research
RUN git clone --depth=1 https://github.com/Qiskit/qiskit-metal.git
RUN git clone --depth=1 https://github.com/tensorflow/gnn.git tensorflow_gnn

# Install SimulaQron 
# RUN pip3 install simulaqron
# RUN simulaqron set backend pyqrack

# isntall qiskit[metal/visualisation] requirements
RUN apt update && apt install cmake nodejs npm libssl-dev gnome-calculator && apt clean all
# Install pyqrack + couplings, runtime requirements
RUN pip3 install --upgrade pyqrack && pip cache purge

# Install IBM QC connector
RUN pip3 install -U IBMQuantumExperience && pip cache purge
# Install Qiskit viz + pyqrack provider
RUN pip3 install qiskit[all] qiskit-qrack-provider && pip cache purge

# install munich qc toolkit - will move to other tag when needed -
# RUN pip3 install mqt.problemsolver mqt.bench mqt.ddsim mqt.qecc

# Install qc-client WebUI
RUN apt install npm && npm install -g qps-client & apt clean all
# convert all the ipynb files to python
RUN cd pyqrack-jupyter && jupyter nbconvert --to script *.ipynb
RUN cd qiskit-iqx-tutorials && jupyter nbconvert --to script *.ipynb
RUN cd Cirq/docs/simulate && jupyter nbconvert --to script *.ipynb
#
# convert some of the py files to ipynb for convenience
RUN cd simulator-benchmarks && jupytext --to notebook *.py
# RUN cd mitiq/benchmarks && jupytext --to notebook benchmarks.py

# make log dir for measured results
RUN mkdir /var/log/thereminq

RUN mkdir /root/.ssh
COPY runfiles/run-boards /root/run-boards

EXPOSE 6080
ENTRYPOINT /root/run-boards
