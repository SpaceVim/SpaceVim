<?php

/**
 * Foo
 *
 * @property DateTime $baz
 */
class Foo {

    /**
     *  FOO constant description
     */
    const FOO_CONST = 42;

    /**
     * @var Foo
     */
    public $foo;

    /**
     * @type Bar
     */
    public $bar;

    /**
     * description, here i come
     *
     * @var string
     */
    var $foo2 = '';

    public $nocomment;
    public static $nocomment2;

    /**
     * Short description
     *
     * @param mixed $foo
     * @param mixed $bar bar
     * @param string $baz baz some description of this baz
     * @return string description of return
     * @throws Foo
     * @exception Foo some description
     * @throws Foo
     */
    public function commentedfoo($foo, $bar, $baz = '') {
    }


    public function not_commented() {
    }

    /**
     * minimally_commented
     */
    public function minimally_commented() {
    }

    /** @var Bar */
    public $onliner;
}
