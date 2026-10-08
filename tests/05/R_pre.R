data_dir <- Sys.getenv("BENCHMARK_DATA_DIR", "/benchmark/data")

data_path <- file.path(
    data_dir,
    "2_official_test_3_data_original.csv"
)

data <- utils::read.csv(data_path)

styr_levels <- sort(unique(data$styr))
styr_cols <- paste0("styr_", styr_levels)