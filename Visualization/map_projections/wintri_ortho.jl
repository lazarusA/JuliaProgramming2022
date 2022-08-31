using GLMakie, Rasters
using RasterDataSources, Dates
using CairoMakie
using GeoJSON, GeoMakie
GLMakie.activate!()

r = Raster("../part8_9/tos_O1_2001-2002.nc")
lon = r.dims[1] |> collect
lat = r.dims[2] |> collect
d =  r.data[:,:,1]

lon2 = lon .-180
d2 = Array(circshift(d', (0,90))')

fig = Figure()
ga = GeoAxis(
    fig[1, 1]; # any cell of the figure's layout
    dest = "+proj=wintri",# ortho, wintri  # the CRS in which you want to plot
    lonlims = automatic,
    coastlines = false # plot coastlines from Natural Earth, as a reference.
)
surface!(ga, lon2, lat, d2;
    colormap =:seaborn_icefire_gradient,
    shading=false)
fig

# another example
A = Raster(WorldClim{Climate}, :tavg; month=June)

lon = A.dims[1] |> collect
lat = A.dims[2] |> collect
lon[1] = -180 + 1e-8
lat[end] = -90.0 +1e-8
lat = lat[end:-1:1]

d = replace(A.data[:,end:-1:1,1], -3.4f38=>NaN)
heatmap(lon, lat, d;
    colormap =:seaborn_icefire_gradient)

fig = Figure()
ga = GeoAxis(
    fig[1, 1]; # any cell of the figure's layout
    dest = "+proj=ortho",# ortho, wintri  # the CRS in which you want to plot
    lonlims = automatic,
    coastlines = false # plot coastlines from Natural Earth, as a reference.
)
surface!(ga, lon, lat, d;
    colormap =:seaborn_icefire_gradient,
    shading=false)
fig