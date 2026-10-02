R_resultat_1 = TwoWayFEWeights::twowayfeweights(
    data                = wagepan,
    Y                   = 'lwage',
    G                   = 'nr',
    T                   = 'year',
    D                   = 'union',
    type                = 'feTR',
    summary_measures    = TRUE,
    test_random_weights = 'educ'
)