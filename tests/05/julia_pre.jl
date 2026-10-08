using CSV
using DataFrames
using TwoWayFEWeights

data_dir = get(ENV, "BENCHMARK_DATA_DIR", "/benchmark/data")

data = CSV.read(
    joinpath(data_dir, "2_official_test_3_data_original.csv"),
    DataFrames.DataFrame
)

styr_cols = ["styr_" * string(x) for x in unique(data.styr)]