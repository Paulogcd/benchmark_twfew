#!/usr/bin/env bash

set -euo pipefail

# ============================================================
# Configuration
# ============================================================

IMAGE="benchmark_twfew-python:latest"

TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../tests" && pwd)"
DATA_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../data" && pwd)"
RUNNER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../runners" && pwd)"
RESULTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../results" && pwd)"

REPETITIONS="${REPETITIONS:-10}"
WARMUPS="${WARMUPS:-2}"

TEST="${1:-03}"

# ============================================================
# Checks
# ============================================================

TEST_DIR="${TESTS_DIR}/${TEST}"

if [[ ! -d "${TEST_DIR}" ]]; then
    echo "ERROR: test directory does not exist:"
    echo "  ${TEST_DIR}"
    exit 1
fi

if [[ ! -f "${TEST_DIR}/python_pre.py" ]]; then
    echo "ERROR: missing python_pre.py"
    exit 1
fi

if [[ ! -f "${TEST_DIR}/python_test.py" ]]; then
    echo "ERROR: missing python_test.py"
    exit 1
fi

mkdir -p "${RESULTS_DIR}"

TIMESTAMP="$(date -u +"%Y%m%dT%H%M%SZ")"

OUTPUT_DIR="${RESULTS_DIR}/${TEST}"
mkdir -p "${OUTPUT_DIR}"

RESULTS_FILE="${OUTPUT_DIR}/python_${TIMESTAMP}.jsonl"

echo "========================================"
echo "Scientific benchmark"
echo "========================================"
echo "Language:       python"
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
    python3 \
        /benchmark/runner/python_runner.py \
        /benchmark/test \
        "/benchmark/results/python_${TIMESTAMP}.jsonl" \
        "${REPETITIONS}" \
        "${WARMUPS}"

echo
echo "========================================"
echo "Benchmark finished"
echo "========================================"
echo "Results:"
echo "  ${RESULTS_FILE}"
