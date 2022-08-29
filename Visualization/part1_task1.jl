using GLMakie, Colors, Random
GLMakie.activate!()
GLMakie.set_window_config!(float=true)
Random.seed!(435)
αbto = reshape(string.('a':'f'), (2,3))
fig = Figure(backgroundcolor = :gainsboro)
[Box(fig[i, j], color = rand(RGBAf)) for i in 1:2, j in 1:3]
[Label(fig[i, j, TopLeft()], αbto[i,j]) for i in 1:2, j in 1:3]
fig
save("./slides/imgs/layout_task_1.png", fig)