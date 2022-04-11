<?php

class Foo3 {
	public function &return_foo_ref_method() {
	}
}

/**
 * return_foo_ref
 *
 * @return Foo3
 */
function &return_foo_ref(){
}

return_foo_ref()->return_foo_ref_method();
