<?php
/*
 * testcase for when the class definition is not on the start of the line
 * related to issue #19
 */

    ABSTRACT	class	FooAbstract
    {
        public function foo() {
            $this->
            ;
            self::
        }
    }
