#include<vector> 
#include <iostream>
#include <string>
#include <fstream>
#include <cstdlib>
#include <math.h>  
#include <algorithm>


struct Solution{
    
    std::vector<int> *solution;
    std::vector<float> * SumConstraint; 
    float FitnessValue1;
    float FitnessValue2;
    int rank; 
    bool valid;
    bool fitnessCalculated;
    bool checkrank;
    float crowdingdistance;

    Solution(){
        solution = new std::vector<int>;
        SumConstraint = new std::vector<float>;
        FitnessValue1 = 0;
        FitnessValue2 = 0; 
         valid = true;
         fitnessCalculated = false; 
         rank = 0;
         checkrank = false;
         crowdingdistance = 0;
    

    }


    void computeFitessValue(std::vector<int>* Price, int Nb){
        float fitness1 = 0;
        float fitness2 = 0;
        for(int i = 0; i < Nb; i++){
            fitness1+= solution[0][i] * Price[0][i];
            fitness2+= solution[0][i] * Price[1][i];
            }
            
            FitnessValue1 = fitness1;
            FitnessValue2 = fitness2; 
            fitnessCalculated = true;
        


        }


    
    void displayIndividual(int NbVariable, int NbConstraints){

        std::cout << "La solution créée est: "; 
        for(int i = 0; i < NbVariable; i ++){

            std::cout << " " << solution[0][i];

        }

        std::cout << std::endl; 

        std::cout << "Les contraintes sont: "; 
        for (int j = 0; j < NbConstraints; j++){

            std::cout << " " << SumConstraint[0][j]; 

        }
        std::cout << std::endl;
    }


    


      float operator()(Solution ind1, Solution ind2) { return ind1.FitnessValue1 > ind2.FitnessValue1; } 












    ~Solution(){

    }


};



struct compareObjectives2:Solution {
      float operator()(Solution ind1, Solution ind2) { return ind1.FitnessValue2 > ind2.FitnessValue2; } 

}; 

struct RangeRankSolution:Solution {
    int operator()(Solution ind1, Solution ind2){ return ind1.rank < ind2.rank; }
};


struct RangeRankcrowdingMeasure:Solution {
    int operator()(Solution ind1, Solution ind2){ return ind1.crowdingdistance > ind2.crowdingdistance; }
};
