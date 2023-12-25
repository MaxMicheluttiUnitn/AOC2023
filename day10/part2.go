package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"strings"
	"time"
)

const interactive = true
const graphic_updates_every = 5
const refresh_rate = 100

var contatore int = 0

type Coords struct {
	row    int
	column int
}

func build_coords(r, c int) Coords {
	return Coords{r, c}
}

func coords_from(c Coords) Coords {
	return Coords{c.row, c.column}
}

func move_once(lines *[]string, in, from Coords) Coords {
	switch next_step(lines, in.row, in.column, from.row, from.column) {
	case 1: // N
		// fmt.Println("North")
		return Coords{in.row - 1, in.column}
	case 2: //S
		// fmt.Println("South")
		return Coords{in.row + 1, in.column}
	case 3: // W
		// fmt.Println("West")
		return Coords{in.row, in.column - 1}
	case 4: // E
		// fmt.Println("East")
		return Coords{in.row, in.column + 1}
	default:
		// fmt.Println("And it was in this moment that he knew, he fd up")
		return Coords{-1, -1}
	}
}

func move_once_and_update_path(mapping *[]int, lines *[]string, in, from Coords) Coords {
	//for i := 3 * in.row; i < 3*in.row+3; i++ {
	//for j := 3 * in.column; j < 3*in.column+3; j++ {
	var wall_value int = 35

	switch (*lines)[in.row][in.column] {
	case 45: // -
		for j := 3 * in.column; j < 3*in.column+3; j++ {
			(*mapping)[(3*in.row+1)*3*len((*lines)[0])+j] = wall_value
		}
	case 46: // .
		(*mapping)[0] = 0
	case 55: // 7
		(*mapping)[(3*in.row+1)*3*len((*lines)[0])+3*in.column+1] = wall_value
		(*mapping)[(3*in.row+1)*3*len((*lines)[0])+3*in.column] = wall_value
		(*mapping)[(3*in.row+2)*3*len((*lines)[0])+3*in.column+1] = wall_value
	case 70: // F
		(*mapping)[(3*in.row+1)*3*len((*lines)[0])+3*in.column+1] = wall_value
		(*mapping)[(3*in.row+2)*3*len((*lines)[0])+3*in.column+1] = wall_value
		(*mapping)[(3*in.row+1)*3*len((*lines)[0])+3*in.column+2] = wall_value
	case 74: // J
		(*mapping)[(3*in.row+1)*3*len((*lines)[0])+3*in.column+1] = wall_value
		(*mapping)[(3*in.row+1)*3*len((*lines)[0])+3*in.column] = wall_value
		(*mapping)[3*in.row*3*len((*lines)[0])+3*in.column+1] = wall_value
	case 76: // L
		(*mapping)[(3*in.row+1)*3*len((*lines)[0])+3*in.column+1] = wall_value
		(*mapping)[(3*in.row+1)*3*len((*lines)[0])+3*in.column+2] = wall_value
		(*mapping)[3*in.row*3*len((*lines)[0])+3*in.column+1] = wall_value
	case 83: // S
		(*mapping)[0] = 0
	case 124: // |
		for i := 3 * in.row; i < 3*in.row+3; i++ {
			(*mapping)[i*3*len((*lines)[0])+3*in.column+1] = wall_value
		}
	default:
		fmt.Println("Not good")
	}
	switch next_step(lines, in.row, in.column, from.row, from.column) {
	case 1: // N
		// fmt.Println("North")
		return Coords{in.row - 1, in.column}
	case 2: //S
		// fmt.Println("South")
		return Coords{in.row + 1, in.column}
	case 3: // W
		// fmt.Println("West")
		return Coords{in.row, in.column - 1}
	case 4: // E
		// fmt.Println("East")
		return Coords{in.row, in.column + 1}
	default:
		// fmt.Println("And it was in this moment that he knew, he fd up")
		return Coords{-1, -1}
	}
}

/*
	'7' = 55
	'-' = 45
	'|' = 124
	'F' = 70
	'J' = 74
	'L' = 76
	'S' = 83
	'.' = 46
*/
/*
	Error = 0
	N = 1
	S = 2
	W = 3
	E = 4
*/
func next_step(lines *[]string, row, column, last_row, last_column int) int {
	switch (*lines)[row][column] {
	case 45: // -
		// If I came from West
		if last_column == column-1 {
			return 4 // East
		} else {
			return 3 // West
		}
	case 46: // .
		return 0 // Error
	case 55: // 7
		// If I came from South
		if last_row == row+1 {
			return 3 // West
		} else {
			return 2 // South
		}
	case 70: // F
		// If I came from South
		if last_row == row+1 {
			return 4 // East
		} else {
			return 2 // South
		}
	case 74: // J
		// If I came from West
		if last_column == column-1 {
			return 1 // North
		} else {
			return 3 // West
		}
	case 76: // L
		// If I came from East
		if last_column == column+1 {
			return 1 // North
		} else {
			return 4 // East
		}
	case 83: // S
		// check North
		if row-1 >= 0 && (((*lines)[row-1][column] == 55) || ((*lines)[row-1][column] == 70) || ((*lines)[row-1][column] == 124)) {
			return 1
		}
		// check South
		if row+1 < len((*lines)[0]) && (((*lines)[row+1][column] == 74) || ((*lines)[row+1][column] == 76) || ((*lines)[row+1][column] == 124)) {
			return 2
		}
		// check West
		if column-1 >= 0 && (((*lines)[row][column-1] == 70) || ((*lines)[row][column-1] == 76) || ((*lines)[row][column-1] == 45)) {
			return 3
		}
		// check East
		if column+1 < len((*lines)[0]) && (((*lines)[row][column+1] == 55) || ((*lines)[row][column+1] == 74) || ((*lines)[row][column+1] == 45)) {
			return 4
		}
		return 0
	case 124: // |
		// If I came from South
		if last_row == row+1 {
			return 1 // North
		} else {
			return 2 // South
		}
	default:
		return 0
	}
}

func check(err error) {
	if err != nil {
		panic(err)
	}
}

func depth_first_update(mapping *[]int, height, width int, coords Coords) {
	if coords.row < 0 || coords.row >= height || coords.column < 0 || coords.column >= width {
		return
	}
	if (*mapping)[coords.row*width+coords.column] == 32 {
		if interactive && contatore%graphic_updates_every == 0 {
			for i := 0; i < width; i++ {
				fmt.Print("\033[1A\x1b[2K")
			}
			for i := 0; i < height; i++ {
				for j := 0; j < width; j++ {
					fmt.Print(string((*mapping)[i*width+j]))
				}
				fmt.Print("\n")
			}
			time.Sleep(refresh_rate * time.Millisecond)
		}
		contatore = contatore + 1
		(*mapping)[coords.row*width+coords.column] = 40
		var north = Coords{coords.row - 1, coords.column}
		var south = Coords{coords.row + 1, coords.column}
		var east = Coords{coords.row, coords.column + 1}
		var west = Coords{coords.row, coords.column - 1}
		depth_first_update(mapping, height, width, north)
		depth_first_update(mapping, height, width, south)
		depth_first_update(mapping, height, width, east)
		depth_first_update(mapping, height, width, west)
	}
}

func count_zeros(mapping *[]int, height, width int) int {
	var res int = 0
	for i := 1; i < 3*height; i += 3 {
		for j := 1; j < 3*width; j += 3 {
			if (*mapping)[i*3*width+j] == 32 {
				res += 1
			}
		}
	}
	return res

}

func main() {
	fmt.Println("Part 2")
	content, err := ioutil.ReadFile("example2.txt")

	if err != nil {
		log.Fatal(err)
	}

	var lines []string = strings.Split(string(content), "\n")

	var start Coords = Coords{-1, -1}

	for row := 0; row < len(lines); row++ {
		for column := 0; column < len(lines[0]); column++ {
			if lines[row][column] == 83 {
				start.row = row
				start.column = column
			}
		}
	}

	var current = move_once(&lines, start, Coords{-1, -1})

	var first = coords_from(current)

	var last = coords_from(start)

	var path_mapping = make([]int, len(lines)*9*len(lines[0]))

	for i := 0; i < len(lines)*3; i++ {
		for j := 0; j < len(lines[0])*3; j++ {
			path_mapping[i*3*len(lines[0])+j] = 32
		}
	}

	for (start.row != current.row) || (start.column != current.column) {
		//fmt.Println(lines[current.row][current.column])
		var next Coords = move_once_and_update_path(&path_mapping, &lines, current, last)
		last = coords_from(current)
		current = coords_from(next)
	}

	var first_direction int = 0
	var last_direction int = 0
	if first.row == start.row+1 {
		first_direction = 2 // South
	} else if first.row == start.row-1 {
		first_direction = 1 // North
	} else if first.column == start.column+1 {
		first_direction = 4 // East
	} else if first.column == start.column-1 {
		first_direction = 3 // West
	} else {
		fmt.Println("soemthing ids erong with first movement")
	}

	if last.row == start.row+1 {
		last_direction = 2 // South
	} else if last.row == start.row-1 {
		last_direction = 1 // North
	} else if last.column == start.column+1 {
		last_direction = 4 // East
	} else if last.column == start.column-1 {
		last_direction = 3 // West
	} else {
		fmt.Println("soemthing ids erong with first movement")
	}

	var wall_value = 35

	// S is |
	if ((first_direction == 1) && (last_direction == 2)) || ((first_direction == 2) && (last_direction == 1)) {
		for i := 3 * start.row; i < 3*start.row+3; i++ {
			path_mapping[i*3*len(lines[0])+3*start.column+1] = wall_value
		}
	}
	// S is -
	if ((first_direction == 3) && (last_direction == 4)) || ((first_direction == 4) && (last_direction == 3)) {
		for j := 3 * start.column; j < 3*start.column+3; j++ {
			path_mapping[(3*start.row+1)*3*len(lines[0])+j] = wall_value
		}
	}
	// S is L
	if ((first_direction == 1) && (last_direction == 4)) || ((first_direction == 4) && (last_direction == 1)) {
		path_mapping[(3*start.row+1)*3*len(lines[0])+3*start.column+1] = wall_value
		path_mapping[(3*start.row+1)*3*len(lines[0])+3*start.column+2] = wall_value
		path_mapping[3*start.row*3*len(lines[0])+3*start.column+1] = wall_value
	}
	// S is 7
	if ((first_direction == 2) && (last_direction == 3)) || ((first_direction == 3) && (last_direction == 2)) {
		path_mapping[(3*start.row+1)*3*len(lines[0])+3*start.column+1] = wall_value
		path_mapping[(3*start.row+1)*3*len(lines[0])+3*start.column] = wall_value
		path_mapping[(3*start.row+2)*3*len(lines[0])+3*start.column+1] = wall_value
	}
	// S is F
	if ((first_direction == 2) && (last_direction == 4)) || ((first_direction == 4) && (last_direction == 2)) {
		path_mapping[(3*start.row+1)*3*len(lines[0])+3*start.column+1] = wall_value
		path_mapping[(3*start.row+2)*3*len(lines[0])+3*start.column+1] = wall_value
		path_mapping[(3*start.row+1)*3*len(lines[0])+3*start.column+2] = wall_value
	}
	// S is J
	if ((first_direction == 1) && (last_direction == 3)) || ((first_direction == 3) && (last_direction == 1)) {
		path_mapping[(3*start.row+1)*3*len(lines[0])+3*start.column+1] = wall_value
		path_mapping[(3*start.row+1)*3*len(lines[0])+3*start.column] = wall_value
		path_mapping[3*start.row*3*len(lines[0])+3*start.column+1] = wall_value
	}

	if interactive {
		for i := 0; i < len(lines)*3; i++ {
			for j := 0; j < len(lines[0])*3; j++ {
				fmt.Print(string(path_mapping[i*3*len(lines[0])+j]))
			}
			fmt.Print("\n")
		}
	}

	depth_first_update(&path_mapping, 3*len(lines), 3*len(lines[0]), Coords{0, 0})

	if interactive {
		for i := 0; i < len(lines)*3; i++ {
			fmt.Print("\033[1A\x1b[2K")
		}

		for i := 0; i < len(lines)*3; i++ {
			for j := 0; j < len(lines[0])*3; j++ {
				fmt.Print(string(path_mapping[i*3*len(lines[0])+j]))
			}
			fmt.Print("\n")
		}
	}

	fmt.Println(count_zeros(&path_mapping, len(lines), len(lines[0])))
}
