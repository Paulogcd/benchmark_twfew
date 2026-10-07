julia_resultat_3 = twowayfeweights(
    data                = data,
    Y                   = "div_rate", 
    G                   = "state",
    T                   = "year",
    D                   = "rel_time1",
    type                = "feTR",
    test_random_weights = "year",
    weights             = weights,
    other_treatments    = other_treatments,
    controls            = controls,
    method              = :Metal
)