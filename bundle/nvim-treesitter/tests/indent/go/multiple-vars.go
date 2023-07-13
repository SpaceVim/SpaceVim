package main

var (
	thing    = 1
	thingTwo = 2
) // <-- This paren should be at 0 instead of indented

var (
	thing    = 1
	thingTwo = 2
)

func main() {
	// It should be
	var (
		thing    = 1
		thingTwo = 2
	)
}
