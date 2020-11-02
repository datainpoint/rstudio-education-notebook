FROM jupyter/datascience-notebook:95ccda3619d0

RUN python3 -m pip install jupyter-rsession-proxy jupyter-server-proxy
RUN cd /tmp/ && \
    git clone --depth 1 https://github.com/jupyterhub/jupyter-server-proxy && \
    cd jupyter-server-proxy/jupyterlab-server-proxy && \
    npm install && npm run build && jupyter labextension link . && \
    npm run build && jupyter lab build
# install rstudio-server
USER root
RUN apt-get update && \
    apt-get install -y gdebi-core
    curl --silent -L --fail https://download2.rstudio.org/server/bionic/amd64/rstudio-server-1.3.1093-amd64.deb > /tmp/rstudio.deb && \
    #echo '24cd11f0405d8372b4168fc9956e0386 /tmp/rstudio.deb' | md5sum -c - && \
    gdebi /tmp/rstudio.deb && \
    rm /tmp/rstudio.deb && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
ENV PATH=$PATH:/usr/lib/rstudio-server/bin
USER $NB_USER
RUN pip install nbgitpuller
