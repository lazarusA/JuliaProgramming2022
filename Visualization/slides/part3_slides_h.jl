using GLMakie, Markdown, MakieSlides, Random, FileIO
include("codeColors.jl")
#set_theme!()

# dark theme
themexx = Themes.TracTheme
bgcolor = :grey90
set_theme!(theme_dark())
txtcolor = :white
# light theme
#txtcolor = :black
#themexx = Themes.MonokaiMiniTheme
#bgcolor = :grey95
#set_theme!(theme_light())

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
    Label(fig[2, 1], "Basics: Axis", textsize = 60, tellwidth = false)
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

idx = [(11,15), (18, 21), (24, 28), (31,35), (38, 43), (46,51), (54,72), (75,101), (104, 129), (133,135)]
srco = readlines("../part3_axis1.jl", keep=true)

for j in eachindex(idx)
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
        img = load("./imgs/part3_$(j).png")
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
#display(pres)
MakieSlides.save(joinpath(@__DIR__, "part3_slides_h_dark.pdf"), pres)
#MakieSlides.save(joinpath(@__DIR__, "part3_slides_h_light.pdf"), pres)
reset!(pres)