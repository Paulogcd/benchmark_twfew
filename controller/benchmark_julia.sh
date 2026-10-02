#!/usr/bin/env bash

set -euo pipefail

# ============================================================
# Configuration
# ============================================================

IMAGE="benchmark_twfew-julia:latest"

TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../tests" && pwd)"
DATA_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../data" && pwd)"
RUNNER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../runners" && pwd)"
RESULTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../results" && pwd)"

REPETITIONS="${REPETITIONS:-10}"
WARMUPS="${WARMUPS:-2}"

TEST="${1:-01}"

# ============================================================
# Checks
# ============================================================

TEST_DIR="${TESTS_DIR}/${TEST}"

if [[ ! -d "${TEST_DIR}" ]]; then
    echo "ERROR: test directory does not exist:"
    echo "  ${TEST_DIR}"
    exit 1
fi

if [[ ! -f "${TEST_DIR}/Julia_pre.jl" ]]; then
    echo "ERROR: missing Julia_pre.jl"
    exit 1
fi

if [[ ! -f "${TEST_DIR}/Julia_test.jl" ]]; then
    echo "ERROR: missing Julia_test.jl"
    exit 1
fi

if ! docker image inspect "${IMAGE}" >/dev/null 2>&1; then
    echo
    echo "ERROR: Docker image not found locally:"
    echo "  ${IMAGE}"
    echo
    echo "Available images:"
    docker images
    exit 1
fi

mkdir -p "${RESULTS_DIR}"

TIMESTAMP="$(date -u +"%Y%m%dT%H%M%SZ")"

OUTPUT_DIR="${RESULTS_DIR}/${TEST}"
mkdir -p "${OUTPUT_DIR}"

RESULTS_FILE="${OUTPUT_DIR}/Julia_${TIMESTAMP}.jsonl"

echo "========================================"
echo "Scientific benchmark"
echo "========================================"
echo "Language:       Julia"
echo "Test:           ${TEST}"
echo "Image:          ${IMAGE}"
echo "Warmups:        ${WARMUPS}"
echo "Repetitions:    ${REPETITIONS}"
echo "Results:        ${RESULTS_FILE}"
echo "========================================"

# ============================================================
# Run container
# ============================================================

docker run \
    --rm \
    \
    -v "${TEST_DIR}:/benchmark/test:ro" \
    -v "${DATA_DIR}:/benchmark/data:ro" \
    -v "${RUNNER_DIR}:/benchmark/runner:ro" \
    -v "${OUTPUT_DIR}:/benchmark/results" \
    \
    "${IMAGE}" \
    julia \
        /benchmark/runner/Julia_runner.jl \
        /benchmark/test \
        "/benchmark/results/Julia_${TIMESTAMP}.jsonl" \
        "${REPETITIONS}" \
        "${WARMUPS}"

echo
echo "========================================"
echo "Benchmark finished"
echo "========================================"
echo "Results:"
echo "  ${RESULTS_FILE}"
