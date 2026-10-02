#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)

if (length(args) < 3) {
    stop(
        "Usage: R_runner.R TEST_DIR RESULTS_FILE REPETITIONS WARMUPS"
    )
}

test_dir    <- args[[1]]
results_file <- args[[2]]
repetitions <- as.integer(args[[3]])
warmups     <- as.integer(args[[4]])

pre_file  <- file.path(test_dir, "R_pre.R")
test_file <- file.path(test_dir, "R_test.R")

if (!file.exists(pre_file)) {
    stop("Pre-test file does not exist: ", pre_file)
}

if (!file.exists(test_file)) {
    stop("Test file does not exist: ", test_file)
}

dir.create(
    dirname(results_file),
    recursive = TRUE,
    showWarnings = FALSE
)

# ------------------------------------------------------------
# Setup
# ------------------------------------------------------------

cat("Running pre-test:", pre_file, "\n")

source(pre_file)

# ------------------------------------------------------------
# Warm-up
# ------------------------------------------------------------

if (warmups > 0) {

    cat("Running", warmups, "warm-up(s)\n")

    for (i in seq_len(warmups)) {

        cat("Warm-up", i, "/", warmups, "\n")

        source(test_file)
    }
}

# ------------------------------------------------------------
# Benchmark
# ------------------------------------------------------------

cat(
    "Running",
    repetitions,
    "benchmark repetitions\n"
)

for (i in seq_len(repetitions)) {

    cat(
        "Repetition",
        i,
        "/",
        repetitions,
        "\n"
    )

    # High-resolution monotonic-ish elapsed CPU/process timer.
    start <- proc.time()

    source(test_file)

    elapsed <- proc.time() - start

    elapsed_seconds <- unname(elapsed[["elapsed"]])

    result <- list(
        repetition = i,
        elapsed_seconds = elapsed_seconds
    )

    # One JSON object per line.
    # jsonlite is expected to be installed in the R image.
    cat(
        jsonlite::toJSON(
            result,
            auto_unbox = TRUE
        ),
        "\n",
        file = results_file,
        append = TRUE
    )

    cat(
        "Elapsed:",
        sprintf("%.9f", elapsed_seconds),
        "seconds\n"
    )
}

cat("Benchmark complete.\n")
