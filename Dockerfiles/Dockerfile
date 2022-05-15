FROM twobombs/cudacluster
#
# install apt packages because 
RUN apt update && apt install cmake libssl-dev && apt clean all
#
# install tensorboard and requisies
RUN pip install --upgrade tensorflow && pip install ipython tensorboard jupyter traitlets nbconvert matplotlib tensorflow jupyter_http_over_ws jupyterlab notebook jupyter-book
# qiskit examples
RUN git clone https://github.com/Qiskit/qiskit-iqx-tutorials.git && mkdir tensorboard-projector && cd tensorboard-projector && wget https://storage.googleapis.com/tensorflow_docs/tensorboard/docs/tensorboard_projector_plugin.ipynb
#
# Install pyqrack + couplings, runtime requirements
RUN pip install --upgrade pyqrack pyzx mitiq ipyparallel pennylane pennylane-qrack qutechopenql mistune cmake
#
RUN git clone https://github.com/vm6502q/pyqrack-jupyter.git 
RUN git clone https://github.com/eclipse/xacc.git && cd xacc && mkdir build && cd build && cmake .. -DXACC_BUILD_EXAMPLES=TRUE -DXACC_BUILD_TESTS=TRUE && make install 
RUN git clone https://github.com/twobombs/thereminq.git
#
# Install SimulaQron 
RUN pip3 install simulaqron
# RUN simulaqron set backend pyqrack

# Install IBM QC connector
RUN pip install -U IBMQuantumExperience
# Install Qiskit
RUN pip install qiskit[visualization]
# Install qc-client WebUI
RUN apt install npm && npm install -g qps-client & apt clean all
#
# convert all ipynb files to python
RUN cd pyqrack-jupyter && jupyter nbconvert --to script *.ipynb
RUN cd qiskit-iqx-tutorials && jupyter nbconvert --to script *.ipynb
#
# make log dir for measured results
RUN mkdir /var/log/thereminq

COPY runfiles/run /root/run
EXPOSE 6080
ENTRYPOINT /root/run
