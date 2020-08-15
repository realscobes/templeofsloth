<?php
class Room {
	public $mapSymbol;
	public $monsters = array();
	public $pools = array();
	public $chests = array();
	public $merchants = array();
	public $discovered;
	public $isWarp;
	public $isSinkhole;
	public $isExit;
	public $stairs;
	public $isBottomFloor;
	
	function __construct () {
		$this->discovered = false;
		$this->mapSymbol = '.';
	}

	function getStuffList () {
		foreach ($this->monsters as $monster) {
			$str .= $monster->name.'<br>';
		}

		foreach ($this->pools as $pool) {
			$str .= $pool->type.' <br>';
		}

		foreach ($this->chests as $chest) {
			$str .= "Chest <br>";
		}

		foreach ($this->merchants as $merchant) {
			$str .= "Merchant <br>";
		}

		if ($this->isExit) {
			$str .= "The dungeon exit to the north. <br>";
		}

		if ($this->stairs) {
			$str .= "Stairs going $this->stairs.<br>";
		}

		if (!$str)
			$str = "Nothing.<br>";

		return $str;
	}
}

class Pool {
	public $type;
	public $attribute;
	public $effect;

	function __construct($pool) {
		foreach ($pool as $key => $value) {
			$this->$key = $value;
		}
		//$this->type = $pool['type'];
		//$this->attribute = $pool['attribute'];
		//$this->effect = $pool['effect'];
	}
}

class Chest {
	public $contents = array();
}

class MacGuffin {
	public $type;

	function __construct($type) {
		$this->type = $type;
	}
}