R_resultat_4 = TwoWayFEWeights::twowayfeweights(
    data                = data,
    Y                   = 'Y',
    G                   = 'indusid',
    T                   = 'time',
    D                   = 'D',
    type                = 'feTR',
    summary_measures    = TRUE
)
