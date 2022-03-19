<?php

/**
 * Foo
 *
 * @property DateTime $commented_from_docblock
 */
class Foo {

    /**
     * @var Foo
     */
    public $commented_property;

    /**
     * @return string description of return
     */
    public function commented_method($foo, $bar, $baz = '') {
    }
}
