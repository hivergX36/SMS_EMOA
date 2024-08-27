
function REPARATION_repair!(offspring::Sol; debug = true)

    debug && DEBUG_correct_solution(offspring)

    @timeit to "Reparation.repair!" begin

    momkp = offspring.prob

    dim = 1
    exceeding = false

    feasible = SOLUTION_is_feasible(offspring, debug = debug)
    if !feasible
        # repair solution
        for var in 1:momkp.n
            if offspring.x[var] == 0
                exceeding = false
                dim = 1
                while !exceeding && dim <= momkp.m
                    if offspring.w[dim] + momkp.W[dim,var] > momkp.ω[dim]
                        exceeding = true
                    end
                    dim += 1
                end
                !exceeding && SOLUTION_add_item!(offspring, var, debug = debug)
            else
                exceeding = false
                dim = 1
                while !exceeding && dim <= momkp.m
                    if offspring.w[dim] > momkp.ω[dim]
                        exceeding = true
                    end
                    dim += 1
                end
                exceeding && SOLUTION_remove_item!(offspring, var, debug = debug)
            end
        end
    end

    end # TimerOutput

    debug && DEBUG_feasible_solution(offspring)
    
end

#=
function REPARATION_repair!(offsprings::Vector{Sol}; debug = true)

    debug && DEBUG_correct_solutions(offsprings)

    @timeit to "Reparation.repair!" begin

    momkp = offsprings[1].prob

    dim = 1
    exceeding = false

    for offspring in offsprings
        feasible = SOLUTION_is_feasible(offspring, debug = debug)
        if !feasible
            # repair solution
            for var in 1:momkp.n
                if offspring.x[var] == 0
                    exceeding = false
                    dim = 1
                    while !exceeding && dim <= momkp.m
                        if offspring.w[dim] + momkp.W[dim,var] > momkp.ω[dim]
                            exceeding = true
                        end
                        dim += 1
                    end
                    !exceeding && SOLUTION_add_item!(offspring, var, debug = debug)
                else
                    exceeding = false
                    dim = 1
                    while !exceeding && dim <= momkp.m
                        if offspring.w[dim] > momkp.ω[dim]
                            exceeding = true
                        end
                        dim += 1
                    end
                    exceeding && SOLUTION_remove_item!(offspring, var, debug = debug)
                end
            end
        end
    end

    end # TimerOutput

    debug && DEBUG_feasible_solutions(offsprings)
    
end
=#