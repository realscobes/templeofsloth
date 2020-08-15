<?php
class World {
	public $map = array();
	public $roomlist = array();
	public $player;
	private $inanimates = array();
	private $monsters = array();
	private $pools = array();
	private $equipment = array();
	private $consumables = array();

	public $termOutput = array();

	public $validCmds = array();
	
	//generate 3d array made up of rooms, as well as sequential list
	function __construct($mapX, $mapY, $mapZ, $thingDensity) {
		//floors
		for ($z = 0; $z < $mapZ; $z++) {
			//columns
			for ($y = 0; $y < $mapY; $y++) {
				//rows
				for ($x = 0; $x < $mapX; $x++) {
					$this->map[$z][$x][$y] = new Room;
					$this->roomlist[] = array(
						'z' => $z,
						'x' => $x,
						'y' => $y
						);
						if ($z == 7) {
							$room = $this->map[$z][$x][$y];
							$room->isBottomFloor = true;
						}
				}
			}
			
		}

		$this->getRoom (0, 3, 0)->isExit = true;
		unset ($this->roomlist[3]); // remove start location from list
		$this->getRoom (0, 3, 0)->mapSymbol = 'E'; 

		//add stairs and remove them from the list
		foreach ($this->map as $z => $floorplan) {
			if (isset($upstairs)) {
				extract($upstairs);
				$room = $this->getRoom($z, $x, $y);
				$room->stairs = "up";
				$room->mapSymbol = "U";
				$roomnum = ($z * 64) + ($y * 8) + $x;
				unset ($this->roomlist[$roomnum]);
			}
			if ($z == 7) 
				break;
			$x = rand (0, 7);
			$y = rand (0, 7);
			$room = $this->getRoom($z, $x, $y);
			$room->stairs = "down";
			$room->mapSymbol = "D";
			$roomnum = ($z * 64) + ($y * 8) + $x;
			unset ($this->roomlist[$roomnum]);
			$upstairs = array('x' => $x, 'y' => $y);

		}

		//dumpData($this->roomlist);
		shuffle($this->roomlist); // randomise room list
		reset($this->roomlist);

		// get command list
		$this->validCmds = parse_ini_file(TOSRES.'data/commandlist.ini', true);
		
		// get thing lists
		$this->inanimates = parse_ini_file(TOSRES.'data/inanimates.ini', true);
		$this->monsters = parse_ini_file(TOSRES.'data/monsters.ini', true);
		$this->pools = parse_ini_file(TOSRES.'data/pools.ini', true);
		$this->equipment = parse_ini_file(TOSRES.'data/equipment.ini', true);
		$this->consumables = parse_ini_file(TOSRES.'data/consumables.ini', true);

		// add monsters
		$this->populate('monsters', $thingDensity['monsters']);

		// add pools
		$this->populate('pools', $thingDensity['pools']);

		// add chests
		$chestnum = (int) count($this->roomlist) * $thingDensity['chests'];
		$content = array_merge($this->equipment, $this->consumables);
		for ($i=0; $i < $chestnum; $i++) {
			$room = $this->getNextRoom();
			$chest = new Chest;
			$room->chests[] = new Chest;
			$room->mapSymbol = "C";

		}

		// add sinkholes
		$shnum = (int) count($this->roomlist) * $thingDensity['sinkholes'];
		for ($i = 0; $i < $shnum; $i++) {
			$room = $this->getNextRoom();
			while ($room->isBottomFloor) {
				$room = $this->getNextRoom();
			} 
			$room->isSinkhole = true; 
			$room->mapSymbol = 'S';
		}

		// add merchants
		// do this later

		// add warps
		$warpnum = (int) count($this->roomlist) * $thingDensity['warps'];
		for ($i = 0; $i < $warpnum; $i++) {
			$room = $this->getNextRoom(); 
			$room->isWarp = true; 
			$room->mapSymbol = 'W';
		}

		// add orb
		$room = $this->getNextRoom();
		$room->inanimates[] = new MacGuffin ('Orb');
		$room->mapSymbol = 'W';

		// add staff
		$room = $this->getNextRoom();
		$room->inanimates[] = new MacGuffin ('Staff');
		$room->mapSymbol = 's';

		// add player
		$this->player = new Player();
		// give player command list
		foreach ($this->validCmds as $key => $value) {
			$this->player->actions[$key] = true;
		}
		// activate game and move commands
			$this->player->actions['doReset'] = true;
			$this->player->actions['doSave'] = true;
			$this->player->actions['goN'] = true;
			$this->player->actions['goS'] = true;
			$this->player->actions['goW'] = true;
			$this->player->actions['goE'] = true;
			//$this->player->actions[lookN] = true;
			//$this->player->actions[lookS] = true;
			//$this->player->actions[lookW] = true;
			//$this->player->actions[lookE] = true;

		// unset object lists
		unset($this->inanimates);
		unset($this->monsters);
		unset($this->pools);
		unset($this->equipment);
		unset($this->consumables);
	}

	// populate random objects
	function populate ($thing, $density) {
		$thingnum = (int) count($this->roomlist) * $density;
		for ($i = 0; $i < $thingnum; $i++) {
			$room = $this->getNextRoom(); 
			$this->addRThing($room, $thing); 
		}
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

		// change room symbol
		$room->mapSymbol = $nObj['symbol'];
	}

	//return the next room from the list
	function getNextRoom () {
		extract(current($this->roomlist));
		$room = $this->getRoom ($z, $x, $y); //$this->map[$rc['z']][$rc['x']][$rc['y']];
		next($this->roomlist);
		return $room;
	}

	//get room by co-ordinates
	function getRoom ($z, $x, $y) {
		return $this->map[$z][$x][$y];
	}

	function say ($string) {
		$this->termOutput[] = $string;
	}

	function printTerminal() {
		$output = array_slice($this->termOutput, -12);
		foreach ($output as $string) {
			echo ($string." <br>".PHP_EOL);
		}
	}
	
}