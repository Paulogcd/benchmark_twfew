base::load(url("https://raw.githubusercontent.com/anzonyquispe/did_book/main/cc_xd_didtextbook_2025_9_30/Data%20sets/Pierce%20and%20Schott%202016/pierce_schott_didtextbook.RData")); df <- as.data.frame(df)
# Workaround: fdTR with constant time variable crashes in R.
# Create a 2-period panel and use feTR (equivalent with T=2).
data <- rbind(
    data.frame(indusid = df$indusid, time = 1, Y = 0, D = 0),
    data.frame(indusid = df$indusid, time = 2, Y = df$delta2001, D = df$ntrgap)
)
