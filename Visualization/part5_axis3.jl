using GLMakie, Colors, Random
using ColorSchemes
GLMakie.activate!()
GLMakie.set_window_config!(float=true)
#GLMakie.set_window_config!(float=true, framerate=60)
#set_theme!(resolution=(600, 400))
#meshscatter(1:10, 1:10, 1:10)
Random.seed!(12133)

x = y = range(-2, 2, length=31)
z = (-x .* exp.(-x .^ 2 .- (y') .^ 2)) .* 4

## 3d axis, defaul LScene
wireframe(x,y,z)
save("./slides/imgs/part5_1.png", current_figure())

# Changing the axis type and color-drawing options, 
# no zoom here.
wireframe(x,y,z; 
    color = :black, 
    transparency = true,
    overdraw = true,
    linewidth = 1,
    axis = (;
    type=Axis3,
    aspect = :data, # other (1,1,1)
    perspectiveness = 0.5,
    elevation = π / 9,
    )
)
save("./slides/imgs/part5_2.png", current_figure())

# add new plot as before
wireframe(x,y,z;
    color = (:black, 0.25),
    transparency = true,
    #overdraw = true,
    linewidth = 1,
    axis = (;
    type=Axis3,
    aspect = :data, # other (1,1,1)
    perspectiveness = 0.5,
    elevation = π / 9,
    )
)
save("./slides/imgs/part5_3.png", current_figure())

# Add more plots and some colour
ncolors = 40
α = range(-1,1,length=ncolors)
#lines(α.^2)
cmap = resample_cmap(:diverging_bkr_55_10_c35_n256,
    ncolors, alpha=α.^2)
function plotSurfaces(cmap; c = (:black, 0.1))
    fig, ax, obj = wireframe(x,y,z/2; color = c,
        transparency = true,
        #overdraw = true,
        linewidth = 1,
        axis = (;
        type=Axis3,
        aspect = :data, # other (1,1,1)
        perspectiveness = 0.5,
        elevation = π / 9,
        )
    )
    meshscatter!(Point3f(0.8,0,0); color = :white,
        markersize=0.35,transparency = true,backlight = 2f0)
    surface!(x,y,z/2; colormap = cmap, transparency =true)
    Colorbar(fig[1,2], colormap = cmap,
        colorrange = extrema(z),
        height=Relative(0.35))
    #hidedecorations!(ax)
    #hidespines!(ax)
    fig
end
plotSurfaces(cmap)
save("./slides/imgs/part5_4.png", current_figure())

with_theme(theme_dark()) do 
    plotSurfaces(cmap; c = (:white, 0.01))
end
save("./slides/imgs/part5_5.png", current_figure())

# With zoom, remove all Axis3 options and use an LScene
function plotSurfacesZoom(cmap; c = (:black, 0.1))
    fig = Figure()
    ax = LScene(fig[1,1], show_axis=false)
    wireframe!(ax, x,y,z/2; color = c, transparency = true,
        #overdraw = true,
        linewidth = 1,
    )
    meshscatter!(ax, Point3f(0.8,0,0); color = :white,
        markersize = 0.35, transparency = true,
        backlight = 2f0)
    surface!(ax, x,y,z/2; colormap = cmap, transparency =true)
    Colorbar(fig[1,2], colormap = cmap,
        colorrange = extrema(z), height=Relative(0.35))
    fig
end
plotSurfacesZoom(cmap)
save("./slides/imgs/part5_6.png", current_figure())

with_theme(theme_dark()) do 
    plotSurfacesZoom(cmap; c = (:white, 0.01))
end
save("./slides/imgs/part5_7.png", current_figure())
