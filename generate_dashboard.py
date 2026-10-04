#!/usr/bin/env python3

import json
import re
from pathlib import Path
from datetime import datetime, timezone


ROOT = Path(__file__).resolve().parent
RESULTS_DIR = ROOT / "results"
DASHBOARD_DIR = ROOT / "dashboard"
OUTPUT_FILE = DASHBOARD_DIR / "data.js"


def package_name(path: Path) -> str:
    """
    Extract package/language name from filenames such as:

        R_timestamp.jsonl
        python_timestamp.jsonl
        julia_timestamp.jsonl

    Everything before the first '_' is considered the package name.
    """
    stem = path.stem

    displayed_prefixes = {
        "julia_multithreading": "Julia\nmultithreading",
        "julia": "Julia",
        "python": "Python",
        "R": "R",
    }

    for prefix, display_name in displayed_prefixes.items():
        if stem == prefix or stem.startswith(prefix + "_"):
            return display_name

    return stem.split("_", 1)[0]


def benchmark_name(path: Path) -> str:
    """
    The first directory below results/ is used as the benchmark name.

        results/01/foo.jsonl -> "01"
        results/02/foo.jsonl -> "02"
    """
    relative = path.relative_to(RESULTS_DIR)
    return relative.parts[0] if len(relative.parts) > 1 else "unknown"


def read_jsonl(path: Path):
    """Read benchmark measurements from a JSONL file."""
    measurements = []

    with path.open("r", encoding="utf-8") as f:
        for line_number, line in enumerate(f, start=1):
            line = line.strip()

            if not line:
                continue

            try:
                record = json.loads(line)
            except json.JSONDecodeError as exc:
                print(
                    f"Warning: invalid JSON in {path}:{line_number}: {exc}"
                )
                continue

            if "elapsed_seconds" not in record:
                print(
                    f"Warning: no elapsed_seconds in "
                    f"{path}:{line_number}"
                )
                continue

            measurements.append({
                "repetition": record.get("repetition"),
                "elapsed_seconds": record["elapsed_seconds"],
            })

    return measurements


def main():
    DASHBOARD_DIR.mkdir(parents=True, exist_ok=True)

    results = []

    files = sorted(RESULTS_DIR.rglob("*.jsonl"))

    if not files:
        raise SystemExit(
            f"No .jsonl files found in {RESULTS_DIR}"
        )

    for path in files:
        measurements = read_jsonl(path)

        if not measurements:
            continue

        results.append({
            "benchmark": benchmark_name(path),
            "package": package_name(path),
            "file": str(path.relative_to(ROOT)),
            "measurements": measurements,
        })

    data = {
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "results": results,
    }

    # json.dumps gives us valid JavaScript as well as valid JSON.
    javascript = (
        "// This file is generated automatically. Do not edit.\n"
        f"window.BENCHMARK_DATA = {json.dumps(data, indent=2)};\n"
    )

    OUTPUT_FILE.write_text(javascript, encoding="utf-8")

    print(f"Found {len(files)} JSONL files.")
    print(f"Loaded {len(results)} benchmark result sets.")
    print(f"Generated: {OUTPUT_FILE}")


if __name__ == "__main__":
    main()
