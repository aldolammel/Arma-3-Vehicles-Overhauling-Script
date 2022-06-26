// File: your_mission\vehiclesOverhauling\fn_VO_coreGrd.sqf
// by thy (@aldolammel)

private ["_fullAssets","_repAssets","_refAssets","_reaAssets","_fullAndRepAssets","_fullAndRefAssets","_fullAndReaAssets","_playersAlive","_grdVehicles","_connected","_servProgrs","_eachPlayer","_eachVeh"];

// Only on the server, you dont want all players checking all players:
if ( !groundVehiclesOverhauling OR !isServer ) exitWith {};

// GROUND SERVICES CORE / BE CAREFUL BELOW:

[] spawn 
{ 	
	// arrays that will be populated only with the objects found out more below:
	_fullAssets = [];
	_repAssets = [];
	_refAssets = [];
	_reaAssets = [];
	
	// if the services are allowed, find out only the assets (classnames) listed through fn_VO_parameters.sqf file:
	if ( VO_grdServFull ) then { { _fullAssets = _fullAssets + allMissionObjects _x } forEach VO_grdFullAssets };	
	if ( VO_grdServRepair ) then { { _repAssets = _repAssets + allMissionObjects _x } forEach VO_grdRepairAssets };	
	if ( VO_grdServRefuel ) then { { _refAssets = _refAssets + allMissionObjects _x } forEach VO_grdRefuelAssets };	
	if ( VO_grdServRearm ) then { { _reaAssets = _reaAssets + allMissionObjects _x } forEach VO_grdRearmAssets };
	
	// loading the main assets arrays:
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
			_grdVehicles = _x nearEntities [VO_grdVehicleTypes, 10];
			// searching the player's connected ground drones: 
			if ( !VO_dronesNeedHuman ) then 
			{
				_connected =  getConnectedUAV _x;
				if ( _connected isKindOf "Car" OR _connected isKindOf "Motorcycle" OR _connected isKindOf "Tank" OR _connected isKindOf "WheeledAPC" OR _connected isKindOf "TrackedAPC" ) then    // WIP: to improve > check the VO_grdVehicleTypes array.
				{
					_grdVehicles append [_connected];
				};
			};
			
			if ( VO_debugMonitor ) then { {systemChat str _x} forEach _grdVehicles };
			
			{ // forEach of _grdVehicles starts...  
			
				_eachVeh = _x;
				
				// GROUND REPAIR
				[VO_grdServRepair, _eachVeh, VO_grdServiceRange, _servProgrs, _fullAndRepAssets, VO_grdServRefuel, _fullAndRefAssets, VO_grdServRearm, _fullAndReaAssets, VO_grdCooldown] call THY_fnc_VO_servRepair;
				
				// GROUND REFUEL
				[VO_grdServRefuel, _eachVeh, VO_grdServiceRange, _servProgrs, _fullAndRefAssets, VO_grdServRearm, _fullAndReaAssets, VO_grdServRepair, _fullAndRepAssets, VO_grdCooldown] call THY_fnc_VO_servRefuel;
				
				// GROUND REARM
				[VO_grdServRearm, _eachVeh, VO_grdServiceRange, _eachPlayer, _servProgrs, _fullAndReaAssets, VO_grdServRepair, _fullAndRepAssets, VO_grdServRefuel, _fullAndRefAssets, VO_grdCooldown] call THY_fnc_VO_servRearm;

			} forEach _grdVehicles;
			
		} forEach _playersAlive;
		
		sleep 5;
		if ( VO_debugMonitor ) then { VO_grdCyclesDone = (VO_grdCyclesDone + 1) };
		
	};  // while-looping ends.

};  // spawn ends.