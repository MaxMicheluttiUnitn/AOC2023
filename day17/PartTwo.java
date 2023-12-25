import java.io.File; 
import java.io.FileNotFoundException; 
import java.util.Scanner;

class PartTwo{
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
        PartTwoDjikstra part_two_solver = new PartTwoDjikstra(p);
        part_two_solver.solve_problem();
    }
}