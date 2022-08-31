












# 1) 
# Calculate the temporal and spatial variance (separately) 
# of each variable in the regional cube, using mapslices.

mapslices(var ∘ skipmissing, cgermany; dims="Time")

mapslices(var ∘ skipmissing, cgermany; dims=("lat","lon"))

# 2) 
# Calculate the temporal variance for MSC and anomalies of air temperature.

mapslices(var ∘ skipmissing, c_anom[var="air_temp"]; dims="Time")

mapslices(var ∘ skipmissing, c_msc[var="air_temp"]; dims="MSC")

# 3)
# Repeat 2, but use mapCube instead of mapslices

mapCube(var ∘ skipmissing, c_msc[var="air_temp"], indims = InDims("MSC"), outdims = OutDims(), inplace=false)

# 4) 
# Calculate a more robust correlation (see below) and 
# compare the difference to the regular correlation we computed.

function comed(xin)
    idx = @. !ismissing(xin[:,1]) & !ismissing(xin[:,2]) 
    sum(idx) == 0 && return missing
    x = xin[idx, 1]
    y = xin[idx, 2]
    MADx = median(abs.(x .- median(x)))
    MADy = median(abs.(y .- median(y)))
    r_comed = median((x .- median(x)).*(y .- median(y))) ./ (MADx*MADy) 
end

c_comed = mapslices(comed, ct; dims = ("Time", "Variable")) # MIND THE ORDER OF DIMENSIONS

heatmap(ct_cor.data .- c_comed.data)


# 5) 
# Calculate an "easy" ratio of NEE and GPP  (temporal) mean(NEE)/mean(GPP), for each pixel


function meanratio(xout,xin)
    idx = @. !ismissing(xin[:,1]) & !ismissing(xin[:,2]) 
    sum(idx) == 0 && return missing
    x = xin[idx, 1]
    y = xin[idx, 2]
end
    xout .= mean(x) / mean(y)

id = InDims("Time", "Variable")
od = OutDims()

cratio = mapCube(meanratio, 
    cgermany[var=["gross_primary_productivity","net_ecosystem_exchange"]],
    indims = id, outdims = od
    )

# 6) 
# Extend 5 so that you return both ratio and temporal correlation 
# - how does outdims have to look now?


function meanratio2(xout,xin)
    idx = @. !ismissing(xin[:,1]) & !ismissing(xin[:,2]) 
    sum(idx) == 0 && return missing
    x = xin[idx, 1]
    y = xin[idx, 2]
    xout[1] = mean(x) / mean(y)
    xout[2] = cor(x,y)
end

id = InDims("Time", "Variable")
od2 = OutDims(CategoricalAxis("Metrics", ["meanratio","Correlation"]))

cratio = mapCube(meanratio2, 
    cgermany[var=["gross_primary_productivity","soil_moisture"]],
    indims = id, outdims = od2
    )


 


