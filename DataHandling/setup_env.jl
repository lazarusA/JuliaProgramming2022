### activate environment and download packages

using Pkg
Pkg.activate("./DataHandling")
Pkg.add(["EarthDataLab", "YAXArrays", "YAXArrayBase"])
Pkg.add(["Dates", "Plots", "Missings", "ProgressMeter", "NetCDF"])
Pkg.add(["OnlineStats", "WeightedOnlineStats"])
Pkg.add(["Zarr", "NetCDF", "ArchGDAL", "DiskArrays", "YAXArrays", "DiskArrayTools"])
### check your environment
Pkg.status()
