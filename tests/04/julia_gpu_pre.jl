using CSV
using DataFrames
using Downloads
using ReadStatTables
using Metal
using TwoWayFEWeights

url = "https://raw.githubusercontent.com/anzonyquispe/did_book/main/cc_xd_didtextbook_2025_9_30/Data%20sets/Pierce%20and%20Schott%202016/pierce_schott_didtextbook.dta"
tmp = Downloads.download(url)
data = ReadStatTables.readstat(tmp)
data = DataFrames.DataFrame(data)

data_1 = DataFrames.DataFrame(indusid = data.indusid, time = 1, Y = 0, D = 0)
data_2 = DataFrames.DataFrame(indusid = data.indusid, time = 2, Y = data.delta2001, D = data.ntrgap)
data = [data_1; data_2]