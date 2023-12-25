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
    neighbour: Array<Link>


    constructor(loc:Coords){
        this.location = loc.clone()
        this.neighbour = []
    }

    add_child(n:Coords,len:number){
        this.neighbour.push(new Link(n,len))
    }
}

class DFS_Frame{
    distance_value: number
    visited: Map<number,boolean>
    current_node: Coords

    constructor(dv:number,vis: Map<number,boolean>,cur:Coords){
        this.distance_value = dv
        this.visited = vis
        this.current_node = cur.clone()
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
            graph.get(indexOfNode(goal,width))?.add_child(current_pair.node_coords,current_pair.length)
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
        next_node.add_child(source_node.location,current_pair.length)
        graph.set(indexOfNode(current_pair.node_coords,width),source_node)
        for(let loc of possible_next_locations){
            queue.push(new CoordPair(loc.last,loc.current,loc.last,1))
        }
    }
    
    // for(let k of graph.keys()){
    //     console.log(k)
    //     console.log(graph.get(k))
    //     console.log(graph.get(k)?.neighbour)
    // }
    
    let dfs_stack : Array<DFS_Frame> = []
    let max_value = 0
    let starting_visited = new Map<number,boolean>()
    for(let k of graph.keys()){
        starting_visited.set(k,false)
    }
    starting_visited.set(indexOfNode(start,width),true)
    dfs_stack.push(new DFS_Frame(0,starting_visited,start))
    while(!(dfs_stack.length==0)){
        let current_frame = dfs_stack.pop()
        if(!current_frame){throw "cframe err"}
        let frame_node_coords = current_frame.current_node
        let frame_node_id = indexOfNode(frame_node_coords,width)
        let current_visited_map = current_frame.visited
        let current_distance = current_frame.distance_value
        if(frame_node_coords.eq(goal)){
            if(max_value<current_distance){
                max_value = current_distance
            }
        }else{
            let frame_node = graph.get(frame_node_id)
            if(!frame_node){throw "fnode err"}
            for(let child of frame_node.neighbour){
                let child_dist = current_distance + child.length
                let child_id = indexOfNode(child.node,width)
                if(!(current_visited_map.get(child_id)==true)){
                    let visited_map_clone = new Map<number,boolean>()
                    for(let k of current_visited_map.keys()){
                        let val = current_visited_map.get(k)
                        if(val==undefined){throw "clone err"}
                        visited_map_clone.set(k,val)
                    }
                    visited_map_clone.set(child_id,true)
                    dfs_stack.push(new DFS_Frame(child_dist,visited_map_clone,child.node.clone()))
                }
            }
        }
    }
    console.log(max_value)
}

fs.readFile(path.join(__dirname, "problem.txt"), (err, data) => {
    if (err) throw err;
    let textByLine = data.toString().split("\n")
    solve(textByLine)
})