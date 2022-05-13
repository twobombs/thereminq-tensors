FROM twobombs/cudacluster
#
# install apt packages because 
RUN apt update && apt install ipython3 jupyter cmake libssl-dev && apt clean all
#
# install tensorboard and requisies
RUN pip install --upgrade tensorflow && pip install traitlets tensorboard jupyter nbconvert matplotlib tensorflow jupyter_http_over_ws jupyterlab notebook jupyter-book
# qiskit examples
RUN git clone https://github.com/Qiskit/qiskit-iqx-tutorials.git && mkdir tensorboard-projector && cd tensorboard-projector && wget https://storage.googleapis.com/tensorflow_docs/tensorboard/docs/tensorboard_projector_plugin.ipynb
#
# Install pyqrack + couplings, runtime requirements
RUN pip install --upgrade pyqrack pyzx mitiq ipyparallel pennylane pennylane-qrack qutechopenql mistune cmake
#
RUN git clone https://github.com/vm6502q/pyqrack-jupyter.git 
RUN git clone https://github.com/eclipse/xacc.git && cd xacc && mkdir build && cd build && cmake .. -DXACC_BUILD_EXAMPLES=TRUE -DXACC_BUILD_TESTS=TRUE && make install 

# install & setup quantum-benchmark + reqs.
RUN git clone https://github.com/yardstiq/quantum-benchmarks.git
#
RUN apt update & apt install -y libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6 cmake & apt clean
RUN wget https://repo.anaconda.com/archive/Anaconda3-2021.11-Linux-x86_64.sh && chmod 744 Anaconda3-2021.11-Linux-x86_64.sh && bash ./Anaconda3-2021.11-Linux-x86_64.sh -b -p $HOME/anaconda3 && rm Anaconda3-2021.11-Linux-x86_64.sh
RUN wget https://julialang-s3.julialang.org/bin/linux/x64/1.7/julia-1.7.2-linux-x86_64.tar.gz && tar -xvzf julia-1.7.2-linux-x86_64.tar.gz && cp -r julia-1.7.2 /opt/ && ln -s /opt/julia-1.7.2/bin/julia /usr/local/bin/julia
#
RUN cd /quantum-benchmarks && ./bin/benchmark install && ./bin/benchmark setup

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
RUN cd qiskit-iqx-tutorials.git && jupyter nbconvert --to script *.ipynb

COPY run /root/run
RUN chmod 744 /root/run
EXPOSE 6080
ENTRYPOINT /root/run
