using CSV
using DataFrames
using TwoWayFEWeights

data_dir = get(ENV, "BENCHMARK_DATA_DIR", "/benchmark/data")

data = CSV.read(joinpath(data_dir, "2_official_test_3_data_original.csv"), DataFrames.DataFrame)
RCall.rcopy(R"styr_cols <- paste0(\"styr_\", levels(factor(data$styr)))")
styr_cols = RCall.rcopy(R"styr_cols")