using GLMakie, Rasters
using RasterDataSources, Dates
using Downloads

r = Raster("tos_O1_2001-2002.nc")
lon = r.dims[1] |> collect
lat = r.dims[2] |> collect
d =  r.data[:,:,1]
heatmap(lon, lat, r.data[:,:,1])

# normal people

lon2 = lon .-180
d2 = Array(circshift(d', (0,90))')
heatmap(lon2, lat, d2)

# example 2
A = Raster(WorldClim{Climate}, :tavg; month=June)

lon = A.dims[1] |> collect
lat = A.dims[2] |> collect
d = replace(A.data[:,:,1], -3.4f38=>NaN)
heatmap(lon, lat, d;
    colormap =:seaborn_icefire_gradient)

# looks ok, but there is also something there.