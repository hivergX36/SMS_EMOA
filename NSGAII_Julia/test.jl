
using BenchmarkTools

function v1(n::Int, m::Int)
    vec = Vector{Int}(undef, 0)
    for i in 1:m
        push!(vec, 1)
    end
end

function t1(it_max::Int, n::Int, m::Int)
    @assert m <= n
    for it in 1:it_max
        v1(n, m)
    end
end

function v2(n::Int, m::Int)
    vec = Vector{Int}(undef, n)
    for i in 1:m
        vec[i] = 1
    end
end

function t2(it_max::Int, n::Int, m::Int)
    @assert m <= n
    for it in 1:it_max
        v2(n, m)
    end
end

function main(it_max::Int, n::Int, m::Int)

    println("it_max = $it_max, n = $n, m = $m")

    @time t1(it_max, n, m)

    println("")

    @time t2(it_max, n, m)

end