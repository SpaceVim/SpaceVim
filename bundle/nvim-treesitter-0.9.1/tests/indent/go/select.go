// issue #4248
package main

import (
	"context"
	"fmt"
)

func test(ch byte) {
	ctx := context.TODO()
	select {
	case <-ctx.Done():
		fmt.Println("indentation")
	default:
	}
}
