using Zarr, YAXArrays, GLMakie
using GeometryBasics
import YAXArrays.Datasets: open_dataset
store ="gs://cmip6/CMIP6/ScenarioMIP/DKRZ/MPI-ESM1-2-HR/ssp585/r1i1p1f1/3hr/tas/gn/v20190710/"
g = zopen(store, consolidated=true)
dset = open_dataset(g);
c = Cube(dset)
d = c.data[:,:,1];
heatmap(c.lon, c.lat, d; colormap = :CMRmap)

ds = replace(d, missing =>NaN)

sphere = uv_normal_mesh(Tesselation(Sphere(Point3f(0), 1), 128))

fig = Figure()
ax = LScene(fig[1,1], show_axis=false)
mesh!(ax, sphere; color = ds'[end:-1:1,:],
    colormap = :seaborn_icefire_gradient)
fig