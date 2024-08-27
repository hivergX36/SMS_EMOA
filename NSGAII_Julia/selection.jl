
# return a parent winner of a binary tournament selection
# ASSERTION : the given population must have been evaluated for crowding distance
function SELECTION_binary_tournament(population::Vector{Sol}; criteria = CROWDING, debug = true)

    debug && DEBUG_feasible_solutions(population)
    #debug && DEBUG_correct_evaluations(population) # expensive (full evaluation)

    @timeit to "Selection.domination_tournament" begin

    function winner_match(population::Vector{Sol}, ind_1::Int, ind_2::Int)
        if INDICATOR_is_dominating(population[ind_1], population[ind_2], debug = debug)
            return ind_1
        elseif INDICATOR_is_dominating(population[ind_2], population[ind_1], debug = debug)
            return ind_2
        elseif criteria == CROWDING
            if population[ind_1].crowding > population[ind_2].crowding
                return ind_1
            else
                return ind_2
            end
        elseif criteria == HV
            if population[ind_1].hv_contrib > population[ind_2].hv_contrib
                return ind_1
            else
                return ind_2
            end
        end
    end

    N = length(population)

    # pick two random distinct solutions
    ind_1 = rand(1:N)
    ind_2 = rand(1:N)
    while ind_1 == ind_2
        ind_2 = rand(1:N)
    end

    # return only the winner
    selected_solution = population[winner_match(population, ind_1, ind_2)]

    return selected_solution

    end # TimerOutput

end

#=
function SELECTION_uniform(population::Vector{Sol}, nb_selected::Int; debug = true)

    debug && DEBUG_feasible_solutions(population)

    @timeit to "Selection.uniform" begin

    # ATTENTION : before i was using @view ... and it didn't work, the order was weird
    uniform_sample = randperm(length(population))[1:nb_selected]
    selection = population[uniform_sample]

    end # TimerOutput

    debug && DEBUG_feasible_solutions(selection)

    return selection
end

function SELECTION_domination_tournament(population::Vector{Sol}, nb_selected::Int; debug = true)

    debug && DEBUG_feasible_solutions(population)

    @timeit to "Selection.domination_tournament" begin

    @assert nb_selected <= length(population)/2 "In a tournament selection, we can't pick more than half of the population"

    function winner_match_domination(population::Vector{Sol}, ind_1::Int, ind_2::Int)
        if INDICATOR_is_dominating(population[ind_1], population[ind_2])
            return ind_1
        elseif INDICATOR_is_dominating(population[ind_2], population[ind_1])
            return ind_2
        else
            if rand() < 0.5
                return ind_1
            else
                return ind_2
            end
        end
    end
    
    N = length(population)

    if nb_selected == 1 # special case
        # pick two random distinct solutions
        ind_1 = rand(1:N)
        ind_2 = rand(1:N)
        while ind_1 == ind_2
            ind_2 = rand(1:N)
        end
        # return only the winner
        selection = population[winner_match_domination(population, ind_1, ind_2)]
    
    elseif nb_selected == 2 # && N > 10 # special case : SMS_EMOA. Faster than general case.
        # pick four random distinct solutions
        ind_1 = rand(1:N)
        ind_2 = rand(1:N)
        ind_3 = rand(1:N)
        ind_4 = rand(1:N)

        while ind_2 == ind_1 || ind_2 == ind_3 || ind_2 == ind_4
            ind_2 = rand(1:N)
        end

        while ind_3 == ind_1 || ind_3 == ind_4
            ind_3 = rand(1:N)
        end

        while ind_4 == ind_1
            ind_4 = rand(1:N)
        end

        winners_indicies = [winner_match_domination(population, ind_1, ind_2), winner_match_domination(population, ind_3, ind_4)]

        selection = population[winners_indicies]

    else # general case
        # pick 2*nb_selected random distinct solutions
        uniform_sample = randperm(N)[1:2*nb_selected]
        winners_indicies = Vector{Int}(undef, nb_selected)

        # make them fight in dominance fights
        for match in 1:nb_selected
            ind_1 = uniform_sample[2*match-1]
            ind_2 = uniform_sample[2*match]

            winners_indicies[match] = winner_match_domination(population, ind_1, ind_2)
        end

        # return only the winner of each fight
        selection = population[winners_indicies]
    end

    end # TimerOutput

    debug && DEBUG_feasible_solutions(selection)

    return selection
end
=#