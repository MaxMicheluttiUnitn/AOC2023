import java.util.ArrayList;

class Problem{
    private ArrayList<ArrayList<Integer>> cells;
    private int width;
    private int height;

    public Problem(){
        this.width = 0;
        this.height = 0;
        this.cells = new ArrayList<ArrayList<Integer>>();
    }

    public void appendLine(String line){
        this.height++;
        this.width = (this.width>line.length())?this.width:line.length();
        ArrayList<Integer> line_list = new ArrayList<Integer>(); 
        for(int i=0;i<line.length();i++){
            line_list.add(line.charAt(i) - '0');
        }
        cells.add(line_list);
    }

    public void print(){
        for(int row=0;row<this.height;row++){
            for(int col=0;col<this.width;col++){
                System.out.print(cells.get(row).get(col));
            }
            System.out.println("");
        }
    }

    public int get(int row,int column){
        if(row <  0 || row >=this.height || column < 0 || column>=this.width){
            System.out.println("PROBLEM GET ERROR");
            return 2000;
        }
        return this.cells.get(row).get(column);
    }

    public int getHeight(){
        return this.height;
    }

    public int getWidth(){
        return this.width;
    }

}