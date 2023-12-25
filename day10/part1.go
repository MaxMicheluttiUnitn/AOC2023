package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"strings"
)

type Coords struct {
	x int
	y int
}

func buildCoords(x, y int) Coords {
	return Coords{x, y}
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
		if row+1 < len(*lines) && (((*lines)[row+1][column] == 74) || ((*lines)[row+1][column] == 76) || ((*lines)[row+1][column] == 124)) {
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

func main() {
	fmt.Println("Part 1")
	content, err := ioutil.ReadFile("problem.txt")

	if err != nil {
		log.Fatal(err)
	}

	var lines []string = strings.Split(string(content), "\n")

	var start_row int = 0
	var start_column int = 0

	for row := 0; row < len(lines); row++ {
		for column := 0; column < len(lines[0]); column++ {
			if lines[row][column] == 83 {
				start_row = row
				start_column = column
			}
		}
	}

	var last_row int = -1
	var last_column int = -1
	var current_row int = start_row
	var current_column int = start_column

	switch next_step(&lines, current_row, current_column, last_row, last_column) {
	case 1: // N
		// fmt.Println("North")
		current_row -= 1
	case 2: //S
		// fmt.Println("South")
		current_row += 1
	case 3: // W
		// fmt.Println("West")
		current_column -= 1
	case 4: // E
		// fmt.Println("East")
		current_column += 1
	default:
		fmt.Println("And it was in this moment that he knew, he fd up")
	}
	last_row = start_row
	last_column = start_column

	var path_length int = 0

	for (start_row != current_row) || (start_column != current_column) {

		// fmt.Println(lines[current_row][current_column])
		switch next_step(&lines, current_row, current_column, last_row, last_column) {
		case 1: // N
			// fmt.Println("North")
			last_row = current_row
			last_column = current_column
			current_row -= 1
		case 2: //S
			// fmt.Println("South")
			last_row = current_row
			last_column = current_column
			current_row += 1
		case 3: // W
			// fmt.Println("West")
			last_row = current_row
			last_column = current_column
			current_column -= 1
		case 4: // E
			// fmt.Println("East")
			last_row = current_row
			last_column = current_column
			current_column += 1
		default:
			fmt.Println("And it was in this moment that he knew, he fd up")
		}
		path_length += 1
	}
	path_length += 1
	fmt.Println(path_length / 2)
}
