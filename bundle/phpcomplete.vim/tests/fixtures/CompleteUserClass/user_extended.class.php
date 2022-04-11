<?php

class UserClass {

    const A_CONST = 'foo';

    var $public_property1;
    public $public_property2;
    protected $protected_property;
    private $private_property;

    public static $public_static_property;
    protected static $protected_static_property;
    private static $private_static_property;

    public function __construct() {
    }

    public function public_method($foo) {
    }

    public function &public_method_with_amp($foo)
    {

    }

    public final function public_final_method($foo, $anotherfoo = '')
    {

    }

    private function private_method($foo) {
    }

    final private function final_private_method($foo = null)
    {

    }

    protected function protected_method($foo) {
    }

    public static function public_static_method($foo) {
    }

    static public function static_public_method($foo) {
    }

    public final static function public_final_static_method( $foo, $anotherfoo = array() )
    {

    }

    final static public function final_static_public_method()
    {

    }

    private static function private_static_method($foo) {
    }

    protected static function protected_static_method($foo) {
    }

    static final protected function static_final_protected_method()
    {

    }

    function naked_public_method(){
    }
}

