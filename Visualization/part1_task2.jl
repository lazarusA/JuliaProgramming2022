using GLMakie, Colors, Random
GLMakie.activate!()
GLMakie.set_window_config!(float=true)
Random.seed!(435)
colors = resample_cmap(:Tam, 6)
c = reshape(colors, (2,3))
αbto = reshape(string.('a':'f'), (2,3))
fig = Figure(backgroundcolor = :gainsboro, font="CMU Serif")
[Box(fig[i, j], color = c[i,j]) for i in 1:2, j in 1:3]
[Label(fig[i, j, TopLeft()], αbto[i,j]) for i in 1:2, j in 1:3]
Label(fig[1,2, Right()], "Hello 😄 ", rotation = π/ 2)
Colorbar(fig[3, 1:3], colormap=cgrad(colors, categorical=true),
    vertical = false,
    flipaxis=false,
    ticksvisible=false,
    ticklabelsvisible=false)
fig
save("./slides/imgs/layout_task_2.png", fig)