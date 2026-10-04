from twowayfeweights import twowayfeweights
import pandas as pd

url = "https://raw.githubusercontent.com/anzonyquispe/did_book/main/cc_xd_didtextbook_2025_9_30/Data%20sets/Pierce%20and%20Schott%202016/pierce_schott_didtextbook.dta"

data = pd.read_stata(url)

data_1 = pd.DataFrame({
    "indusid": data["indusid"],
    "time": 1,
    "Y": 0,
    "D": 0,
})

data_2 = pd.DataFrame({
    "indusid": data["indusid"],
    "time": 2,
    "Y": data["delta2001"],
    "D": data["ntrgap"],
})

data = pd.concat([data_1, data_2], ignore_index = True)
