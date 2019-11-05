FROM twobombs/cudacluster
RUN pip3 install --user --upgrade tensorflow && pip3 install tensorboard 
COPY run /root/run
