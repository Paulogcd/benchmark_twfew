# r/Dockerfile
FROM benchmark_twfew-base:latest

ARG R_VERSION=4.6.1

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        r-base \
        r-base-dev \
    && rm -rf /var/lib/apt/lists/*

# Optional: make R non-interactive
ENV R_DEFAULT_PACKAGES=NULL

WORKDIR /benchmark_twfew

CMD ["R"]

# Dependencies
RUN R -e "utils::install.packages('haven',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "utils::install.packages('TwoWayFEWeights',dependencies=TRUE, repos='http://cran.rstudio.com/')"