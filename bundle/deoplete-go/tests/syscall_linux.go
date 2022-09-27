// Copyright 2016 Koichi Shiraishi. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// +build linux

package main

import (
	"golang.org/x/sys/unix"
)

func main() {
	unix.TCGETS
}
