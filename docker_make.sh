export DOCKER_DEFAULT_PLATFORM=linux/amd64
docker build prune

docker build -t benchmark_twfew-base ./base
# For ARM
docker build --platform=linux/arm64 --no-cache -t benchmark_twfew-base ./base

# To check: 
docker image inspect benchmark_twfew-base --format '{{.Os}}/{{.Architecture}}'

# R
docker build -t benchmark_twfew-r ./r

# Julia
# docker build -t benchmark_twfew-julia ./julia
# docker build --platform=linux/amd64 --no-cache -t benchmark_twfew-julia ./julia # For AMD64
# For ARM
docker build --platform=linux/arm64 --no-cache -t benchmark_twfew-julia ./julia 

# Python
# For ARM
docker build --platform=linux/arm64 --no-cache -t benchmark_twfew-python ./python

# Stata
docker build -t benchmark_twfew-stata ./stata

bash controller_R.sh
bash controller_julia.sh
bash controller_julia_multithreading.sh
bash controller_python.sh