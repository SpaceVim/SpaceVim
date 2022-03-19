<?php
/* @var $bar FooClass */
$bar->

// @var $bar2 FooClass
$bar2->

// @var $bar3 Renamed
$bar3->

$foo_conflicting_sources = Baz::getInstance();
// @var $foo_conflicting_sources Foo
$foo_conflicting_sources->

;

// @var $foo2 Foo2
$foo2 = unknown();
$foo2->
;

function baz() {
	// @var $foo3 Foo3
	$foo3 = $unknown_assignment['foo3'];
	$foo3->
}

$foo2-> // should find the @var on line 17
;

/* @var FooClass2 $baz */
$baz->

/** @var FooClass2 $baz2 */
$baz2->

// @var FooClass2 $baz3
$baz3->
