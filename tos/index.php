<?php

// define resource location
const TOSRES = '../tosres/';

// include the includes
require_once(TOSRES.'includes.inc');


// check the session, if none go do setup - for testing just going to go ahead and do setup
session_start();
if (!isset($_SESSION['world'])) {
	include ('init.php');
}
else {
	$world = loadWorld();
}

$player = $world->player; // for simplicity
$fbkString = '';

//$room->mapSymbol = '+';


// if there's input send it to the parser
if ($_POST['cmd']) {
	$parser = new Parser($world);
	extract ($_POST);
	$parser->parse($cmd);
}


// check player is alive
if ($player->hitPoints <= 0) {
	$world->say ("You died. <br> <input type=submit name=cmd value=doReset>Reset</input>");
}


// get current room
$room = $world->getRoom (
	$player->posZ,
	$player->posX,
	$player->posY
);

// set room as discovered
$room->discovered = true;

if (isset($_SESSION['warp'])) {
	$world->say ("You fell through a warp! <br>");
	unset($_SESSION['warp']);
}

if (isset($_SESSION['sinkhole'])) {
	$world->say ("You fell through a sinkhole! <br>");
	unset($_SESSION['sinkhole']);
}

// is it a warp or sinkhole?
if ($room->isWarp) {
	$player->teleport (rand(0, 7), rand(0, 7), rand(0, 7));
	$_SESSION['warp'] = true;
	saveWorld ($world);
	header("Refresh:0");
}

if ($room->isSinkhole) {
	$player->posZ++;
	$_SESSION['sinkhole'] = true;
	saveWorld ($world);
	header("Refresh:0");
}

// describe room and situation
$world->say ("You see here: ");
$world->say ($room->getStuffList());


// select input options
$actions = $player->actions;



// write world to session
saveWorld($world);
//dumpData($world->player);


// display interface
?>

<html>
	<head>
		<link rel="stylesheet" type="text/css" href="mainlayout.css">
</head>
<body>
<form method=post>

<div class="grid-container">
  <div class="termArea">
    <div class="termView"><?php	$world->printTerminal(); ?></div>
  </div>

  <div class="actionArea">
	<?php
	
		foreach ($actions as $key => $value) {
			if ($value) {
				echo ('<div class="'.$key.'"> <input type=submit name=cmd value='.$key.'> </div>'.PHP_EOL);
			}
		}
	?>
	</div>

  <div class="mapInvArea">
    <div class="mapArea">
		<?php
		drawMap($world->map, $player->posZ, $player->posX, $player->posY);
		?>
	</div>
    <div class="invArea">Inventory here</div>
    <div class="statsArea">
		<?php
		$player->getStats();
		?>
	</div>
  </div>
</div>
</form>


<?php






