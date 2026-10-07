julia_test_6 = twowayfeweights(
    data        = data,
    Y           = "prestout",
    G           = "cnty90",
    T           = "year",
    D           = "numdailies",
    type        = "fdTR",
    controls    = styr_cols,
    method      = :Metal
)