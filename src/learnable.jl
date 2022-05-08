using Printf
using Zygote

struct Infixed{X,F<:Function}
    x::X
    f::F
end

mutable struct Group
    # vars::Vector{Variable}
    # nodes::Vector{Expr}
    nodes::Vector{Function}
    # func::Function
end

function print_node(x)
    Printf.@printf("expr %s\n", x)
end

# function score(dict_)
#     t = product( eval(c(dict_)) for c ∈ g.nodes)
#     println("this is ",t)
#     return t
# end

# macro hack(f,variable)
#     quote
#         Base.invokelatest(f, variable)
#     end
# end

# macro expr2fn(fname, expr, args...)
#     fn = quote
#         function $(esc(fname))()
#             $(esc(expr.args[1]))
#         end
#     end
#     for arg in args
#         push!(fn.args[2].args[1].args, esc(arg))
#     end
#     return fn
# end

function buffer_helper(x, funcs)
    buf = Zygote.Buffer(rand(length(funcs)), length(funcs))
    for i = 1:length(funcs)
        buf[i] = funcs[i](x)
    end
    return copy(buf)
end

function solve(g::Group, dict_)
    score_f = dict -> 1 - prod(buffer_helper(dict, g.nodes))
    score = score_f(dict_)
    println("score is",score)
    grad = gradient(score_f, dict_)[1]

    α = 1
    for (key, _) in grad
        dict_[key] -= α * grad[key]
        dict_[key] = clamp(dict_[key], 0.01, 0.99)
    end
    println(dict_)
    return
    # return dict_
end