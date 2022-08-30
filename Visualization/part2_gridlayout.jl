using GLMakie, Colors, Random
using ColorSchemes
GLMakie.activate!()
GLMakie.set_window_config!(float=true)
Random.seed!(12133)
## Nested boxes
function nested_boxes!(fig; strokecolor = :black)
    colors = shuffle(resample_cmap(:VanGogh2, 10))
    b1 = Box(fig[1, 1]; color=colors[1], strokecolor)
    b2 = Box(fig[1, 2]; color=colors[2], strokecolor)
    b3 = Box(fig[2, 1:2]; color=colors[3], strokecolor)
    b4 = Box(fig[1:2, 3]; color=colors[4], strokecolor)
    #return nothing #(b1, b2, b3, b4)
end
fig = Figure(backgroundcolor= :black, resolution = (1600,900))
nested_boxes!(fig)
fig
save("./slides/imgs/part2_1.png", fig)
# usual grid
fig = Figure(backgroundcolor = :gainsboro)
[nested_boxes!(fig[i,j]) for i in 1:7, j in 1:9]
colgap!(fig.layout, 2)
rowgap!(fig.layout, 2)
fig
save("./slides/imgs/part2_2.png", fig)
# GridLayout
fig = Figure(backgroundcolor= :black, resolution = (1600,900))
gls = [fig[i, j] = GridLayout() for i in 1:7, j in 1:9]
[nested_boxes!(g; strokecolor = (:white, 0.5)) for g in gls]
colgap!.(gls, 1)
rowgap!.(gls, 1)
colgap!(fig.layout, 1)
rowgap!(fig.layout, 1)
fig
save("./slides/imgs/part2_3.png", fig)