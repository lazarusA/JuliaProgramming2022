using GLMakie, Colors, Random
using ColorSchemes
GLMakie.activate!()
GLMakie.set_window_config!(float=true)
Random.seed!(12133)
x1 = 0.05:0.05:4π
y1 = sin.(3x1) ./ (cos.(x1) .+ 2) ./ x1

x = y = range(-2, 2, length=31)
z = -2x .* exp.(-x .^ 2 .- (y') .^ 2)
function plotmulti(x,y, x3d, y3d, z3d; c = (:black, 0.1))
    fig = Figure(resolution = (1200,800), font = "CMU Serif")
    g2d = GridLayout(fig[1,1])
    g3d = GridLayout(fig[2,1], alignmode = Outside())

    ax1 = Axis(g2d[1,1], xlabel = "", ylabel = "y")
    ax2 = Axis(g2d[1,2], xlabel = "")
    ax3 = Axis(g2d[2,1:2], xlabel = "x", ylabel = "y",
        backgroundcolor = :black)
    axS1 = Axis3(g3d[1,1], aspect = :data, perspectiveness = 0.5,
        elevation = π / 9)
    axS2 = LScene(g3d[1,2], show_axis=false)

    axs = [ax1, ax2, ax3]
    lines!(ax1, x, y; #linestyle = :dashdot,
        linewidth = 3, label = "f(x)")
    band!(ax2, x, x*0, y; color = x, label = "f(x) colored")
    scatter!(ax3, x, y; color = :transparent, strokewidth = 1,
        markersize = exp.(0.59x[end:-1:begin]),
        strokecolor = 1.5resample_cmap(:bone_1, length(x)),
        label = "f(x) empty markers")
    Label(g2d[1,1], "(a)", tellwidth=false, tellheight=false,
        valign = :bottom, halign = :right,
        #font = "TeX Gyre Heros Bold",
        #textsize = 24,
        padding = (3, 15, 10, 3))
    Label(g2d[1,2], "(b)", tellwidth=false, tellheight=false,
        valign = :bottom, halign = :right,
        #font = "TeX Gyre Heros Bold",
        #textsize = 24,
        padding = (3, 15, 10, 3))
    Label(g2d[2,1:2], "(c)", tellwidth=false, tellheight=false,
        valign = :bottom, halign = :right,
        #font = "TeX Gyre Heros Bold",
        #textsize = 24,
        color = :white,
        padding = (3, 15, 10, 3))
    axislegend.(axs)
    hideydecorations!(ax2; ticks = false)
    # our 3d plots
    wireframe!(axS1, x3d, y3d, z3d; color = c, transparency = true,
        #overdraw = true,
        linewidth = 1)
    meshscatter!(axS1,Point3f(0.8,0,0); color = :white,
        markersize = 0.35, transparency = true, backlight = 2f0)
    surface!(axS1, x3d, y3d, z3d; colormap = cmap,transparency =true)
    # with zoom
    wireframe!(axS2, x3d, y3d, z3d; color = c, transparency = true,
        #overdraw = true,
        linewidth = 1,
    )
    meshscatter!(axS2, Point3f(0.8,0,0); color = :white,
        markersize = 0.35, transparency = true, backlight = 2f0)
    surface!(axS2, x3d, y3d, z3d; colormap = cmap,transparency =true)
    Colorbar(g3d[1,3], colormap = cmap, colorrange = extrema(z),
        label = L"f(x,y)", height=Relative(0.35))
    Label(g3d[1,1], "(d)", tellwidth=false, tellheight=false,
        valign = :bottom, halign = :right,
        #font = "TeX Gyre Heros Bold",
        #textsize = 24,
        padding = (3, 15, 10, 3))
    Label(g3d[1,2], "(e)", tellwidth=false, tellheight=false,
        valign = :bottom, halign = :right,
        #font = "TeX Gyre Heros Bold",
        #textsize = 24,
        padding = (3, 15, 10, 3))
    s = campixel(fig.scene)
    text!(s, L"f(x,y) = -2\,x\, e^{-x^2 - y^2}",
        position=(100, 700/2), space=:pixel)
    text!(ax3, L"f(x) = x\,\sin(3x)/(\cos(x) + 2)",
        position = (7, 0.8), color = :grey70)
    rowgap!(g2d, 2)
    colgap!(g2d, 2)
    colgap!(g2d, 2)
    rowgap!(fig.layout, 2)
    fig
end
plotmulti(x1, y1, x, y, z)

#with_theme(theme_dark()) do
#    plotmulti(x1, y1, x, y, z; c = (:white, 0.05))
#end
save("./slides/imgs/part6_1.png", current_figure())

with_theme(theme_dark()) do
    plotmulti(x1, y1, x, y, z; c = (:white, 0.05))
end
save("./slides/imgs/part6_2.png", current_figure())

