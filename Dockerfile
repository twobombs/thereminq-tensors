FROM twobombs/cudacluster

# Install pyqrack
RUN pip3 install pyqrack
RUN pip3 install pyzx
RUN pip install mitiq
RUN git clone https://github.com/vm6502q/pyqrack-jupyter.git

# Install SimulaQron 
RUN pip3 install simulaqron
# RUN simulaqron set backend pyqrack

# Install IBM QC connector
RUN pip3 install -U IBMQuantumExperience
# Install Qiskit
RUN pip3 install qiskit

# install tensorboard
RUN pip3 install --user --upgrade tensorflow && pip3 install tensorboard jupyter matplotlib tensorflow jupyter_http_over_ws jupyterlab notebook jupyter-book
# qiskit examples
RUN cd /root && git clone https://github.com/Qiskit/qiskit-iqx-tutorials.git && wget https://storage.googleapis.com/tensorflow_docs/tensorboard/docs/tensorboard_projector_plugin.ipynb

COPY run /root/run
RUN chmod 744 /root/run
EXPOSE 6006 8888
ENTRYPOINT /root/run
