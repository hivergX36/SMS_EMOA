#include<vector> 
#include <iostream>
#include <string>
#include <fstream>
#include <cstdlib>
#include <math.h>  
#include <algorithm>
#include "Solution.hpp"

   struct NSGAIIAlgorithme{

    int NbVariable;
    int NbConstraints;
    int NbObjectives; 
    int IndCandidat;
    int NbPop;
    int Nbind; 


    /* Price function */
    std::vector<int> * Price;
    /* Utility function */

    /*Matrix of constraint*/
    std::vector<float>*CostMatrix;
    /*Vector of solution*/





    std::vector<float> * constraint;
    std::vector<Solution> * Population; 
    std::vector<Solution> * Echantillon; 
    std::vector<std::vector<Solution>> * Front; 
    Solution IdealPoint; 
    Solution NadirPoint; 




 
    NSGAIIAlgorithme(std::string name, int nbpop, int nbind){

        int k = 0;
        int number;
        int candidat; 
        Nbind = nbind;
        NbPop = nbpop;  
        Population = new std::vector<Solution>;
        Front = new std::vector<std::vector<Solution>>; 
        

            std::ifstream fichier(name);
                if(fichier){

                   

                     fichier >> NbVariable;
                     fichier >> NbObjectives;
                     fichier >> NbConstraints; 

                     std::cout << "Les caractéristiques du problèmes sont: " << std::endl;
                     std::cout << "Le nombre d'objectifs est: " << NbObjectives << std::endl;
                     std::cout << "Le nombre de contraintes est: " << NbConstraints << std::endl;


             


                     Price = new std::vector<int>[NbObjectives]; 
                     CostMatrix = new std::vector<float>[NbConstraints];
                     constraint = new std::vector<float>[NbConstraints]; 


                     


                   for (int i = 0; i < NbObjectives; i++){
                     while(k < NbVariable){
                        fichier >> number; 
                        Price[i].push_back(number);
                        k++;
                        };
                        k = 0;
                   }


                     for(int i = 0; i < NbConstraints; i++){
                        k = 0;

                        while(k < NbVariable){
                            fichier >> number; 
                            CostMatrix[i].push_back(number);
                            k++;
                        }
                     }


              
                        for(int i = 0; i < NbConstraints; i++){
                        fichier >> number;
                        std::cout << "la contrainte est: " << number << std::endl;
                        constraint[i].push_back(number);

                     } 
                     
                }
    }



    void computeExtremePoint(){

        float fitnessI1 = 0;  
        float fitnessI2 = 0;  
        float fitnessN1 = 0;
        float fitnessN2 = 0; 


       for(int i = 0; i < NbVariable; i++){
        IdealPoint.solution->push_back(1); 
        NadirPoint.solution->push_back(0); 
        fitnessI1 += Price[0][i] * IdealPoint.solution[0][i];
        fitnessI2 += Price[1][i] * IdealPoint.solution[0][i];
        fitnessN1 += Price[0][i] * NadirPoint.solution[0][i];
        fitnessN2 += Price[1][i] * NadirPoint.solution[0][i];



       }

       IdealPoint.FitnessValue1 = fitnessI1;
       IdealPoint.FitnessValue2 = fitnessI2;
       NadirPoint.FitnessValue1 = fitnessN1; 
       NadirPoint.FitnessValue2 = fitnessN2; 

       

    }


 

    
    void sumconstraint(Solution & individual){
        float addconstraint;
        for(int j = 0;j < NbConstraints; j++){
            addconstraint = 0;
            for(int i = 0; i < NbVariable; i++){
               addconstraint += CostMatrix[j][i] * individual.solution[0][i];


            }
            individual.SumConstraint->push_back(addconstraint);
                std::cout <<  individual.SumConstraint[0][j] << std::endl;  
        }
    }

    void checkPopindividual(Solution & individual, int & compteur){
        bool check = true;

        for(int i = 0; i < NbConstraints; i++){
            std::cout << "La contrainte est: " << constraint[i][0] << std::endl;
            if( individual.SumConstraint[0][i] > constraint[i][0] || individual.SumConstraint[0][i] == 0){
             
                check = false;
                break;
            }
        }

        std::cout << "le booléen est: " << check << std::endl;

        if(check == false){
            std::cout << "La solution n'est pas admissible" << std::endl; 

        }else{

        std::cout << "La solution est admissible" << std::endl; 
        Population->push_back(individual);
        compteur++; 

        }
   


        }
        

    

    


    void initPopulation(){
        int compteur = 0; 
        int nbrandomseeds;
        int indice; 
        int value;
 while(compteur < NbPop)
            {
           Solution individual;
           individual.rank = NbPop + 1; 
            for(int k = 0; k < NbVariable; k++){
                 individual.solution->push_back(0);
            }
            nbrandomseeds = rand() %  NbVariable;
            std::cout << nbrandomseeds << std::endl;  
            for(int j = 0; j < nbrandomseeds; j++){
                indice = rand() % NbVariable ;
                value = rand() % 2;
                if(value > 0){

                  individual.solution[0][indice] = 1; 


                }

            }
            sumconstraint( individual);
            individual.computeFitessValue(Price,NbVariable);
            individual.displayIndividual(NbVariable, NbConstraints);

            checkPopindividual(individual,compteur);
    }

    }


    void displayPopulation(){

        sort(Population[0].begin(), Population[0].end(),RangeRankSolution());

        std::cout << "La population est: " << std::endl; 
        for(int i = 0;i < NbPop; i++){
            std::cout << "individu_" << i + 1 << " : ";
            for(int j = 0; j < NbVariable; j++){

                std::cout << Population[0][i].solution[0][j] << " ";
            }

            std::cout << "obj1: " << Population[0][i].FitnessValue1 << " " << "obj2: " << Population[0][i].FitnessValue2 << " rank: " << Population[0][i].rank <<   std::endl;  



        }

      

    }

    void displayList(std::vector<Solution> & List){

        std::cout << "La Liste est: " << std::endl; 
        for(int i = 0;i < List.size(); i++){
            std::cout << "individu_" << i + 1 << " : ";
            for(int j = 0; j < NbVariable; j++){

                std::cout << List[i].solution[0][j] << " ";
            }

            std::cout << "obj1: " << List[i].FitnessValue1 << " " << "obj2: " << List[i].FitnessValue2 << " rank: " << List[i].rank <<   std::endl;  



        }

      

    }

    void defineRankList(std::vector<Solution> & List, int nbind){
        int compteur = 0;     
        int nextrank = 0; 
        int Nbrank = 0;
        int indMax = 0;
        bool ranked; 
        float max; 
        for(int i = 0 ; i < nbind; i++){
            List[i].rank = nbind + 1;
            List[i].checkrank = false;
        }
        sort(List.begin(), List.end(),Solution());
        while(Nbrank < nbind){
            ranked = false; 
            max = List[compteur].FitnessValue2;
            List[compteur].rank = nextrank; 
            for(int k = compteur; k < nbind ; k++){
                if(List[k].FitnessValue2 < max ){
                    if(ranked == false){
                    compteur = k;
                    ranked = true;
                    } 
                    }
                    else{
          
                        if(List[k].checkrank == false){
                        List[k].rank = nextrank;
                        max = List[k].FitnessValue2;
                        indMax = k;
                        List[k].checkrank = true;
                        Nbrank ++; 
                        
                    }
                }
            }

            nextrank++;

        }
    }


    void defineFront( std::vector<Solution> & List, int nbind){
        int compteur = 0;
        int range = 0;
        int comptadd = 0;
        Front = new std::vector<std::vector<Solution>>; 
        sort(List.begin(), List.end(),RangeRankSolution());
        displayList(List);
        int numberRank = List[nbind - 1].rank + 1;
        std::cout << "le nombre de rang est: " << numberRank << std::endl; 
        for(int r = 0; r < numberRank ; r++){
            std::vector<Solution> f1  ;
            comptadd = 0;
            for(int i = compteur; i < nbind; i++ ){
                range = List[i].rank;
                if(range == r){
                    f1.push_back(List[i]);
                    comptadd ++; 
                }else{
                    compteur = i;
                    Front->push_back(f1);
                    break;
                }
                if( i > nbind - 2 && r > numberRank - 2){
                    Front->push_back(f1);
                    }
                }
            }
        }

    void definePopulationfront(){
        int compteur = 0;
        int range = 0;
        int comptadd = 0;
        Front = new std::vector<std::vector<Solution>>; 


        sort(Population[0].begin(), Population[0].end(),RangeRankSolution());
        int numberRank = Population[0][NbPop - 1].rank + 1;
        for(int r = 0; r < numberRank ; r++){

           std::vector<Solution> f1  ;
            comptadd = 0;
            for(int i = compteur; i < NbPop; i++ ){
                range = Population[0][i].rank;
                if(range == r){
                    f1.push_back(Population[0][i]);
                    comptadd ++; 
                }else{
                    compteur = i;
                    Front->push_back(f1);
                    break;
                }
                if( i > NbPop - 2 && r > numberRank - 2){
                    Front->push_back(f1);

                }
            }
            
           

        }


        }

    

        
void displayFront(){
    std::cout << "La front est: " << std::endl;
    for (int i = 0; i < Front[0].size() + 1; i++) { 
        std::cout << "Front_" << i <<" : ";
        for (int j = 0; j < Front[0][i].size(); j++){

                    std::cout << "Solution_" << j <<" : ";

            for(int k = 0; k < NbVariable; k++){
                 std::cout << Front[0][i][j].solution[0][k] << " ";


            }
        }

    std::cout << " range: " << i << std::endl;
} 
}

        



void measureCrowdingDistance(){
    int vecsize = 0;
    float f1 = 0;
    float f2 = 0;
    std::cout << "taille du vecteur" << vecsize << std::endl;

    for(int i = 0; i < Front[0].size(); i++){
        sort(Front[0][i].begin(),Front[0][i].end(),Solution());
        vecsize = Front[0][i].size();
        std::cout << "taille du vecteur" << vecsize << std::endl;
        Front[0][i][0].crowdingdistance = std::numeric_limits<double>::max();
        Front[0][i][vecsize - 1].crowdingdistance = std::numeric_limits<double>::max();
        for(int k = 1; k < vecsize - 1; k ++){

            Front[0][i][k].crowdingdistance = (Front[0][i][k - 1].FitnessValue1 - Front[0][i][k + 1].FitnessValue1)  / (IdealPoint.FitnessValue1 - NadirPoint.FitnessValue1) + (Front[0][i][k + 1].FitnessValue2 - Front[0][i][k - 1].FitnessValue2) / (IdealPoint.FitnessValue2 - NadirPoint.FitnessValue2);

        }



        
    }

}


void measureCrowdingDistance(std::vector<Solution>* List){
    int vecsize = 0;
    float f1 = 0;
    float f2 = 0;
    for(int i = 0; i < Front[0].size(); i++){
        sort(Front[0][i].begin(),Front[0][i].end(),Solution());
        vecsize = Front[0][i].size();
        Front[0][i][0].crowdingdistance = std::numeric_limits<double>::max();
        Front[0][i][vecsize - 1].crowdingdistance = std::numeric_limits<double>::max();
        for(int k = 1; k < vecsize - 1; k ++){

            Front[0][i][k].crowdingdistance = (Front[0][i][k - 1].FitnessValue1 - Front[0][i][k + 1].FitnessValue1)  / (IdealPoint.FitnessValue1 - NadirPoint.FitnessValue1) + (Front[0][i][k + 1].FitnessValue2 - Front[0][i][k - 1].FitnessValue2) / (IdealPoint.FitnessValue2 - NadirPoint.FitnessValue2);

        }



        
    }

}


//Display the norm1 value  

void displayCrowdingDistance(){
    std::cout << "La front est: " << std::endl;
    for (int i = 0; i < Front[0].size(); i++) { 
        std::cout << "Front_" << i <<" : ";
        for (int j = 0; j < Front[0][i].size(); j++){

                    std::cout << "CrowdingDistance : " << j <<" : ";

                 std::cout << Front[0][i][j].crowdingdistance << " ";
                 }

                 std::cout << std::endl;
            } 
        }

// Display the new sample

        

      void displayEchantillon(){
        std::cout << "L'Echantillon est: " << std::endl; 
        for(int i = 0;i < Nbind; i++){
            std::cout << "individu_" << i + 1 << " : ";
            for(int j = 0; j < NbVariable; j++){

                std::cout << Echantillon[0][i].solution[0][j] << " ";
            }

            std::cout << "obj1: " << Echantillon[0][i].FitnessValue1 << " " << "obj2: " << Echantillon[0][i].FitnessValue2 << std::endl;  




        }
      }
                
                



    

    void displayCostMatrix(){
        for(int i = 0; i < NbConstraints; i++){
            for(int j = 0; j < NbVariable; j++)
            {
                std::cout << CostMatrix[i][j] << " ";

        }

        std::cout << std::endl;
        }
    }


    void displayProblemVega(){



       std::cout << "Les prix des fonctions objectifs sont: " << std::endl;
       for(int i = 0; i < NbObjectives; i++){
        for(int j = 0; j <NbVariable; j++){
            std::cout << Price[i][j] << " ";
        }
        std::cout << std::endl;
       }

        std::cout << "La matrice des contraintes est: " << std::endl; 
             for(int i = 0; i < NbConstraints; i++){
            for(int j = 0; j < NbVariable; j++)
            {
                std::cout << CostMatrix[i][j] << " ";

        }

        std::cout << std::endl;
        }

        std::cout << "Les contraintes sont:";
        for(int i = 0; i < NbConstraints; i++){
            std::cout << constraint[i][0] << std::endl;
        }

    }


    void fitnessValuePop(/*std::vector<Solution> & Echantillon, int dim*/){
        float fitnessvalue1;
        float fitnessvalue2; 
        int compteur = 0;
        while(compteur < NbPop)
        {
            fitnessvalue1 = 0; 
            fitnessvalue2 = 0;
            if(Population[0][compteur].fitnessCalculated == false){
                for(int i = 0; i < NbVariable; i++){
                    fitnessvalue1+= Population[0][compteur].solution[0][i] * Price[0][i];
                    fitnessvalue2+= Population[0][compteur].solution[0][i] * Price[1][i];

                }
                Population[0][compteur].FitnessValue1 = fitnessvalue1;
                Population[0][compteur].FitnessValue2 = fitnessvalue2; 
 
                Population[0][compteur].fitnessCalculated = true;
            }

            compteur++;


        }
    }


    void rankPopulation(){
        int compteur = 0;     
        int nextrank = 0; 
        int Nbrank = 0;
        int indMax = 0;
        bool ranked; 
        float max; 
        sort(Population[0].begin(), Population[0].end(),Solution());
        for(int k = 0; k < NbPop; k++){
            Population[0][k].rank = NbPop + 1;
        }

        while(Nbrank < NbPop){
            ranked = false; 
            max = Population[0][compteur].FitnessValue2;
            Population[0][compteur].rank = nextrank; 
            for(int k = compteur; k < NbPop ; k++){
                if(Population[0][k].FitnessValue2 < max ){
                    if(ranked == false){
                    compteur = k;
                    ranked = true;
                    } 
                    }
                    else{
          
                        if(Population[0][k].checkrank == false){
                        Population[0][k].rank = nextrank;
                        max = Population[0][k].FitnessValue2;
                        indMax = k;
                        Population[0][k].checkrank = true;
                        Nbrank ++; 
                        
                    }
                }
            }

            nextrank++;

        }
    }


                                   


        
    

    void fitnessValueSample(){
        float fitnessvalue1;
        float fitnessvalue2; 
        int compteur = 0;
        while(compteur < Nbind)
        {
            fitnessvalue1 = 0; 
            fitnessvalue2 = 0; 
            if(Echantillon[0][compteur].fitnessCalculated == false){
                for(int i = 0; i < NbVariable; i++){
                    fitnessvalue1 += Echantillon[0][compteur].solution[0][i] * Price[0][i];
                    fitnessvalue2 += Echantillon[0][compteur].solution[0][i] * Price[1][i]; 
                }
                Echantillon[0][compteur].FitnessValue1 = fitnessvalue1;
                Echantillon[0][compteur].FitnessValue2 = fitnessvalue2;
                Echantillon[0][compteur].fitnessCalculated = true;
            }

            compteur++;


        }


    }

    void Tournament(){


        Echantillon = new std::vector<Solution>;

        Solution individual1;
        Solution individual2;
        int compteur = 0;
        int randomIndividual1;
        int randomIndividual2;
        while(compteur < Nbind){
            randomIndividual1 = rand() % NbPop;
            randomIndividual2 = rand() % NbPop;

            individual1 = Population[0][randomIndividual1];
            individual2 = Population[0][randomIndividual2];

            if(individual1.rank < individual2.rank){
                         Echantillon->push_back(individual1);


            }else{
                if(individual1.rank > individual2.rank){
                    Echantillon->push_back(individual2);
                }
                else{
                    if(individual1.crowdingdistance > individual2.crowdingdistance){

                        Echantillon->push_back(individual1);

                    }else{
                         Echantillon->push_back(individual2);
                    }
                }

    
 

            }

        


         compteur++; 




        }




    }

    void CrossoverMutation(){
        int ind_Parent1 = rand() % Nbind;
        int ind_Parent2 = rand() % Nbind;
        int ind_crossover = rand() % NbVariable; 
        int Getmuted;
        Solution Enfant1; 
        Solution Enfant2;
        /*for(int k = 0; k < NbVariable; k++){

        } */
        for(int i = 0; i < ind_crossover; i++){
            Enfant1.solution->push_back(Echantillon[0][ind_Parent1].solution[0][i]);
            Enfant2.solution->push_back(Echantillon[0][ind_Parent2].solution[0][i]);
            
        }

        for(int j = ind_crossover; j < NbVariable; j++){

            Enfant2.solution->push_back(Echantillon[0][ind_Parent1].solution[0][j]);
            Enfant1.solution->push_back(Echantillon[0][ind_Parent2].solution[0][j]);

        }

        Getmuted = rand() % 3;
        std::cout << "choixmutation: " << Getmuted << std::endl;
        if(Getmuted > 0){
        
        Addmutation(Enfant1);
        std::cout << "Enfant2" <<  std::endl;

        Addmutation(Enfant2);

        }
        
        sumconstraint(Enfant1);
        sumconstraint(Enfant2);

        CheckSampleindividual(Enfant1,0,ind_Parent1);
        CheckSampleindividual(Enfant2,0,ind_Parent2);


}

        void CheckSampleindividual(Solution & individual, int k, int ind){
        int compteur = k;
        bool check = true;
        for(int i = 0; i < NbConstraints; i++){
            std::cout << "La contrainte est: " << constraint[i][0] << std::endl;
            if( individual.SumConstraint[0][i] > constraint[i][0] || individual.SumConstraint[0][i] == 0){
             
                check = false;
                break;
            }
        }
        std::cout << "le booléen est: " << check << std::endl;
        if(check == false){
            std::cout << "La solution n'est pas admissible" << std::endl; 
        
            if(compteur < 1){
                RepaireSample(individual);
                compteur++;
                CheckSampleindividual(individual, compteur, ind);

            }
            }else{
                std::cout << "La solution est admissible" << std::endl; 
                Echantillon[0][ind] = individual;
                compteur++;
                }
            }



    void Addmutation(Solution & Enfant){

        std::cout << "mutation enfant" << std::endl;
        int compteur = 0;
        int nb_one = 0;
        int indice;
        int choix; 
        

        for(int i = 0; i < NbVariable; i++){
            if(Enfant.solution[0][i] < 1){
            nb_one++;  
            }
        }

        if(nb_one > 0){
        int listChoix[nb_one];
        std::cout << "nbone: " << nb_one << std::endl;
        for(int i = 0; i < NbVariable; i++){
            if(Enfant.solution[0][i] < 1){
                listChoix[compteur] = i;
                compteur++;
            }
        }

        indice = rand() % compteur;
        std::cout << "indice Enfant: " << indice << std::endl;
        choix = listChoix[indice];
        Enfant.solution[0][choix] = 1;
        std::cout << "Enfant Solution: " <<  Enfant.solution[0][choix] << std::endl;
        }else{
            std::cout << "Pas de mutation possible" << std::endl;
        }




    }




    void RepaireSample(Solution & Enfant){
        int compteur = 0;
        int nb_one = 0;
        int indice;
        int choix; 
        

        for(int i = 0; i < NbVariable; i++){
            if(Enfant.solution[0][i] > 0){
            nb_one++;  
            }
        }
        int listChoix[nb_one];
        for(int i = 0; i < NbVariable; i++){
            if(Enfant.solution[0][i] > 0){
                listChoix[compteur] = i;
                compteur++;
            }
        }

        indice = rand() % compteur;
        std::cout << "indice à supprimer: " << indice << std::endl;
        choix = listChoix[indice];
        Enfant.solution[0][choix] = 0;

    }



 

//Update by rank and crowding distance 

   void UpdateElitePopulation(){
    int compteur = 0; 
    int indicefront = 0;
    bool Update = false;
    int indiceVec = 0;
    int comptList = 0; 
    int nbListInd = NbPop + Nbind;
    fitnessValueSample();
    std::vector<Solution> List;
    for(int i = 0; i < NbPop; i++){
        List.push_back(Population[0][i]);
    }
    for(int j = 0; j < Nbind; j++){
        List.push_back(Echantillon[0][j]);
    }
    defineRankList(List, nbListInd);
    defineFront(List,nbListInd);
    measureCrowdingDistance();
    displayCrowdingDistance();
    while(compteur < NbPop){
    sort(Front[0][indicefront].begin(), Front[0][indicefront].end(),RangeRankcrowdingMeasure());
    for(int k = 0; k < Front[0][indicefront].size();k++){
        Population[0][compteur] = Front[0][indicefront][k];
        compteur++;
        if(compteur > NbPop - 1){
            std::cout << "La génération suivante est créee" << std::endl;
            break;
        }
    }
    indicefront++;
}
}

void resolve(int Nbgen){ 
int nbCrossover;
displayProblemVega();
computeExtremePoint();
initPopulation();
displayPopulation();
   fitnessValuePop();
        rankPopulation();

   displayPopulation();
   for(int k = 0; k < Nbgen; k++){
    definePopulationfront();
    measureCrowdingDistance();
    Tournament();
   displayEchantillon();
   for(int i = 0; i < 5; i++){
      try{
   CrossoverMutation();
   }catch(int err){
      std::cout << "Il y'a un problème dans la fonction";
   }
   };
 UpdateElitePopulation();
   displayPopulation();

   }
}


};
