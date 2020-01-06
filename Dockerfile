FROM twobombs/cudacluster
RUN pip3 install --user --upgrade tensorflow && pip3 install tensorboard jupyter matplotlib tensorflow jupyter_http_over_ws 
RUN cd /root && git clone https://github.com/Qiskit/qiskit-iqx-tutorials.git
COPY run /root/run
EXPOSE 6006 8888
