python_test_6 = twowayfeweights(
    data        = data,
    Y           = "prestout",
    G           = "cnty90",
    T           = "year",
    D           = "changedailies",
    D0          = "numdailies",
    type        = "fdTR",
    controls    = styr_cols,
)
