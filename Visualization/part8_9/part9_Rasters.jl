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
ds = d[:, end:-1:1]
mesh(Sphere(Point3f(0), 1); color = ds'[end:-1:1,:])

fig = Figure()
ax = LScene(fig[1,1], show_axis=false)
mesh!(ax, Sphere(Point3f(0), 0.99); color = (:white,0.8),
    transparency = true
    )
mesh!(ax, Sphere(Point3f(0), 1); color = ds'[end:-1:1,:])
fig