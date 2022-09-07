
# YAXArrays can handle many different data formats. 
# We will look at some examples on Day 4. 

# You can access the online Earth Data Cube 
# directly with the function esdc, or use the 
# EarthDataLab infrastructure to load your own data, 
# here e. g. some GPP data downloaded from the 
# MPI server. 
# To prepare, please
#
# (1) download the GPP data from the ftp server below, and
#
# (2) download the regional cube for Germany 
# (or your favourite mid-sized country)


## download data 
using EarthDataLab
using YAXArrays
using YAXArrays.Datasets: open_mfdataset # open multifile dataset
using ProgressMeter

# note! For this to work, create a '../data' directory 
# or change the path you want to save the data to
mkdir("../data")

for yr in 2001:2010
    p = "ftp://ftp.bgc-jena.mpg.de/pub/outgoing/FluxCom/CarbonFluxes/RS_METEO/ensemble/ALL/monthly/GPP.RS_METEO.FP-ALL.MLM-ALL.METEO-ALL.720_360.monthly.$yr.nc"
    download(p,"../data/GPP.$yr.nc")
end

### download part of the EDL cube
# The EDL cube is a collection of 75 variables. 
# Attention: not all datasets span the whole 
# temporal range!

# https://www.earthsystemdatalab.net/

c = esdc()

cgermany = c[
  region = "Germany",
  var = ["gross", "net_ecosystem", "air_temperature_2m", "terrestrial_ecosystem"],
  time = 2000:2010
]

# save cube to disk
# again, you need a '../data' directory or change the path for saving!

savecube(cgermany,"../data/germanycube.zarr",
  chunksize=Dict("lon"=>20,"lat"=>20,"time"=>92)) # Chunksize definition is optional

