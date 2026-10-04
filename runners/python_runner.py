#!/usr/bin/env python3

import json
import os
import sys
import time
import runpy


# ============================================================
# Arguments
# ============================================================

args = sys.argv[1:]

if len(args) < 4:
    raise SystemExit(
        "Usage: python_runner.py TEST_DIR RESULTS_FILE REPETITIONS WARMUPS"
    )

test_dir = args[0]
results_file = args[1]
repetitions = int(args[2])
warmups = int(args[3])

pre_file = os.path.join(test_dir, "python_pre.py")
test_file = os.path.join(test_dir, "python_test.py")


if not os.path.exists(pre_file):
    raise FileNotFoundError(
        f"Pre-test file does not exist: {pre_file}"
    )

if not os.path.exists(test_file):
    raise FileNotFoundError(
        f"Test file does not exist: {test_file}"
    )


os.makedirs(
    os.path.dirname(results_file),
    exist_ok=True
)


# ============================================================
# Setup
# ============================================================

print(f"Running pre-test: {pre_file}")

namespace = runpy.run_path(pre_file)


# ============================================================
# Warm-up
# ============================================================

if warmups > 0:

    print(f"Running {warmups} warm-up(s)")

    for i in range(1, warmups + 1):

        print(f"Warm-up {i} / {warmups}")

        runpy.run_path(test_file, init_globals=namespace)



# ============================================================
# Benchmark
# ============================================================

print(
    f"Running {repetitions} benchmark repetitions"
)


for i in range(1, repetitions + 1):

    print(
        f"Repetition {i} / {repetitions}"
    )

    # High-resolution monotonic timer.
    start = time.perf_counter()

    runpy.run_path(test_file, init_globals=namespace)

    elapsed_seconds = time.perf_counter() - start

    result = {
        "repetition": i,
        "elapsed_seconds": elapsed_seconds,
    }

    # One JSON object per line.
    with open(
        results_file,
        "a",
        encoding="utf-8",
    ) as f:

        json.dump(
            result,
            f,
            separators=(",", ":"),
        )

        f.write("\n")

    print(
        f"Elapsed: {elapsed_seconds:.9f} seconds"
    )


print("Benchmark complete.")
