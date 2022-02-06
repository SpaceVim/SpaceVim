<?php

/**
 * foo
 *
 * @param BarClass1 $bar1 bar
 *
 * @return void
 */
function foo1($bar1) {
    $bar1->
}

/**
 * foo
 * extra whitespaces are intentional between the block and the function
 *
 * @param BarClass2 $bar1
 * @param BarClass2 $bar2
 * @param BarClass2 $bar3
 *
 * @return void
 */


function foo2($bar1, $bar2, $bar3) {
    $bar2->
}

/**
 *
 * @param BarClass3 $bar3
 *
 * @return void
 */


$foo = function($bar3, \Some\Class $foo) {
    $bar3->
}


/**
 * baz3
 *
 * @param DateTime $docblocked
 */
function baz3(
	$docblocked,
	$multi,
	$line,
	$arguments
) {
	$docblocked->
}

