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