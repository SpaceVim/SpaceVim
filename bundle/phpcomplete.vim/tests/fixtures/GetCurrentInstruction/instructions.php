<?php

use Foo1 // cursor just before the comment
;

use Foo2,
    Bar // cursor just before the comment
;

use Foo3,
    // Bar
    Baz // cursor just before the comment
;

$a = new

    Foo // cursor just before the comment
;

$foo()->bar(
    /* ; */
    array(';')
)-> // cursor just before the comment


;


$some->foo = $some_long_variable
->love()
->me()
->love()
->me()
->say()
->that()
->you()
->love // cursor just before comment

class Foo {
    public function bar()
    {
        $this->foo-> // cursor before the comment
    }
}

if (true) {
}
$foo-> // cursor just before the comment
;



if( $date->format('N') > 5 ) $date-> // cursor before the comment
;
while ($date->format('N') > 5) $date-> // cursor before the comment
;
foreach ($date->format('N') > 5) $date-> // cursor before the comment
;
for ($i = 0; $i < 10; ++$i) $date-> // cursor before the comment
;



$foo = $bar->baz($f, $bar2-> // cursor before the comment
$foo = $bar->baz($foo = call(), (new foo)->  // cursor before the comment
;

!$foo-> // cursor here
;
@$foo-> // cursor here
;
$foo + $foo-> // cursor here
;
$foo * $foo-> // cursor here
;
$foo = $foo ? $bar : $baz-> //cursor here
;
$foo > $foo-> // cursor here
;
$foo or $foo-> // cursor here
;
$foo and $foo-> // cursor here
;
$foo[$bar]-> // cursor here
;
$foo[$bar-> // cursor here
;
DateTime::createFromFormat()-> // cursor here
;

throw $foo-> // cursor here
;
return $foo-> // cursor here
;

class Foo extends Bar implements ArrayAccess, It
