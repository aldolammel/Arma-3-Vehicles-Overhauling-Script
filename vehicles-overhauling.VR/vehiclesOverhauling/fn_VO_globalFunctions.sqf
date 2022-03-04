// fn_VOglobalFunctions.sqf file

THY_fnc_VO_humanPlayersAlive =
{
	private ["_headlessClients"];
	
	_headlessClients = entities "HeadlessClient_F"; 
	VO_humanPlayersAlive = (allPlayers - _headlessClients) select {alive _x};

	true
};

THY_fnc_VO_debugMonitor = 
{
	hint format ["\n\nDEBUG MONITOR\n\n- - - THE VEHICLE - - -\nType = %1.\n\n- - - GROUND - - -\nIs there the service = %2.\nAction range= %3m.\nIs there repairing = %4.\nIs there refueling = %5.\nIs there rearming = %6.\nGround while-cycles done: %17x.\n\n- - - AIR - - -\nIs there the service = %7.\nAction range = %8m.\nIs there repairing = %9.\nIs there refueling = %10.\nIs there rearming = %11.\nAir while-cycles done: %18x.\n\n- - - NAUTIC - - -\nIs there the service = %12.\nAction range = %13m.\nIs there repairing = %14.\nIs there refueling = %15.\nIs there rearming = %16.\nNautic while-cycles done: %19x.\n\n", [vehicle player] call BIS_fnc_objectType, groundVehiclesOverhauling, VO_grdActRange, VO_groundServRepair, VO_groundServRefuel, VO_groundServRearm, airVehiclesOverhauling, VO_airActRange, VO_airServRepair, VO_airServRefuel, VO_airServRearm, nauticVehiclesOverhauling, VO_nauActRange, VO_nauticServRepair, VO_nauticServRefuel, VO_nauticServRearm, VO_grdCyclesDone, VO_airCyclesDone, VO_nauCyclesDone];
	
	true
};

THY_fnc_VO_stationAdvCondition =
{
	params ["_station","_player"];
	
	// checking the mobile stations are in good conditions to work:
	if ( ( underwater _station ) OR !((getPos _station) select 2 < 1) OR ( speed _station > 0 ) ) exitWith              // <<---- "!(isTouchingGround)" is not working reliable!
	{ 
		// Show if the player is NOT in a vehicle-station and NOT in a helicopter-transporting-a-rearm-container when the VO_airActRange is too large:
		if ( !(_player in _station) AND !(vehicle _player isKindOf "Helicopter") ) then
		{
			["The station doesn't meet the conditions to work! Try later..."] remoteExec ["systemChat", _player];
		};
	};
	
	true
};

THY_fnc_VO_checkNextServiceRefuelOrRearm =
{
	params ["_doctRefuel","_station","_arrayDoctFullRefuel","_eachDoctVeh","_doctRearm","_arrayDoctFullRearm","_coolDown"];
	
	// checking the vehicle needs and if another service is available for that station:
	if ( ( _doctRefuel AND ( _station in _arrayDoctFullRefuel ) AND ( fuel _eachDoctVeh < 0.8 ) ) OR ( _doctRearm AND ( _station in _arrayDoctFullRearm ) AND ( ({getNumber (configFile >> "CfgMagazines" >> _x select 0 >> "count") != _x select 1} count (magazinesAmmo _eachDoctVeh)) > 0 ) ) ) then
	{
		format ["Preparing to the next service. Wait %1 seconds...", _coolDown] remoteExec ["systemChat", _eachDoctVeh];
	};
	
	true
};

THY_fnc_VO_checkNextServiceRearmOrRepair =
{
	params ["_doctRearm","_station","_arrayDoctFullRearm","_eachDoctVeh","_doctRepair","_arrayDoctFullRepair","_coolDown"];
	
	// checking the vehicle needs and if another service is available for that station:
	if ( ( _doctRearm AND ( _station in _arrayDoctFullRearm ) AND ( ({getNumber (configFile >> "CfgMagazines" >> _x select 0 >> "count") != _x select 1} count (magazinesAmmo _eachDoctVeh)) > 0 ) ) OR ( _doctRepair AND ( _station in _arrayDoctFullRepair ) AND ( damage _eachDoctVeh < 0.1 ) ) ) then
	{
		format ["Preparing to the next service. Wait %1 seconds...", _coolDown] remoteExec ["systemChat", _eachDoctVeh];
	};
	
	true
};

THY_fnc_VO_checkNextServiceRepairOrRefuel =
{
	params ["_doctRepair","_station","_arrayDoctFullRepair","_eachDoctVeh","_doctRefuel","_arrayDoctFullRefuel","_coolDown"];
	
	// checking the vehicle needs and if another service is available for that station:
	if ( ( _doctRepair AND ( _station in _arrayDoctFullRepair ) AND ( damage _eachDoctVeh < 0.1 ) ) OR ( _doctRefuel AND ( _station in _arrayDoctFullRefuel ) AND ( fuel _eachDoctVeh < 0.8 ) ) ) then
	{
		if (isEngineOn _eachDoctVeh == false) then
		{
			format ["Preparing to the next service. Wait %1 seconds...", _coolDown] remoteExec ["systemChat", _eachDoctVeh];
			
		} 
		else 
		{
			format ["For the next service, turn off the engine and wait %1 seconds...", _coolDown] remoteExec ["systemChat", _eachDoctVeh];
		};
	};
	
	true
};