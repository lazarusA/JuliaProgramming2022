using EarthDataLab
using YAXArrays
using YAXArrays.Datasets: open_mfdataset
using ProgressMeter
using NetCDF
using Plots
using Dates
using Plots

# https://github.com/JuliaDataCubes

#######################
### Datacubes
#######################

# load a dataset from disk

# pointer to the dataset
ds_germany = open_dataset("../data/germanycube.zarr")

# make a cube out of it (a YAXArray)
cgermany = Cube(ds_germany)

# opening multi-file dataset 
@edit open_mfdataset("../data/GPP.*.nc")
fluxcom_gpp = open_mfdataset("../data/GPP.*.nc")
gpp = Cube(fluxcom_gpp)

extrema(skipmissing(gpp.data[:,:,1,1]))

plot(gpp[lon=30, lat=50][:,1:2])

# Plot the first timestep of GPP
Plots.heatmap(replace(gpp.data[:,:,1,1],missing=>NaN))

# transpose and count backwards to get the map correctly
Plots.heatmap(replace(gpp.data[:,:,1,1]'[end:-1:1,:],-9999=>NaN))

c = Cube(open_dataset("../data/germanycube.zarr"))

# Cube fields 
# Cubes have different fields: 
# ´data´ to access their data, 
# ´axes´ to access their axes.

# 1.) the data inside a Cube is a DiskArray
c.data

# 2.) Datacube / YAXArray: named axes + operations  
c.axes

# get an axis by name
getAxis("Variable",c)
getAxis("lon",c)

# get axis values
getAxis("Variable",c).values

# creating axes + cubes 


dates = collect(Date(2000,1,1):Day(1):Date(2000,12,31)) 
ax1 = RangeAxis("Time", dates)

ax2 = CategoricalAxis("Variable",["var1","var2"])
ax2.values
data = randn((length(ax1),length(ax2)))

cnew = YAXArray([ax1, ax2], data)
cnew.data
cnew.axes

#######################
### Subsetting + concatenating cubes
#######################

# Your data is not loaded into memory, but read from disk.
# Subsetting happens lazily, the data is not copied 
# but the new cube is just a pointer to the subset of the disk. 

# slicing in different dimensions
csmall = c[
    var = ["gross"],
    lon = (10,11),
    lat = (50,51),
    time = 2000:2010]

    c[
    var = "gross",
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

# pass a list of cubes and an axis to concatenate along
c_concat = concatenatecubes(
    [c[var="gross_primary_productivity"],
    c[var="net_ecosystem_exchange"]],
    CategoricalAxis("Variable",["GPP","NEE"]))

#######################
### Computations
#######################

### 1.) Cubes can be treated like datasets...
# access DiskArray at c.data 

# YAXArray cube is a container for DiskArray dataset 
# containing additional information (named axes etc)
c.data 

# computation directly on datasets 
# not ideal: you lose your axes
# we circumvent  this below 
c[var="gross"].data .- c[var="net"].data 


### 2.) Elementwise operations on cubes 

# out temperature data is in Kelvin 
extrema(c[var="air_temperature_2m"].data)

# transform to celcius
function kelvintocelcius(x)
    x - 273.15
end

c_celsius = map(kelvintocelcius, c[var="air_temperature_2m"])
#extrema(c_celsius.data)

# same operation with other notations:
c_celsius = map(x -> x - 273.15, c[var="air_temperature_2m"])

c_celsius = map(c[var="air_temperature_2m"]) do x
	x - 273.15
end


### 3.) Built-in functions

# The EarthDataLab is basesd on YAXArrays.
# It implements standard operations
# needed for earth science data cubes. 
# https://github.com/JuliaDataCubes/EarthDataLab.jl

# It also hosts a data cube accessible via 
# c = esdc()

### Mean Seasonal Cycle 
c_msc = getMSC(c)

plot(c_msc[lon = 10,lat = 50, 
    var="gross_primary_productivity"].data)


# also median seasonal cycle
getMedSC(c)

plot(getAxis(:MSC,c_msc).values, c_msc[:,10,10,:])

# anomalies from Mean seasonal cycle 
c_anom = removeMSC(cgermany)

plot(getAxis(:Time,c_anom).values, c_anom[:,10,10,:],
    layout=(4,1),label=permutedims(c_anom.Variable.values))


gapFillMSC

gapfillpoly

normalizeTS


# 4.) Cube operations with mapslices & mapCube

# apply functions on cube dimensions / named axes
# this way you keep + transform the axis information 

using Statistics

methods(mapslices)

#?mapslices

## mapslices
# mapslices(f, A; dims = d) transforms a given dataset A 
# by a function f along dimension d. Notice that 
# the input dimension disappears from the output cube. 
# Mapslices automatically iterates over all other 
# dimensions (Lat, Lon, Variable) independently and 
# returns them again.

# compute the temporal mean of each variable over regional cube
c_tempmean = mapslices(mean ∘ skipmissing, c; dims="Time")

heatmap(replace(c_tempmean[var="air"].data, missing => NaN))

c_spatialmean = mapslices(mean ∘ skipmissing, cgermany, dims = ("lon","lat"))

#c_mean = mapslices(mean ∘ skipmissing, cgermany, dims = ("lon","lat","time")) 
# attention, this might not work for larger cubes (chunk have to fit into memory)

c_latmsc = mapslices(mean ∘ skipmissing, c_msc; dims="lon")

heatmap(c_latmsc.data[:,:,2]')


### mapCube

#?mapCube

# mapCube is similar to mapslices, 
# but takes explicit input dimensions (InDims) 
# and output dimensions (outDims)


# mapCube is similar to mapslices: It also transforms 
# a given dataset by a function along specified 
# dimensions, but it is more customizable than 
# mapslices. You can specify several input and output 
# dimensions, e. g. if you want to do an aggregation 
# over time and variable. The input dimensions are 
# replaced by the output dimensions in the output cube. 
# Like mapslices, mapCube automatically iterates over 
# all other dimensions independently and returns them 
# again.

id = InDims("Time")
od = OutDims()
#od = OutDims(path="./mgpp.zarr", backend = :zarr, overwrite=true) # if you want to save the output array to disk

r = mapCube(mean, c, indims = id, outdims = od, inplace=false)

# Two input cubes - note that indims needs to be adjusted to also contain two indims. there can be different between cubes

c_cor = mapCube(cor, 
    (c[variable="air_temperature"], c[variable="terrestrial_ecosystem_respiration"]),
    indims = (id, id),
    outdims = od,
    inplace = false
)

#?InDims

#?OutDims

### Writing your own function for mapCube
# The function mapCube expects is of type 
# f(xout, xin; kwargs ...), 
# i. e. the output array is internally passed as 
# the first argument, then comes the input array. 
# If you want to include a function of type 
# f(xin; kwargs...), 
# use the keyword inplace = false (less memory efficient).


# Let's say we want the two variables in one cube 
# and write a function that can access them there. 
ct = c[variable=["air_temperature",
    "terrestrial_ecosystem_respiration"]]

# We write a correlation function `cubecor` that calculates 
# the correlation between two columns of input `xin`.

function cubecor(xout, xin)
    # index of pairwise complete observations
    idx = .!ismissing.(xin[:,1]) .& .!ismissing.(xin[:,2])
    sum(idx) == 0 && return missing
    # correlation assigned to xout. note the [:] access is important!
    xout[:] .= cor(xin[idx,1],xin[idx,2])
end

#ated array)

# Think about all the data you need to access at once to your calculation:
# The input dimensions to calculate temporal correlation need to be "Time" and "Variable"
id = InDims("Time", "Variable") # the order of dimensions defines the size of xin! -> time in rows, var in cloumns

# Think about the dimension of your output, here: one number. So OutDims is empty!
od = OutDims()

# now put it into mapCube:
ct_cor = mapCube(cubecor, ct, indims = id, outdims = od) 

# Just for demonstration, a function used with inplace = false (no xout)

function cubecor(xin)
    # index of pairwise complete observations
    idx = .!ismissing.(xin[:,1]) .& .!ismissing.(xin[:,2])
    sum(idx) == 0 && return missing
    # correlation assigned to xout. note the [:] access is important!
    return cor(xin[idx,1],xin[idx,2])
end

### Checklist with errors or all missing output
# dimensions of data correct?
# catch statement for errors concerning all missing data?
# xout[:] needs to be assigned with [:] (you are writing into a preallocated array)

# now put it into mapCube:
ct_cor = mapCube(cubecor, ct, indims = id, outdims = od, inplace=false) 

ct_cor.data

Plots.heatmap(replace(ct_cor.data'[end:-1:1,:],missing=>NaN))

### Customizing Cube Dimensions
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


#######################
### Make Moving Window Computations
#######################

function movingmean(xout, xin)
    xout .= mean(xin)
end

function movingmean(cube::YAXArray)
    indims = InDims(MovingWindow("lat", 1,1),MovingWindow("lon", 1,1))
    outdims=OutDims()
    mapCube(movingmean, cube; indims=indims, outdims=outdims)
end

movingavgprange = movingmean(c)

## save cubes 

savecube(c,"outcube")