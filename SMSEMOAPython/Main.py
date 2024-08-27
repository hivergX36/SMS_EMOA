from SMSEMOA_Algorithm import NSGAIIAlgorithm
import random
import os


fileName = "knapsack.txt"
os.chdir("NSGAIIPython")
print(os.getcwd()) 


NSGAII = NSGAIIAlgorithm(30,10)
NSGAII.parseKnapsack(fileName)
NSGAII.resolve(12)


