using GLMakie, Colors, Random
using ColorSchemes
GLMakie.activate!()
GLMakie.set_window_config!(float=true)
#GLMakie.set_window_config!(float=true, framerate=60)
#set_theme!(resolution=(600, 400))
#meshscatter(1:10, 1:10, 1:10)
Random.seed!(12133)

# Basic plot 
x = 0.05:0.05:4π
y = sin.(3x) ./ (cos.(x) .+ 2) ./ x

lines(x,y)
scatter(x,y)

## Line attributes
lines(x, y; color = :black, linewidth = 2, linestyle = :dash)
lines(x, y; color = x, linewidth = 3, linestyle = :solid, colormap = :imola)

## Reversed colormap
lines(x, y; color = x, linewidth = 3, linestyle = :solid, colormap = Reverse(:imola))

## Your own colors
lines(x, y; color = x, linewidth = 3, linestyle = :solid, colormap = [:black, :red, :orange])

## Axis arguments

lines(x, y;
    color = x,
    linewidth = 3,
    linestyle = :solid,
    colormap = [:black, :red, :orange],
    axis = (; 
        xlabel = "x",
        ylabel = "y",
        xlabelsize = 20,
        ylabelsize = 20,),
    figure = (;
        resolution = (600, 400),
        font = "CMU Serif"
        )
    )

## Adding a Legend
function plotlineLegend()
    lines(x, y;
        color = x,
        linewidth = 3,
        linestyle = :solid,
        colormap = [:black, :red, :orange],
        label = L"sin(3x)/(cos(x) +2)/x",
        axis = (; 
            xlabel = L"x",
            ylabel = L"y",
            xlabelsize = 20,
            ylabelsize = 20,),
        figure = (;
            resolution = (600, 400),
            font = "CMU Serif"
            )
        )
    axislegend(L"f(x)";
        position = :rt,
        bgcolor = (:grey, 0.1),
        labelcolor = :dodgerblue4,
        framecolor = :snow3,
        )
    current_figure()
end
plotlineLegend()

## Adding a Legend and Colorbar
function plotlineCbar()
    fig, ax, obj = lines(x, y;
        color = x,
        linewidth = 3,
        linestyle = :solid,
        colormap = [:dodgerblue, :red, :orange],
        label = L"sin(3x)/(cos(x) +2)/x",
        axis = (; 
            xlabel = L"x",
            ylabel = L"y",
            xlabelsize = 20,
            ylabelsize = 20,),
        figure = (;
            resolution = (600, 400),
            font = "CMU Serif"
            )
        )
    limits!(ax, 0, 4π, -0.5, 1)
    axislegend(L"f(x)";
        position = :rt,
        bgcolor = (:grey, 0.1),
        #labelcolor = :dodgerblue4,
        framecolor = :snow3,
    )
    Colorbar(fig[1,2], obj;
        label = L"x",
        width=10,
        labelsize = 20
        )
    colgap!(fig.layout, 5)
    fig
end

plotlineCbar() 

with_theme(theme_ggplot2()) do
    plotlineCbar() 
end

