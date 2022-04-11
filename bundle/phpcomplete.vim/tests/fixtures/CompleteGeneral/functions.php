<?php

class CommonFoo {
    public function common_public_method($foo) { }
    private function common_private_method($foo) { }
    protected function common_protected_method($foo) { }
    public static function common_public_static_method($foo) { }
    static public function common_static_public_method($foo) { }
    private static function common_private_static_method($foo) { }
    protected static function common_protected_static_method($foo) { }
}

trait CommonTrait {}

function common_plain_old_function(){}
function common_plain_old_function_with_arguments($a, $b=''){}
