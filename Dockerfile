FROM jupyter/r-notebook

RUN pip install jupyter-rsession-proxy
RUN cd /tmp/ && \
    git clone --depth 1 https://github.com/jupyterhub/jupyter-server-proxy && \
    cd jupyter-server-proxy/jupyterlab-server-proxy && \
    npm install && npm run build && jupyter labextension link . && \
    npm run build && jupyter lab build

USER root
RUN apt-get update && \
    apt-get -y install libssl1.0.0 libssl-dev && \
    cd /lib/x86_64-linux-gnu && ln -s libssl.so.1.0.0 libssl.so.10 &&  ln -s libcrypto.so.1.0.0 libcrypto.so.10  && \
    cd /tmp/ && wget https://download2.rstudio.org/server/trusty/amd64/rstudio-server-1.2.5019-amd64.deb &&\
    apt-get install -y /tmp/rstudio-server-1.2.5019-amd64.deb && \
    rm /tmp/rstudio-server-1.2.5019-amd64.deb && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
ENV PATH=$PATH:/usr/lib/rstudio-server/bin
USER $NB_USER
RUN pip install nbgitpuller
