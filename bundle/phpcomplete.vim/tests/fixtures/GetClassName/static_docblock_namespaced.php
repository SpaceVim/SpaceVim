<?php
namespace Foo;
use Foo\Page as P;
use Foo as RenamedFoo;

class Page {
    /**
     * @return Page
     */
    public static function getPage(){
    }
    /**
     * @return \Foo\Page
     */
    public static function getPage2(){
    }

    /**
     * @return P
     */
    public static function getRenamedPage(){
    }

    /**
     * @return RenamedFoo\Page
     */
    public static function getRenamedPage2(){
    }
}

$p = Page::getPage();
$p->

$p = \Foo\Page::getPage();
$p->

$p = P::getPage();
$p->

$p = RenamedFoo\Page::getPage();
$p->

$p = Page::getPage2();
$p->

$p = Page::getRenamedPage();
$p->

$p = Page::getRenamedPage2();
$p->
