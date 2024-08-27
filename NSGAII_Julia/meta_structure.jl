
function f1(c1,x)
    return sum(c1[i,j]*x[i,j] for i in 1:length(c1[1,:]) for j in 1:length(c1[:,1]))
end

function f2(c2,x) 
    return sum(c2[i,j]*x[i,j] for i in 1:length(c2[1,:]) for j in 1:length(c2[:,1]))
end


function generer_liste_solution(nb_vecteur, nb_ligne, nb_colonne)
    liste  = [rand(0:1,nb_ligne,nb_colonne) for i in 1:nb_vecteur]
    return liste 
end 


function generer_espace_objectif(liste,c1,c2)
    Y = [(f1(c1,liste[i]), f2(c2,liste[i])) for i in 1:length(liste)] 
    return Y       
end

function jointure_solution_espace_obj(liste,Y)
    couplage_X_Y = [(Y[i],liste[i]) for i in 1:length(Y)]
    return couplage_X_Y 
end 

function tri_par_ordre(Y)
    lex = sort(Y)
    Y_N = [lex[i] for i in 1:length(lex) if lex[i][2] <= lex[1][2]]
    Y_D = setdiff(Y,Y_N)
    return Y_N, Y_D
end

function update(couplage, solution)
    S_N = [couplage[a] for a in 1:length(couplage) for k in 1:length(solution) if couplage[a][1] == solution[k]]
    return S_N
end 

function tri_dynamique(nb_vecteur, nb_ligne, nb_colonne,c1,c2,compteur)
    S_N = []
    while compteur > 0
        compteur = compteur - 1
        X = generer_liste_solution(nb_vecteur, nb_ligne, nb_colonne)
        Y = generer_espace_objectif(X,c1,c2)
        S_N = jointure_solution_espace_obj(X,Y)
        Y_N = tri_par_ordre(Y)
        S_N =  update(S_N, Y_N)
        print(S_N)
    end
    return S_N
end



function rang_Paretto(Y)
    front = tri_par_ordre(Y)
    S = [front[1]]
    b = true 
    while length(front[2]) > 0
        front = tri_par_ordre(front[2])
        if length(front[2]) == 0 
            push!(S,front[1])
        else
            push!(S,front[1]) 
        end
    end 
    return S
end 

function generer_espace_objectif_2(liste,c1,c2)
    Y = [( obj1(1,liste[i],c1), obj2(1,liste[i],c2)) for i in 1:length(liste)] 
    return Y       
end


function comparaison_lexicographique(population::Sol,voisin)
    Y = generer_espace_objectif_2(voisin,population.prob.P[1,:],population.prob.P[2,:])
    couplage = jointure_solution_espace_obj(voisin,Y)
    Y_N_D = tri_par_ordre(Y)
    solution = update(couplage, Y_N_D[1])
    return solution
end