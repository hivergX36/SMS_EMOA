
function MUTATION_flip!(offspring::Sol; debug = true)
    
    debug && DEBUG_correct_solution(offspring)

    @timeit to "Mutation.flip!" begin

    mut_ind = rand(1:offspring.prob.n) # mutation index
    offspring.x[mut_ind] == 0 ? SOLUTION_add_item!(offspring, mut_ind, debug = debug) : SOLUTION_remove_item!(offspring, mut_ind, debug = debug) # flip

    end # TimerOutput

    debug && DEBUG_correct_solution(offspring)

end

#=
function MUTATION_flip!(offsprings::Vector{Sol}, mutation_rate::Float64; debug = true)

    debug && DEBUG_correct_solutions(offsprings)

    @timeit to "Mutation.flip!" begin

    momkp = offsprings[1].prob
    for sol in offsprings
        if rand() < mutation_rate
            mut_ind = rand(1:momkp.n) # mutation index
            sol.x[mut_ind] == 0 ? SOLUTION_add_item!(sol, mut_ind, debug = debug) : SOLUTION_remove_item!(sol, mut_ind, debug = debug) # flip
        end
    end

    end # TimerOutput

    debug && DEBUG_correct_solutions(offsprings)
    
end
=#