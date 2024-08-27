######## Compitation avec une somme des poids pondérées ###############################################"

using JuMP, GLPK, MathOptInterface

function obj1(lambda_1,X,P1)
    return lambda_1 * sum(X[i]*P1[i] for i in 1:length(P1))
end 

function obj2(lambda_2,X,P2)
    return lambda_2 * sum(X[i]*P2[i] for i in 1:length(P2))
end

function seeds(n,m,P, W,contraintes,lambda_1,lambda_2)
    model = Model(GLPK.Optimizer)
    @variable(model,X[1:n], binary = true)
    @objective(model,Max, obj1(lambda_1,X,P[1,:]) + obj2(lambda_2,X,P[2,:]))
    for i in 1:m
        @constraint(model, sum(W[i,j]*X[j] for j in 1:n) <= contraintes[i])
    end
    optimize!(model)
    x = JuMP.value.(X)
    x = [Int64(x[i]) for i in 1:length(x)]
    return x
end 


function INIT_seed_feasible_solution(momkp::_MOMKP;   debug = true)
    lambda1 = rand()
    lambda2 = 1 - lambda1
    sol =  SOLUTION_empty_solution(momkp)
    x = seeds(momkp.n,momkp.m,momkp.P,momkp.W,momkp.ω,lambda1,lambda2)
    sol.x = x 
    sol.z[1] = obj1(1,x,sol.prob.P[1,:])
    sol.z[2] = obj2(1,x,sol.prob.P[2,:])
    for i in 1:sol.prob.m
    sol.w[i] = sum(sol.prob.W[i,j]*x[j] for j in 1:sol.prob.n)
    end
    return sol
end
