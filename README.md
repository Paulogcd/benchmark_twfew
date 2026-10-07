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


Python fails at test "03":
"""
File "/benchmark/test/python_test.py", line 1, in <module>
    python_resultat_3 = twowayfeweights(
        data                = data,
    ...<8 lines>...
        controls            = controls
    )
  File "/opt/venv/lib/python3.14/site-packages/twowayfeweights/_core.py", line 98, in twowayfeweights
    needed = [Y, G, T, D, *controls, *ots, *rw_vars] + ([D0] if D0 else []) + ([weights] if weights else [])
                                                                                            ^^^^^^^
  File "/opt/venv/lib/python3.14/site-packages/pandas/core/generic.py", line 1501, in __bool__
    raise ValueError(
    ...<2 lines>...
    )
ValueError: The truth value of a Series is ambiguous. Use a.empty, a.bool(), a.item(), a.any() or a.all().
"""

# Tests

Some tests are unstable.

Test 03: python does not finish.
Test 05: only python finishes.
Test 06: R does not finish.

The issues have been identified, and will be added in the future.
