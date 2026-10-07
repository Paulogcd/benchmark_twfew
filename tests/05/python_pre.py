import os
import pandas as pd
from twowayfeweights import twowayfeweights

data_dir = os.environ.get("BENCHMARK_DATA_DIR", "/benchmark/data")

data_path = os.path.join(
    data_dir,
    "2_official_test_3_data_original.csv",
)

data = pd.read_csv(data_path)

styr_levels = sorted(
    data["styr"].dropna().unique()
)

styr_cols = [
    f"styr_{level}"
    for level in styr_levels
]
