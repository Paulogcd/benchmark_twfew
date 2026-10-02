# Benchmark Two Way Fixed Effects

This is a folder dedicated to the benchmark of the different versions of the TwoWayFEWeights package, in Stata, R, and Julia.

Its structure is:

benchmark_twfew/
│
├── base/
│   └── Dockerfile
│
├── r/
│   └── Dockerfile
│
├── julia/
│   ├── Dockerfile
│   ├── Project.toml
│   └── Manifest.toml
│
├── stata/
│   ├── Dockerfile
│   └── stata-installer/
│
└── tests/
└── results/
│
└── controller/
    └── ...

# Build the images

For more details about the construction of the images, go see the `make.sh` file.

