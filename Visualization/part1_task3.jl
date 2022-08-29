using GLMakie, Colors, Random
GLMakie.activate!()
GLMakie.set_window_config!(float=true)
Random.seed!(435)
pastel = resample_cmap(:Pastel2_4, 4)
fig = Figure()
Box(fig[1, 1:2], color = pastel[1])
Box(fig[1, 3],color = pastel[2])
Box(fig[2, 1:3], color = pastel[3])
Box(fig[3, 1:3], color = pastel[4])
Box(fig[2:3, 3, Right()], color = :transparent,
    strokecolor = (:brown, 0.5))
Label(fig[2:3, 3, Right()], "Hey ☕", color = :brown,
    rotation = pi / 2, padding = (3, 3, 3, 3))
colsize!(fig.layout, 1, Auto(2))
rowsize!(fig.layout, 2, Auto(0.5))
rowsize!(fig.layout, 3, Auto(0.5))
rowgap!(fig.layout, 1, 15)
rowgap!(fig.layout, 2, 5)
colgap!(fig.layout, 5)
fig
save("./slides/imgs/layout_task_3.png", fig)