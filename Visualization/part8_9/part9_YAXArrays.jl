using GLMakie, NetCDF, YAXArrays
c = Cube("tos_O1_2001-2002.nc")

heatmap(c.lon, c.lat, c.data[:,:,1])