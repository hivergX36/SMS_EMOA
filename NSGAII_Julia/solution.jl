
function SOLUTION_is_feasible(sol::Sol; debug = true)

    debug && DEBUG_correct_solution(sol)

    @timeit to "Solution.is_feasible" begin

    momkp = sol.prob

    feasible = true
    dim = 1
    while feasible && dim <= momkp.m
        if sol.w[dim] > momkp.ω[dim]
            feasible = false
        end
        dim += 1
    end

    end # TimerOutput
    
    return feasible
end

function SOLUTION_add_seed(sol::Sol, item)
    @timeit to "Solution_add_seed" begin

        sol.x = item
        
        
    end
end


function SOLUTION_add_item!(sol::Sol, item::Int; debug = true)

    debug && @assert sol.x[item] == 0 "Item already in the bag"
    debug && DEBUG_correct_solution(sol) # abusive

    @timeit to "Solution.add_item!" begin

    momkp = sol.prob

    sol.x[item] = 1
    sol.z[1] += momkp.P[1,item]
    sol.z[2] += momkp.P[2,item]
    for dim in 1:momkp.m
        sol.w[dim] += momkp.W[dim,item]
    end

    end # TimerOutput

    debug && DEBUG_correct_solution(sol)

end

function SOLUTION_remove_item!(sol::Sol, item::Int; debug = true)

    debug && @assert sol.x[item] == 1 "Item not in the bag"
    debug && DEBUG_correct_solution(sol) # abusive

    @timeit to "Solution.remove_item!" begin

    momkp = sol.prob

    sol.x[item] = 0
    sol.z[1] -= momkp.P[1,item]
    sol.z[2] -= momkp.P[2,item]
    for dim in 1:momkp.m
        sol.w[dim] -= momkp.W[dim,item]
    end
    
    end # TimerOutput

    debug && DEBUG_correct_solution(sol)
    
end

function SOLUTION_empty_solution(momkp::_MOMKP)

    @timeit to "Solution.empty_solution" begin

    empty_sol = Sol(momkp, zeros(Int, momkp.n), [0, 0], zeros(Int, momkp.m))

    end # TimerOutput

    return empty_sol
end

function SOLUTION_list_of_empty_solutions(nb_solutions::Int, momkp::_MOMKP)

    @timeit to "vector_empty_solutions" begin

    vec = Vector{Sol}(undef, nb_solutions)
    for i in 1:nb_solutions
        vec[i] = SOLUTION_empty_solution(momkp)
    end

    end # TimerOutput

    return vec
end


function remplacement_solution(pop::Vector{Sol}, choix,solution)
    remplacement = pop
    remplacement[choix].x = solution[2]
    remplacement[choix].z[1] = obj1(1,solution[2],remplacement[choix].prob.P[1,:])
    remplacement[choix].z[2] = obj2(1,solution[2],remplacement[choix].prob.P[2,:])
    for i in 1:remplacement[choix].prob.m
        remplacement[choix].w[i] = sum(remplacement[choix].prob.W[i,j]*solution[2][j] for j in 1:remplacement[choix].prob.n)
    end
    return remplacement
end

function creation_solution(momkp::_MOMKP,solution)
    number = length(solution)
    new_solution = SOLUTION_list_of_empty_solutions(number, momkp)
    for i in 1:length(new_solution)
        new_solution[i] = add_solution(new_solution[i],solution[i])
    end
    return new_solution
end

function add_solution(sol::Sol,x)
    sol.x = x[2] 
    sol.z[1] = obj1(1,x[2],sol.prob.P[1,:])
    sol.z[2] = obj2(1,x[2],sol.prob.P[2,:])
    for i in 1:sol.prob.m
        sol.w[i] = sum(sol.prob.W[i,j]*x[2][j] for j in 1:sol.prob.n)
    end
    return sol
end

