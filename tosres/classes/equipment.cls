<?php

class Weapon {
	public $name = "Sword";
	public $damage;
	public $value;
	
	function __construct ($dam, $val) {
		$this->damage = $dam;
		$this->value = $val;
	}
}

class Armour {
	public $name = "Armour";
	public $defence;
	public $value;
	
	function __construct ($def, $val) {
		$this->defence = $def;
		$this->value = $val;
	}
}