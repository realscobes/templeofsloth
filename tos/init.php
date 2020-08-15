<?php

extract(parse_ini_file (TOSRES.'settings/initsettings.ini'));

$thingDensity = array ('monsters' => $monstPercent, 
                       'chests' => $chestPercent, 
                       'pools' => $poolPercent, 
                       'warp' => $warpPercent);

$world = new World ($mapX, $mapY, $mapFlr, $thingDensity);

