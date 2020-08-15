<?php
class World {
	public $map = array();
	public $roomlist = array();
	public $player;
	public $inanimates = array();
	public $monsters = array();
	
	//generate 3d array made up of rooms, as well as sequential list
	function __construct($mapX, $mapY, $mapZ, $thingDensity) {
		//floors
		for ($z = 0; $z < $mapZ; $z++) {
			//columns
			for ($y = 0; $y < $mapY; $y++) {
				//rows
				for ($x = 0; $x < $mapX; $x++){
					$this->map[$z][$x][$y] = new Room;
					$this->roomlist[] = array(
						'z' => $z,
						'x' => $x,
						'y' => $y
						);
				}
			}
			
		}
		
		unset ($this->roomlist[3]); // remove start location from list
		shuffle($this->roomlist); // randomise room list
		reset($this->roomlist);
		
		// get thing lists
		$this->inanimates = parse_ini_file(TOSRES.'data/inanimates.ini', true);
		$this->monsters = parse_ini_file(TOSRES.'data/monsters.ini', true);
		
		// add monsters
		$monstnum = (int) count($this->roomlist) * $thingDensity['monsters'];
		for ($i = 0; $i < $monstnum; $i++) {
			$room = $this->getNextRoom(); 
			$this->addRThing($room, 'monsters'); 
		} 

		// add pools

		// add chests

		// add sinkholes

		// add merchants

		// add warps
		$warpnum = (int) count($this->roomlist) * $thingDensity['warps'];
		for ($i = 0; $i < $warpnum; $i++) {
			$room = $this->getNextRoom(); 
			$room->isWarp = true; 
		}

		// add orb
		$this->getNextRoom()->inanimates[] = new MacGuffin ('Orb');

		// add staff
		$this->getNextRoom()->inanimates[] = new MacGuffin ('Staff');

		// add player
		$this->player = new Player();
	}
	
	//add a random thing to a room from a collection list
	function addRThing ($room, $coll, $type = NULL) {
		$objList = $this->$coll;
		if ($type) {
			// if type is specified remove others
			foreach ($objList as $key => $value) {
				if (!in_array($type, $objList[$key], true))
					unset($objList[$key]);
			}
		}
	
		// pick something at random from the list
		$nObj = $objList[array_rand($objList)];
	
		// dump it in the room
		$room->$coll[] = new $nObj['type']($nObj);
	}

	//return the next room from the list
	function getNextRoom () {
		$rc = current($this->roomlist);
		$room = $this->map[$rc['z']][$rc['x']][$rc['y']];
		next($this->roomlist);
		return $room;
	}

	
	
}