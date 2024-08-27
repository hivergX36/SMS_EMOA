
function SMS_EMOA_update(P::Vector{Sol}, mutation_rate::Float64; debug = true)

    debug && DEBUG_feasible_solutions(P)
    debug && DEBUG_correct_evaluations(P, hv = true)

    @timeit to "SMS_EMOA.update" begin

    momkp = P[1].prob
    N = length(P)

    #--------- generate offspring ----------#

    # choose parents
    parent_1 = SELECTION_binary_tournament(P, criteria = HV, debug = debug)
    parent_2 = SELECTION_binary_tournament(P, criteria = HV, debug = debug)
    while parent_2 == parent_1
        parent_2 = SELECTION_binary_tournament(P, criteria = HV, debug = debug)
    end

    # recombine parents
    offspring = CROSSOVER_binary_uniform(parent_1, parent_2, debug = debug)

    # mutate offspring
    if rand() < mutation_rate
        MUTATION_flip!(offspring, debug = debug)
    end

    # repair offspring
    REPARATION_repair!(offspring, debug = debug)

    #-------------- add offspring to current population ---------------#

    # add offspring to the population
    push!(P, offspring)

    #- sort population by rank, and compute hypervolume for each rank -#

    # evaluate population
    F = INDICATOR_fast_non_dominated_sort!(P, debug = debug)
    for front in F
        INDICATOR_hypervolume_contribution!(front, debug = debug)
    end

    #- Find the solution in last rank that contributes the less to hv -#

    R_I = F[length(F)]

    # find the solution in R_I that contributes the less to the hypervolume
    idx_min = 1
    sol_min = R_I[1]
    hv_min = R_I[1].hv_contrib
    for idx in 1:length(R_I)
        sol = R_I[idx]
        if sol.hv_contrib < hv_min
            idx_min = idx
            sol_min = sol
            hv_min = sol.hv_contrib
        end
    end

    deleteat!(R_I, idx_min) # remove the worst contributing solution in the front

    # evaluate the new contributions (for next iteration)
    if length(R_I) > 0
        INDICATOR_hypervolume_contribution!(R_I, debug = debug)
    end

    # mark the solution that contributes the less to the hypervolume
    sol_min.hv_contrib = -1

    # find the solution marked in P
    idx_worst_contribution_sol = 0
    idx = 1
    while idx <= N+1 && idx_worst_contribution_sol == 0
        if P[idx].hv_contrib == -1 # we found the marked solution
            idx_worst_contribution_sol = idx
        end
        idx += 1
    end

    @assert idx_worst_contribution_sol != 0 "The marked solution isn't found"

    #------------- Remove the worst contribution solution from P -----------#

    # remove the marked solution (contributing less to the hypervolume)
    deleteat!(P, idx_worst_contribution_sol)

    end # TimerOutput

    debug && DEBUG_feasible_solutions(P)
    debug && DEBUG_correct_evaluations(P, hv = true)

    return P
end

function SMS_EMOA_solve(prob::_MOMKP ; nb_it = 10, max_t = 10.0, size_pop = 10, debug = true)
    
    st = time()

    println("start sms")

    # params
    mutation_rate = 0.1

    # create population
    P = INIT_random_feasible_population(size_pop, prob, debug = debug)

    # evaluate population
    F = INDICATOR_fast_non_dominated_sort!(P, debug = debug)
    for front in F
        INDICATOR_hypervolume_contribution!(front, debug = debug)
    end

    # iterate
    while !TOOL_termination_criteria_met(time()-st, max_t)
        #println("")
        #println("sms")
        P = SMS_EMOA_update(P,mutation_rate, debug = debug)
    end

    println("end sms")

    #exit()

    # evaluate population
    F = INDICATOR_fast_non_dominated_sort!(P, debug = debug)

    println("F sms")

    last_front = TOOL_remove_doublons_from_front(F[1], debug = debug)

    println("remove doublons sms")

    sort!(last_front, by = sol -> sol.z[1])

    println("total time spent : ",time() - st)

    return last_front
end