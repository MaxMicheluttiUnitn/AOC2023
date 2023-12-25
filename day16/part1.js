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

function solve(input){
    let start_row = 0
    let start_column = 0
    let start_direction = "lr"
    var width = input[0].length
    var height = input.length

    var direction_map=Array.from(Array(height), () => Array(input[0].width))
    var light_map=Array.from(Array(height), () => Array(input[0].width))
    for(i=0;i<height;i++){
        for(j=0;j<height;j++){
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
    for(i=0;i<height;i++){
        for(j=0;j<height;j++){
            if(light_map[i][j] == 1){
                sum_of_all_ones = sum_of_all_ones + 1
            }
        }
    }   
    print(sum_of_all_ones)
}