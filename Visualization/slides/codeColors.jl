using Highlights, Colors
using Highlights.Format
using Highlights.Tokens
using Highlights.Themes
css2color(str) = parse(RGBA{Float32}, string("#", str))
css2color(c::Themes.RGB) = RGBA{Float32}(c.r / 255, c.g / 255, c.b / 255, 1.0)

function style2color(style, default)
    if style.fg.active #has_fg(style)
        css2color(style.fg)
    else
        default
    end
end

function render_str(
    ctx::Format.Context, theme::Format.Theme
)
    defaultcolor = if theme.base.fg.active # #has_fg(theme.base)
        css2color(theme.base.fg)
    else
        RGBA(0.0f0, 0.0f0, 0.0f0, 1.0f0)
    end
    colormap = map(s -> style2color(s, defaultcolor), theme.styles)
    tocolor = Dict(zip(Tokens.__TOKENS__, colormap))
    colors = RGBA{Float32}[]
    io = IOBuffer()
    for token in ctx.tokens
        t = Tokens.__TOKENS__[token.value.value]
        str = SubString(ctx.source, token.first, token.last)
        print(io, str)
        append!(colors, fill(tocolor[t], length(str)))
        # push!(colors, tocolor[t])
    end
    String(take!(io)), colors
end

function highlight_text(src::AbstractString, theme = Themes.DefaultTheme)
    io = IOBuffer()
    render_str(
        Highlights.Compiler.lex(src, Lexers.JuliaLexer),
        Themes.theme(theme)
    )
end