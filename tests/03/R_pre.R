url         <- "https://raw.githubusercontent.com/anzonyquispe/did_book/main/cc_xd_didtextbook_2025_9_30/Data%20sets/Wolfers%202006/wolfers2006_didtextbook.dta"
data        <- haven::read_dta(url)

controls            <- paste0("rel_timeminus", 1:9)
other_treatments    <- paste0("rel_time", 2:16)
weights             <- data$stpop
