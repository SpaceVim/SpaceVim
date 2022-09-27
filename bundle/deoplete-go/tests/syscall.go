// Copyright 2016 Koichi Shiraishi. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package main

import (
	"syscall"

	"golang.org/x/sys/unix"
)

func main() {
	syscall.TIOCGETA
	unix.TIOCGE
}
