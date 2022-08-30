using GLMakie, Markdown, MakieSlides, Random, FileIO
include("codeColors.jl")
#set_theme!()

# dark theme
#themexx = Themes.TracTheme
#bgcolor = :grey90
#set_theme!(theme_dark())
#txtcolor = :white
# light theme
txtcolor = :black
themexx = Themes.MonokaiMiniTheme
bgcolor = :grey95
set_theme!(theme_light())

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
    Label(fig[2, 1], "GridLayouts", textsize = 60, tellwidth = false)
    Label(fig[3, 1], "Danisch & Krumbiegel, (2021). Makie.jl: Flexible high-performance data visualization for Julia.\nJournal of Open Source Software, 6(65), 3349",
        textsize = 20, tellwidth = false, color = :dodgerblue)
    rowgap!(fig.layout, 1, Fixed(10))
    s = campixel(fig.scene)
    text!(s, "Data Visualization", position=(20, 40), space=:pixel,
        color = :grey90,  textsize = 14,)
    text!(s, "Lazaro Alonso @LazarusAlon", position=(20, 25), space=:pixel, color =txtcolor, 
        textsize = 12,)
    text!(s, "MPI-BGI", position=(20, 10), space=:pixel, color =txtcolor, 
        textsize = 12,)
end
idx = [(1,17), (20, 24), (27, 34)]
srco = readlines("../part2_gridlayout.jl", keep=true)

for j in 1:3
    src1x = srco[idx[j][1]:idx[j][2]]
    h1o = length(src1x)*25
    srcxxo = join(src1x)
    strxxo, colorsxxo = highlight_text(srcxxo, themexx)

    add_slide!(pres) do s
        fig1 = GridLayout(s[1,1])
        axcode = Axis(fig1[1,1], height = h1o, tellheight = false,  backgroundcolor = bgcolor)
        t = text!(axcode, strxxo, color = colorsxxo[1], textsize = 15,
            position = (0.025,0.8),
            align = (:left, :top), space= :relative,
            font = "mono",
            )
        hidedecorations!(axcode)
        hidespines!(axcode)
        applycolors(t, colorsxxo)

        fig = GridLayout(s[1,2])
        img = load("./imgs/part2_$(j).png")
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

idxs = (1,19)
src1 = readlines("../part2_task1.jl", keep=true)
src1xq = src1[idxs[1]:idxs[2]]
h1 = length(src1xq)*25
srcxxq = join(src1xq)
strxxq, colorsxxq = highlight_text(srcxxq, themexx)

add_slide!(pres) do s
    fig1 = GridLayout(s[1,1])
    axcode = Axis(fig1[1,1], height = h1, tellheight = false,  backgroundcolor = bgcolor)
    t = text!(axcode, strxxq, color = colorsxxq[1], textsize = 15,
        position = (0.025,0.8),
        align = (:left, :top), space= :relative,
        font = "mono",
        )
    hidedecorations!(axcode)
    hidespines!(axcode)
    applycolors(t, colorsxxq)

    fig = GridLayout(s[1,2])
    img = load("./imgs/part2_task1_1.png")
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

add_slide!(pres) do s
    fig1 = GridLayout(s[1,1])
    axcode = Axis(fig1[1,1], height = 100, tellheight = false,  backgroundcolor = bgcolor)
    t = text!(axcode,"Task 1:\n Your code goes here!", 
        color = :orangered, textsize = 15,
        position = (0.025,0.8),
        align = (:left, :top), space= :relative,
        font = "mono",
        )
    hidedecorations!(axcode)
    hidespines!(axcode)
    #applycolors(t, colorsxx)

    fig = GridLayout(s[1,2])
    img = load("./imgs/part2_task1_2.png")
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

idxs = (22,41)
srcs = readlines("../part2_task1.jl", keep=true)
src1xs = srcs[idxs[1]:idxs[2]]
h1 = length(src1xs)*25
srcxxs = join(src1xs)
strxxs, colorsxxs = highlight_text(srcxxs, themexx)

add_slide!(pres) do s
    fig1 = GridLayout(s[1,1])
    axcode = Axis(fig1[1,1], height = h1, tellheight = false,  backgroundcolor = bgcolor)
    t = text!(axcode, strxxs, color = colorsxxs[1], textsize = 15,
        position = (0.025,0.8),
        align = (:left, :top), space= :relative,
        font = "mono",
        )
    hidedecorations!(axcode)
    hidespines!(axcode)
    applycolors(t, colorsxxs)

    fig = GridLayout(s[1,2])
    img = load("./imgs/part2_task1_2.png")
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

display(pres)
#MakieSlides.save(joinpath(@__DIR__, "part2_slides_h_dark.pdf"), pres)
MakieSlides.save(joinpath(@__DIR__, "part2_slides_h_light.pdf"), pres)
reset!(pres)