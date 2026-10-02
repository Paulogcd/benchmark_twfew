R_resultat_2 = TwoWayFEWeights::twowayfeweights(
  data                  = wagepan,
  Y                     = "diff_lwage",
  G                     = "nr",
  T                     = "year",
  D                     = "diff_union",
  type                  = "fdTR",
  D0                    = "union",
  summary_measures      = TRUE,
  test_random_weights   = "educ"
)