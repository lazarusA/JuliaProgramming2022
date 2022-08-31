using GLMakie, NCDatasets
ds = Dataset("tos_O1_2001-2002.nc")

heatmap(ds["lon"], ds["lat"], ds["tos"][:,:,1])