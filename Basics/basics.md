## Editors

I am using mostly VS Code for my development but you could also use

- Jupyter
- Pluto
- any other IDE you are comfortable with

## Basic Syntax

Assignment with =
x = 3

Silence printing with ;

## Types

In Julia everything has a Type.
You can check the type of a variable with 
```julia
typeof(1)
typeof(1.0)

supertypes(Float64)

Int64 <: Number # Subtype relationship

subtypes(Number)
```

### Multiple Dispatch and Methods 

- Julia is Multiple Dispatch
- Functions in Julia have methods associated for different combinations of types
- methods are selected by the type of all inputs

Code Example function definition

```julia
function hello(name)
    "Hello $(name)!"
end
hello("Greg")

hello(["Greg, Nora"])

function hello(names::Vector) 
    return  "Hello " * join(names, ",", " and" )
end

function hello(name, x::Int) 
    repeat(hello(name), x)
end
hello("Greg", 3)
function hello(name, x::Any)
    repeat(hello(name), Int(x))
end
hello("Greg", 3.0)
hello("Greg", 3.4)

function hello(names::Vector, x::Int)
    for i in 1:x
        println(hello(names))
    end
end

```

## Arrays

Standard Julia Arrays are mutable ordered collections of the same type. The dimension of an array is important and encoded as a type parameter
`Matrix` is an Array of two dimensions.
`Vector` is an Array of one dimensions. 

The dimension of an Array is independent of its element type.

```julia

any = []
intempty = Int[]

v = [1,2,3]

Float64[1,2,3]

a = [1 2 3]

b = Float64[1 2 3 ; 2 3 4]

c = [1, 2, 3.]

d = [1, 2, "three"]

```

### More Array constructors

```julia

similar(a)
zero(b)
zeros(size(b))
ones(a)
```

### Array Access

```julia
a[1,1]
size(a)
size(b)
eltype(a)
eltype(b)
typeof(a)
typeof(b)
a[2,:]
b[2,:]

a[1,end]

Any[1,3, 4.0]
b[begin+1,end]
a[1,begin+1:end-1]
```

### Broadcasting

```julia
v + v
v * v
v .* v

a + a
a * a
a.*a
a
b
a + b 
a .+ b

a .+ 4

ns = ["Greg", "Uli"]
hello(ns)
hello.(ns)
```

## Comprehension

```julia
for i = 1
    println(i)
end

for i = 1:5, j = [" Dog", " Cat"]
    println(i,j)
end

[string(i,j) for i=1:5, j= ["Dog", "Cat"]]
samplenames = ["Sample " * string(i) for i=1:5]
"Sample " .* string.(1:5)
```

## Performance

- Write your code in functions
- Measure your code with @time and @btime 
- Check for allocations
- Make your code typestable

```julia


function unstable(flag::Bool)
           if flag
               return 1
           else
               return 1.0
           end
       end
function stablebool(flag::Bool)
           if flag
               return 1
           else
               return 1
           end
       end

function unstable()
    x = 1
    for i = 1:10
        x /= rand(Int64)
    end
    return x
end

function stable()
    x = 1.0
    for i = 1:1000000
        x /= rand()
    end
    return x
end

```

## Missing values

- Can be represented by Missing
- Or by NaN



## Basic Plots

```julia
using UnicodePlots

@time lineplot(rand(100))
@time lineplot(rand(100))
lineplot(sin.(0:.01:3π))
```


## Workflow

I highly recommend to develop your code directly in a package structure to enable better reusability and also testability. 

To set up a package you can use PkgTemplates

```julia
using PkgTemplates
Template(user="felixcremer", dir=".")("MyScienceProject")
```

### Tests

You can then add tests to your package in the tests/ folder. 

