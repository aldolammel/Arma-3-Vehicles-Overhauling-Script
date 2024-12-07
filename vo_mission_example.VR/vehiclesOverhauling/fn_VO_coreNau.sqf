// VO v2.5
// File: your_mission\vehiclesOverhauling\fn_VO_coreNau.sqf
// Documentation: https://github.com/aldolammel/Arma-3-Vehicles-Overhauling-Script/blob/main/_VO_Script_Documentation.pdf
// by thy (@aldolammel)

// Only on the server, you dont want all players checking all players:
if ( !isServer || !VO_isOn || !VO_nauticDoctrine ) exitWith {};

// NAUTIC SERVICES CORE / BE CAREFUL BELOW:
[] spawn {

	private ["_fullAssets","_repAssets","_refAssets","_reaAssets","_fullAndRepAssets","_fullAndRefAssets","_fullAndReaAssets","_allAssets","_isServProgrs","_players","_eachPlayer","_playerVehList","_currentPlayerVehList","_veh","_isAmphibious","_eachVeh"];

	sleep 1;  // avoid messages during briefing screen.
	
	// arrays that will be populated only with the objects found out more below:
	_fullAssets = [];
	_repAssets = [];
	_refAssets = [];
	_reaAssets = [];
	_fullAndRepAssets = [];
	_fullAndRefAssets = [];
	_fullAndReaAssets = [];
	_allAssets = [];

	// if the services are allowed, find out only the assets listed (fn_VO_management.sqf) and present in the mission:
	if VO_nauServFull then { { _fullAssets = _fullAssets + allMissionObjects _x } forEach VO_nauFullAssets };	
	if VO_nauServRepair then { { _repAssets = _repAssets + allMissionObjects _x } forEach VO_nauRepairAssets };	
	if VO_nauServRefuel then { { _refAssets = _refAssets + allMissionObjects _x } forEach VO_nauRefuelAssets };	
	if VO_nauServRearm then { { _reaAssets = _reaAssets + allMissionObjects _x } forEach VO_nauRearmAssets };
	// loading the main station's array without duplicated content:
	{_fullAndRepAssets pushBackUnique _x} forEach _repAssets + _fullAssets;	
	{_fullAndRefAssets pushBackUnique _x} forEach _refAssets + _fullAssets;
	{_fullAndReaAssets pushBackUnique _x} forEach _reaAssets + _fullAssets;

	// Checking if there are simpleObject assets (bad):
	{_allAssets pushBackUnique _x} forEach _fullAndRepAssets + _fullAndRefAssets + _fullAndReaAssets;
	if VO_debug_isOn then { VO_nauStationsAmount = count _allAssets }; 
	[_allAssets, "nau"] call THY_fnc_VO_isSimpleObjects;
	
	// Compatibility checking: 
	[_fullAssets, _repAssets, _refAssets, _reaAssets] call THY_fnc_VO_compatibility;
	
	// Initial nautical work values:
	_isServProgrs = false; 
	
	// Checking if fn_VO_management.sqf has been configured to start the looping:
	while { VO_isStationsOkay && VO_isServicesOkay } do {
		_players = call THY_fnc_VO_playersAlive;
		
		{ // _players forEach starts...
			_eachPlayer = _x;
			
			_playerVehList = [_x, VO_nauVehicleTypes] call THY_fnc_VO_playerVehicles;
			
			// checking the current player's vec and, if amphibious, add to the nautical vehicles list:
			if ( !isNull objectParent _x ) then 
			{
				_veh = vehicle _x;
				_isAmphibious = [_veh] call THY_fnc_VO_isAmphibious;
				if ( _isAmphibious AND !(_veh in _playerVehList) ) then { _playerVehList append [_veh] };
			}; 
			
			_currentPlayerVehList = [_x, "nau", _playerVehList] call THY_fnc_VO_addConnectedDrone;
			
			{ // forEach of _currentPlayerVehList starts...
				_eachVeh = _x;

				// Check if the vehicle is on water to avoid duplicate service checks when the vehicle is amphibious and it's on ground:
				if ( surfaceIsWater position _x ) then 
				{
					[	// NAUTIC REPAIR
						_eachPlayer, _eachVeh, VO_nauServRepair, VO_nauServiceRange, _isServProgrs, _fullAndRepAssets, VO_nauCooldown, true, false
					] call THY_fnc_VO_servRepair;
					
					[	// NAUTIC REFUEL
						_eachPlayer, _eachVeh, VO_nauServRefuel, VO_nauServiceRange, _isServProgrs, _fullAndRefAssets, VO_nauCooldown, true, false
					] call THY_fnc_VO_servRefuel;
					
					[	// NAUTIC REARM
						_eachPlayer, _eachVeh, VO_nauServRearm, VO_nauServiceRange, _isServProgrs, _fullAndReaAssets, VO_nauCooldown, true, false
					] call THY_fnc_VO_servRearm;
				};

			} forEach _currentPlayerVehList;
		
		} forEach _players;
		
		sleep 5;
		
		// debug:
		if VO_debug_isOn then { call THY_fnc_VO_debugMonitor; VO_nauCyclesDone = (VO_nauCyclesDone + 1) };
		
	};  // while-looping ends.
};  // spawn ends.