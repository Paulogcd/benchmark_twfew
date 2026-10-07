#!/usr/bin/env julia

using Printf

# ============================================================
# Arguments
# ============================================================

if length(ARGS) < 4
    error(
        "Usage: julia_runner.jl TEST_DIR RESULTS_FILE REPETITIONS WARMUPS"
    )
end

test_dir     = ARGS[1]
results_file = ARGS[2]
repetitions  = parse(Int, ARGS[3])
warmups      = parse(Int, ARGS[4])

pre_file  = joinpath(test_dir, "julia_gpu_pre.jl")
test_file = joinpath(test_dir, "julia_gpu_test.jl")

if !isfile(pre_file)
    error("Pre-test file does not exist: $pre_file")
end

if !isfile(test_file)
    error("Test file does not exist: $test_file")
end

mkpath(dirname(results_file))

# ============================================================
# Setup
# ============================================================

println("Running pre-test: $pre_file")

include(pre_file)

# ============================================================
# Warm-up
# ============================================================

if warmups > 0

    println("Running $warmups warm-up(s)")

    for i in 1:warmups

        println("Warm-up $i / $warmups")

        include(test_file)

    end
end

# ============================================================
# Benchmark
# ============================================================

println("Running $repetitions benchmark repetitions")

# Open once and append each observation.
open(results_file, "a") do io

    for i in 1:repetitions

        println("Repetition $i / $repetitions")

        # ----------------------------------------------------
        # Start timer
        # ----------------------------------------------------

        start = time_ns()

        include(test_file)

        # ----------------------------------------------------
        # Stop timer
        # ----------------------------------------------------

        elapsed_seconds = (time_ns() - start) / 1e9

        println(
            "Elapsed: ",
            @sprintf("%.9f", elapsed_seconds),
            " seconds"
        )

        println(
            io,
            "{\"repetition\":$i,\"elapsed_seconds\":$elapsed_seconds}"
        )

        flush(io)
    end
end

println("Benchmark complete.")
