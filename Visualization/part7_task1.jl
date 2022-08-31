using GLMakie, Colors, Random, ColorSchemes
using CSV, DataFrames, Chain,DataFramesMeta
using Downloads: download
using FileIO
GLMakie.activate!()
GLMakie.set_window_config!(float=true)

function getPoints(xi, yi, xf, yf)
    xyos = []
    for i in eachindex(xi)
        push!(xyos, [xi[i], yi[i]])
        push!(xyos, [xf[i], yf[i]])
    end
    xyos
end

# Task 1
# https://github.com/bkamins/JuliaCon2021-DataFrames-Tutorial/blob/main/Tutorial.ipynb
# https://juliadata.github.io/DataFramesMeta.jl/stable/

df = CSV.read("FluxnetInfo.csv", DataFrame)
#scatter(df.longitude, df.latitude)

ymn = minimum(df.start_year)
s = 2022 - ymn

df = @chain df begin
    @transform(:starty = (:start_year .- ymn)/s)
    @transform(:span = (:end_year - :start_year))
    @transform(:nspan = :span/s)
    @transform(:θ = atan.(:latitude, :longitude))
    @transform(:x = cos.(:θ), :y = sin.(:θ))
    @transform(:xi = :starty .* cos.(:θ), :yi = :starty .* sin.(:θ))
    @transform(:xf = (:starty .+ :nspan) .* cos.(:θ), :yf = (:starty .+ :nspan) .* sin.(:θ))
    @select(:x, :y, :span, :nspan, :xi, :yi, :xf, :yf)
end

xyos = Point2f.(getPoints(df.xi, df.yi, df.xf, df.yf))
scolors = repeat(df.span, inner = 2)
α = range(0.8,0.25,length=100)
cmap = resample_cmap(:roma, 100, alpha=α.^2)

with_theme(theme_dark()) do
    fig, ax, obj = scatter(df.x, df.y; color = df.span .+ 1,
        markersize=2.5(df.span .+1), colormap = 1.52*cmap,
        strokecolor = :white, strokewidth=0.35,
        axis=(;
            aspect = 1,
            xticks = ([-1,0,1], string.([-180,0,180])),
            yticks = ([-1,0,1], string.([-90,0,90])),
            yticksmirrored = true,
            xticksmirrored=true,
            )
        )
    lines!(Circle(Point2f(0,0),1); color = :grey80, linestyle = :solid)
    linesegments!(xyos; color = scolors,
        colormap = 1.52*cmap, linewidth = 1 .+ scolors / 5,)
    for i in 0:5:31
        lines!(Circle(Point2f(0,0), 1/s*i); color = (:white, 0.75),
            linestyle = :solid, linewidth=0.15)
        text!("$(ymn + i)", position = (0,-1/s*i), textsize = 12,
            #color = :white
            )
    end
    Label(fig[0,1], "Fluxnet sites: Operating time",
        tellwidth=false)
    current_figure()
end