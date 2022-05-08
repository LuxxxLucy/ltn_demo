include("./src/LogicChains.jl")
using .LogicChains
using Zygote
# import .LogicChains
using Printf
using DataFrames, StatsPlots

(|)(args...) = Base.:(|)(args...)
(|)(x, f::Function) = Infixed(x, f)
(|)(xf::Infixed, y) = xf.f(xf.x, y)

X = [1, 2, 3, 10]
Y = [1, 2]

# dict = Dict(
#   1 => 1.0,
#   2 => 1.0,
#   3 => 1.0,
#   10 => 2.0
# )
# dict = Dict(
#   1 => 1.0,
#   2 => 1.0,
#   3 => 1.0,
#   10 => 2.0
# )

dict = Dict{Tuple{Int64,Int64},Float64}()
dict[(1, 1)] = 1.0
dict[(2, 1)] = 1.0
dict[(3, 1)] = 1.0
# dict[(1, 2)] = 0.0
# dict[(2, 2)] = 0.0
# dict[(3, 2)] = 0.0
dict[(10, 1)] = 0.0
# dict[(10, 2)] = 1.0

for (key, value) in dict
  dict[key] = rand(Float64)
end

function neural_(x, y, dict)
  if y == 1
    return dict[x, 1]
  else
    return 1 - dict[x, 1]
  end
end

function C(x, y, dict)
  neural_(x, y, dict)
end


g = Group(
  [
  dict -> forall([
    exists([
      C(1, 1, dict),
      C(1, 2, dict),
    ]),
    exists([
      C(2, 1, dict),
      C(2, 2, dict),
    ]),
    exists([
      C(3, 1, dict),
      C(3, 2, dict),
    ]),
    exists([
      C(10, 1, dict),
      C(10, 2, dict),
    ]),
  ]),
  dict -> forall([
    exists([
      C(1, 1, dict),
      C(2, 1, dict),
      C(3, 1, dict),
      C(10, 1, dict),
    ]),
    exists([
      C(1, 2, dict),
      C(2, 2, dict),
      C(3, 2, dict),
      C(10, 2, dict),
    ]),
  ]),
  dict -> forall([
    C(1, 1, dict) | eq | C(2, 1, dict),
    C(1, 1, dict) | eq | C(3, 1, dict),
    C(2, 1, dict) | eq | C(3, 1, dict),
    C(1, 2, dict) | eq | C(2, 2, dict),
    C(1, 2, dict) | eq | C(3, 2, dict),
    C(1, 2, dict) | eq | C(3, 2, dict),
  ]),
  dict -> forall([
    C(1, 1, dict) | non_and | C(10, 1, dict),
    C(2, 1, dict) | non_and | C(10, 1, dict),
    C(3, 1, dict) | non_and | C(10, 1, dict),
    C(1, 2, dict) | non_and | C(10, 2, dict),
    C(2, 2, dict) | non_and | C(10, 2, dict),
    C(3, 2, dict) | non_and | C(10, 2, dict),
    C(1, 1, dict) | non_and | C(1, 2, dict),
    C(2, 1, dict) | non_and | C(2, 2, dict),
    C(3, 1, dict) | non_and | C(3, 2, dict),
    C(10, 1, dict) | non_and | C(10, 2, dict),
  ]),
  # dict -> forall([
  #   C(1, 1, dict) | non_and | C(1, 2, dict),
  #   C(2, 1, dict) | non_and | C(2, 2, dict),
  #   C(3, 1, dict) | non_and | C(3, 2, dict),
  #   C(10, 1, dict) | non_and | C(10, 2, dict),
  # ])
  # dict -> forall([exists([C(x, y, dict) for y ∈ Y]) for x ∈ X]),
  # dict -> forall([exists([C(x, y, dict) for x ∈ X]) for y ∈ Y]),
  # dict -> forall(
  #   C(x, label, dict) | eq | C(y, label, dict)
  #   for x ∈ X, y ∈ X, label ∈ Y
  #   if abs(x - y) <= 1
  # ),
  # dict -> forall(
  #   C(x, label, dict) | non_and | C(y, label, dict)
  #   for x ∈ X, y ∈ X, label ∈ Y
  #   if abs(x - y) > 2
  # )
]
)

n = 10
anim = @animate for step in 1:n
  solve(g, dict)
  # data = DataFrame(
  #   x=[k[1][1] for k in keys(dict)],
  #   y=[v for v in values(dict)]
  # )
  score_1 = [v for v in values(dict)]
  score_2 = 1 .- score_1
  ticklabel = string.([k[1][1] for k in keys(dict)])
  groupedbar([score_1 score_2],
    bar_position=:stack,
    bar_width=0.7,
    xticks=(1:4, ticklabel),
    label=["cluster 1" "cluster 2"])
end
gif(anim, "ltn_clustering_demo.gif", fps=2)


