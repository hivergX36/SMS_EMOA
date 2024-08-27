
TOOL_inf() = 2^31 - 1

function TOOL_concatenate_solutions_vectors(population::Vector{Sol}, offsprings::Vector{Sol}; debug = debug)

    debug && DEBUG_feasible_solutions(population)
    debug && DEBUG_feasible_solutions(offsprings)

    @timeit to "Tool.concatenate_solutions_vectors" begin

    result = vcat(population,offsprings)

    end # TimerOutput

    return result
end

function TOOL_remove_doublons_from_front(front::Vector{Sol}; debug = debug)
    
    debug && DEBUG_is_front(front)
    
    @timeit to "Tool.remove_doublons_from_front" begin

    new_front = Vector{Sol}(undef, 0)

    for sol in front
        if !(sol in new_front)
            push!(new_front, sol)
        end
    end

    end # TimerOutput

    debug && DEBUG_is_front(new_front)
    debug && DEBUG_unicity(new_front)

    return new_front
end

function TOOL_termination_criteria_met(it::Int, nb_it::Int)
    return it > nb_it
end

function TOOL_termination_criteria_met(t::Float64, max_t::Float64)
    return t > max_t
end

#= Uncomment with the updated version (home computer)
function TOOL_vOptGeneric_Solve(solverSelected, prob)

    A = prob.W
    B = prob.ω
    C = prob.P

    m, n = size(A)
  
    # ---- setting the model
    println("Building...")
    Bi01IP = vModel( solverSelected )
    @variable( Bi01IP, x[1:n], Bin )
    @addobjective( Bi01IP, Max, sum(C[1,j] * x[j] for j=1:n) )
    @addobjective( Bi01IP, Max, sum(C[2,j] * x[j] for j=1:n) )
    @constraint( Bi01IP, cte[i=1:m], sum(A[i,j] * x[j] for j=1:n) <= B[i])
  
    # ---- Invoking the solver (epsilon constraint method)
    println("Solving...")
    vSolve( Bi01IP, method=:epsilon, step=0.5, verbose=true )
  
    # ---- Querying the results
    println("Querying...")
    Y_N = getY_N( Bi01IP )
  
    return Y_N, x
end=#