# julia/Dockerfile
FROM benchmark_twfew-base:latest

ENV JULIA_VERSION=1.13.1 \
    JULIA_HOME=/opt/julia \
    JULIA_DEPOT_PATH=/opt/julia-depot

RUN curl -fsSL \
        "https://julialang-s3.julialang.org/bin/linux/aarch64/1.13/julia-${JULIA_VERSION}-linux-aarch64.tar.gz" \
        -o /tmp/julia.tar.gz \
    && tar -xzf /tmp/julia.tar.gz -C /opt \
    && mv "/opt/julia-${JULIA_VERSION}" "${JULIA_HOME}" \
    && ln -s "${JULIA_HOME}/bin/julia" /usr/local/bin/julia \
    && rm /tmp/julia.tar.gz

RUN mkdir -p "${JULIA_DEPOT_PATH}"

WORKDIR /benchmark_twfew

RUN julia --version

RUN julia -e 'import Pkg; Pkg.add(Pkg.PackageSpec(url="https://github.com/Paulogcd/twowayfeweights.jl/")); using TwoWayFEWeights'

# Does not work, we ignore it for now.
# COPY ../twowayfeweights.jl /opt/twowayfeweights
# RUN julia -e 'import Pkg; Pkg.develop(path="/opt/twowayfeweights"); using TwoWayFEWeights'

RUN julia -e 'import Pkg; Pkg.add("ReadStatTables")'
RUN julia -e 'import Pkg; Pkg.add("DataFrames")'
RUN julia -e 'import Pkg; Pkg.add("CSV")'

RUN julia -e 'using ReadStatTables'
RUN julia -e 'using DataFrames'
RUN julia -e 'using Downloads'
RUN julia -e 'using CSV'
