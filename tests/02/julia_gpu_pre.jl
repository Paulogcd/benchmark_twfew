using Downloads
using ReadStatTables
using DataFrames
using Metal
using TwoWayFEWeights

repo = "chaisemartinPackages/twowayfeweights/main"
file = "wagepan_twfeweights.dta"
url = "https://raw.githubusercontent.com" * "/" * repo * "/" * file
path = Downloads.download(url)
wagepan = ReadStatTables.readstat(path)
wagepan = DataFrames.DataFrame(wagepan)