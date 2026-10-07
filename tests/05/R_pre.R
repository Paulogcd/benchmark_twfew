data <- utils::read.csv(
    base::file.path(
        base::dirname(sys.frame(1)$ofile),
        "data",
        "2_official_test_3_data_original.csv"
    )
)
styr_levels <- sort(unique(data$styr))
styr_cols <- paste0("styr_", styr_levels)