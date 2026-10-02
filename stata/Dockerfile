# stata/Dockerfile
FROM benchmark_twfew-base:latest

ENV DEBIAN_FRONTEND=noninteractive

# Stata installer supplied separately.
COPY stata-installer/ /tmp/stata-installer/

RUN apt-get update && apt-get install -y --no-install-recommends \
        libncurses6 \
        libx11-6 \
        libxext6 \
        libxrender1 \
        libxt6 \
        libxi6 \
        libxfixes3 \
        libfontconfig1 \
        libfreetype6 \
    && rm -rf /var/lib/apt/lists/*

# Installation command depends on the Stata distribution/version.
# For example, invoke the supplied installer here.
RUN /tmp/stata-installer/install.sh \
    && rm -rf /tmp/stata-installer

WORKDIR /benchmark_twfew

CMD ["stata-mp"]
