<?php

class Parser {
	public $validCmds = array();
	public $world;
	
	function __construct ($world) {
		//read accepted command list and aliases from file into $validCmds
		
		$this->validCmds = parse_ini_file(TOSRES.'data/commandlist.ini', true);
		$this->world = $world;
	}
	
	function parse ($newCmd) {
		if (!array_key_exists($newCmd, $this->validCmds)) {
			echo("Invalid command: $newCmd <br>");
			return false;
		}
		else {
			$cmdArray = $this->validCmds[$newCmd];
			$intCmd = '$this->'.$cmdArray['cmd'].'(';
            unset($cmdArray['cmd']);
            unset($cmdArray['label']);
			foreach ($cmdArray as $key => $arg)
				$intCmd .= $arg.', ';
			//rtrim($intCmd, ', ');
			$intCmd .= ');';
			//echo($intCmd);
			eval($intCmd);
		}
		
	}

// Moving and looking
	function move ($xOff, $yOff) {
        $x = &$this->world->player->posX;
        $y = &$this->world->player->posY;
        $newX = $x + $xOff;
        $newY = $y + $yOff;
        if ( ($newX >= 0) && ($newX < 8) && ($newY >=0) && ($newY < 8) ) {
            $x = $newX;
            $y = $newY;
            $this->world->say ("You walk into the next room <br>");
        }
        else $this->world->say ("You can't go that way. <br>");
		return true;
	}

	function look ($xOff, $yOff) {
		$this->world->say ("look function called, offset $xOff, $yOff. <br>");
		return true;
	}
	

// Context based actions	
	function doAttack () {
		$this->world->say ("Attack function called. <br>");
		return true;
	}
	
	function doFlee () {
		$this->world->say ("Flee function called. <br>");
		return true;
	}
	function doOpen () {
		$this->world->say ("doOpen function called. <br>");
		return true;
	}

 	function doDrink () {
		$this->world->say ("doDrink function called. <br>");
		return true;
	}

 	function doRead () {
		$this->world->say ("doRead function called. <br>");
		return true;
	}

 	function doTrade () {
		$this->world->say ("doTrade function called. <br>");
		return true;
	}
	
	
// Game actions
	function doReset () {
        $this->world->say ("Reset function called. Push 'Save'.<br>");
        $_SESSION = array();
        session_destroy();
        return true;
	}

 	function doSave () {
		$this->world->say ("Save not implemented <br>");
		return true;
	}
	
}