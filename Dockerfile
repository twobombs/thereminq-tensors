FROM twobombs/cudacluster
RUN apt-get update && apt-get install python3-dev python3-pip && pip3 install --user --upgrade pip && pip3 install --user --upgrade tensorflow && pip3 install tensorboard && apt-get clean all
COPY run /root/run
