# ## Syntax

methods(+)
methodswith(Float64, +)


function hello(name)
    return "Hello $(name)!"
end

hello("Uli")
hello(["Uli", "Greg"])


function hello(names::AbstractArray)
    join(names, ",", " and ")
end

hello(["Uli", "Greg"])

hello(name, x::Int) = repeat(hello(name), x)

hello("Uli", 3)

hello("Uli", 3.0)

hello(name, x::Number) = repeat(hello(name), Int(x)) 
hello("Greg", 4.)

hello("Greg", Complex(3,2))
