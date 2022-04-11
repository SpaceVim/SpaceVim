<?php

class Bar {
    /**
     * return_foo
     *
     *
     * @return Foo
     */
    public function return_foo() {
    }
}

class Foo {
    /**
     * return_bar
     *
     * @return Bar
     */
    public function return_bar() {
    }
}

(new Foo)->return_bar()->
