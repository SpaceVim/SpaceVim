<?php
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

Foo::baz();

$f2 = new \NS2\Foo2;
$f2->returnBaz2()->returnFoo2();

?>


