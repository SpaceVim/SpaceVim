<?php

class Foo
	public function returnBar($a, $b = 'foo') : Bar {
	}

	public function returnBar2($a, $b = 'foo') : Bar2
	{
	}
}

function returnFoo() : Foo {

}
