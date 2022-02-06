<?php

foo(); // line outside of a function

function foo() {
	$foo = 42;
	$bar; // line inside a function
}

$baz = new FooBar(); // line after a function but not inside one

class FooBar {

	public static function fun()
	{
		global $baz;
		$baz = 42; // line inside a method
	}
}

function comments_and_strings() {
	// {
	/*
	{
	*/
	$a = '{'."{";

	$baz3 = 42; // search here
}

function unfinished() {
	$baz2 = 42; // search here

