using GLMakie, Colors, Random
using ColorSchemes
GLMakie.activate!()
GLMakie.set_window_config!(float=true)
Random.seed!(21343)
function nested_boxes_cbar!(fig)
    colors = shuffle(resample_cmap(:VanGogh2, 10))
    b1 = Box(fig[1, 1], color=colors[1])
    b2 = Box(fig[1, 2], color=colors[2])
    b3 = Box(fig[2, 1:2], color=colors[3])
    b4 = Colorbar(fig[1:2, 3],
        colormap=cgrad(ColorScheme(colors[1:3]),
        categorical = true),
        ticksvisible=false,
        ticklabelsvisible=false)
    #return nothing #(b1, b2, b3, b4)
end
fig = Figure(backgroundcolor= :black, resolution = (1600,900))
nested_boxes_cbar!(fig)
fig
save("./slides/imgs/part2_task1_1.png", fig)
fig = Figure(backgroundcolor= :black, resolution = (1600,900))
ga = fig[1, 1] = GridLayout()
gb = fig[1, 2] = GridLayout()
gc = fig[1, 3] = GridLayout()
gd = fig[2, 1:3] = GridLayout()
gA = Box(ga[1, 1], color = :olive)
nested_boxes_cbar!(gb)
nested_boxes_cbar!(gc)
Box(gd[1,1], color = rand(RGBAf))
Box(gd[2,1], color = rand(RGBAf))
Box(gd[3,1], color = rand(RGBAf))
colgap!(gb, 5)
colgap!(gc, 5)
rowgap!(gc, 5)
rowgap!(gd, 5)
rowgap!(fig.layout, 5)
colgap!(fig.layout, 5)
rowsize!(fig.layout, 2, Auto(0.5))
colsize!(fig.layout, 1, Auto(0.5))
fig
save("./slides/imgs/part2_task1_2.png", fig)