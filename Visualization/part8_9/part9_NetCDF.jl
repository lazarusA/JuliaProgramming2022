using GLMakie
using NetCDF, Downloads

#url = "https://www.unidata.ucar.edu/software/netcdf/examples/tos_O1_2001-2002.nc";
#filename = Downloads.download(url, "tos_O1_2001-2002.nc");
filename = "tos_O1_2001-2002.nc"
# ncinfo(filename)
data = NetCDF.open(filename, "tos")
lon = NetCDF.open(filename, "lon")
lat = NetCDF.open(filename, "lat")
ds = replace(data[:,:,1], 1.0f20=>NaN);
heatmap(lon, lat, ds)

mesh!(Sphere(Point3f(0), 1); color = ds'[end:-1:1,:])

fig = Figure()
ax = LScene(fig[1,1], show_axis=false)
mesh!(ax, Sphere(Point3f(0), 0.99); color = (:white,0.8),
    transparency = true
    )
mesh!(ax, Sphere(Point3f(0), 1); color = ds'[end:-1:1,:])
fig