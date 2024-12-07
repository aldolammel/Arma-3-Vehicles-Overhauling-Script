// VO v2.5
// File: your_mission\vehiclesOverhauling\fn_VO_coreAir.sqf
// Documentation: https://docs.google.com/document/d/1l0MGrLNk6DXZdtq41brhtQLgSxpgPQ4hOj_5fm_KaI8/edit?usp=sharing
// by thy (@aldolammel)

// Only on the server, you dont want all players checking all players:
if ( !VO_airDoctrine || !isServer ) exitWith {};

// AIR SERVICES CORE / BE CAREFUL BELOW:
[] spawn {

	private ["_fullAssets","_repAssets","_refAssets","_reaAssets","_fullAndRepAssets","_fullAndRefAssets","_fullAndReaAssets","_allAssets","_parkingHelperAssets","_isServProgrs","_players","_eachPlayer","_playerVehList","_currentPlayerVehList","_eachVeh"];

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
	_parkingHelperAssets = [];
	
	// if the services are allowed, find out only the assets listed (fn_VO_parameters.sqf) and present in the mission:
	if ( VO_airServFull ) then { { _fullAssets = _fullAssets + allMissionObjects _x } forEach VO_airFullAssets };
	if ( VO_airServRepair ) then { { _repAssets = _repAssets + allMissionObjects _x } forEach VO_airRepairAssets };
	if ( VO_airServRefuel ) then { { _refAssets = _refAssets + allMissionObjects _x } forEach VO_airRefuelAssets };
	if ( VO_airServRearm ) then { { _reaAssets = _reaAssets + allMissionObjects _x } forEach VO_airRearmAssets };
	// loading the main station's array without duplicated content:
	{_fullAndRepAssets pushBackUnique _x} forEach _repAssets + _fullAssets;	
	{_fullAndRefAssets pushBackUnique _x} forEach _refAssets + _fullAssets;
	{_fullAndReaAssets pushBackUnique _x} forEach _reaAssets + _fullAssets;

	// Checking if there are simpleObject assets (bad):
	{_allAssets pushBackUnique _x} forEach _fullAndRepAssets + _fullAndRefAssets + _fullAndReaAssets;
	if VO_debug_isOn then { VO_airStationsAmount = count _allAssets }; 
	[_allAssets, "air"] call THY_fnc_VO_isSimpleObjects;
	
	// Compatibility checking:
	[_fullAssets, _repAssets, _refAssets, _reaAssets] call THY_fnc_VO_compatibility;
	
	// List of assets with a parking system to help plane to maneuver:
	{ _parkingHelperAssets = _parkingHelperAssets + allMissionObjects _x } forEach VO_airParkingHelperAssets;
	
	// Initial air work values:
	_isServProgrs = false;

	// Checking if fn_VO_parameters.sqf has been configured to start the looping:
	while { VO_isStationsOkay AND VO_isServicesOkay } do 
	{
		_players = call THY_fnc_VO_playersAlive;
		
		{ // _players forEach starts...
			_eachPlayer = _x;
			
			_playerVehList = [_x, VO_airVehicleTypes] call THY_fnc_VO_playerVehicles;

			_currentPlayerVehList = [_x, "air", _playerVehList] call THY_fnc_VO_addConnectedDrone;
			
			{ // forEach of _currentPlayerVehList starts...
				_eachVeh = _x; 

				[	// AIR REPAIR
					_eachPlayer, _eachVeh, VO_airServRepair, VO_airServiceRange, _isServProgrs, _fullAndRepAssets, VO_airCooldown, false, VO_hasAirRngChanger
				] call THY_fnc_VO_servRepair;
				
				[	// AIR REFUEL
					_eachPlayer, _eachVeh, VO_airServRefuel, VO_airServiceRange, _isServProgrs, _fullAndRefAssets, VO_airCooldown, false, VO_hasAirRngChanger
				] call THY_fnc_VO_servRefuel;
	
				[	// AIR REARM
					_eachPlayer, _eachVeh, VO_airServRearm, VO_airServiceRange, _isServProgrs, _fullAndReaAssets, VO_airCooldown, false, VO_hasAirRngChanger
				] call THY_fnc_VO_servRearm;
				
				// Parking plane helper:
				[_eachVeh, _parkingHelperAssets] call THY_fnc_VO_parkingHelper;

			} forEach _currentPlayerVehList;
		
		} forEach _players;
		
		sleep 5;
		
		// debug:
		if VO_debug_isOn then { call THY_fnc_VO_debugMonitor; VO_airCyclesDone = (VO_airCyclesDone + 1) };

	};  // while-looping ends.
};  // spawn ends.