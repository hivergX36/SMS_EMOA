
# Main file

# INCLUDE LIBRARIES ############################################

println("\n\$ Loading libraries")

println("[INFO] using TimerOutputs ...")
using TimerOutputs
println("[INFO] using Random ...")
using Random
println("[INFO] using PyPlot ...")
using PyPlot
#=println("[INFO] using vOptGeneric ...")
using vOptGeneric
println("[INFO] using JuMP ...")
using JuMP
println("[INFO] using GLPK ...")
using GLPK=#

# INCLUDE FILES ############################################

# Structs, tools, debuging, indicators computation...
include("structs.jl")
include("printing.jl")
include("debug.jl")
include("tool.jl")
include("solution.jl")
include("indicator.jl")

# GA operators
include("initialisation.jl")
include("selection.jl")
include("crossover.jl")
include("mutation.jl")
include("reparation.jl")

# EMOA algorithms
include("nsgaii.jl")
include("sms_emoa.jl")

# INTRO #####################################################

to = TimerOutput()

print_version()

# CODE #######################################################

function test_nsgaii(; nb_it = 3, max_t = 30.0, size_pop = 10, debug = true)
    prob = MOMKP("instancesZL/knapsack.100.2",ZL)

    front_estimation = NSGAII_solve(prob, nb_it = nb_it, max_t = max_t, size_pop = size_pop, debug = debug)
end

function test_sms_emoa(; nb_it = 3, max_t = 30.0, size_pop = 10, debug = true)
    prob = MOMKP("instancesZL/knapsack.100.2",ZL)

    front_estimation = SMS_EMOA_solve(prob, nb_it = nb_it, max_t = max_t, size_pop = size_pop, debug = debug)
end

function test_vOpt(; debug = true)
    prob = MOMKP("instancesZL/knapsack.100.2",ZL)
    Y_N, X_E = TOOL_vOptGeneric_Solve(GLPK.Optimizer, prob)
end

function compare_algos(; nb_it = 10, max_t = 10.0, size_pop = 10, debug = true)
    prob = MOMKP("instancesZL/knapsack.100.2",ZL)

    println("start")

    NSGAII_front = NSGAII_solve(prob, nb_it = nb_it, max_t = max_t, size_pop = size_pop, debug = debug)
    SMS_front = SMS_EMOA_solve(prob, nb_it = nb_it, max_t = max_t, size_pop = size_pop, debug = debug)
    
    #Y_N, X_E = TOOL_vOptGeneric_Solve(GLPK.Optimizer, prob)

    println("end")

    NSGAII_YN = Vector{Vector{Int}}(undef, length(NSGAII_front))
    SMS_YN = Vector{Vector{Int}}(undef, length(SMS_front))

    for i in 1:length(NSGAII_front)
        NSGAII_YN[i] = NSGAII_front[i].z
    end

    for i in 1:length(SMS_front)
        SMS_YN[i] = SMS_front[i].z
    end

    return NSGAII_YN, SMS_YN
end