<?php

trait FooTrait { }

class SomeTraitedClass {
	use FooTrait;
}

class ExtendsNonExistsing extends NoSuchClass {

}

