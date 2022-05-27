<?php
class Model {
	/**
	 * getResult
	 *
	 * @return Model[]
	 */
	public function getResult() {
	}
}
$someModel = new Model();
$results = $someModel->getResult(1);

foreach( $results as $result ) {
    $foo = $result->
