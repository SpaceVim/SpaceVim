// https://github.com/nvim-treesitter/nvim-treesitter/issues/2369
package main

import "fmt"

func goodIndent(param string) {
	fmt.Println("typing o here works as expected")
}

func badIndent(
	param string, // this is the difference
) {
	fmt.Println("typing o here triggers bad indent")
	foo(bar,
		baz,
		call,
		stop,
		please)
}
