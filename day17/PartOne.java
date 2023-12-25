import java.io.File; 
import java.io.FileNotFoundException; 
import java.util.Scanner;

class PartOne{
    public static void main(String[] args){
        Problem p = new Problem();
        try {
            File myObj = new File("problem.txt");
            Scanner myReader = new Scanner(myObj);
            while (myReader.hasNextLine()) {
                String data = myReader.nextLine();
                p.appendLine(data);
            }
            myReader.close();
        } catch (FileNotFoundException e) {
            System.out.println("An error occurred.");
            e.printStackTrace();
        }
        // p.print();
        PartOneDjikstra part_one_solver = new PartOneDjikstra(p);
        part_one_solver.solve_problem();
    }
}