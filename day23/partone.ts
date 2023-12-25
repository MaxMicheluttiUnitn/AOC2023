import * as fs from 'fs';
import * as path from 'path';
import TreeMap from 'ts-treemap';

const UP = 0
const DOWN = 1
const LEFT = 2
const RIGHT = 3

class CoordPair{
    last: Coords
    current: Coords
    node_coords: Coords
    length: number

    constructor(last:Coords,current:Coords, node_coords: Coords, len: number){
        this.last = last.clone()
        this.current = current.clone()
        this.node_coords = node_coords.clone()
        this.length = len
    }

    getDirection(){
        if(this.last.row == this.current.row){
            if(this.last.column == this.current.column - 1){
                return RIGHT
            }else{
                return LEFT
            }
        }else{
            if(this.last.row == this.current.row - 1){
                return DOWN
            }else{
                return UP
            }
        }
    }

    nextCoords(){
        let res :Array<CoordPair> = []
        if(this.last.row == this.current.row){
            res.push(new CoordPair(this.current,new Coords(this.current.row+1,this.current.column),this.node_coords,this.length+1))
            res.push(new CoordPair(this.current,new Coords(this.current.row-1,this.current.column),this.node_coords,this.length+1))
            if(this.last.column == this.current.column - 1){
                res.push(new CoordPair(this.current,new Coords(this.current.row,this.current.column + 1),this.node_coords,this.length+1))
            }else{
                res.push(new CoordPair(this.current,new Coords(this.current.row,this.current.column - 1),this.node_coords,this.length+1))
            }
        }else{
            res.push(new CoordPair(this.current,new Coords(this.current.row,this.current.column - 1),this.node_coords,this.length+1))
            res.push(new CoordPair(this.current,new Coords(this.current.row,this.current.column + 1),this.node_coords,this.length+1))
            if(this.last.row == this.current.row - 1){
                res.push(new CoordPair(this.current,new Coords(this.current.row + 1,this.current.column),this.node_coords,this.length+1))
            }else{
                res.push(new CoordPair(this.current,new Coords(this.current.row - 1,this.current.column),this.node_coords,this.length+1))
            }
        }
        return res
    }
}

class Coords{
    row: number
    column: number
    
    constructor(r: number,c:number){
        this.row = r
        this.column = c
    }

    toString() {
        return "row: "+this.row+" col: "+this.column
    }

    clone(){
        return new Coords(this.row,this.column)
    }

    eq(other: Coords){
        return (this.row == other.row) && (this.column == other.column)
    }
}

class Link{
    node: Coords
    length: number

    constructor(n:Coords,len:number){
        this.node = n.clone()
        this.length = len
    }
}

class Node{
    location: Coords
    children: Array<Link>
    parents: Array<Link>


    constructor(loc:Coords){
        this.location = loc.clone()
        this.children = []
        this.parents = []
    }

    add_child(n:Coords,len:number){
        this.children.push(new Link(n,len))
    }

    add_parent(n:Coords,len:number){
        this.parents.push(new Link(n,len))
    }
}

const indexOfNode = (c:Coords,w:number) =>{
    return c.row * w + c.column
}

const solve = (input: Array<string>) =>{
    let width = input[0].length
    let height = input.length
    let start = new Coords(0,1)
    let goal = new Coords(height - 1,width - 2)
    let current = new Coords(1,1)
    let last = start.clone()
    let graph : Map<number,Node> = new Map<number,Node>();
    graph.set(indexOfNode(start,width),new Node(start))
    graph.set(indexOfNode(goal,width),new Node(goal))
    let visited :Array<Array<Array<number>>> = []
    for(let i=0;i<height;i++){
        visited.push([])
        for(let j=0;j<width;j++){
            visited[i].push([])
            for(let k=0;k<4;k++){
                visited[i][j].push(0)
            }
        }
    }
    let queue : Array<CoordPair> = []
    queue.push(new CoordPair(last,current,start,1))
    while(!(queue.length==0)){
        let current_pair = queue.shift()
        if(!current_pair){
            throw "Undefined error";
        }
        if(visited[current_pair.current.row][current_pair.current.column][current_pair.getDirection()] == 1){
            continue
        }
        visited[current_pair.current.row][current_pair.current.column][current_pair.getDirection()] = 1
        if(current_pair.current.eq(goal)){
            graph.get(indexOfNode(current_pair.node_coords,width))?.add_child(goal,current_pair.length)
            graph.get(indexOfNode(goal,width))?.add_parent(current_pair.node_coords,current_pair.length)
            continue
        }
        let next_locations = current_pair.nextCoords()
        let valid_next_locations : Array<CoordPair> = []
        let possible_next_locations : Array<CoordPair> = []
        for(let loc of next_locations){
            if((loc.current.row<0) || (loc.current.row>=height) || (loc.current.column<0) ||(loc.current.column>=width)){
                continue
            }
            let last_symbol = input[loc.last.row][loc.last.column]
            let current_symbol = input[loc.current.row][loc.current.column]
            let direction = loc.getDirection()
            if(current_symbol != "#"){
                possible_next_locations.push(loc)
            }
            if(last_symbol == "."){
                if(current_symbol != "#"){
                    valid_next_locations.push(loc)
                }
            }else if(last_symbol == ">" && direction == RIGHT){
                if(current_symbol != "#"){
                    valid_next_locations.push(loc)
                }
            }else if(last_symbol == "<" && direction == LEFT){
                if(current_symbol != "#"){
                    valid_next_locations.push(loc)
                }
            }else if(last_symbol == "v" && direction == DOWN){
                if(current_symbol != "#"){
                    valid_next_locations.push(loc)
                }
            }else if(last_symbol == "^" && direction == UP){
                if(current_symbol != "#"){
                    valid_next_locations.push(loc)
                }
            }
        }
        if(possible_next_locations.length == 0){
            continue
        }
        if(possible_next_locations.length == 1){
            for(let valid of valid_next_locations){
                queue.push(valid)
            }
            continue
        }
        let source_node = graph.get(indexOfNode(current_pair.node_coords,width))
        if(!source_node){
            throw "Source error"
        }
        let next_node = graph.get(indexOfNode(current_pair.current,width))
        if(!next_node){
            next_node = new Node(current_pair.current)
            graph.set(indexOfNode(current_pair.current,width),next_node)
        }
        source_node.add_child(current_pair.current,current_pair.length)
        next_node.add_parent(source_node.location,current_pair.length)
        graph.set(indexOfNode(current_pair.node_coords,width),source_node)
        for(let loc of possible_next_locations){
            queue.push(new CoordPair(loc.last,loc.current,loc.last,1))
        }
    }
    
    // for(let k of graph.keys()){
    //     console.log(k)
    //     console.log(graph.get(k))
    //     console.log(graph.get(k)?.children)
    //     console.log(graph.get(k)?.parents)
    // }
    
    let search_distance : Map<number,number> = new Map<number,number>()
    for(let k of graph.keys()){
       search_distance.set(k,-1)
    }
    let search_queue : Array<number> = []
    search_distance.set(indexOfNode(start,width),0)
    let start_node = graph.get(indexOfNode(start,width))
    if(!start_node){throw "err"}
    for(let child of start_node.children){
        search_queue.push(indexOfNode(child.node,width))
    }
    while(!(search_queue.length==0)){
        let current_node_id = search_queue.shift()
        if(!current_node_id){throw "cnodeid err"}
        let current_node = graph.get(current_node_id)
        if(!current_node){throw "cnode err"}
        if(search_distance.get(current_node_id) == -1){
            let max_value = 0
            let can_compute_distance = true
            for(let parent of current_node.parents){
                if(search_distance.get(indexOfNode(parent.node,width))==-1){
                    can_compute_distance = false
                    break
                }else{
                    let parent_dist = search_distance.get(indexOfNode(parent.node,width))
                    if(parent_dist==undefined){throw "pdist err"}
                    if(parent_dist+parent.length > max_value){
                        max_value = parent_dist+parent.length
                    }
                }
            }
            if(!can_compute_distance){
                search_queue.push(current_node_id)
            }else{
                search_distance.set(current_node_id,max_value)
                for(let child of current_node.children){
                    search_queue.push(indexOfNode(child.node,width))
                } 
            }
        }
    }
    console.log(search_distance.get(indexOfNode(goal,width)))
}

fs.readFile(path.join(__dirname, "problem.txt"), (err, data) => {
    if (err) throw err;
    let textByLine = data.toString().split("\n")
    solve(textByLine)
})