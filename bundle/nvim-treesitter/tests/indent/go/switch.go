// issue #2166
package main

import (
	"fmt"
)

func test(ch byte) {
	fmt.Println("hey!")
	switch ch {
	case 'l':
		return
	}
}
