<?php
/*
 * testcase for when the class keyword is not on the start of the line
 * related to issue #19
 */
    clASs		    FooClass
    {

        public function bar() {
            $this->
            self::
        }
    }

