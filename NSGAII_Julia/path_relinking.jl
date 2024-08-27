function suaps(individu,alea,retro)
    s1 = copy(individu)
    s1[alea] = 1
    s1[retro] = 0
    return s1
end 

function constraint(individu::Sol,k)
    contrainte = []
    for i in 1:individu.prob.m
        push!(contrainte, sum(individu.prob.W[i,j]*k[j] for j in 1:individu.prob.n))
    end
    return contrainte
end 


function path_voisin(pop::Sol,nb_voisin::Int,item)
    p = copy(item)
    voisins = []
    capacite = pop.prob.ω
    perm1 = findall(x->x==0, item)
    perm2 = findall(x->x==1, item)
    change_alea = sample(perm1,nb_voisin,replace = false)
    retro_alea = sample(perm2,nb_voisin,replace = false)
    for i in 1:nb_voisin
        x = suaps(p,change_alea[i],retro_alea[i]) 
        contraintes = constraint(pop,x)
        if sum(contraintes .< capacite) == length(capacite)
        push!(voisins,x)
        end
    end
    push!(voisin,item)
    return voisins
end




function local_voisin(momkp::_MOMKP,population::Vector{Sol}, nbvoisin)
    vect_choix = randperm(length(population))
    len = rand(1:length(vect_choix))
    choix = sample(vect_choix,len,replace = false)
    for i in 1:length(choix) 
        individu = population[choix[i]]
        item = individu.x
        voisin = path_voisin(individu,nbvoisin,item)
        if length(voisin) > 0
            s1 = comparaison_lexicographique(individu,voisin)
            vivi = creation_solution(momkp,s1)
            population = [population;vivi]
        end
    end
    return population
end











      
  




