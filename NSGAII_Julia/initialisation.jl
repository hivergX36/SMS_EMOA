
# RANDOM FEASIBLE POPULATION #####################################################

# generate a totally random population of feasible solutions for the given momkp
function INIT_random_feasible_population(size_population::Int, momkp::_MOMKP,seed::Int; debug = true)

    @timeit to "Init.random_feasible_population" begin
        
    population = Vector{Sol}(undef, size_population)
    if seed > 0 
        for i in 1:seed 
            population[i] = INIT_seed_feasible_solution(momkp)
        end
    end
    
    for i in seed + 1 :size_population   
        population[i] = INIT_random_feasible_solution(momkp, debug = debug)
    end

    # sort!(population, by = sol -> sol.z[1]) # O(nlog(n))

    end # TimerOutput

    debug && DEBUG_feasible_solutions(population)

    return population
end

# RANDOM FEASIBLE SOLUTION #####################################################

# generate a random feasible solution for the given momkp
function INIT_random_feasible_solution(momkp::_MOMKP; debug = true)

    @timeit to "Init.random_feasible_solution" begin

    perm_var = randperm(momkp.n) # random order for the variables
    can_be_added = true # true if the current variable fit in the bag
    dim = 1
    sol = SOLUTION_empty_solution(momkp)
    for var in 1:momkp.n
        # make sure the object won't exceed one of the dimensions
        can_be_added = true
        dim = 1
        while can_be_added && dim <= momkp.m
            if sol.w[dim] + momkp.W[dim,perm_var[var]] > momkp.ω[dim]
                can_be_added = false
            end
            dim += 1
        end
        can_be_added && SOLUTION_add_item!(sol, perm_var[var], debug = debug)
    end

    end # TimerOutput

    debug && DEBUG_feasible_solution(sol)

    return sol
end