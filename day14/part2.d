module day14.part2;

import std.file;
import std.stdio;
import std.container;


const int BOULDER = 2;
const int WALL = 1;
const int EMPTY = 0;

class Platform{
    int[][] items;
    int width;
    int height;

    this(int[][] i,int w,int h){
        this.width=w;
        this.height=h;
        this.items=i;
    }

    this(char[] input){
        // GET WIDTH AND HEIGHT
        this.height=1;
        this.width=0;
        int width_count=0;
        for(int i=0;i<input.length;i++){
            if(input[i]=='\n'){
                this.height++;
                this.width=width_count;
            }else if(this.width==0){
                width_count++;
            }
        }
        
        //INITIALIZE MATRIX WITH ZEROS
        this.items = new int[][this.height];
        for(int i=0;i<this.height;i++){
            this.items[i]=new int[this.width];
            for(int j=0;j<this.width;j++){
                this.items[i][j] = EMPTY;
            }
        }

        //FILL MATRIX WITH INPUT
        width_count=0;
        int height_count=0;
        for(int i=0;i<input.length;i++){
            if(input[i]=='\n'){
                height_count++;
                width_count=0;
            }else{
                if(input[i]=='O'){
                    this.items[height_count][width_count] = BOULDER;
                }else if(input[i]=='#'){
                    this.items[height_count][width_count] = WALL;
                }
                width_count++;
            }
        }
    }

    Platform clone(){
        int[][] cloned=new int[][this.height];
        for(int i=0;i<this.height;i++){
            cloned[i]=new int[this.width];
            for(int j=0;j<this.width;j++){
                cloned[i][j]=this.items[i][j];
            }
        }
        return new Platform(
            cloned,
            this.width,
            this.height
        );
    }

    void print_platform(){
        for(int i=0;i<this.height;i++){
            for(int j=0;j<this.width;j++){
                write(this.items[i][j]);
            }
            writeln("");
        }
    }

    void roll_north(){
        for(int i=0;i<this.height;i++){
            for(int j=0;j<this.width;j++){
                if(this.items[i][j]==BOULDER){
                    this.roll_boulder_north(i,j);
                }
            }
        }
    }

    void roll_boulder_north(int start,int column){
        assert(this.items[start][column]==BOULDER);
        int new_location = start;
        for(int i=start-1;i>=0;i--){
            if(this.items[i][column]==EMPTY){
                new_location = i;
            }else{
                break;
            }
        }
        this.items[start][column] = EMPTY;
        this.items[new_location][column] = BOULDER;
    }

    void roll_south(){
        for(int i=this.height-1;i>=0;i--){
            for(int j=0;j<this.width;j++){
                if(this.items[i][j]==BOULDER){
                    this.roll_boulder_south(i,j);
                }
            }
        }
    }

    void roll_boulder_south(int start,int column){
        assert(this.items[start][column]==BOULDER);
        int new_location = start;
        for(int i=start+1;i<this.height;i++){
            if(this.items[i][column]==EMPTY){
                new_location = i;
            }else{
                break;
            }
        }
        this.items[start][column] = EMPTY;
        this.items[new_location][column] = BOULDER;
    }

    void roll_east(){
        for(int i=0;i<this.height;i++){
            for(int j=this.width-1;j>=0;j--){
                if(this.items[i][j]==BOULDER){
                    this.roll_boulder_east(i,j);
                }
            }
        }
    }

    void roll_boulder_east(int row,int start){
        assert(this.items[row][start]==BOULDER);
        int new_location = start;
        for(int i=start+1;i<this.width;i++){
            if(this.items[row][i]==EMPTY){
                new_location = i;
            }else{
                break;
            }
        }
        this.items[row][start] = EMPTY;
        this.items[row][new_location] = BOULDER;
    }

    void roll_west(){
        for(int i=0;i<this.height;i++){
            for(int j=0;j<this.width;j++){
                if(this.items[i][j]==BOULDER){
                    this.roll_boulder_west(i,j);
                }
            }
        }
    }

    void roll_boulder_west(int row,int start){
        assert(this.items[row][start]==BOULDER);
        int new_location = start;
        for(int i=start-1;i>=0;i--){
            if(this.items[row][i]==EMPTY){
                new_location = i;
            }else{
                break;
            }
        }
        this.items[row][start] = EMPTY;
        this.items[row][new_location] = BOULDER;
    }

    void roll_one_cycle(){
        this.roll_north();
        this.roll_west();
        this.roll_south();
        this.roll_east();
    }

    bool equals(Platform p){
        if(this.width != p.width){
            return false;
        }
        if(this.height != p.height){
            return false;
        }
        for(int i=0;i<this.height;i++){
            for(int j=0;j<this.width;j++){
                if(this.items[i][j]!=p.items[i][j]){
                    return false;
                }
            }
        }
        return true;
    }

    void roll_n_cycles(int n){
        auto iters = [this.clone()];
        Platform start = this.clone();
        int end_index = 0;
        bool found = false;
        // start.print_platform();
        //     writeln("");
        for(int x=0;x<n && !found;x++){
            // writeln("Rolling cycle ",x+1);
            start.roll_one_cycle();
            end_index++;
            foreach (key; iters){
                if(start.equals(key)){
                    found=true;
                    break;
                }
            }
            // start.print_platform();
            // writeln("");
            iters~=start.clone();
        }
        int start_index=0;
        while(!this.equals(start)){
            start_index++;
            this.roll_one_cycle();
        }
        // writeln(start_index);
        // writeln(end_index);
        int loop_length = end_index - start_index;
        int rolls_to_do = (n - start_index) % loop_length;
        // writeln(rolls_to_do);
        for(int i=0;i<rolls_to_do;i++){
            this.roll_one_cycle();
        }
    }

    int compute_load(){
        int total_load=0;
        for(int i=0;i<this.height;i++){
            for(int j=0;j<this.width;j++){
                if(this.items[i][j]==BOULDER){
                    total_load+=this.height-i;
                }
            }
        }
        return total_load;
    }
}

void main()
{
    char[] input_chars = cast(char[]) read("problem.txt");
    Platform p = new Platform(input_chars);
    // p.print_platform();    
    p.roll_n_cycles(1_000_000_000);
    // 1000000000
    // writeln("");
    // p.print_platform();
    // p.roll_n_cycles(1);
    // writeln("");
    // p.print_platform();
    // writeln("");
    writeln(p.compute_load());
}