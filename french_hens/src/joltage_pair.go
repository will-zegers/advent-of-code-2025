package main

import (
	"fmt"
)

type JoltagePair struct {
	tens int
	ones int
}

func (pair JoltagePair) Value() int {
	return 10*pair.tens + pair.ones
}

func SayHello() {
	fmt.Println("Hello!")
}
