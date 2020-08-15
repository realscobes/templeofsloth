<?php

class Entity {
	public $hitPoints;
	public $valStr;
	public $valDex;
	public $eqWeap;
	public $eqArm;
}

class Player extends Entity {
	public $posX;
	public $posY;
	public $posZ;
    public $inventory = array();
    public $hasStaff;
	
	function __construct () {
		$this->posX = 3;
		$this->posY = 0;
        $this->posZ = 0;
        $this->hasStaff = false;

		$this->hitPoints = 25;
		$this->valStr = 10;
		$this->valDex = 10;
		$this->eqWeap = new Weapon(10, 10);
		$this->eqArm = new Armour(10, 10);
	}
	
}

class Merchant extends Entity {
    public $inventory = array ();

    function __construct () {
        $this->hitPoints = 100;
        $this->valStr = 50;
        $this->valDex = 50;

        $this->eqWeap = new Weapon(100, 100);
        $this->eqArm = new Armour(100, 100);
        
        // generate inventory
    }
}


class Monster extends Entity {
	// monster types:
	// 0 = Troll
	// 1 = Orc
	// 2 = Nazi
	
	public $type;
	public $name;
	
	function __construct ($params) {
		extract($params);
		$this->type = $type;
		$this->name = $name;
		$this->hitPoints = rand($minHP, $maxHP);
		$this->valStr = rand($minSTR, $maxSTR);
		$this->valDex = rand($minDEX, $maxDEX);
		$this->eqWeap = new Weapon(10, 10);
		$this->eqArm = new Armour(10, 10);
	}
	
}