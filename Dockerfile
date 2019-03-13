FROM continuumio/anaconda:2018.12 as conda3-mirror

RUN conda install -c anaconda -y conda-build && \
    apt-get update && apt-get install -y curl && \
    # pip install pathlib && \
    mkdir -p /usr/local/src/channel/linux-64 && cp /opt/conda/pkgs/*.tar.bz2 /usr/local/src/channel/linux-64 && \
    conda index /usr/local/src/channel

FROM continuumio/anaconda2:2018.12 as conda2-mirror

RUN conda install -c anaconda -y conda-build && \
    apt-get update && apt-get install -y curl && \
    # pip install pathlib && \
    mkdir -p /usr/local/src/channel/linux-64 && cp /opt/conda/pkgs/*.tar.bz2 /usr/local/src/channel/linux-64 && \
    conda index /usr/local/src/channel

FROM nginx:1.14.0-alpine

COPY --from=conda3-mirror /usr/local/src/channel /usr/share/nginx/html/channel3
COPY --from=conda2-mirror /usr/local/src/channel /usr/share/nginx/html/channel2
RUN mkdir -p /usr/share/nginx/html/channel && \
    cp -r /usr/share/nginx/html/channel3/* /usr/share/nginx/html/channel && \
    cp -r /usr/share/nginx/html/channel2/* /usr/share/nginx/html/channel && \
    rm -r /usr/share/nginx/html/channel3/* && \
    rm -r /usr/share/nginx/html/channel2/*
