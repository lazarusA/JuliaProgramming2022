
### download data 
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

