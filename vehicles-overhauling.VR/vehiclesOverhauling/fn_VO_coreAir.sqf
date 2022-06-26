// File: your_mission\vehiclesOverhauling\fn_VO_coreAir.sqf
// by thy (@aldolammel)

private ["_fullAssets","_repAssets","_refAssets","_reaAssets","_parkingHelperAssets","_fullAndRepAssets","_fullAndRefAssets","_fullAndReaAssets","_playersAlive","_airVehicles","_connected","_servProgrs","_eachPlayer","_eachVeh"];

// Only on the server, you dont want all players checking all players:
if ( !airVehiclesOverhauling OR !isServer ) exitWith {};

// AIR SERVICES CORE / BE CAREFUL BELOW:

[] spawn 
{
	// arrays that will be populated only with the objects found out more below:
	_fullAssets = [];
	_repAssets = [];
	_refAssets = [];
	_reaAssets = [];
	_parkingHelperAssets = [];
	
	// if the services are allowed, find out only the assets (classnames) listed through fn_VO_parameters.sqf file:
	if ( VO_airServFull ) then { { _fullAssets = _fullAssets + allMissionObjects _x } forEach VO_airFullAssets };	
	if ( VO_airServRepair ) then { { _repAssets = _repAssets + allMissionObjects _x } forEach VO_airRepairAssets };	
	if ( VO_airServRefuel ) then { { _refAssets = _refAssets + allMissionObjects _x } forEach VO_airRefuelAssets };	
	if ( VO_airServRearm ) then { { _reaAssets = _reaAssets + allMissionObjects _x } forEach VO_airRearmAssets };
	
	// List of assets with a parking system to help plane to maneuver:
	{ _parkingHelperAssets = _parkingHelperAssets + allMissionObjects _x } forEach VO_airParkingHelperAssets;
	
	// loading the main station's assets:
	_fullAndRepAssets = _repAssets + _fullAssets;
	_fullAndRefAssets = _refAssets + _fullAssets;
	_fullAndReaAssets = _reaAssets + _fullAssets;
	
	// Removes repairing, refueling and rearming from A3 vanilla's assets: 
	[_fullAssets, _repAssets, _refAssets, _reaAssets] call THY_fnc_VO_A3CargoOff;
	
	// ACE Compatibility:
	if ( ACE_isOn ) then 
	{
		// WIP
	};
	
	// Initial services condition:
	_servProgrs = false;
	
	// Checking if fn_VO_parameters.sqf has been configured to start the looping:
	while { isStationsOkay AND isServicesOkay } do
	{
		// debug:
		if ( VO_debugMonitor ) then { call THY_fnc_VO_debugMonitor };
		
		_playersAlive = (allPlayers - (entities "HeadlessClient_F")) select {alive _x};
		
		{ // _playersAlive forEach starts...
			
			_eachPlayer = _x;
			
			// searching the player's regular vehicles into XXm radius:
			_airVehicles = _x nearEntities [VO_airVehicleTypes, 20];
			// searching the player's connected air drones: 
			if ( !VO_dronesNeedHuman ) then 
			{
				_connected =  getConnectedUAV _x;
				if ( _connected isKindOf "Helicopter" OR _connected isKindOf "Plane" ) then        // WIP: Future improvement > make it search the connected veh type directly in VO_airVehicleTypes array, and so make it as function.
				{
					_airVehicles append [_connected];
				};
			};
			
			if ( VO_debugMonitor ) then { {systemChat str _x} forEach _airVehicles };
			
			{ // forEach of _airVehicles starts... 
				
				_eachVeh = _x; 

				// AIR REPAIR
				[VO_airServRepair, _eachVeh, VO_airServiceRange, _servProgrs, _fullAndRepAssets, VO_airServRefuel, _fullAndRefAssets, VO_airServRearm, _fullAndReaAssets, VO_airCooldown] call THY_fnc_VO_servRepair;
				
				// AIR REFUEL
				[VO_airServRefuel, _eachVeh, VO_airServiceRange, _servProgrs, _fullAndRefAssets, VO_airServRearm, _fullAndReaAssets, VO_airServRepair, _fullAndRepAssets, VO_airCooldown] call THY_fnc_VO_servRefuel;
	
				// AIR REARM
				[VO_airServRearm, _eachVeh, VO_airServiceRange, _eachPlayer, _servProgrs, _fullAndReaAssets, VO_airServRepair, _fullAndRepAssets, VO_airServRefuel, _fullAndRefAssets, VO_airCooldown] call THY_fnc_VO_servRearm;
				
				// Parking plane helper:
				[_eachVeh, _parkingHelperAssets] call THY_fnc_VO_parkingHelper;
				

			} forEach _airVehicles;
		
		} forEach _playersAlive;
		
		sleep 5;
		if ( VO_debugMonitor ) then { VO_airCyclesDone = (VO_airCyclesDone + 1) };
		
	};  // while-looping ends.

};  // spawn ends.