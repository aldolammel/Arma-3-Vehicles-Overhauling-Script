// VO v1.7
// File: your_mission\vehiclesOverhauling\fn_VO_coreNau.sqf
// by thy (@aldolammel)

private ["_fullAssets","_repAssets","_refAssets","_reaAssets","_fullAndRepAssets","_fullAndRefAssets","_fullAndReaAssets","_playersAlive","_nauVehicles","_connected","_isServProgrs","_eachPlayer","_eachVeh"];

// Only on the server, you dont want all players checking all players:
if ( !nauticVehiclesOverhauling OR !isServer ) exitWith {};

// NAUTIC SERVICES CORE / BE CAREFUL BELOW:

[] spawn 
{
	// arrays that will be populated only with the objects found out more below:
	_fullAssets = [];
	_repAssets = [];
	_refAssets = [];
	_reaAssets = [];

	// if the services are allowed, find out only the assets (classnames) listed through fn_VO_parameters.sqf file:
	if ( VO_nauServFull ) then { { _fullAssets = _fullAssets + allMissionObjects _x } forEach VO_nauFullAssets };	
	if ( VO_nauServRepair ) then { { _repAssets = _repAssets + allMissionObjects _x } forEach VO_nauRepairAssets };	
	if ( VO_nauServRefuel ) then { { _refAssets = _refAssets + allMissionObjects _x } forEach VO_nauRefuelAssets };	
	if ( VO_nauServRearm ) then { { _reaAssets = _reaAssets + allMissionObjects _x } forEach VO_nauRearmAssets };
	
	// loading the main assets arrays:
	_fullAndRepAssets = _repAssets + _fullAssets;
	_fullAndRefAssets = _refAssets + _fullAssets;
	_fullAndReaAssets = _reaAssets + _fullAssets;
	
	// Compatibility checking: 
	[_fullAssets, _repAssets, _refAssets, _reaAssets] call THY_fnc_VO_compatibility;
	
	// initial services condition:
	_isServProgrs = false; 
	
	// Checking if fn_VO_parameters.sqf has been configured to start the looping:
	while { isStationsOkay AND isServicesOkay } do
	{
		_playersAlive = (allPlayers - (entities "HeadlessClient_F")) select {alive _x};
		
		{ // _playersAlive forEach starts...
			
			_eachPlayer = _x;
			
			// searching the player's regular vehicles into XXm radius:
			_nauVehicles = _x nearEntities [VO_nauVehicleTypes, 20];
			// searching the player's connected nautic drones: 
			if ( !VO_dronesNeedHuman ) then 
			{
				_connected =  getConnectedUAV _x;
				if ( _connected isKindOf "Ship" OR _connected isKindOf "Submarine" ) then        // WIP: Future improvement > make it search the connected veh type directly in VO_nauVehicleTypes array, and so make it as function.
				{
					_nauVehicles append [_connected];
				};
			};
			
			{ // forEach of _nauVehicles starts...
				
				_eachVeh = _x;
			
				// NAUTIC REPAIR
				[VO_nauServRepair, _eachVeh, VO_nauServiceRange, _isServProgrs, _fullAndRepAssets, VO_nauServRefuel, _fullAndRefAssets, VO_nauServRearm, _fullAndReaAssets, VO_nauCooldown, true] call THY_fnc_VO_servRepair;
				
				// NAUTIC REFUEL
				[VO_nauServRefuel, _eachVeh, VO_nauServiceRange, _isServProgrs, _fullAndRefAssets, VO_nauServRearm, _fullAndReaAssets, VO_nauServRepair, _fullAndRepAssets, VO_nauCooldown, true] call THY_fnc_VO_servRefuel;
				
				// NAUTIC REARM
				[VO_nauServRearm, _eachVeh, VO_nauServiceRange, _eachPlayer, _isServProgrs, _fullAndReaAssets, VO_nauServRepair, _fullAndRepAssets, VO_nauServRefuel, _fullAndRefAssets, VO_nauCooldown, true] call THY_fnc_VO_servRearm;

			} forEach _nauVehicles;
		
		} forEach _playersAlive;
		
		sleep 5;
		
		// debug:
		if ( VO_debugMonitor ) then { call THY_fnc_VO_debugMonitor; VO_nauCyclesDone = (VO_nauCyclesDone + 1) };
		
	};  // while-looping ends.

};  // spawn ends.