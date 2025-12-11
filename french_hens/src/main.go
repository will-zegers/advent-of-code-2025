package main

import (
	"bufio"
	"fmt"
	"os"
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
		line := scanner.Bytes()
		result := compute_maximum_joltage(line)
		max_joltage += result
	}

	fmt.Println(max_joltage)
}

func compute_maximum_joltage(content []byte) int {
	joltages := []JoltagePair{JoltagePair{0, 0}}

	for i := 0; i < len(content); i++ {
		tens := joltages[i].tens
		ones := joltages[i].ones
		next := int(content[i] - '0')

		var next_pair JoltagePair
		if combined_value(ones, next) > combined_value(tens, ones) {
			next_pair = JoltagePair{ones, next}
		} else if combined_value(tens, next) > combined_value(tens, ones) {
			next_pair = JoltagePair{tens, next}
		} else {
			next_pair = joltages[i]
		}

		joltages = append(joltages, next_pair)
	}

	return joltages[len(joltages)-1].Value()
}

func combined_value(tens int, ones int) int {
	return (tens-'0')*10 + ones - '0'
}
