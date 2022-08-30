using GLMakie, Colors, Random
using ColorSchemes
GLMakie.activate!()
GLMakie.set_window_config!(float=true)
#GLMakie.set_window_config!(float=true, framerate=60)
#set_theme!(resolution=(600, 400))
#meshscatter(1:10, 1:10, 1:10)
Random.seed!(12133)

# Basic plot 
using GLMakie, Colors, Random, ColorSchemes
x = 0.05:0.05:4π
y = sin.(3x) ./ (cos.(x) .+ 2) ./ x

lines(x,y)
save("./slides/imgs/part3_1.png", current_figure())

x = 0.05:0.05:4π
y = sin.(3x) ./ (cos.(x) .+ 2) ./ x

scatter(x,y)
save("./slides/imgs/part3_2.png", current_figure())

## Line attributes
x = 0.05:0.05:4π
y = sin.(3x) ./ (cos.(x) .+ 2) ./ x

lines(x, y; color = :black, linewidth = 2, linestyle = :dash)
save("./slides/imgs/part3_3.png", current_figure())

x = 0.05:0.05:4π
y = sin.(3x) ./ (cos.(x) .+ 2) ./ x

lines(x, y; color = x, linewidth = 3, linestyle = :solid,
    colormap = :imola)
save("./slides/imgs/part3_4.png", current_figure())

## Reversed colormap
x = 0.05:0.05:4π
y = sin.(3x) ./ (cos.(x) .+ 2) ./ x

lines(x, y; color = x, linewidth = 3, linestyle = :solid,
    colormap = Reverse(:imola))
save("./slides/imgs/part3_5.png", current_figure())

## Your own colors
x = 0.05:0.05:4π
y = sin.(3x) ./ (cos.(x) .+ 2) ./ x

lines(x, y; color = x, linewidth = 3, linestyle = :solid,
    colormap = [:black, :red, :orange])
save("./slides/imgs/part3_6.png", current_figure())

## Axis arguments
x = 0.05:0.05:4π
y = sin.(3x) ./ (cos.(x) .+ 2) ./ x

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
save("./slides/imgs/part3_7.png", current_figure())

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
save("./slides/imgs/part3_8.png", current_figure())

## Adding a Legend and Colorbar
function plotlineCbar()
    fig, ax, obj = lines(x, y;
        color = x, linewidth = 3, linestyle = :solid,
        colormap = [:dodgerblue, :red, :orange],
        label = L"sin(3x)/(cos(x) +2)/x",
        axis = (; 
            xlabel = L"x", ylabel = L"y",
            xlabelsize = 20, ylabelsize = 20,),
        figure = (;
            resolution = (600, 400),
            font = "CMU Serif"
            )
        )
    limits!(ax, 0, 4π, -0.5, 1)
    axislegend(L"f(x)"; position = :rt, bgcolor = (:grey, 0.1),
        framecolor = :snow3)
    Colorbar(fig[1,2], obj;
        label = L"x",
        width=10,
        labelsize = 20
        )
    colgap!(fig.layout, 5)
    fig
end
plotlineCbar() 

save("./slides/imgs/part3_9.png", current_figure())

with_theme(theme_ggplot2()) do
    plotlineCbar() 
end
save("./slides/imgs/part3_10.png", current_figure())