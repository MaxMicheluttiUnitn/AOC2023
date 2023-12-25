open System.IO

let lines = File.ReadLines("problem.txt")                
let mutable direction_input = []
let mutable movement_input = []
let mutable hex_color_input = []

for line in lines do
    let line_list = line.Split [|' '|] |> Array.toList
    //direction_input <- direction_input @ [line_list[0]]
    // movement_input <- movement_input @ [0]
    hex_color_input <- hex_color_input @ [line_list[2]]

let height = hex_color_input.Length

let char_to_hexvalue (c:char) =
    if c = '1' then 1
    else if c = '2' then 2
    else if c = '3' then 3
    else if c = '4' then 4
    else if c = '5' then 5
    else if c = '6' then 6
    else if c = '7' then 7
    else if c = '8' then 8
    else if c = '9' then 9
    else if c = 'a' then 10
    else if c = 'b' then 11
    else if c = 'c' then 12
    else if c = 'd' then 13
    else if c = 'e' then 14
    else if c = 'f' then 15
    else 0

for i in 0..(height - 1) do
    //  printfn "%s" hex_color_input[i]
    if hex_color_input[i].[7] = '0' then
        direction_input <- direction_input @ ["R"]
    if hex_color_input[i].[7] = '1' then
        direction_input <- direction_input @ ["D"]
    if hex_color_input[i].[7] = '2' then
        direction_input <- direction_input @ ["L"]
    if hex_color_input[i].[7] = '3' then
        direction_input <- direction_input @ ["U"]
    movement_input <- movement_input @ [16*16*16*16*(char_to_hexvalue hex_color_input[i].[2]) + 16*16*16*(char_to_hexvalue hex_color_input[i].[3]) + 16*16*(char_to_hexvalue hex_color_input[i].[4]) + 16*(char_to_hexvalue hex_color_input[i].[5]) + (char_to_hexvalue hex_color_input[i].[6])]

let mutable x_coords_one = []
let mutable y_coords_one = []

let mutable x_coords_two = []
let mutable y_coords_two = []

let mutable x = 0
let mutable y = 0
let mutable perimeter = 0
for i in 0..(height-1) do
    // printfn "In: ( %d, %d )" x y
    if direction_input[i] = "L"  then
        x <- x - movement_input[i]
    if direction_input[i] = "R"  then
        x <- x + movement_input[i]
    if direction_input[i] = "U"  then
        y <- y - movement_input[i]
    if direction_input[i] = "D"  then
        y <- y + movement_input[i]
    
    perimeter <- perimeter + movement_input[i]

    x_coords_one <- x_coords_one @ [int64 x]
    y_coords_one <- y_coords_one @ [int64 y]
    x_coords_two <- [int64 x] @ x_coords_two
    y_coords_two <- [int64 y] @ y_coords_two
    // printfn "%d %d" x y

let mutable x_sum_one:int64 = 0
let mutable y_sum_one:int64 = 0
let mutable x_sum_two:int64 = 0
let mutable y_sum_two:int64 = 0
// printfn ""
for i in 0..(height-1) do
    let mutable j = i + 1
    if j = height then
        j <- 0
    // case one
    let intermediate_one_x:int64 = x_coords_one[i] * y_coords_one[j]
    x_sum_one <- x_sum_one + intermediate_one_x
    let intermediate_one_y:int64 = y_coords_one[i] * x_coords_one[j]
    y_sum_one <- y_sum_one + intermediate_one_y
    // case two
    let intermediate_two_x:int64 = x_coords_two[i] * y_coords_two[j]
    x_sum_two <- x_sum_two + intermediate_two_x
    let intermediate_two_y:int64 = y_coords_two[i] * x_coords_two[j]
    y_sum_two <- y_sum_two + intermediate_two_y
    // printfn "%d %d" intermediate_one_x intermediate_one_y
    // printfn "%d %d" intermediate_two_x intermediate_two_y
    

let mutable res_one :int64= x_sum_one - y_sum_one
if res_one < 0 then
    res_one <- int64 0 - res_one
// printfn "One before half: %d" res_one
res_one <- res_one / int64 2

let mutable res_two :int64= x_sum_two - y_sum_two
if res_two < 0 then
    res_two <- int64 0 - res_two
res_two <- res_two / int64 2

// They should be the same number
// printfn "One: %d" res_one   
// printfn "Two: %d" res_two   

let semi_perimeter :int64 = int64 perimeter / int64 2

// For some reason I always miss by 1 (IDK why though lol)
res_one <- res_one + semi_perimeter + int64 1
printfn "Result is: %d" res_one 