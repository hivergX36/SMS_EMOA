
function NSGAII_update(P::Vector{Sol}, mutation_rate::Float64,nb_voisin; verbose = true, debug = true)

    # P is supposed to be already evaluated (vector of AVLs)
    debug && DEBUG_correct_evaluations(P, crowding = true)

    #------ Offsprings -------#

    N = length(P)

    # generate offsprings
    offsprings = Vector{Sol}(undef, N)
    for idx_offspring in 1:N

        # choose parents
        parent_1 = SELECTION_binary_tournament(P, debug = debug)
        parent_2 = SELECTION_binary_tournament(P, debug = debug)
        while parent_2 == parent_1
            parent_2 = SELECTION_binary_tournament(P, debug = debug)
        end

        # recombine parents
        offspring = CROSSOVER_binary_uniform(parent_1, parent_2, debug = debug)

        # mutate offspring
        if rand() < mutation_rate
            MUTATION_flip!(offspring, debug = debug)
        end

        # repair offspring
        REPARATION_repair!(offspring, debug = debug)

        # store offspring
        offsprings[idx_offspring] = offspring
    end

    #------ Create merged population R, sort it and evaluate it ------#

    R = TOOL_concatenate_solutions_vectors(P,offsprings, debug = debug)

    F = INDICATOR_fast_non_dominated_sort!(R, debug = debug)
    F[1] = local_search(momkp::_MOMKP,population::Vector{Sol}, nbvoisin)

    new_P = Vector{Sol}(undef, N)
    size_new_P = 0
    idx_front = 1

    while size_new_P + length(F[idx_front]) <= N # we can the whole front

        # evaluate front (for next iteration)
        INDICATOR_crowding_distance!(F[idx_front], debug = debug)

        # add the whole front
        for sol_front in F[idx_front]
            size_new_P += 1
            new_P[size_new_P] = sol_front
        end

        idx_front += 1
    end

    if size_new_P < N # we still have space for a few solutions of the next front
        # evaluate front
        INDICATOR_crowding_distance!(F[idx_front], debug = debug)

        # sort front by decreasing crowding distance
        perm = sortperm(F[idx_front], by = sol -> sol.crowding, rev = true)

        idx_sol = 0
        while size_new_P < N
            size_new_P += 1
            idx_sol += 1
            new_P[size_new_P] = F[idx_front][perm[idx_sol]]
        end

    end

    debug && DEBUG_correct_evaluations(new_P, crowding = true)
    debug && @assert length(new_P) == length(P) "Sizes of population have changed"

    return new_P

end

function NSGAII_solve(prob::_MOMKP ; nb_it = 10, max_t = 10.0, size_pop = 10,seed::Int, nb_voisin, debug = true)
    
    st = time()

    #println("start nsgaii")
    
    # params
    mutation_rate = 0.1

    # create population
    P = INIT_random_feasible_population(size_pop, prob, seed, debug = debug)

    # evaluate population
    F = INDICATOR_fast_non_dominated_sort!(P, debug = debug)
    for front in F
        INDICATOR_crowding_distance!(front, debug = debug)
    end

    # iterate
    while !TOOL_termination_criteria_met(time()-st, max_t)
        P = NSGAII_update(P,mutation_rate,nb_voisin, debug = debug)
    end

    println("end nsgaii")

    # evaluate final front
    F = INDICATOR_fast_non_dominated_sort!(P, debug = debug)
    INDICATOR_crowding_distance!(F[1], debug = debug)

    last_front = TOOL_remove_doublons_from_front(F[1], debug = debug)
    sort!(last_front, by = sol -> sol.z[1])

    println("total time spent : ",time() - st)

    return F

end