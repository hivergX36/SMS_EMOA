
import java.util.Comparator;

public class Solution   {

    double[] solution;
    double[] SumConstraint; 
    float FitnessValue1;
    float FitnessValue2; 
    boolean valid;
    boolean fitnessCalculated;

    Solution(int NbVariable, int NbConstraint){
        solution = new double[NbVariable];
        SumConstraint = new double[NbConstraint];
        FitnessValue1 = 0;
        FitnessValue2 = 0; 
        valid = true;
        fitnessCalculated = false; 
    

    }

    public  float getFitness1(){
        return this.FitnessValue1; 
    }


    
    public  float getFitness2(){
        return this.FitnessValue2; 
    }

    
    public static Comparator<Solution> OperatorFitness1 = new Comparator<Solution>(){


        @Override
        public int compare(Solution s1, Solution s2) {
            int value = 0;
            if(s1.getFitness1() >= s2.getFitness1()){
                value = 1;
            }else{
                value = -1;

            }

            return value; 
        
        };
    
    };

    public static Comparator<Solution> OperatorFitness2 = new Comparator<Solution>(){


        @Override
        public int compare(Solution s1, Solution s2) {
            int value = 0;
            if(s1.getFitness2() >= s2.getFitness2()){
                value = 1;
            }else{
                value = -1;

            }

            return value; 
        
        };
};


}
