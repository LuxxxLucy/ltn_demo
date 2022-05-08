using Statistics

function equal_(x, y)
    return EQUAL(eval(x),eval(y))
end

function EQUAL(x::Bool, y::Bool)
    return x == y
end
function EQUAL(x::Float64, y::Float64)
    imply(x,y) = 1.0 - x + x*y
    t1 = imply(x,y)
    t2 = imply(y,x)
    t = t1 * t2
    return t
end

# todo: this is not in fact nequal, it is a NAND
function nand_(x, y)
    return NAND_(eval(x), eval(y))
end

function NAND_(x::Bool, y::Bool)
    return x != y
end

function NAND_(x::Float64, y::Float64)
    t = 1 - x * y
    return t
end

# function forall_(x)
#     # println("for all 1")
#     # x = map(eval, x)
#     # x = map(x -> (@eval d -> $x(:d))(x), x)
#     # println("for all 2")
#     # t = all(x .== true)
#     # t = ALL(x)
#     # t = Expr(:call, :ALL, Expr(:call, :eval, x))

#     # t = Expr(:call, :ALL, [Expr(:call, :eval, i) for i in x])
#     t = Expr(:call, :ALL, [Expr(:call, :eval, i) for i in x]...)
#     t = Expr(:call, :ALL, [(i) for i in x])
#     # println("call forall x is ",x)
#     # t = Expr(:call, :ALL, x...)
#     # t = Expr(:call, :ALL, x)
#     # t = Expr(:call, :ALL, eval(x))
#     return t
# end
function ALL(x::Array{Bool})
    t = all(x .== true)
    return t
end

function ALL(x::Array{Real})
    p=4.0
    tmp = Statistics.mean( (1.0 .- x) .^ p)
    t = 1 - (tmp) ^ (1/p)
    return t
end

function ALL(x::Array{Float64})
    p=4.0
    tmp = mean( (1.0 .- x) .^ p)
    t = 1 - (tmp) ^ (1/p)
    return t
end

# function exists_(x)
#     x = map(eval, x)
#     t = ANY(x)
#     return t
# end

function ANY(x::Array{Bool})
    t = any(x .== true)
    return t
end

function ANY(x::Array{Float64})
    # p=6.0
    p = 100
    tmp = mean( (x).^ p)
    t = tmp ^ (1/p)
    return t
end

(eq)(x, y) = EQUAL(x, y)
(non_and)(x, y) = NAND_(x, y)
(non_equal) = 

(forall)(x) = ALL(x)
(exists)(x) = ANY(x)