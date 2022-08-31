using ESDL, Zarr, YAXArrays

c = Cube("data/germanycube.zarr/")

c = c[time=2001:2010, var = "air_temp"]

t = CubeTable(tair = c, include_axes=("lon","lat","time"))

for row in Iterators.take(t,10)
    println(row)
end;

using DataFrames
DataFrame(t)

function count_negative_tair(t)
    n = 0
    for r in t
        if r.tair < 273.15
            n = n+1
        end
    end
    n
end
count_negative_tair(t)

count(r->r.tair<273.15, t)

using OnlineStats

m=Mean()

foreach(t) do row
    fit!(m, row.tair)
end
m

using WeightedOnlineStats

m2 = WeightedMean()
foreach(t) do row
    fit!(m2, row.tair, abs(cosd(row.lat)))
end
m2

# p = "https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip"
# download(p,"data/countries.zip")
# run(`unzip data/countries.zip -d data/countries`)

countrycube = cubefromshape("data/countries/ne_50m_admin_0_countries",c, labelsym=:NAME)

countrycube.properties

using ESDLPlots

plotMAP(countrycube)

using Plots
heatmap(countrycube.data)

t2 = CubeTable(tair = c, country = countrycube, include_axes=("lon","lat","time"))

#?fittable

using Dates: month
r = fittable(t2, WeightedMean, :tair, weight=(i->abs(cosd.(i.lat))), by=(:country,r->month(r.time)))
r.d

using Dates: month

season(row) = ("Winter", "Spring", "Summer", "Autumn")[mod1((month(row.time)+3)÷3,4)]
agg2 = cubefittable(t2,WeightedMean,:tair,weight=(i->abs(cosd(i.lat))),by=(season,:country))

renameaxis!(agg2,"Category"=>"Season")

plotXY(agg2,xaxis = "Season", group = "Label")

using YAXArrays.Datasets: open_mfdataset
using NetCDF
ds = open_mfdataset("data/GPP.*.nc")
gpp = ds.GPP

countrymask2 = cubefromshape("data/countries/ne_50m_admin_0_countries",gpp, labelsym=:NAME)

gpptable = CubeTable(gpp = gpp, country = countrymask2, include_axes = ("lon", "lat", "time"))

countrytimeseries = cubefittable(gpptable, WeightedMean, :gpp, weight=(i->abs(cosd(i.lat))),by=(:time, :country, r->r.gpp>=0.0))

plotTS(countrytimeseries[Category3 = true])


