<?php
class Room {
	public $monsters = array();
	public $inanimates = array();
	public $features = array();
	public $discovered;
	
	function __construct () {
		$discovered = false;
	}
}