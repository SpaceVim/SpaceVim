package main

import (
	"fmt"
	"net"
	"os"
	"strconv"
	"syscall"
)

var str string

func main() {
	fmt.Println(os.Args[0])
	fmt.Println(net.InterfaceAddrs())

	fmt.Println(strconv.FormatInt(int64(syscall.Getuid()), 10))
}
