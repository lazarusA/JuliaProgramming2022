using GLMakie, Markdown, MakieSlides, Random, FileIO
include("codeColors.jl")
#set_theme!(theme_ggplot2())
#set_theme!()
#themexx = Themes.TracTheme
bgcolor = :grey90
txtcolor = :black
themexx = Themes.MonokaiMiniTheme
bgcolor = :grey95
set_theme!(theme_light())
#set_theme!(theme_dark())
#txtcolor = :white
function applycolors(t, colors2)
    gc = t.plots[1].plots[1][1][][1]
    for (i, newc) in enumerate(colors2[2:end])
        gc.colors.sv[i+1] = newc
    end
    notify(t.plots[1].plots[1][1])
end

pres = Presentation(figure_padding =  25)

add_slide!(pres) do fig
    Label(fig[1, 1], "Makie", textsize = 100, tellwidth = false)
    Label(fig[2, 1], "The layout approach", textsize = 60, tellwidth = false)
    rowgap!(fig.layout, 1, Fixed(10))
    s = campixel(fig.scene)
    text!(s, "Data Visualization", position=(20, 40), space=:pixel,
        color = :grey90,  textsize = 14,)
    text!(s, "Lazaro Alonso @LazarusAlon", position=(20, 25), space=:pixel, color =txtcolor, 
        textsize = 12,)
    text!(s, "MPI-BGI", position=(20, 10), space=:pixel, color =txtcolor, 
        textsize = 12,)
end

src = readlines("../part1_layout.jl", keep=true)
for k in 1:18
    add_slide!(pres) do s
        h = (2+k)*25 #length(src)*25
        srcx = join(src[1:2+k])
        strx, colorsx = highlight_text(srcx, themexx)
    
        fig1 = GridLayout(s[1,1])
        axcode = Axis(fig1[1,1], height = h, tellheight = false, backgroundcolor = bgcolor)
        tx = text!(axcode, strx, color = colorsx[1], textsize = 12,
            position = (0.025,0.8),
            align = (:left, :top), space= :relative,
            font = "mono",
            )
        hidedecorations!(axcode)
        hidespines!(axcode)
        applycolors(tx, colorsx)

        fig = GridLayout(s[1,2])
        img = load("./imgs/layout_$(k).png")
        ax = Axis(fig[1,1], aspect = DataAspect())
        image!(ax, rotr90(img))
        hidedecorations!(ax)
        hidespines!(ax)
        colsize!(s.layout, 1, Auto(0.85))
        colgap!(s.layout, 5)
        snew = campixel(s.scene)
        text!(snew, "Data Visualization", position=(20, 40), space=:pixel,
            color = :grey90,  textsize = 14,)
        text!(snew, "Lazaro Alonso @LazarusAlon", position=(20, 25), space=:pixel, color =txtcolor, 
            textsize = 12,)
        text!(snew, "MPI-BGI", position=(20, 10), space=:pixel, color =txtcolor, 
            textsize = 12,)
    end
end

for j in 1:3
    add_slide!(pres) do s
        fig1 = GridLayout(s[1,1])
        axcode = Axis(fig1[1,1], height = 100, tellheight = false,  backgroundcolor = bgcolor)
        t = text!(axcode, "Task $(j)\n Your code goes here!", 
            color = :orangered, textsize = 25,
            position = (0.025,0.8),
            align = (:left, :top), space= :relative,
            font = "mono",
            )
        hidedecorations!(axcode)
        hidespines!(axcode)

        fig = GridLayout(s[1,2])
        img = load("./imgs/layout_task_$(j).png")
        ax = Axis(fig[1,1], aspect = DataAspect())
        image!(ax, rotr90(img))
        hidedecorations!(ax)
        hidespines!(ax)
        colsize!(s.layout, 1, Auto(0.7))
        colgap!(s.layout, 5)
        snew = campixel(s.scene)
        text!(snew, "Data Visualization", position=(20, 40), space=:pixel,
            color = :grey90,  textsize = 14,)
        text!(snew, "Lazaro Alonso @LazarusAlon", position=(20, 25), space=:pixel, color =txtcolor, 
            textsize = 12,)
        text!(snew, "MPI-BGI", position=(20, 10), space=:pixel, color =txtcolor, 
            textsize = 12,)
    end
end

for j in 1:3
    src1 = readlines("../part1_task$(j).jl", keep=true)
    h1 = length(src1)*25
    srcxx = join(src1[1:end-1])
    strxx, colorsxx = highlight_text(srcxx, themexx)

    add_slide!(pres) do s
        fig1 = GridLayout(s[1,1])
        axcode = Axis(fig1[1,1], height = h1, tellheight = false,  backgroundcolor = bgcolor)
        t = text!(axcode, strxx, color = colorsxx[1], textsize = 15,
            position = (0.025,0.8),
            align = (:left, :top), space= :relative,
            font = "mono",
            )
        hidedecorations!(axcode)
        hidespines!(axcode)
        applycolors(t, colorsxx)

        fig = GridLayout(s[1,2])
        img = load("./imgs/layout_task_$(j).png")
        ax = Axis(fig[1,1], aspect = DataAspect())
        image!(ax, rotr90(img))
        hidedecorations!(ax)
        hidespines!(ax)
        colsize!(s.layout, 1, Auto(0.7))
        colgap!(s.layout, 5)
        snew = campixel(s.scene)
        text!(snew, "Data Visualization", position=(20, 40), space=:pixel,
            color = :grey90,  textsize = 14,)
        text!(snew, "Lazaro Alonso @LazarusAlon", position=(20, 25), space=:pixel, color =txtcolor, 
            textsize = 12,)
        text!(snew, "MPI-BGI", position=(20, 10), space=:pixel, color =txtcolor, 
            textsize = 12,)
    end
end
display(pres)
#MakieSlides.save(joinpath(@__DIR__, "part1_slides_h_dark.pdf"), pres)
MakieSlides.save(joinpath(@__DIR__, "part1_slides_h_light.pdf"), pres)

reset!(pres)



#=
text = """
       first line
       second line
       and so on
       """;
lines = collect(eachline(IOBuffer(text)));
[lines[1:n] for n in eachindex(lines)]
join(["first line", "second line"], "\n    ")
=#