module LogicChains

export Group, solve
export Infixed

export forall, exists
export eq, non_and
# export C
include("./logic.jl")

export C
include("./learnable.jl")

end