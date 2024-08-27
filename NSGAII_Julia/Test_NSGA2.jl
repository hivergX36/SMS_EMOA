# Main file

# INCLUDE LIBRARIES ############################################

println("\n\$ Loading libraries")

println("[INFO] using TimerOutputs ...")
using TimerOutputs
println("[INFO] using Random ...")
using Random
println("[INFO] using PyPlot ...")
#=println("[INFO] using vOptGeneric ...")
using vOptGeneric
println("[INFO] using JuMP ...")
using JuMP
println("[INFO] using GLPK ...")
using GLPK=#

# INCLUDE FILES ############################################

# Structs, tools, debuging, indicators computation...
include("structs.jl")
include("meta_structure.jl")
#include("printing.jl")
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
include("seed.jl")
include("path_relinking.jl")

# EMOA algorithms
include("nsgaii.jl")
include("sms_emoa.jl")

# INTRO #####################################################

to = TimerOutput()
seed = 2
nb_voisin = 4
seed2 = 0
nbvoisin2 = 0

# CODE #######################################################

G = readInstanceMOMKPformatZL(true,"knapsack.100.4")
front_G = NSGAII_solve(G ; nb_it = 10, max_t = 10.0, size_pop = 10,seed, nbvoisin, debug = true)
front_G2 = NSGAII_solve(G ; nb_it = 10, max_t = 10.0, size_pop = 10,seed2, nbvoisin2, debug = true)


