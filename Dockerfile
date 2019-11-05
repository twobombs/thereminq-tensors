FROM twobombs/cudacluster
RUN pip3 install --user --upgrade tensorflow && pip3 install tensorboard jupyter matplotlib tensorflow jupyter_http_over_ws 
COPY run /root/run
EXPOSE 8888
