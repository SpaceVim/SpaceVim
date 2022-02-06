<?php

class Foo {

    public function bar() {
		// search from here
    }
}

// leading whitespace intentional
 final class Foo2 {

    function bar2() {
		// search from here
    }
 }

// no whitespace before {
class Foo3{
    function bar2() {
		// search from here
    }
 }
