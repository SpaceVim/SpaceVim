<?php
namespace NS1;
use NS2\Foo2 as RenamedFoo2;

class Foo {

	public function baz() {

	}
}

/**
 * get_foo
 *
 * @access public
 * @return Foo
 */
function get_foo() {
}

get_foo()->baz();

$f2 = new \NS2\Foo2;
$f2->returnBaz2()->returnFoo2();


$f3 = new RenamedFoo2;
$f3->returnBaz2();
