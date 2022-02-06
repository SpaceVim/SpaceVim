<?php

class Baz3 {
	/**
	 * return_self_array
	 *
	 * @return self[]
	 */
	public function return_self_array() {

	}
	/**
	 * return_static_array
	 *
	 * @return static[]
	 */
	public function return_static_array() {

	}

	/**
	 * return_this_array
	 *
	 * @return $this[]
	 */
	public function return_this_array() {

	}
}

$b3 = new Baz3;
$selfs = $b3->return_self_array();
$thises = $b3->return_this_array();
$statics = $b3->return_static_array();


foreach ($selfs as $self) {
	$self->
}

foreach ($thises as $that) {
	$that->
}

foreach ($statics as $static) {
	$static->
}
