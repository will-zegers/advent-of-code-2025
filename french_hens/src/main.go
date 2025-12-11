package main

import (
	"bufio"
	"fmt"
	"os"
	"slices"
)

func main() {
	input, err := os.Open("input.txt")
	if err != nil {
		fmt.Printf("Error reading file %v\n", err)
		return
	}
	defer input.Close()

	scanner := bufio.NewScanner(input)
	max_joltage := 0
	for scanner.Scan() {
		var content []int
		line := scanner.Bytes()
		for _, elem := range line {
			content = append(content, int(elem-'0'))
		}

		result := compute_maximum_joltage(content, 12)
		max_joltage += result
	}

	fmt.Println(max_joltage)
}

func compute_maximum_joltage(content []int, n int) int {
	// Create a slice of candidate banks, consisting of the first 'n'
	// of the input
	var banks []int
	for i := range n {
		banks = append(banks, content[i])
	}

	/* Look through the remaining banks in our input and, as we add new
	ones to the end, we pop off the first number that is lower than
	its next neighor.

	e.g. If n = 3, our current banks are 423, and the next number is
	7, we first pop out the '2' so our new higher number is 437
	*/
	for i := n; i < len(content); i++ {
		for j := range n - 1 {
			if banks[j] < banks[j+1] {
				banks = slices.Delete(banks, j, j+1)
				banks = append(banks, content[i])
				break // We've found a spot for our new number, so move onto the next
			}
		}

		// If we make it to this point, then no changes were made to the
		// list of candidate banks. Instead now just see if we need to swap
		// out a new higher number for the one at the end of the list
		if banks[len(banks)-1] < content[i] {
			banks[len(banks)-1] = content[i]
		}
	}
	return accumulate_joltages(banks)
}

// Helper function to put the slice of bank joltages into an int
// of their correct decimal notation
func accumulate_joltages(banks []int) int {
	accum := 0
	for _, joltage := range banks {
		accum = accum*10 + joltage
	}

	return accum
}
