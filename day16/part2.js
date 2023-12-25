const fs = require('fs');

function print(item){
    console.log(item)
}

fs.readFile('problem.txt', 'utf8', (err, data) => {
    if (err) {
        console.error(err);
        return;
    }
    var lines = data.split('\n')
    var input = []
    for(let line of lines){
        input[input.length] = line
    }
    solve(input)
});

function energizing(input,start_row,start_column,start_direction){
    let width = input[0].length
    let height = input.length

    let direction_map=Array.from(Array(height), () => Array(input[0].width))
    let light_map=Array.from(Array(height), () => Array(input[0].width))
    for(let i=0;i<height;i++){
        for(let j=0;j<height;j++){
            light_map[i][j] = 0
            direction_map[i][j] = []
        }
    }

    var processing = [[start_row,start_column,start_direction]]
    // visit matrix following instruction
    while(!(processing.length==0)){
        let step = processing.shift()
        let row = step[0]
        let column = step[1]
        let action = step[2]
        // If I am out of bounds do not perform this step
        if(row<0 || row>=height || column<0 || column>=width){
            continue;
        }
        light_map[row][column] = 1
        // IF I already performed this action here, don't consider this step
        if(direction_map[row][column].includes(action)){
            continue;
        }
        direction_map[row][column].push(action)
        let symbol = input[row].charAt(column)
        if(symbol=='.'){
            // simple move to next place
            if(action=="lr"){
                processing.push([row,column+1,"lr"])
            }else if(action=="rl"){
                processing.push([row,column-1,"rl"])
            }else if(action=="td"){
                processing.push([row+1,column,"td"])
            }else if(action=="dt"){
                processing.push([row-1,column,"dt"])
            }
            continue;
        }
        if(symbol=='/'){
            // mirror move
            if(action=="lr"){
                processing.push([row-1,column,"dt"])
            }else if(action=="rl"){
                processing.push([row+1,column,"td"])
            }else if(action=="td"){
                processing.push([row,column-1,"rl"])
            }else if(action=="dt"){
                processing.push([row,column+1,"lr"])
            }else{
                print("direction error")
            }
            continue;
        }
        if(symbol=='\\'){
            // other mirror move
            if(action=="lr"){
                processing.push([row+1,column,"td"])
            }else if(action=="rl"){
                processing.push([row-1,column,"dt"])
            }else if(action=="td"){
                processing.push([row,column+1,"lr"])
            }else if(action=="dt"){
                processing.push([row,column-1,"rl"])
            }else{
                print("direction error")
            }
            continue;
        }
        if(symbol=='-'){
            // horizontal split
            if(action=="lr"){
                processing.push([row,column+1,"lr"])
            }else if(action=="rl"){
                processing.push([row,column-1,"rl"])
            }else if(action=="td"){
                processing.push([row,column+1,"lr"])
                processing.push([row,column-1,"rl"])
            }else if(action=="dt"){
                processing.push([row,column+1,"lr"])
                processing.push([row,column-1,"rl"])
            }else{
                print("direction error")
            }
            continue;
        }
        if(symbol=='|'){
            // vertical split
            if(action=="lr"){
                processing.push([row+1,column,"td"])
                processing.push([row-1,column,"dt"])
            }else if(action=="rl"){
                processing.push([row+1,column,"td"])
                processing.push([row-1,column,"dt"])
            }else if(action=="td"){
                processing.push([row+1,column,"td"])
            }else if(action=="dt"){
                processing.push([row-1,column,"dt"])
            }else{
                print("direction error")
            }
            continue;
        }
        print("unknown symbol found: "+symbol)
    }

    let sum_of_all_ones = 0
    for(let i=0;i<height;i++){
        for(let j=0;j<height;j++){
            if(light_map[i][j] == 1){
                sum_of_all_ones = sum_of_all_ones + 1
            }
        }
    }   
    return sum_of_all_ones
}

function solve(input){
    var width = input[0].length
    var height = input.length

    let max_energy = 0
    for(let i=0;i<height;i++){
        let left_right_energy = energizing(input,i,0,"lr")
        let right_left_energy = energizing(input,i,width-1,"rl")    
        if(left_right_energy > max_energy){
            max_energy = left_right_energy
        }  
        if(right_left_energy > max_energy){
            max_energy = right_left_energy
        }
    }
    for(let j=0;j<width;j++){
        let top_down_energy = energizing(input,0,j,"td")
        let down_top_energy = energizing(input,height-1,j,"dt")      
        if(top_down_energy > max_energy){
            max_energy = top_down_energy
        }  
        if(down_top_energy > max_energy){
            max_energy = down_top_energy
        }
    }
    print(max_energy)
    
}