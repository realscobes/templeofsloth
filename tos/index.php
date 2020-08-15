<?php

// define resource location
const TOSRES = '../tosres/';

// include the includes
require_once(TOSRES.'includes.inc');


// check the session, if none go do setup - for testing just going to go ahead and do setup
// session_start();
// if (!isset($_SESSION['world'])) {
	include ('init.php');
// }
// else {
//	$world = $_SESSION['world'];
// }

dumpData($world); //let's see if I fucked this up

// if there's input send it to the parser


// check player is alive


// get current room


// describe room and situation


// select input options


// write world to session


// display interface

function stuffOnScreen() {
	?>
<pre> Nothing here yet </pre>

<?php 
}
	
stuffOnScreen();	
?>
