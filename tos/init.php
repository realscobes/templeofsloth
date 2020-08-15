<?php

extract(parse_ini_file (TOSRES.'settings/initsettings.ini'));

$thingDensity = array ('monsters' => $monstPercent, 
                       'chests' => $chestPercent, 
                       'pools' => $poolPercent, 
                       'sinkholes' => $sinkholePercent,
                       'warps' => $warpPercent);

$world = new World ($mapX, $mapY, $mapFlr, $thingDensity);

