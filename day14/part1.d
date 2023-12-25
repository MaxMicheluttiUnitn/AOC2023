module day14.part1;

import std.file;
import std.stdio;

const int BOULDER = 2;
const int WALL = 1;
const int EMPTY = 0;

class Platform{
    int[][] items;
    int width;
    int height;

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
    p.roll_north();
    // writeln("");
    // p.print_platform();
    // writeln("");
    writeln(p.compute_load());
}