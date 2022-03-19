<?php
namespace Foo;
use Foo\FooClass as F;

class FooClass {
    public function findme() {
    }
}

/**
 * make_a_foo
 *
 * @return FooClass
 */
function make_a_foo(){
    return new FooClass;
}

/**
 * make_a_renamed_foo
 *
 * @return F
 */
function make_a_renamed_foo(){
    return new F;
}

$foo = make_a_foo();
$foo->

$foo2 = make_a_renamed_foo();
$foo2->

$foo3 = no_ns_make_a_foo();
$foo3->

;
simplexml_load_string()->

;
make_a_foo()->

;
make_a_renamed_foo()->

;
no_ns_make_a_foo()->

