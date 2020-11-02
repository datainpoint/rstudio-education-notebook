FROM jupyter/r-notebook

RUN pip install jupyter-rsession-proxy
RUN cd /tmp/ && \
    git clone --depth 1 https://github.com/jupyterhub/jupyter-server-proxy && \
    cd jupyter-server-proxy/jupyterlab-server-proxy && \
    npm install && npm run build && jupyter labextension link . && \
    npm run build && jupyter lab build

# install rstudio-server
USER root
RUN apt-get update && \
    apt-get -y install libssl1.1 libssl-dev && \
    cd /lib/x86_64-linux-gnu && ln -s libssl.so.1.0.0 libssl.so.10 &&  ln -s libcrypto.so.1.0.0 libcrypto.so.10  && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
RUN apt-get update && \
    curl --silent -L --fail https://download2.rstudio.org/rstudio-server-1.1.419-amd64.deb > /tmp/rstudio.deb && \
    echo '24cd11f0405d8372b4168fc9956e0386 /tmp/rstudio.deb' | md5sum -c - && \
    apt-get install -y /tmp/rstudio.deb && \
    rm /tmp/rstudio.deb && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
ENV PATH=$PATH:/usr/lib/rstudio-server/bin
USER $NB_USER
RUN pip install nbgitpuller
