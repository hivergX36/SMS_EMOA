
function CROSSOVER_binary_uniform(p1::Sol, p2::Sol; debug = true)
    
    debug && DEBUG_feasible_solution(p1)
    debug && DEBUG_feasible_solution(p2)

    @timeit to "Crossover.binary_uniform" begin

    momkp = p1.prob
    n = momkp.n

    uniform_sample = rand(1:2, n)

    offspring = SOLUTION_empty_solution(momkp)

    for idx_var in 1:n
        # get the value of the gene
        value = p1.x[idx_var]
        if uniform_sample[idx_var] == 2
            value = p2.x[idx_var]
        end

        # if the item has been added, modify the solution
        if value == 1
            SOLUTION_add_item!(offspring, idx_var, debug = debug)
        end
    end

    end # TimerOutput
    
    debug && DEBUG_correct_solution(offspring)

    return offspring

end

#=
function CROSSOVER_uniform(parents::Vector{Sol}, size_offsprings::Int; debug = true, verbose = false)

    debug && DEBUG_feasible_solutions(parents)

    @timeit to "Crossover.uniform" begin

    momkp = parents[1].prob
    n = momkp.n

    if size_offsprings == 1 # special case of SMS-sms_emoa
        uniform_sample = rand(1:length(parents), n)

        verbose && println("crossover sample : ",uniform_sample,"\n")

        offspring = SOLUTION_empty_solution(momkp)

        for index_var in 1:n
            value = parents[uniform_sample[index_var]].x[index_var]
            if value == 1
                SOLUTION_add_item!(offspring, index_var, debug = debug)
            end
        end

        verbose && @show SOLUTION_is_feasible(offspring, debug = debug)

        offsprings = [offspring]

    else # general case
        uniform_samples = rand(1:length(parents), size_offsprings, n)

        verbose && println("crossover samples : ",uniform_samples,"\n")

        offsprings = SOLUTION_list_of_empty_solutions(size_offsprings, momkp)

        for index_offspring in 1:size_offsprings
            for index_var in 1:n
                value = parents[uniform_samples[index_offspring,index_var]].x[index_var]
                if value == 1
                    SOLUTION_add_item!(offsprings[index_offspring], index_var, debug = debug)
                end
            end
        end
    end

    end # TimerOutput

    debug && DEBUG_correct_solutions(offsprings)

    return offsprings
end
=#

# SBX-crossover : TODO