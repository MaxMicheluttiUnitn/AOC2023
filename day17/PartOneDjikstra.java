import java.util.*;

class PartOneDjikstra{
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

        public DjikstraItem(int row,int column,int energy,int direction_steps, int direction){
            this.row = row;
            this.column = column;
            this.energy = energy;
            this.steps_at_direction = direction_steps;
            this.direction = direction;
        }
    }

    private class CoordVisitor{
        public int row;
        public int column;
        public boolean[][] visited;

        CoordVisitor(int r,int c){
            this.row = r;
            this.column = c;
            this.visited = new boolean[4][4];
            for(int i=0;i<4;i++){
                for(int j=0;j<4;j++){
                    this.visited[i][j]=false;
                }
            }
        }
    }
    TreeMap<Integer,LinkedList<DjikstraItem>> items;
    Problem input;
    CoordVisitor[][] visited_cells;

    PartOneDjikstra(Problem p){
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
        LinkedList<DjikstraItem> first_entry_list = new LinkedList<DjikstraItem>();
        first_entry_list.add(new DjikstraItem(0,0,input.get(0,0),0,0));
        this.items.put(input.get(0,0),first_entry_list);
        boolean found_exit = false;
        int exit_value = 0;
        while(!found_exit){
            LinkedList<DjikstraItem> current_entry = this.items.pollFirstEntry().getValue();
            for (DjikstraItem element : current_entry) { 
                if(this.visited_cells[element.row][element.column].visited[element.direction][element.steps_at_direction]){
                    continue;
                }else{
                    this.visited_cells[element.row][element.column].visited[element.direction][element.steps_at_direction] = true;
                }
                System.out.println("Processing element ["+element.row+", "+element.column+", nrg: "+element.energy+", from: "+element.direction+", with_steps: "+element.steps_at_direction+"]");
                if((element.row == this.input.getHeight()-1)&&(element.column==this.input.getWidth()-1)){
                    found_exit = true;
                    exit_value = element.energy;
                    break;
                }else{
                    // move NORTH
                    if((element.row>0)&&(element.direction!=PartOneDjikstra.SOUTH)&&((element.direction!=PartOneDjikstra.NORTH)||(element.steps_at_direction<3))){
                        int energy_after_north = element.energy + this.input.get(element.row-1,element.column);
                        LinkedList<DjikstraItem> north_entry = this.items.get(energy_after_north);
                        if(north_entry==null){
                            north_entry = new LinkedList<DjikstraItem>(); 
                        }
                        north_entry.add(new DjikstraItem(element.row-1,element.column,energy_after_north,
                            (element.direction==PartOneDjikstra.NORTH)?(element.steps_at_direction+1):1,PartOneDjikstra.NORTH));
                        this.items.put(energy_after_north,north_entry);
                    }
                    // move SOUTH
                    if((element.row<this.input.getHeight()-1)&&(element.direction!=PartOneDjikstra.NORTH)&&((element.direction!=PartOneDjikstra.SOUTH)||(element.steps_at_direction<3))){
                        int energy_after_south = element.energy + this.input.get(element.row+1,element.column);
                        LinkedList<DjikstraItem> south_entry = this.items.get(energy_after_south);
                        if(south_entry==null){
                            south_entry = new LinkedList<DjikstraItem>(); 
                        }
                        south_entry.add(new DjikstraItem(element.row+1,element.column,energy_after_south,
                            (element.direction==PartOneDjikstra.SOUTH)?(element.steps_at_direction+1):1,PartOneDjikstra.SOUTH));
                        this.items.put(energy_after_south,south_entry);
                    }
                    // move WEST
                    if((element.column>0)&&(element.direction!=PartOneDjikstra.EAST)&&((element.direction!=PartOneDjikstra.WEST)||(element.steps_at_direction<3))){
                        int energy_after_west = element.energy + this.input.get(element.row,element.column-1);
                        LinkedList<DjikstraItem> west_entry = this.items.get(energy_after_west);
                        if(west_entry==null){
                            west_entry = new LinkedList<DjikstraItem>(); 
                        }
                        west_entry.add(new DjikstraItem(element.row,element.column-1,energy_after_west,
                            (element.direction==PartOneDjikstra.WEST)?(element.steps_at_direction+1):1,PartOneDjikstra.WEST));
                        this.items.put(energy_after_west,west_entry);
                    }
                    // move EAST
                    if((element.column<this.input.getWidth()-1)&&(element.direction!=PartOneDjikstra.WEST)&&((element.direction!=PartOneDjikstra.EAST)||(element.steps_at_direction<3))){
                        int energy_after_east = element.energy + this.input.get(element.row,element.column+1);
                        LinkedList<DjikstraItem> east_entry = this.items.get(energy_after_east);
                        if(east_entry==null){
                            east_entry = new LinkedList<DjikstraItem>(); 
                        }
                        east_entry.add(new DjikstraItem(element.row,element.column+1,energy_after_east,
                            (element.direction==PartOneDjikstra.EAST)?(element.steps_at_direction+1):1,PartOneDjikstra.EAST));
                        this.items.put(energy_after_east,east_entry);
                    }
                }
            } 
        }
        System.out.println("Result is "+(exit_value-this.input.get(0,0)));
    }
}