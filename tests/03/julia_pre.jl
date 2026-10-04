using Downloads
using ReadStatTables
using DataFrames
using TwoWayFEWeights

url     = "https://raw.githubusercontent.com/anzonyquispe/did_book/main/cc_xd_didtextbook_2025_9_30/Data%20sets/Wolfers%202006/wolfers2006_didtextbook.dta"
tmp     = Downloads.download(url)
data    = ReadStatTables.readstat(tmp)
data    = DataFrames.DataFrame(data)

controls            = ["rel_timeminus$(i)" for i in 1:9]
other_treatments    = ["rel_time$(i)" for i in 2:16]
weights             = data[!, :stpop]