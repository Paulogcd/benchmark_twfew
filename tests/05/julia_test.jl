julia_result_5 = twowayfeweights(
    data                = data,
    Y                   = "changeprestout",
    G                   = "cnty90",
    T                   = "year",
    D                   = "changedailies",
    D0                  = "numdailies",
    type                = "fdTR",
    controls            = styr_cols,
    summary_measures    = true,
)