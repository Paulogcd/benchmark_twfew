# Benchmark Two Way Fixed Effects

This is a folder dedicated to the benchmark of the different versions of the TwoWayFEWeights package, in Stata, R, and Julia.

Its structure is:

```
benchmark_twfew/
│
├── base/
│   └── Dockerfile
│
├── r/
│   └── Dockerfile
│
├── julia/
│   └── Dockerfile
│
├── python/
│   └── Dockerfile
│
├── stata/ # Not yet implemented
│   ├── Dockerfile
│   └── stata-installer/
│
└── tests/
│   ├── 01/
│   ├── 02/
│   └── ...
│
└── results/
│   ├── 01/
│   ├── 02/
│   └── ...
│
└── controller/
    └── ...
````

# Build the images

For more details about the construction of the images, go see the `docker_make.sh` file.

# Run the benchmark

For more details about the construction of the images, go see the `make.sh` file.

# Next steps

- Write all tests successfully
- Include GPU method in benchmark