// VO v2.0
// File: your_mission\vehiclesOverhauling\fn_VO_coreGrd.sqf
// by thy (@aldolammel)

// Only on the server, you dont want all players checking all players:
if ( !VO_groundDoctrine OR !isServer ) exitWith {};

// GROUND SERVICES CORE / BE CAREFUL BELOW:
[] spawn {

	private ["_fullAssets","_repAssets","_refAssets","_reaAssets","_fullAndRepAssets","_fullAndRefAssets","_fullAndReaAssets","_allAssets","_isServProgrs","_players","_eachPlayer","_playerVehList","_currentPlayerVehList","_connected","_eachVeh"];

	sleep 1;  // avoid messages during briefing screen.
	
	// Arrays that will be populated only with the objects found out more below:
	_fullAssets = [];
	_repAssets = [];
	_refAssets = [];
	_reaAssets = [];
	_fullAndRepAssets = [];
	_fullAndRefAssets = [];
	_fullAndReaAssets = [];
	_allAssets = [];
	
	// If the services are allowed, find out only the assets listed (fn_VO_parameters.sqf) and present in the mission:
	if ( VO_grdServFull ) then { { _fullAssets = _fullAssets + allMissionObjects _x } forEach VO_grdFullAssets };	
	if ( VO_grdServRepair ) then { { _repAssets = _repAssets + allMissionObjects _x } forEach VO_grdRepairAssets };	
	if ( VO_grdServRefuel ) then { { _refAssets = _refAssets + allMissionObjects _x } forEach VO_grdRefuelAssets };	
	if ( VO_grdServRearm ) then { { _reaAssets = _reaAssets + allMissionObjects _x } forEach VO_grdRearmAssets };
	// Loading the main station's array without duplicated content:
	{_fullAndRepAssets pushBackUnique _x} forEach _repAssets + _fullAssets;
	{_fullAndRefAssets pushBackUnique _x} forEach _refAssets + _fullAssets;
	{_fullAndReaAssets pushBackUnique _x} forEach _reaAssets + _fullAssets;

	// Checking if there are simpleObject assets (bad):
	{_allAssets pushBackUnique _x} forEach _fullAndRepAssets + _fullAndRefAssets + _fullAndReaAssets;
	if ( VO_debugMonitor ) then { VO_grdStationsAmount = count _allAssets } else { VO_grdStationsAmount = 0 };
	[_allAssets, "grd"] call THY_fnc_VO_isSimpleObjects;
	
	// Compatibility checking: 
	[_fullAssets, _repAssets, _refAssets, _reaAssets] call THY_fnc_VO_compatibility;
	
	// Initial ground work values:
	_isServProgrs = false; 
	
	// Checking if fn_VO_parameters.sqf has been configured to start the looping:
	while { VO_isStationsOkay AND VO_isServicesOkay } do
	{
		_players = call THY_fnc_VO_playersAlive;
		
		{ // _players forEach starts...
			_eachPlayer = _x;
			
			_playerVehList = [_x, VO_grdVehicleTypes] call THY_fnc_VO_playerVehicles;

			_currentPlayerVehList = [_x, "grd", _playerVehList] call THY_fnc_VO_addConnectedDrone;
			
			{ // forEach of _currentPlayerVehList starts...
				_eachVeh = _x;
				
				[	// GROUND REPAIR
					_eachPlayer, _eachVeh, VO_grdServRepair, VO_grdServiceRange, _isServProgrs, _fullAndRepAssets, VO_grdCooldown, false, false
				] call THY_fnc_VO_servRepair;
				
				[	// GROUND REFUEL
					_eachPlayer, _eachVeh, VO_grdServRefuel, VO_grdServiceRange, _isServProgrs, _fullAndRefAssets, VO_grdCooldown, false, false
				] call THY_fnc_VO_servRefuel;
				
				[	// GROUND REARM
					_eachPlayer, _eachVeh, VO_grdServRearm, VO_grdServiceRange, _isServProgrs, _fullAndReaAssets, VO_grdCooldown, false, false
				] call THY_fnc_VO_servRearm;

			} forEach _currentPlayerVehList;
			
		} forEach _players;
		
		sleep 5;
		
		// debug:
		if ( VO_debugMonitor ) then { call THY_fnc_VO_debugMonitor; VO_grdCyclesDone = (VO_grdCyclesDone + 1) };

	};  // while-looping ends.
};  // spawn ends.