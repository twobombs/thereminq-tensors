FROM twobombs/cudacluster

# install tensorboard
RUN pip3 install --user --upgrade tensorflow && pip3 install tensorboard jupyter matplotlib tensorflow jupyter_http_over_ws jupyterlab notebook jupyter-book
# qiskit examples
RUN cd /root && git clone https://github.com/Qiskit/qiskit-iqx-tutorials.git && wget https://storage.googleapis.com/tensorflow_docs/tensorboard/docs/tensorboard_projector_plugin.ipynb

# Install pyqrack + runtime requirement
RUN pip3 install pyqrack
RUN pip3 install pyzx
RUN pip install mitiq
RUN pip install ipyparallel
RUN pip install pennylane
RUN pip install pennylane-qrack
RUN git clone https://github.com/vm6502q/pyqrack-jupyter.git && git clone https://github.com/eclipse/xacc.git

# install quantum-benchmark + reqs.
RUN git clone https://github.com/yardstiq/quantum-benchmarks.git
RUN apt update & apt install -y libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6 & apt clean
RUN wget https://repo.anaconda.com/archive/Anaconda3-2021.11-Linux-x86_64.sh && chmod 744 Anaconda3-2021.11-Linux-x86_64.sh && bash ./Anaconda3-2021.11-Linux-x86_64.sh -b -p $HOME/anaconda3
RUN wget https://julialang-s3.julialang.org/bin/linux/x64/1.7/julia-1.7.2-linux-x86_64.tar.gz && tar -xvzf julia-1.7.2-linux-x86_64.tar.gz && cp -r julia-1.7.2 /opt/ && ln -s /opt/julia-1.7.2/bin/julia /usr/local/bin/julia

RUN cd /quantum-benchmarks && ./bin/benchmark install

# Install SimulaQron 
RUN pip3 install simulaqron
# RUN simulaqron set backend pyqrack

# Install IBM QC connector
RUN pip3 install -U IBMQuantumExperience
# Install Qiskit
RUN pip3 install qiskit[visualization]
# Install qc-client WebUI
RUN apt install npm && npm install -g qps-client & apt clean all

COPY run /root/run
RUN chmod 744 /root/run
EXPOSE 6006 8888
ENTRYPOINT /root/run
