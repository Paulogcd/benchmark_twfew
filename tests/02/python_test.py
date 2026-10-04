python_resultat_2 = twowayfeweights(
    df,
    Y                   = "lwage",
    G                   = "nr",
    T                   = "year",
    D                   = "union",
    type                = "feTR",
    summary_measures    = True,
    test_random_weights = "educ")