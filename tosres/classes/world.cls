<?php
class World {
	public $map = array();
	public $roomList = array();
	public $orbLocation = array();
	public $staffLocation = array();
	public $player;
	public $inanimates = array();
	public $monsters = array();
	
	//generate 3d array made up of rooms, as well as sequential list
	function __construct() {
		//floors
		for ($z = 0; $z < MAPFLR; $z++) {
			//columns
			for ($y = 0; $y < MAPY; $y++) {
				//rows
				for ($x = 0; $x < MAPX; $x++){
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
		
		// get thing lists
		$this->inanimates = parse_ini_file('./inanimates.ini', true);
		$this->monsters = parse_ini_file('./monsters.ini', true);
		//var_dump($this->monsters);
		// FIX: having basically the same code three times is redundant, replace with a 'populate' function
		
		// add monsters
		$monstnum = (int) count($this->roomlist) * MONSTPERCENT;
		for ($i = 0; $i < $monstnum; $i++) {
			$rc = $this->roomlist[$i];
			$room = $this->map[$rc['z']][$rc['x']][$rc['y']];
			$this->addRThing($room, 'monsters');
			//$room->monsters[] = new Monster();
		} 
		
		// add chests
		/*$chestnum = (int) count($this->roomlist) * CHESTPERCENT;
		for ($i; $i < ($monstnum + $chestnum); $i++) {
			$rc = $this->roomlist[$i];
			$room =& $this->map[$rc['z']][$rc['x']][$rc['y']];
			$room->objects[] = new Chest();
		} */
		
		/* add pools
		$poolnum = (int) count($this->roomlist) * POOLPERCENT;
		for ($i; $i < ($monstnum + $chestnum + $poolnum); $i++) {
			$rc = $this->roomlist[$i];
			$room =& $this->map[$rc['z']][$rc['x']][$rc['y']];
			$room->features[] = new Pool();
		} */
		
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
	
		// build the constructor command
		$build = '$room->'.$coll.'[] = new '.$nObj['type'].'($nObj);';
	
		//put the thing in the room
		eval($build);
	}
	
}