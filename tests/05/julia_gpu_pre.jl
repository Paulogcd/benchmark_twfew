using CSV
using DataFrames
using Metal
using TwoWayFEWeights

data_dir = get(ENV, "BENCHMARK_DATA_DIR", "/benchmark/data")

data = CSV.read(
    joinpath(data_dir, "2_official_test_3_data_original.csv"),
    DataFrame
)

styr_levels = sort(unique(skipmissing(data.styr)))

styr_cols = [
    string("styr_", level)
    for level in styr_levels
]
