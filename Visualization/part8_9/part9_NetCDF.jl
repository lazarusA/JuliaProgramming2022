using GLMakie
using NetCDF, Downloads

#url = "https://www.unidata.ucar.edu/software/netcdf/examples/tos_O1_2001-2002.nc";
#filename = Downloads.download(url, "tos_O1_2001-2002.nc");
filename = "tos_O1_2001-2002.nc"
# ncinfo(filename)
data = NetCDF.open(filename, "tos")
lon = NetCDF.open(filename, "lon")
lat = NetCDF.open(filename, "lat")

heatmap(lon, lat, replace(data[:,:,1], 1.0f20=>NaN))