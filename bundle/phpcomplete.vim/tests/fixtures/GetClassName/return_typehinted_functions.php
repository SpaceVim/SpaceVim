<?php

class Bar {
	public function findMe() { }
}

class Bar2 {
	public function findMe() { }
}

class FooReturnBars {
	public function returnBar($a, $b = 'foo') : Bar {
	}

	public function returnBar2($a, $b = 'foo') : Bar2
	{
	}
}

function returnFoo() : FooReturnBars {
}

$f = returnFoo();
$f->
;
$f->returnBar()->
;
$f->returnBar2()->
;
