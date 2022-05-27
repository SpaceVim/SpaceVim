<?php

class Foo {
    /**
     * findme
     *
     * @param Foo[] $a a
     *
     * @return Foo[]
     */
    public function findme($a) {
        $a[42]->
    }

    /**
     * fooarray
     *
     * @var Foo[]
     */
    public $fooarray;
}

// @var $foo Foo[]
$foo[0]->
;

$foo2 = new Foo;
$foo2->fooarray[42]->
;

$foo3 = new Foo;
$foo4 = $foo2->fooarray[42]->findme();
$foo4[42]->
;

// @var $foo5 Foo[]
foreach ($foo5 as $f) {
    $f->
}

// @var $foo6 Foo[]
foreach ($foo6 as $i => $f) {
    $f->
}

// @var $foo7 Foo[]
foreach ($foo7[0]->fooarray as $i => $f) {
    $f->
}

// @var $foo7 Foo[]
foreach ($foo7[0]->fooarray[42]->findme() as $i => $f) {
    $f->
}
