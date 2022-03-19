<?php

class Baz2 {
	/**
	 * return_self
	 *
	 * @return self
	 */
	public function return_self() {

	}
	/**
	 * return_static
	 *
	 * @return static
	 */
	public function return_static() {

	}

	/**
	 * return_this
	 *
	 * @return $this
	 */
	public function return_this() {

	}
}

$b2 = new Baz2;
$b2->return_self()->
$b2->return_this()->
$b2->return_static()->
