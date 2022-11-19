using GLMakie, Zarr, YAXArrays
using Dates, Statistics, Colors
GLMakie.activate!()

store ="gs://cmip6/CMIP6/ScenarioMIP/DKRZ/MPI-ESM1-2-HR/ssp585/r1i1p1f1/3hr/tas/gn/v20190710/"
g = open_dataset(zopen(store, consolidated=true))
c = g["tas"]
# coordinates
lon, lat = c.lon, c.lat
δlon = (lon[2]-lon[1])/2
nlon = lon .- 180 .+ δlon
δx = abs(nlon[2] - nlon[1])
δy = abs(lat[2] - lat[1])
ps = [Point3f(i, j, 0.1*rand()) for i in nlon for j in lat] # fix z close to zero, points in 3d
# select time period
kelvinCube = c[time=(DateTime("2030-01-01"), DateTime("2030-04-01"))]
# download data, usually not needed it, but here is done just to speed up
# the animation proccess.
kelvinCube = readcubedata(kelvinCube) 
tempo = kelvinCube.time # dates
cCube = map(x -> x-273.15, kelvinCube)
idx = Observable(1)
# update data
d = @lift(circshift(cCube.data[:, :, $idx], (192,1)))
mx = maximum(cCube.data[:, :, :])
mn = minimum(cCube.data[:, :, :])
colorrange = (mn, mx)
# update properties
color = @lift([$d[i, j] for (i, _) in enumerate(nlon) for (j, _) in enumerate(lat)])
markersize = @lift(Vec3f.(δx - 0.0 * δx, δy - 0.0 * δy, $color))
marker = Rect3f(Vec3f(-0.5, -0.5, 0.0), Vec3f(1))
colormap = :seaborn_icefire_gradient

set_theme!(theme_black(), resolution=(1600,900))
fig = Figure()
ax1 = LScene(fig[1,1], show_axis=false)
ax2 = LScene(fig[1,2], show_axis=false)
meshscatter!(ax1, ps; color, marker, markersize, colormap, colorrange)
meshscatter!(ax2, ps; color, marker, markersize, colormap, colorrange)
Label(fig[1,1:2, BottomLeft()], "CMIP6/ScenarioMIP/DKRZ/MPI-ESM1-2-HR",
    halign=:left, tellwidth=false, textsize= 24, color = :grey)
Label(fig[1,1:2, Top()], @lift("Near-Surface Air Temperature, $(tempo[$idx])"), textsize= 32)
Label(fig[1,1:2, BottomRight()], "Visualization by Lazaro Alonso", 
    textsize= 24, color = 1.65colorant"grey", tellwidth=false,halign=:right)
Label(fig[1,1:2, Bottom()], "using GLMakie, Zarr, YAXArrays", color = :white)
fig


record(fig, "t2m_MPI_ESM1_2_HR_2030_01_fix.mp4", profile = "main") do io
    for i in 1:720
        idx[] = i
        recordframe!(io)  # record a new frame
    end
end