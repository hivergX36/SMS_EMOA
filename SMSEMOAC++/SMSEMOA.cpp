#include<iostream> 
#include<vector> 
#include<fstream> 
#include "NSGAIIAlgorithm.hpp"

int main(){
      
      
      /*La fonction checkup n'est pas bonne */
 
   std::string file = "knapsack.txt";
   SmsEmoaAlgorithme SmsEmoa = SmsEmoaAlgorithme(file,5,1);
   /* SmsEmoa.initPopulation();
   SmsEmoa.computeExtremePoint();
   SmsEmoa.rankPopulation();
   SmsEmoa.definePopulationfront();
   SmsEmoa.measureCrowdingDistance();
   SmsEmoa.Tournament();
   SmsEmoa.displayEchantillon();
   for(int i = 0; i < 5; i++){
      try{
   SmsEmoa.CrossoverMutation();
   }catch(int err){
      std::cout << "Il y'a un problème dans la fonction";

   }
}
SmsEmoa.UpdateElitePopulation(); */

SmsEmoa.resolve(20);
}