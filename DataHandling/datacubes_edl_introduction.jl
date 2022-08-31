using EarthDataLab
using YAXArrays.Datasets: open_mfdataset
using ProgressMeter
using NetCDF
using Plots

# load a dataset from disk

#cgermany = Cube(open_dataset("../data/germanycube.zarr"))

fluxcom_gpp = open_mfdataset("../data/GPP.*.nc")

gpp = Cube(fluxcom_gpp)

using Plots

plot(gpp[lon=30, lat=50][:,1:2])

# Plot the first timestep of GPP
Plots.heatmap(replace(gpp.data[:,:,1,1],-9999=>NaN))

# transpose and count backwards to get the map correctly
Plots.heatmap(replace(gpp.data[:,:,1,1]'[end:-1:1,:],-9999=>NaN))

### Datacubes

#c = esdc()
c = Cube(open_dataset("../data/germanycube.zarr"))

# Cube fields 
c.data

c.axes

# get an axis by name
getAxis("Variable",c)

# get axis values
show(getAxis("Variable",c).values)

# slicing in different dimensions
csmall = c[
    var = ["gross"],
    lon = (10,11),
    lat = (50,51),
    time = 2000:2010]

# or via subsetcube function
csmall = subsetcube(c,
    variable="air_temperature_2m",
    lon=(10,11),
    lat=(51,50),
    time=(Date("2002-01-01"),Date("2008-12-31")))

#?extractLonLats

# extracting specific grid points
ll=[10.1 50.2;
    10.5 51.1;
    10.8 51.1]
llcube = extractLonLats(cgermany,ll)

getAxis(:Variable, llcube).values

plot(getAxis(:Time,llcube).values, llcube[1,:,3:4])

c_msc = getMSC(cgermany)
plot(c_msc[lon = 10,lat = 50, 
    var="gross_primary_productivity"].data)
# also median seasonal cycle
getMedSC(cgermany)

plot(getAxis(:MSC,c_msc).values, c_msc[:,10,10,:])

c_anom = removeMSC(cgermany)

plot(getAxis(:Time,c_anom).values, c_anom[:,10,10,:],
    layout=(4,1),label=permutedims(c_anom.Variable.values))

#?concatenatecubes

#?gapFillMSC

#gapfillpoly

c

c[var="gross"].data .- c[var="net"].data 

using Statistics

methods(mapslices)

#?mapslices

# compute the temporal mean of each variable over regional cube
c_tempmean = mapslices(mean ∘ skipmissing, cgermany; dims="Time")

heatmap(replace(c_tempmean.data, missing => NaN))

c_spatialmean = mapslices(mean ∘ skipmissing, cgermany, dims = ("lon","lat"))

c_mean = mapslices(mean ∘ skipmissing, cgermany, dims = ("lon","lat","time")) 
# attention, this might not work for larger cubes (chunk does not fit into memory)... see OnlineStats with Fabian?

c_mean.data

c_msc

c_latmsc = mapslices(mean ∘ skipmissing, c_msc; dims="lon")

heatmap(c_latmsc.data[:,:,2]')

#?mapCube

# mapCube is similar to mapslices, 
# but takes explicit input dimensions (InDims) 
# and output dimensions (outDims)

id = InDims("Time")
od = OutDims()
#od = OutDims(path="./mgpp.zarr", backend = :zarr, overwrite=true) # if you want to save the output array to disk

r = mapCube(mean, gpp[region="Europe"], indims = id, outdims = od, inplace=false)

# Two input cubes - note that indims needs to be adjusted to also contain two indims. there can be different between cubes

c_cor = mapCube(cor, 
    (cgermany[variable="air_temperature"], cgermany[variable="terrestrial_ecosystem_respiration"]),
    indims = (id, id),
    outdims = od,
    inplace = false
)

# Two input cubes - note that indims needs to be adjusted to also contain two indims. there can be different between cubes

c_cor = mapCube(cor, 
    (cgermany[variable="air_temperature"], cgermany[variable="terrestrial_ecosystem_respiration"]),
    indims = (id, id),
    outdims = od,
    inplace = false
)

#?InDims

#?OutDims

# Let's say we want the two variables in one cube and write a function that can access them there. 
ct = cgermany[variable=["air_temperature","terrestrial_ecosystem_respiration"]]

# We write a correlation function `cubecor` that calculates the correlation between two columns of input `xin`.

function cubecor(xout, xin)
    # index of pairwise complete observations
    idx = .!ismissing.(xin[:,1]) .& .!ismissing.(xin[:,2])
    sum(idx) == 0 && return missing
    # correlation assigned to xout. note the [:] access is important!
    xout[:] .= cor(xin[idx,1],xin[idx,2])
end

# Just for demonstration, a function used with inplace = false (no xout)

function cubecor(xin)
    # index of pairwise complete observations
    idx = .!ismissing.(xin[:,1]) .& .!ismissing.(xin[:,2])
    sum(idx) == 0 && return missing
    # correlation assigned to xout. note the [:] access is important!
    return cor(xin[idx,1],xin[idx,2])
end

# Think about all the data you need to access at once to your calculation:
# The input dimensions to calculate temporal correlation need to be "Time" and "Variable"
id = InDims("Time", "Variable") # the order of dimensions defines the size of xin! -> time in rows, var in cloumns

# Think about the dimension of your output, here: one number. So OutDims is empty!
od = OutDims()

# now put it into mapCube:
ct_cor = mapCube(cubecor, ct, indims = id, outdims = od) 

ct_cor.data

Plots.heatmap(replace(ct_cor.data'[end:-1:1,:],missing=>NaN))

# We write a correlation function `cubecor` that calculates the correlation between two columns of input `xin`.

function cubesummary(xout, xin)
    # index of pairwise complete observations
    idx = .!ismissing.(xin[:,1]) .& .!ismissing.(xin[:,2])
    sum(idx) == 0 && return missing

    xout[1] = cor(xin[idx,1],xin[idx,2])
    xout[2] = length(idx) # number of pairwise complete obs
end

id = InDims("Time", "Variable") # the order of dimensions defines the size of xin! -> time in rows, var in cloumns
# customized OutDims fitting to your function!
od = OutDims(CategoricalAxis("Summary Stats",["Correlation","n_pairwise_obs"]))

# now put it into mapCube:
ct_cor2 = mapCube(cubesummary, ct, indims = id, outdims = od) 

#?RangeAxis

#?CategoricalAxis


