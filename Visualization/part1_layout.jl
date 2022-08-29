using GLMakie, Colors, Random
GLMakie.activate!()
GLMakie.set_window_config!(float=true)
#GLMakie.set_window_config!(float=true, framerate=60)
#set_theme!(resolution=(600, 400))
#meshscatter(1:10, 1:10, 1:10)
Random.seed!(12133)

fig = Figure(backgroundcolor = :ivory) # named colors
Box(fig[1, 1:3]; color=rand(RGBAf), strokecolor=rand(RGBf))
Box(fig[2, 1:3]; color=rand(RGBAf), strokecolor=rand(RGBf))
Box(fig[3, 1:3]; color=rand(RGBAf), strokecolor=rand(RGBf))

Box(fig[1:3, 1]; color=:transparent, strokecolor=:black, strokewidth = 2)
Box(fig[1:3, 2]; color=:transparent, strokecolor=rand(RGBf))
Box(fig[1:3, 3]; color=:transparent, strokecolor=rand(RGBf))

Box(fig[:, 3, Right()]; color=(:orangered, 0.15))
Label(fig[:, 3, Right()], "protrusion", textsize=18,
        rotation = π/ 2, padding=(3, 3, 3, 3))
Box(fig[1, 1:3, Bottom()]; color=rand(RGBAf))
Label(fig[1, 2, Bottom()], "protrusion")

Box(fig[1:3, 1, TopLeft()]; color = (:white, 0.95))
Label(fig[1:3, 1, TopLeft()], "(a)"; textsize=18, padding=(2, 2, 2, 2))
Colorbar(fig[:,end+1])
Label(fig[4,:], "My set of boxes")
Label(fig[0,:], "Basic Layout", textsize = 24,
    color = :steelblue4, font = "TeX Gyre Heros Bold")
colgap!(fig.layout, 5)
rowgap!(fig.layout, 5)
fig

# Task 1
αbto = reshape(string.('a':'f'), (2,3))
fig = Figure(backgroundcolor = :gainsboro)
[Box(fig[i, j], color = rand(RGBAf)) for i in 1:2, j in 1:3]
[Label(fig[i, j, TopLeft()], αbto[i,j]) for i in 1:2, j in 1:3]
fig

# Task 2
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

# Task 3
pastel = resample_cmap(:Pastel2_4, 4)
fig = Figure()
Box(fig[1, 1:2], color = pastel[1])
Box(fig[1, 3],color = pastel[2])
Box(fig[2, 1:3], color = pastel[3])
Box(fig[3, 1:3], color = pastel[4])
Box(fig[2:3, 3, Right()], color = :transparent, strokecolor = (:brown, 0.5))
Label(fig[2:3, 3, Right()], "Hey ☕", color = :brown, rotation = pi / 2,
        padding = (3, 3, 3, 3))
colsize!(fig.layout, 1, Auto(2))
rowsize!(fig.layout, 2, Auto(0.5))
rowsize!(fig.layout, 3, Auto(0.5))
rowgap!(fig.layout, 1, 15)
rowgap!(fig.layout, 2, 5)
colgap!(fig.layout, 5)
fig

fig = Figure()
Box(fig[1, 1])
Box(fig[2, 1])
Box(fig[2, 1, Right()], color = :transparent)
Label(fig[2, 1, Right()], "protrusion", color = :brown, rotation = pi / 2,
        padding = (3, 3, 3, 3))
fig