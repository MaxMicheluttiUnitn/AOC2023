import java.util.*;

class PartTwoDjikstra{
    private final static int NORTH = 0;
    private final static int SOUTH = 1;
    private final static int EAST = 2;
    private final static int WEST = 3;

    private class DjikstraItem{
        public int row;
        public int column;
        public int energy;
        public int steps_at_direction;
        public int direction;
        public int last_row;
        public int last_column;

        public DjikstraItem(int row,int column,int energy,int direction_steps, int direction,int last_row, int last_col){
            this.row = row;
            this.column = column;
            this.energy = energy;
            this.steps_at_direction = direction_steps;
            this.direction = direction;
            this.last_row = last_row;
            this.last_column = last_col;
        }
    }

    private class CoordVisitor{
        public int row;
        public int column;
        public boolean[][] visited;

        public CoordVisitor(int r,int c){
            this.row = r;
            this.column = c;
            this.visited = new boolean[4][10-4+1];
            for(int i=0;i<4;i++){
                for(int j=0;j<4;j++){
                    this.visited[i][j]=false;
                }
            }
        }

        public boolean is_visited(int direction, int times_moved){
            int j = times_moved - 4;
            if(j<0){
                System.out.println("IS VISITED ERROR");
                return true;
            }
            return this.visited[direction][j];
        }

        public void make_visited(int direction, int times_moved){
            int j = times_moved - 4;
            if(j<0){
                System.out.println("MAKE VISITED ERROR");
                return;
            }
            this.visited[direction][j] = true;
        }
    }
    TreeMap<Integer,LinkedList<DjikstraItem>> items;
    Problem input;
    CoordVisitor[][] visited_cells;

    PartTwoDjikstra(Problem p){
        this.input = p;
        this.items = new TreeMap<Integer,LinkedList<DjikstraItem>>();
        this.visited_cells = new CoordVisitor[this.input.getHeight()][this.input.getWidth()];
        for(int i=0;i<this.input.getHeight();i++){
            for(int j=0;j<this.input.getWidth();j++){
                this.visited_cells[i][j] = new CoordVisitor(i,j);
            }
        }
    }

    public void solve_problem(){
        int row_acc = this.input.get(0,0);
        int col_acc = this.input.get(0,0);
        for(int j=1;j<=10;j++){
            row_acc += this.input.get(0,j);
            col_acc += this.input.get(j,0);
            if(j>=4){
                LinkedList<DjikstraItem> entry = this.items.get(row_acc);
                if(entry==null){
                    entry = new LinkedList<DjikstraItem>(); 
                }
                entry.add(new DjikstraItem(0,j,row_acc,j,PartTwoDjikstra.EAST,0,0));
                this.items.put(row_acc,entry);

                entry = this.items.get(col_acc);
                if(entry==null){
                    entry = new LinkedList<DjikstraItem>(); 
                }
                entry.add(new DjikstraItem(j,0,col_acc,j,PartTwoDjikstra.SOUTH,0,0));
                this.items.put(col_acc,entry);
            }
        }
        boolean found_exit = false;
        int exit_value = 0;
        while(!found_exit){
            LinkedList<DjikstraItem> current_entry = this.items.pollFirstEntry().getValue();
            for (DjikstraItem element : current_entry) { 
                if(this.visited_cells[element.row][element.column].is_visited(element.direction,element.steps_at_direction)){
                    continue;
                }else{
                    this.visited_cells[element.row][element.column].make_visited(element.direction,element.steps_at_direction);
                }
                // System.out.println("Processing element [ in: ("+element.row+", "+element.column+"), nrg: "+element.energy+", from: "+element.direction+", with_steps: "+element.steps_at_direction+" coming from: ("+element.last_row+", "+element.last_column+")]");
                if((element.row == this.input.getHeight()-1)&&(element.column==this.input.getWidth()-1)){
                    found_exit = true;
                    exit_value = element.energy;
                    break;
                }else{
                    // compute all possible movements and push them to the list
                    // NORTH
                    if((element.direction!=PartTwoDjikstra.NORTH)&&(element.direction!=PartTwoDjikstra.SOUTH)){
                        int energy_acc = element.energy;
                        for(int j=1;j<=10 && (element.row-j>=0);j++){
                            energy_acc += this.input.get(element.row-j, element.column);
                            if(j>=4){
                                LinkedList<DjikstraItem> entry = this.items.get(energy_acc);
                                if(entry==null){
                                    entry = new LinkedList<DjikstraItem>(); 
                                }
                                entry.add(new DjikstraItem(element.row-j,element.column,energy_acc,j,PartTwoDjikstra.NORTH,element.row,element.column));
                                this.items.put(energy_acc,entry);
                            }
                        }
                    }
                    // SOUTH
                    if((element.direction!=PartTwoDjikstra.NORTH)&&(element.direction!=PartTwoDjikstra.SOUTH)){
                        int energy_acc = element.energy;
                        for(int j=1;j<=10 && (element.row+j<this.input.getHeight());j++){
                            energy_acc += this.input.get(element.row+j, element.column);
                            if(j>=4){
                                LinkedList<DjikstraItem> entry = this.items.get(energy_acc);
                                if(entry==null){
                                    entry = new LinkedList<DjikstraItem>(); 
                                }
                                entry.add(new DjikstraItem(element.row+j,element.column,energy_acc,j,PartTwoDjikstra.SOUTH,element.row,element.column));
                                this.items.put(energy_acc,entry);
                            }
                        }
                    }
                    // WEST
                    if((element.direction!=PartTwoDjikstra.WEST)&&(element.direction!=PartTwoDjikstra.EAST)){
                        int energy_acc = element.energy;
                        for(int j=1;j<=10 && (element.column-j>=0);j++){
                            energy_acc += this.input.get(element.row, element.column-j);
                            if(j>=4){
                                LinkedList<DjikstraItem> entry = this.items.get(energy_acc);
                                if(entry==null){
                                    entry = new LinkedList<DjikstraItem>(); 
                                }
                                entry.add(new DjikstraItem(element.row,element.column-j,energy_acc,j,PartTwoDjikstra.WEST,element.row,element.column));
                                this.items.put(energy_acc,entry);
                            }
                        }
                    }
                    // EAST
                    if((element.direction!=PartTwoDjikstra.WEST)&&(element.direction!=PartTwoDjikstra.EAST)){
                        int energy_acc = element.energy;
                        for(int j=1;j<=10 && (element.column+j<this.input.getWidth());j++){
                            energy_acc += this.input.get(element.row, element.column+j);
                            if(j>=4){
                                LinkedList<DjikstraItem> entry = this.items.get(energy_acc);
                                if(entry==null){
                                    entry = new LinkedList<DjikstraItem>(); 
                                }
                                entry.add(new DjikstraItem(element.row,element.column+j,energy_acc,j,PartTwoDjikstra.EAST,element.row,element.column));
                                this.items.put(energy_acc,entry);
                            }
                        }
                    }
                } 
            } 
        }
        System.out.println("Result is "+(exit_value-this.input.get(0,0)));
    }
}