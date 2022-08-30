using GLMakie, Markdown, MakieSlides, Random, FileIO
include("codeColors.jl")
#set_theme!()

# dark theme
#themexx = Themes.TracTheme
#bgcolor = :grey90
#set_theme!(theme_dark())
#txtcolor = :grey
# light theme
txtcolor = :orangered
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
    Label(fig[2, 1], "Mixed: Axis, Axis3 & LScene", textsize = 60, tellwidth = false)
    Label(fig[3, 1], "Danisch & Krumbiegel, (2021). Makie.jl: Flexible high-performance data visualization for Julia.\nJournal of Open Source Software, 6(65), 3349",
        textsize = 20, tellwidth = false, color = :dodgerblue)
    rowgap!(fig.layout, 1, Fixed(10))
    s = campixel(fig.scene)
    text!(s, "Data Visualization", position=(20, 40), space=:pixel,
        color = :grey60,  textsize = 14,)
    text!(s, "Lazaro Alonso @LazarusAlon", position=(20, 25), space=:pixel, color =txtcolor, 
        textsize = 12,)
    text!(s, "MPI-BGI", position=(20, 10), space=:pixel, color =txtcolor, 
        textsize = 12,)
end

for j in 1:2
    add_slide!(pres) do s
        fig = GridLayout(s[1,1])
        img = load("./imgs/part6_$(j).png")
        ax = Axis(fig[1,1], aspect = DataAspect())
        image!(ax, rotr90(img))
        hidedecorations!(ax)
        hidespines!(ax)
        colsize!(s.layout, 1, Auto(0.7))
        colgap!(s.layout, 5)
        snew = campixel(s.scene)
        text!(snew, "Data Visualization", position=(20, 40), space=:pixel,
            color = :grey60,  textsize = 14,)
        text!(snew, "Lazaro Alonso @LazarusAlon", position=(20, 25), space=:pixel, color =txtcolor, 
            textsize = 12,)
        text!(snew, "MPI-BGI", position=(20, 10), space=:pixel, color =txtcolor, 
            textsize = 12,)
    end
end

idx = [(1,26), (27, 47), (48, 71), (72, 92)]
srco = readlines("../part6_axis_mixed.jl", keep=true)
hs = 400
add_slide!(pres) do s
    fig1 = [GridLayout(s[j,i]) for i in 1:2 for j in 1:2]
    for j in eachindex(idx)
        src1x = srco[idx[j][1]:idx[j][2]]
        #h1o = length(src1x)*22
        srcxxo = join(src1x)
        strxxo, colorsxxo = highlight_text(srcxxo, themexx)
    
        axcode = Axis(fig1[j][1,1], height = hs, tellheight = false, 
            backgroundcolor = bgcolor)
        t = text!(axcode, strxxo, color = colorsxxo[1], textsize = 12,
            position = (0.025,0.98),
            align = (:left, :top), space= :relative,
            font = "mono",
            )
        hidedecorations!(axcode)
        hidespines!(axcode)
        applycolors(t, colorsxxo)
    end
    colsize!(s.layout, 1, Auto(1))
    colgap!(s.layout, 1)
    rowgap!(s.layout, 0)
    snew = campixel(s.scene)
    text!(snew, "Data Visualization", position=(30, 50), space=:pixel,
        color = :black,  textsize = 14,)
    text!(snew, "Lazaro Alonso @LazarusAlon", position=(30, 38), space=:pixel, color =:black, 
        textsize = 12,)
    text!(snew, "MPI-BGI", position=(30, 25), space=:pixel, color =:black, 
        textsize = 12,)
end


#display(pres)
#MakieSlides.save(joinpath(@__DIR__, "part6_slides_h_dark.pdf"), pres)
MakieSlides.save(joinpath(@__DIR__, "part6_slides_h_light.pdf"), pres)
reset!(pres)