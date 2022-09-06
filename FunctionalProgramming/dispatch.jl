# Recap from day 1


# Loops can be fast in julia



# This does not mean you have to write loops all over the place, feel encouraged to use dots



# The dot syntax is just different syntax for calling broadcast



# What are functions/callable objects



# map, broadcast, mapreduce, foldl



# Examples: 
# In the following section we have a collection of small programming tasks. You can choose
# if you want to solve the task by using vectorized operations, writing a for-loop or 
# by using a functional pattern

# 1. Compute Sum of squares of a vector 

x = rand(10)
function ssq(x)

end

# 2. Count how often in a series X the successor is larger than the predecessor, 
# i.e. count how many times X_{i+1} > X_{i} for all i.  

data = rand(100)
function count_pos_diff(x)

end


# 3. applying a function chain to an array
data = rand(20)
# compute abs(sin(2*x)) for every element 
function abs_of_sin_of_2x(x)

end

# 4. Return the largest 2 values of a collection

data = rand(100)
function largest_two(x)

end

# 5. grouped aggregation of vector of named tuples
classes = ["Tree", "Grass","Barren"] 
data = [(class = rand(classes), data = rand()) for _ in 1:100]

function minimum_by_class(data)

end
# 6. running a model in forward mode
# given a vector of inputs X and an initial state S_0=0
# we can compute S_{i+1} = S_i*a + X_i
# Compute the state S_n where n is the number of elements of X


data = rand(50)
function run_evolution(x::Vector; s0=0.0, a=0.5)


end

# Overview of differential equation amd automatic differentiation packages



# Preview for tomorrow: Dealing with Zarr, NetCDF and DiskArrays



