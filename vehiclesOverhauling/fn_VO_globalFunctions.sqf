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
	hint format ["\n\nDEBUG MONITOR\n\n- - - THE VEHICLE - - -\nVehicle type = Soon.\nIs damaged = %2.\nIs refueled = %3.\n\n- - - GROUND - - -\nHas ground services = %4.\nGround action range= %5m.\nHas grnd repairing = %6.\nHas grnd refueling = %7.\nHas grnd rearming = %8.\n\n- - - AIR - - -\nHas air services = %9.\nAir action range = %10m.\nHas air repairing = %11.\nHas air refueling = %12.\nHas air rearming = %13.\n\n- - - NAUTIC - - -\nHas nautic services = %14.\nNautic action range = %15m.\nHas nautic repairing = %16.\nHas nautic refueling = %17.\nHas nautic rearming = %18.\n\n", _groundVehicles call BIS_fnc_objectType, damage _groundVehicles, fuel _groundVehicles, THY_fnc_groundOverhauling, THY_fnc_grdActRange, THY_fnc_groundRepair, THY_fnc_groundRefuel, THY_fnc_groundRearm, THY_fnc_airOverhauling, THY_fnc_airActRange, THY_fnc_airRepair, THY_fnc_airRefuel, THY_fnc_airRearm, THY_fnc_nauticOverhauling, THY_fnc_nauActRange, THY_fnc_nauticRepair, THY_fnc_nauticRefuel, THY_fnc_nauticRearm];
	
	true
};