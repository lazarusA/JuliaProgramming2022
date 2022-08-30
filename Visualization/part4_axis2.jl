using GLMakie, Colors, Random
using ColorSchemes
GLMakie.activate!()
GLMakie.set_window_config!(float=true)
#GLMakie.set_window_config!(float=true, framerate=60)
#set_theme!(resolution=(600, 400))
#meshscatter(1:10, 1:10, 1:10)
Random.seed!(12133)

x = 0.05:0.05:4π
y = sin.(3x) ./ (cos.(x) .+ 2) ./ x

lines(x,y)
scatter!(x,y) # use bang ! to add a new plot
current_figure()
# scatterlines(x,y)

# layout positions
fig = Figure()
ax, obj = lines(fig[1,1], x, y; color = x,
    label =L"sin(3x)/(cos(x) +2)/x")
scatter!(ax, x,y, color = x)
Colorbar(fig[1,2], obj)
Legend(fig[0,1], ax; tellwidth=false, tellheight = true)
fig
save("./slides/imgs/part4_1.png", current_figure())

# more layout freedom, multiple axis
function plotmulti()
    fig = Figure(resolution = (1200,800))
    ax1 = Axis(fig[1,1], xlabel = "x", ylabel = "y")
    ax2 = Axis(fig[1,2], xlabel = "x")
    ax3 = Axis(fig[2,1:2], xlabel ="x", ylabel ="y",
        backgroundcolor = :black)
    axs = [ax1, ax2, ax3]
    lines!(ax1, x, y; color = :black, linestyle = :dashdot,
        linewidth = 3, label = "f(x)")
    band!(ax2, x, x*0, y; color = x, label = "f(x) colored")
    scatter!(ax3, x, y; color = :transparent, strokewidth = 1,
        markersize = exp.(0.59x[end:-1:begin]),
        strokecolor = 1.5resample_cmap(:bone_1, length(x)),
        label = "f(x) empty markers")
    Label(fig[1,1], "(a)", tellwidth=false, tellheight=false,
        valign = :bottom, halign = :right,
        font = "TeX Gyre Heros Bold", textsize = 24,
        padding = (3, 15, 10, 3))
    Label(fig[1,2], "(b)", tellwidth=false, tellheight=false,
        valign = :bottom, halign = :right,
        font = "TeX Gyre Heros Bold", textsize = 24,
        padding = (3, 15, 10, 3))
    Label(fig[2,1:2], "(c)", tellwidth=false,tellheight=false,
        valign = :bottom, halign = :right,
        font = "TeX Gyre Heros Bold", textsize = 24,
        color = :white,
        padding = (3, 15, 10, 3))
    axislegend.(axs)
    hideydecorations!(ax2; ticks = false)
    fig
end
plotmulti()
save("./slides/imgs/part4_2.png", current_figure())
