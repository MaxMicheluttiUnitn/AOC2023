open System.IO

let lines = File.ReadLines("example.txt")                
let mutable direction_input = []
let mutable movement_input = []
let mutable hex_color_input = []

for line in lines do
    let line_list = line.Split [|' '|] |> Array.toList
    direction_input <- direction_input @ [line_list[0]]
    movement_input <- movement_input @ [int line_list[1]]
    hex_color_input <- hex_color_input @ [line_list[2]]

let height = direction_input.Length

// for i in 0..(height - 1) do
//     printfn "%d" movement_input[i]

let mutable max_right = 0
let mutable max_down = 0
let mutable min_right = 0
let mutable min_down = 0

let mutable x = 0
let mutable y = 0
for i in 0..(height - 1) do
    if direction_input[i] = "L"  then
        x <- x - movement_input[i]
        if x < min_right then
            min_right <- x
    if direction_input[i] = "R"  then
        x <- x + movement_input[i]
        if x > max_right then
            max_right <- x
    if direction_input[i] = "U"  then
        y <- y - movement_input[i]
        if y < min_down then
            min_down <- y
    if direction_input[i] = "D"  then
        y <- y + movement_input[i]
        if y > max_down then
            max_down <- y 

// printfn "min r %d" min_right
// printfn "min d %d" min_down
// printfn "max r %d" max_right
// printfn "max d %d" max_down

let x_dim = max_right - min_right + 3
let y_dim = max_down - min_down + 3

let start_x = 0 - min_right + 1
let start_y = 0 - min_down + 1

// let mutable input = array2D [| for i in 1..height -> [| for j in 1..height -> 0|]|]
let mutable route_matrix = array2D [| for i in 1..(x_dim) -> [| for j in 1..(y_dim) -> 0|]|]

// for i in 0..(x_dim-1) do    
//     for j in 0..(y_dim-1) do
//         printf "%d" route_matrix[i, j]
//     printfn ""
// printfn ""

x <- start_x
y <- start_y
route_matrix[start_x, start_y] <- 3
for i in 0..(height-1) do
    // printfn "In: ( %d, %d )" x y
    if direction_input[i] = "L"  then
        for shift in (x - movement_input[i])..x do
            // printfn "( %d, %d )" shift y
            route_matrix[shift, y] <- 3
        x <- x - movement_input[i]
    if direction_input[i] = "R"  then
        for shift in x..(x + movement_input[i]) do
            // printfn "( %d, %d )" shift y
            route_matrix[shift, y] <- 3
        x <- x + movement_input[i]
    if direction_input[i] = "U"  then
        for shift in (y - movement_input[i])..y do
            // printfn "( %d, %d )" x shift
            route_matrix[x, shift] <- 3
        y <- y - movement_input[i]
    if direction_input[i] = "D"  then
        for shift in y..(y + movement_input[i]) do
            // printfn "( %d, %d )" x shift
            route_matrix[x, shift] <- 3
        y <- y + movement_input[i]

// for i in 0..(x_dim-1) do    
//     for j in 0..(y_dim-1) do
//         printf "%d" route_matrix[i, j]
//     printfn ""
// printfn ""

let rec depth_first_search x y =
    if x<0 then ignore 0 else
        if y<0 then ignore 0 else
            if x>=x_dim then ignore 0 else
                if y>=y_dim then ignore 0 else
                    if route_matrix[x, y] > 0 then ignore 0 else
                        let step = route_matrix[x, y] <- 1
                        depth_first_search (x+1) y
                        depth_first_search (x-1) y 
                        depth_first_search x (y-1)
                        depth_first_search x (y+1)

depth_first_search 0 0

// for i in 0..(x_dim-1) do    
//     for j in 0..(y_dim-1) do
//         printf "%d" route_matrix[i, j]
//     printfn ""
// printfn ""

let mutable zero_count = 0

for i in 0..(x_dim-1) do    
    for j in 0..(y_dim-1) do
        if route_matrix[i, j] = 0 then
            zero_count <- zero_count + 1
        if route_matrix[i, j] = 3 then
            zero_count <- zero_count + 1

printfn "Result is: %d" zero_count