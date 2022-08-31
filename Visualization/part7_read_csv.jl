using GLMakie, Colors, Random, ColorSchemes
using CSV, DataFrames
using Downloads: download
using FileIO
GLMakie.activate!()
GLMakie.set_window_config!(float=true)
df = CSV.read("gapminder-health-income.csv", DataFrame)
x = df[!, :income]
y = df[!, :health]
pop = df[!, :population]
Random.seed!(134)
#cmap = distinguishable_colors(length(pop))
mxs = maximum(pop)
spop = pop./1e6
set_theme!(theme_ggplot2())
fig, ax, obj = scatter(x, y;
    color = spop,
    colorrange = (1,1e3),
    #colormap = :viridis,#cgrad(cmap, categorical=true),
    markersize = 3 .+ spop/15,
    axis = (;
        xscale = log10,
        xlabel = "Income",
        ylabel = "Health",
        xticks = ([1e3, 1e4, 1e5], string.([1000, 10_000, 100_000]))
        ),
    figure = (;
        resolution = (800, 450),
        font = "CMU Serif"),
        
    )
Colorbar(fig[1,2], obj, label= "Population in millions")
display(fig)
set_theme!()


# Task 1
fluxnet = CSV.read("FluxnetInfo.csv", DataFrame)

lon = fluxnet.longitude/180
lat = fluxnet.latitude/180
iyear = fluxnet.start_year
fyear = fluxnet.end_year
iymn = minimum(iyear)
fymxo = maximum(fyear)
nyear = 2022
fymx = nyear - iymn

starty = (iyear .- iymn)/fymx
span = (fyear .- iyear)
nspan = span/fymx

1/31
#pnts = toCartesian.(lon, lat)
function getPoints(xi, yi, xf, yf)
    xyos = []
    for i in eachindex(xi)
        push!(xyos, [xi[i], yi[i]])
        push!(xyos, [xf[i], yf[i]])
    end
    xyos
end

θ = atan.(lat, lon)
x = cos.(θ)
y = sin.(θ)

xi = starty .* cos.(θ)
yi = starty .* sin.(θ)
xf = (starty .+ nspan) .* cos.(θ)
yf = (starty .+ nspan) .* sin.(θ)
xyos = getPoints(xi, yi, xf, yf)
scolors = repeat(span, inner = 2)

α = range(0.8,0.25,length=100)
cmap = resample_cmap(:roma, 100, alpha=α.^2)
with_theme(theme_dark()) do
    fig, ax, obj = scatter(x, y; color = span .+ 1, markersize=2.5(span .+1),
        colormap = 1.52*cmap, strokecolor = :white, strokewidth=0.35,
        axis=(;
            aspect = 1,
            xticks = ([-1,0,1], string.([-180,0,180])),
            yticks = ([-1,0,1], string.([-90,0,90])),
            )
        )
    lines!(Circle(Point2f(0,0),1); color = :grey80, linestyle = :solid)
    linesegments!(Point2f.(xyos); color = scolors,
        colormap = 1.52*cmap, linewidth = 1 .+ scolors / 5,)
    for i in 0:5:31
        lines!(Circle(Point2f(0,0), 1/fymx*i); color = (:white, 0.75),
            linestyle = :solid, linewidth=0.15)
        text!("$(1991 + i)", position = (0,-1/fymx*i), textsize = 12,
            #color = :white
            )
    end
    Label(fig[0,1], "Fluxnet sites: Operating time",
        tellwidth=false)
    current_figure()
end