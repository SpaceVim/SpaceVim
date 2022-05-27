<?php

namespace BarNS\Things;

class Thing {

	public $publicThing;

	protected $protectedThing;

	private $privateThing;

	function getActualThing(){

	}
}

namespace FooNS\SomethingNS;

use BarNS\Things\Thing;

class Something {


	public $publicSomeThing;
	protected $protectedSomeThing;
	private $privateSomeThing;

	/**
	 * The current thing in something.
	 *
	 * @var BarNS\Things\Thing
	 */
	public $currentThing;

	/**
	 * Return a thing.
	 *
	 * @return Thing
	 */
	function getThing() {
	}

}

namespace FooNS\SubNameSpace;

use FooNS\Foo;

class FooExtension extends Foo {

	function bar() {
		$this->getSomething()->
	}

}

namespace FooNS;

use FooNS\SomethingNS\Something;
use BarNS\Things\Thing;

class Foo {

	/**
	 * Get something.
	 *
	 * @return Something
	 */
	function getSomething() {
	}

	/**
	 * Get thing.
	 *
	 * @return Thing
	 */
	function getThing() {
	}

	function barThis() {
	}

	function completeThisGetSomething() {
		$this->getSomething()->
	}

	function completeThis() {
		$this->
	}

}



