from twowayfeweights import twowayfeweights
import pandas as pd

url = (
    "https://raw.githubusercontent.com/anzonyquispe/did_book/main/"
    "cc_xd_didtextbook_2025_9_30/Data%20sets/"
    "Wolfers%202006/wolfers2006_didtextbook.dta"
)

# Read Stata data
data = pd.read_stata(url)

# Variables
controls            = [f"rel_timeminus{i}" for i in range(1, 10)]
other_treatments    = [f"rel_time{i}" for i in range(2, 16)]
weights             = data["stpop"]
