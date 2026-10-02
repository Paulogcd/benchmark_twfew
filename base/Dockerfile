FROM ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    wget \
    git \
    unzip \
    xz-utils \
    bzip2 \
    gzip \
    tar \
    file \
    procps \
    time \
    numactl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /benchmark_twfew
