import random 
import math 


class Solution: 
  def __init__(self, nbVariable,nbconstraint,listConstraint):
        
        self.solution = [0 for i in range(nbVariable)]
        self.SumConstraint = [0 for i in range(nbconstraint)]
        self.fitnessValue1 = 0
        self.fitnessValue2 = 0 
        self.rank = 0 
        valid = True 
        fitnessCalculated = False; 
        self.NbVariable = nbVariable
        self.Nbconstraint = nbconstraint
        self.listConstraint = listConstraint
        self.admissible = True
        self.crowdingdistance = 0
        self.solhypervolume = 0  
        

  def sumconstraint(self, matrix):
       self.SumConstraint = [sum([matrix[ind1][ind2] * self.solution[ind2] for ind2 in range(self.NbVariable)])for ind1 in range(self.Nbconstraint)]
       
  def calculatefitnessvalue(self,Price):
        self.fitnessValue1 = sum([Price[0][i] * self.solution[i] for i in range(self.NbVariable)]) 
        self.fitnessValue2 = sum([Price[1][i] * self.solution[i] for i in range(self.NbVariable)]) 
        
  def CheckIndividual(self):
        check = True
        for k in range(self.Nbconstraint):
              print(self.SumConstraint[k])
              if(self.SumConstraint[k] > self.listConstraint[k] or self.SumConstraint[k] == 0):
                    check = False
                    break
        if check == False:
              print("La solution n'est pas admissible")
              self.admissible = False
        else:
              "La solution est admissible"  
              self.admissible = True


        
  def addmutation(self):
        indlistadd = [i for i in range(self.NbVariable) if self.solution[i] == 0]
        if len(indlistadd) < 1:
              print("Il n'y a rien a muté")
        else:
              indice = random.choice(indlistadd)
              self.solution[indice] = 1
        
  def repaire(self):
        indlistadd = [i for i in range(self.NbVariable) if self.solution[i] == 1]
        if len(indlistadd) > 1:
              indice = random.choice(indlistadd)
              self.solution[indice] = 0
        else:
              indice = random.choice(self.NbVariable)
              self.solution[indice] = 1
        
  def checkandrepaire(self,compteur):
        check = True
        for k in range(self.Nbconstraint):
              print(self.SumConstraint[k])
              if(self.SumConstraint[k] > self.listConstraint[k] or self.SumConstraint[k] == 0):
                    check = False
                    if(compteur < 1):
                          compteur += 1 
                          self.repaire()
                          self.checkandrepaire(compteur)
                    break
        if check == False:
              print("La solution n'est pas admissible")
              self.admissible = False
        else:
              "La solution est admissible"  
              self.admissible = True
        
        
   
class SMSemoaAlgorithm():
    
  def __init__(self, NbPop,NbInd):
        """Constructeur de notre classe"""
        self.NbInd = NbInd
        self.NbPop = NbPop
        self.NbVariable = 0 
        self.NbObjectives = 0 
        self.NbConstraint = 0 
        self.Population = []
        self.Sample = 0 
        self.PriceVariable = []
        self.Constraint = []
        self.MatrixConstraint = []
        self.front = []
        self.hypervolumemesure = []
        self.idealpoint = 0 
        self.nadirpoint = 0 
        self.List = []
        
        
        
  def checknumber(self,lignes,indice):
        ParsedList = []
        compteur1 = 0
        compteur2 = 0
        while(lignes[indice][compteur1] != '\n' and lignes[indice][compteur2] != '\n'):
              while(lignes[indice][compteur2] != " " and lignes[indice][compteur2] != '\n'):
                    compteur2 += 1
              ParsedList.append(int(lignes[indice][compteur1:compteur2]))
              compteur1 = compteur2 + 1
              compteur2 = compteur1

   
              if compteur1 > len(lignes[indice]) - 1:
                    break
        return ParsedList
 
 
  
  def parseKnapsack(self,text):
      fichier = open(text, "r",encoding="utf8")
      lignes = fichier.readlines()
      tab = [self.checknumber(lignes,indice) for indice in range(len(lignes) - 1)]
      self.NbVariable = tab[0][0]
      self.NbObjectives = tab[0][1]
      self.NbConstraint = tab[0][2]
      self.PriceVariable = [[tab[ind2][ind1] for ind1 in range(self.NbVariable)] for ind2 in range(1,self.NbObjectives + 1)]
      self.MatrixConstraint = [[tab[ind][j] for j in range(self.NbVariable)] for ind in range(3,3 + self.NbConstraint )]
      self.constraint = [tab[-1][ind] for ind in range(self.NbConstraint)]
      
  def computeExtremePoint(self):
        self.nadirpoint = Solution(self.NbVariable,self.NbConstraint,self.constraint)
        self.idealpoint = Solution(self.NbVariable,self.NbConstraint,self.constraint)
        self.idealpoint.solution = [1 for i in range(self.NbVariable)]
        self.idealpoint.calculatefitnessvalue(self.PriceVariable)
        self.nadirpoint.fitnessValue1 = 0 
        self.nadirpoint.fitnessValue2 = 0 
        


      
 
    
  def initPopulation(self):
      self.Population = [Solution(self.NbVariable,self.NbConstraint,self.constraint) for i in range(self.NbPop)]
      for i in range(self.NbPop):
            
            self.Population[i].solution = [random.randrange(0,2) for i in range(self.NbVariable)]
            self.Population[i].sumconstraint(self.MatrixConstraint)
            self.Population[i].CheckIndividual()
            while(self.Population[i].admissible == False):
                  self.Population[i].solution = [random.randrange(0,2) for i in range(self.NbVariable)]
                  self.Population[i].sumconstraint(self.MatrixConstraint)
                  self.Population[i].CheckIndividual()
            self.Population[i].calculatefitnessvalue(self.PriceVariable)
            
            

  def displayProblem(self):
        print("The number of variable is: " , self.NbVariable)
        print("The number of constraint is: " , self.NbConstraint)
        print("The number of objectives is: " , self.NbObjectives)
        print("The vector of price is: " , self.PriceVariable)
        print("The cost Matrix is: " , self.MatrixConstraint)
        print("The constraints are: ", self.constraint)

        

                  
                   
  def displayPopulation(self):
        print("The population is: ")
        for i in range(self.NbPop):
              print(self.Population[i].solution, " ", self.Population[i].fitnessValue1, self.Population[i].fitnessValue2)
              
                      
  def displaySample(self):
        print("The sample is: ")
        for i in range(self.NbInd):
              print(self.Sample[i].solution, " ", self.Sample[i].fitnessValue1, self.Sample[i].fitnessValue2, self.Sample[i].rank)
              
  def rankPopulation(self):
        self.Population.sort(key = lambda x: x.fitnessValue1, reverse = True)
        self.Population[0].rank = 0 
        for i in range(1,self.NbPop):
              if  self.Population[i].fitnessValue2 <  self.Population[i - 1].fitnessValue2 and self.Population[i].fitnessValue1 < self.Population[i - 1].fitnessValue1: 
                    self.Population[i].rank = self.Population[i - 1].rank + 1
              else:
                    self.Population[i].rank = self.Population[i - 1].rank
                    
  def rankList(self):
        self.List.sort(key = lambda x: x.fitnessValue1, reverse = True)
        self.List[0].rank = 0 

        for i in range(1,len(self.List)):
              if  self.List[i].fitnessValue2 <  self.List[i - 1].fitnessValue2 and self.List[i].fitnessValue1 < self.List[i - 1].fitnessValue1: 
                    self.List[i].rank = self.List[i - 1].rank + 1
              else:
                    self.List[i].rank = self.List[i - 1].rank
  
  def frontList(self):
        self.List.sort(key = lambda x : x.rank)
        numberRank = self.List[-1].rank  
        self.front = [[self.List[i] for i in range(len(self.List)) if self.List[i].rank == r] for r in range(numberRank + 1)]
        while len(self.front[-1]) < 1:
              self.front = self.front[0:(len(self.front) - 1)]
        
         
                    
  def definePopulationfront(self):
        self.Population.sort(key = lambda x: x.rank)
        numberRank = self.Population[-1].rank 
        print("rang",numberRank)
        self.front = [[self.Population[i] for i in range(self.NbPop) if self.Population[i].rank == r] for r in range(numberRank + 1)]
        print("bonjour",self.front)
        while len(self.front[-1]) < 1:
              self.front = self.front[0:(len(self.front) - 1)]
        
      
        
        
  def defineSamplefront(self):
        self.Sample.sort(key = lambda x : x.rank)
        numberRank = self.Sample[-1].rank 
        print(numberRank)
        self.front = [[self.Sample[i] for i in range(self.NbInd) if self.Sample[i].rank == r] for r in range(numberRank + 1)]
        print("bonjourfront",self.front)
        if len(self.front[-1]) < 1:
              self.front = self.front[0:len(self.front) - 1]
        
  def displayfront(self):
        print([[self.front[i][j].solution for j in range(len(self.front[i]))] for i in range(len(self.front))])
 
        
         
        
        
  

  def hypervolumemesuretournament(self):
        print(self.front)
        indlastfront = len(self.front) - 1 
        print("longueur", len(self.front))
        print("indlastfront: ", indlastfront)
        lastfront = [self.front[indlastfront][i] for i in range(self.front[indlastfront])]
        lastfront.sort(key = lambda x: x.fitnessValue1, reverse = True)
        lastfront[0].solhypervolume = 2^31
        lastfront[indlastfront].hypervolume = 2^31
        for i in range(2,indlastfront):
              lastfront[i].solhypervolume = (lastfront[i + 1].fitnessValue1 - lastfront[i].fitnessValue1) * (lastfront[i - 1].fitnessValue2 - lastfront[i].fitnessValue2)
        lastfront.sort(key = lambda x: x.solhypervolume, reverse = True)
        lastfront = [lastfront[i] for i in range(len(lastfront) - 1)]
        self.front[indlastfront] = lastfront
        
 
        
         

         
        
                    
    
def tounament_parent_selection(self):
        while(compteur < self.NbInd):
              AddList = []
              for i in range(2):
                    if len(self.front) > 0:
                          indicefront = random.randrange(0,len(self.front))
                    else:
                          indicefront = 0
                    indicesolution = random.randrange(0, len(self.front[indicefront]))
                    randomIndividual = self.front[indicefront][indicesolution]
                    AddList.append(randomIndividual)
              AddList.sort(key = lambda x: x.rank) 
              if AddList[0].rank == AddList[1].rank and AddList[1].crowdingdistance > AddList[0].crowdingdistance:
                    self.Sample.append(AddList[1])
              else:
                    self.Sample.append(AddList[0])
              compteur+=1
              

              
              
def crossOverMutation(self):
        ind_Parent1 = random.randrange(0,self.NbInd)
        ind_Parent2 = random.randrange(0,self.NbInd)
        ind_crossover = random.randrange(0,self.NbVariable); 
        children = Solution(self.NbVariable,self.NbConstraint,self.constraint)
        children.solution = [0 for i in range(self.NbVariable)]
        for i in range(ind_crossover):
              children.solution[i] = self.Sample[ind_Parent1].solution[i]
        for j in range(ind_crossover, self.NbVariable):
              children.solution[j] = self.Sample[ind_Parent2].solution[j]
              
        Getmuted = random.randrange(3)
        print("choixmutation: ", Getmuted)
        if Getmuted > 0:
              children.addmutation()
              children.sumconstraint(self.MatrixConstraint)
              children.checkandrepaire(0)
              if children.admissible == True:
                    self.Sample[ind_Parent1] = children
                    self.Sample[ind_Parent1].calculatefitnessvalue(self.PriceVariable)
   
  


def UpdatePopulation(self):
        compteur = 0 
        arret = False 
        self.List = [self.Population[i] for i in range(self.NbPop)]
        for i in range(self.NbInd):
              self.List.append(self.Sample[i])
        self.rankList()
        self.frontList()
        self.measurecrowdingdistance()
        self.Population = self.List
       
              
        


  
        
def resolve(self, Nbgen):
        self.initPopulation()
        self.computeExtremePoint()
        self.displayPopulation()
        for i in range(Nbgen):
              self.displayPopulation()     
              self.rankPopulation()
              self.displayPopulation()     
              self.definePopulationfront()
              self.tounament_parent_selection()
              NbMutation = random.randrange(self.NbInd)
              for j in range(NbMutation):
                    self.crossOverMutation()
              self.UpdatePopulation()
              self.hypervolumemesuretournament()
        self.displayPopulation()     



            
              

   




    
      




        


              
              
         
         




        
        
            
      



     

 
    

           
    
    

        
  
        
  
        

      
             
        
             
             
            
             
            



             
            
            

            
             
          
            

        
        
        




     






    
      
        

