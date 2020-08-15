<?php
class Room {
	public $monsters = array();
	public $inanimates = array();
	public $features = array();
	public $discovered;
	public $isWarp;
	public $isSinkhole;
	
	function __construct () {
		$discovered = false;
	}
}

class MacGuffin {
	public $type;

	function __construct($type) {
		$this->type = $type;
	}
}