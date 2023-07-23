FROM twobombs/cudacluster:dev
#
# install apt packages because 

RUN apt update && apt install cmake nodejs npm libssl-dev gnome-calculator && apt clean all
RUN npm install -g qps-client
# install tensorboard and requisies
RUN pip install jupytext ipython tensorboard jupyter covalent traitlets nbconvert matplotlib jupyter_http_over_ws jupyterlab notebook jupyter-book
# qiskit examples
RUN git clone https://github.com/Qiskit/qiskit-iqx-tutorials.git && mkdir tensorboard-projector && cd tensorboard-projector && wget https://storage.googleapis.com/tensorflow_docs/tensorboard/docs/tensorboard_projector_plugin.ipynb
#
# Install pyqrack + couplings, runtime requirements
RUN pip install --upgrade pyqrack cirq pyzx mitiq ipyparallel pennylane pennylane-qrack qutechopenql mistune cmake cirq numpy
#
RUN git clone https://github.com/vm6502q/pyqrack-jupyter.git 
RUN git clone https://github.com/twobombs/thereminq-tensors.git
RUN git clone https://github.com/vm6502q/simulator-benchmarks.git
RUN git clone https://github.com/quantumlib/Cirq.git
RUN git clone https://github.com/vm6502q/qiskit-qrack-provider.git
RUN git clone https://github.com/unitaryfund/mitiq.git
RUN git clone https://github.com/NVIDIA/cuQuantum.git
RUN git clone https://github.com/unitaryfund/research
# RUN git clone https://github.com/Qiskit/qiskit-metal.git
#
# Install SimulaQron 
# RUN pip3 install simulaqron
# RUN simulaqron set backend pyqrack

# Install IBM QC connector
RUN pip install -U IBMQuantumExperience
# Install Qiskit
# RUN pip install qiskit[visualization] qiskit-qrack-provider
# Install Qiskit metal
# RUN cd qiskit-metal && pip install --no-deps -e .

# install munich qc toolkit
RUN pip install mqt.problemsolver mqt.bench mqt.ddsim mqt.qecc

# Install qc-client WebUI
RUN apt install npm && npm install -g qps-client & apt clean all
# convert all the ipynb files to python
RUN cd pyqrack-jupyter && jupyter nbconvert --to script *.ipynb
RUN cd qiskit-iqx-tutorials && jupyter nbconvert --to script *.ipynb
RUN cd Cirq/docs/simulate && jupyter nbconvert --to script *.ipynb
#
# convert some of the py files to ipynb for convenience
RUN cd simulator-benchmarks && jupytext --to notebook *.py
RUN cd mitiq/benchmarks && jupytext --to notebook benchmarks.py

# make log dir for measured results
RUN mkdir /var/log/thereminq

COPY runfiles/run /root/run
EXPOSE 6080
ENTRYPOINT /root/run
