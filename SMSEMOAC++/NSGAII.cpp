#include<iostream> 
#include<vector> 
#include<fstream> 
#include "NSGAIIAlgorithm.hpp"

int main(){
      
      
      /*La fonction checkup n'est pas bonne */
 
   std::string file = "Knapsack.txt";
   NSGAIIAlgorithme NSGAII = NSGAIIAlgorithme(file,5,1);
   /* NSGAII.initPopulation();
   NSGAII.computeExtremePoint();
   NSGAII.rankPopulation();
   NSGAII.definePopulationfront();
   NSGAII.measureCrowdingDistance();
   NSGAII.Tournament();
   NSGAII.displayEchantillon();
   for(int i = 0; i < 5; i++){
      try{
   NSGAII.CrossoverMutation();
   }catch(int err){
      std::cout << "Il y'a un problème dans la fonction";

   }
}
NSGAII.UpdateElitePopulation(); */

NSGAII.resolve(20);
}