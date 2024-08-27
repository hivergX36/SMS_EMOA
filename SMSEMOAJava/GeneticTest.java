import org.junit.*;
 
public class GeneticTest{

    @Test
    public void testpopulation(){
        String file = "Knapsack.txt";
        Genetic GeneticAlgorithm = new Genetic(file,50,20);
        Assert.assertEquals(GeneticAlgorithm.NbPop, 50);
    }

    @Test
    public void testnbind(){
        String file = "Knapsack.txt";
        Genetic GeneticAlgorithm = new Genetic(file, 50, 20);
        Assert.assertEquals(GeneticAlgorithm.Nbind, 20);

    }

    @Test
    public void testnbvariable(){
        String file = "Knapsack.txt";
        Genetic GeneticAlgorithm = new Genetic(file, 50, 20);
        Assert.assertEquals(GeneticAlgorithm.NbVariable, 4);

    }

    @Test
    public void testprice(){
        String file = "Knapsack.txt";
        Genetic GeneticAlgorithm = new Genetic(file, 50, 20);
        Assert.assertEquals(GeneticAlgorithm.NbConstraints, 2);    
    }

    @Test
    public void testNbojective(){
        String file = "Knapsack.txt";
        Genetic GeneticAlgorithm = new Genetic(file, 50, 20);
        Assert.assertEquals(GeneticAlgorithm.NbObj, 2);    
    }


}