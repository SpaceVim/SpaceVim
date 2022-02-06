<?php

class Bar {

    /**
     * foo
     *
     * @var Foo
     * @access public
     */
    var $foo;

    /**
     * return_foo
     *
     *
     * @return Foo
     */
    public function return_foo() {
    }
}

class Foo {
    /**
     * bar
     *
     * @var Bar
     */
    public $bar;

    /**
     * bar
     *
     * @var Bar
     */
    private $bar2;

    /**
     * bar
     *
     * @var Bar
     */
    protected $bar3;

    /**
     * @var Bar
     */
    protected static $static_bar;

    /**
     * @var Bar
     */
    static public $static_bar2;

    /**
     * return_bar
     *
     * @return Bar
     */
    public function return_bar() {
    }
}

// not intended to recite every way that is not $this-> or (new Foo)->
// just some example of that path

$foo = new Foo;
$foo->return_bar()->return_foo()->return_bar()->

// @var $foo Foo
$foo->return_bar()->return_foo()->return_bar()->

function fun(Foo $foo) {
    $foo->return_bar()->return_foo()->return_bar()->
}

$foo->bar->
$foo->bar2->
$foo->bar3->
$foo->bar3->foo->



// ----

$doc = new DOMDocument;
$doc->createAttribute()->ownerElement->

$d = new DateTime;
$d->add()->getTimezone()->

// ----
$tz = DateTime::createFromFormat()->getTimezone();
$tz->

// ---
$foobar = Foo::$static_bar2->return_foo();
$foobar->


// ----

$foo2 = new Foo;
$bar2 = $foo2->return_bar();
$bar2->

$foo3 = new Foo;
$bar3 = $foo3->return_bar();
$bar3->return_foo()->

// --

class SimilarNames {
	/**
	 * return_self
	 *
	 * @return self
	 */
	public function return_self() {
	}
	/**
	 * return_
	 *
	 * @return Foo
	 */
	public function return_() {

	}
}

$foo3 = new SimilarNames;
$foo3->return_self()->return_()->

// ----

/**
 * CommentedFoo
 *
 * @property DateTime $docBlockProperty
 */
class CommentedFoo {

}
$commentedFoo = new CommentedFoo;
$commentedFoo->docBlockProperty->
