// VO v2.5
// File: your_mission\vehiclesOverhauling\fn_VO_globalFunctions.sqf
// Documentation: https://github.com/aldolammel/Arma-3-Vehicles-Overhauling-Script/blob/main/_VO_Script_Documentation.pdf
// by thy (@aldolammel)


// VO CORE / TRY TO CHANGE NOTHING BELOW!!! --------------------------------------------------------------------


// STRUCTURE OF A FUNCTION BY THY:
/* THY_fnc_VO_name_of_the_function = {
	// This function <doc string>.
	// Return nothing <or varname + type>

	params["", "", "", ""];
	private["", "", ""];

	// Escape:
		// reserved space.
	// Initial values:
		// reserved space.
	// Declarations:
		// reserved space.
	// Debug texts:
		// reserved space.

	// Main functionality:
	// code

	// Return:
	true;
}; */


THY_fnc_VO_debugMonitor = {
	// This function: helps the mission's editor to find errors out and possible fixes.
	// return nothing.

	private ["_vehCategory"];

	_vehCategory = [vehicle player] call BIS_fnc_objectType;
	
	format [
		"\n" +
		"\n--- VO DEBUG MONITOR ---\n" +
		"\n%1." +
		"\n%2\n" +
		"\n- - - YOU'RE BY - - -" +
		"\n%3" +
		"\n%4" +
		"\n%5" +
		// "\n- - - YOUR CURRENT STATION - - -\n" +
		// "%20" +
		// "\nBusy with: %23\n" +
		"\n- - - GROUND - - -" +
		"\n%6" +
		"\nAmount stations= %7" +
		"\nAction range= %8m" +
		"\nRepairing = %9" +
		"\nRefueling = %10" +
		"\nRearming = %11" +
		"\nGround while-cycles done: %12x" +
		"\n\n- - - AIR - - -" +
		"\n%13" +
		"\nAmount stations= %14" +
		"\nAction range = %15m" +
		"\nRepairing = %16" +
		"\nRefueling = %17" +
		"\nRearming = %18" +
		"\nAir while-cycles done: %19x" +
		"\n\n- - - NAUTICAL - - -" +
		"\n%20" +
		"\nAmount stations= %21" +
		"\nAction range = %22m" +
		"\nRepairing = %23" +
		"\nRefueling = %24" +
		"\nRearming = %25" +
		"\nNautic while-cycles done: %26x" +
		"\n\n",
		VO_debug_ACE,
		VO_debug_ACE_vehDamage,
		_vehCategory,
		if ((_vehCategory # 0) != "Soldier") then {typeOf (vehicle player)} else {"on foot"},
		if (VO_nauticDoctrine && (_vehCategory # 0) != "Soldier" ) then {format ["Float on water = %1", [vehicle player] call THY_fnc_VO_isAmphibious]} else {""},

		VO_groundDoctrine,
		if VO_groundDoctrine then {VO_grdStationsAmount} else {""},
		VO_grdServiceRange,
		VO_grdServRepair,
		VO_grdServRefuel,
		VO_grdServRearm,
		VO_grdCyclesDone,

		VO_airDoctrine,
		if VO_airDoctrine then {VO_airStationsAmount} else {""},
		VO_airServiceRange,
		VO_airServRepair,
		VO_airServRefuel,
		VO_airServRearm,
		VO_airCyclesDone,

		VO_nauticDoctrine,
		if VO_nauticDoctrine then {VO_nauStationsAmount} else {""},
		VO_nauServiceRange,
		VO_nauServRepair,
		VO_nauServRefuel,
		VO_nauServRearm,
		VO_nauCyclesDone

	] remoteExec ["hintSilent", player];

	true
};


THY_fnc_VO_isSimpleObjects = {
	// This function identify and, if so, tells to editor that some station asset has a misconfiguration.
	// Returns nothing.

	params ["_allAssets", "_doctrine"];
	private ["_counter", "_txtSing", "_txtPlur"];

	if !VO_debug_isOn exitWith {};

	_counter = 0;

	{ if ( isSimpleObject _x ) then { _counter = _counter + 1 } } forEach _allAssets;

	if ( _counter > 0 ) then {
		_txtSing = "station is badly set as SimpleObject that will bring a weird behavior to the station.";
		_txtPlur = "stations are badly set as SimpleObject that will bring a weird behavior to the stations.";
		
		if ( _counter isEqualTo 1 ) then {
			switch _doctrine do {
				case "grd": {systemChat format ["VO ERROR > %1 GROUND %2", _counter, _txtSing]};
				case "air": {systemChat format ["VO ERROR > %1 AIR %2", _counter, _txtSing]};
				case "nau": {systemChat format ["VO ERROR > %1 NAUTICAL %2", _counter, _txtSing]};
			};
		} else {
			switch _doctrine do {
				case "grd": {systemChat format ["VO ERROR > %1 GROUND %2", _counter, _txtPlur]};
				case "air": {systemChat format ["VO ERROR > %1 AIR %2", _counter, _txtPlur]};
				case "nau": {systemChat format ["VO ERROR > %1 NAUTICAL %2", _counter, _txtPlur]};
			};
		};
	};

	true
};


THY_fnc_VO_compatibility = {
	// This function: compatibility checking with Arma 3 vanilla assets and ACE services.
	// Returns nothing.
	
	params ["_fullAssets", "_repAssets", "_refAssets", "_reaAssets"];
	
	if VO_isACErun then               // detecting basic ACE components to check if ACE is running in server.
	{
		// Stations conformity with ACE:
		{
			_x setVariable ["ACE_isRepairFacility", 0];  // 0 = disable
			[_x, 0] call ace_refuel_fnc_setFuel;
			[_x] call ace_rearm_fnc_disable;
		
		} forEach _fullAssets + _repAssets + _refAssets + _reaAssets;
		
		// Vehicles conformity with ACE:
		{
			_x setVariable ["ACE_isRepairVehicle", 0];  // 0 = disable
			[_x, 0] call ace_refuel_fnc_setFuel;
			[_x] call ace_rearm_fnc_disable;
			
		} forEach allMissionObjects "Tank" + allMissionObjects "Truck";  // https://community.bistudio.com/wiki/ArmA:_Armed_Assault:_CfgVehicles
		
		VO_debug_ACE = "ACE ON";
		if ( ace_vehicle_damage_enabled ) then { VO_debug_ACE_vehDamage = "ACE Veh Damage ON" } else { VO_debug_ACE_vehDamage = "ACE Veh Damage OFF" };
	
	} else {
	
		// Stations conformity with NO ACE:
		{
			_x setRepairCargo 0;
			_x setFuelCargo 0;
			_x setAmmoCargo 0;
			
		} forEach _fullAssets + _repAssets + _refAssets + _reaAssets;
		
		// Vehicles conformity with NO ACE:
		// not needed.
		
		VO_debug_ACE = "ACE OFF";
		VO_debug_ACE_vehDamage = "ACE Veh Damage OFF";
	};

	true
};


THY_fnc_VO_playersAlive = {
	// This function identifies only and all humam players are alive in-game.
	// Returns _playersAlive array.

	private _playersAlive = [];
	_playersAlive = (allPlayers - (entities "HeadlessClient_F")) select { alive _x };

	_playersAlive  // returning.
};


THY_fnc_VO_isDroneConnected = {
	// This function checks wether the player is connected.
	// Returns _isDroneConnected bool.

	params [["_player", objNull]];
	private ["_isDroneConnected", "_connected"];

	_isDroneConnected = false;

	// Handling Errors:
	if (_player isEqualTo objNull) exitWith {if VO_debug_isOn then {systemChat "VO ERROR > THY_fnc_VO_isDroneConnected: needs a player as parameter."; sleep 15}; _isDroneConnected  /* Returning. */};

	_connected = getConnectedUAV _player;
	if (!isNull _connected) then { _isDroneConnected = true };

	_isDroneConnected  // Returning.
};


THY_fnc_VO_isAmphibious = {
	// This function checks if the vehicle at station has the ability to float as an amphibious vehicle (APC, for example).
	// Returns _canFloat.

	params [["_veh", objNull]];
	private ["_floatVal", "_canFloat"];

	// Handling Errors:
	if (_veh isEqualTo objNull) exitWith {if VO_debug_isOn then {systemChat "VO ERROR > THY_fnc_VO_isAmphibious: needs a vehicle as parameter."; sleep 15}};

	_floatVal = _veh getVariable ['TAG_canFloat',-1];

	if (_floatVal isEqualTo -1) then {
		_floatVal = getNumber (configFile >> 'CfgVehicles' >> (typeOf _veh) >> 'canFloat');
		_veh setVariable ['TAG_canFloat',_floatVal];
	};
	_canFloat = _floatVal > 0;
	
	_canFloat  // returning.
};


THY_fnc_VO_addConnectedDrone = {
	// This function understands if vehicle is a drone and, if so, adds to the current vehicle list next to the player.
	// Returns _currentPlayerVehList array.

	params [["_player", objNull], ["_doctrine", ""], "_playerVehList"];
	private ["_isDroneConnected", "_connected"];

	// Handling Errors:
	if (_player isEqualTo objNull) exitWith {if VO_debug_isOn then {systemChat "VO ERROR > THY_fnc_VO_addConnectedDrone: needs a player as parameter."; sleep 15}; _playerVehList  /* Returning. */};
	if (_doctrine isEqualTo "") exitWith {if VO_debug_isOn then {systemChat "VO ERROR > THY_fnc_VO_addConnectedDrone: needs a doctrine as parameter."; sleep 15}; _playerVehList  /* Returning. */};

	_isDroneConnected = [_player] call THY_fnc_VO_isDroneConnected;

	if !_isDroneConnected exitWith { _playerVehList  /* Returning. */};

	_currentPlayerVehList = _playerVehList;

	_connected = getConnectedUAV _player;

	switch _doctrine do {
		case "grd":  // Ground doctrine vehicles
		{
			if (_connected isKindOf "Car" || _connected isKindOf "Motorcycle" || _connected isKindOf "Tank" || _connected isKindOf "WheeledAPC" || _connected isKindOf "TrackedAPC") then { _currentPlayerVehList append [_connected] };
		};
		case "air":  // Air doctrine vehicles
		{
			if ( _connected isKindOf "Helicopter" || _connected isKindOf "Plane" ) then { _currentPlayerVehList append [_connected] };
		};
		case "nau":  // Nautical doctrine vehicles
		{
			if ( _connected isKindOf "Ship" || _connected isKindOf "Submarine" ) then { _currentPlayerVehList append [_connected] };
		};
	};

	_currentPlayerVehList  // Returning.
};


THY_fnc_VO_playerVehicles = {
	// This function detects all allowed vehicles (by doctrine) in certain range from the player and set them in a list.
	// Returns the array _playerVehList.

	params [["_player", objNull], ["_allowedVehTypes", []], ["_range", 20]];
	private ["_playerVehList"];

	_playerVehList = [];

	// Handling Errors:
	if (_player isEqualTo objNull) exitWith {if VO_debug_isOn then {systemChat "VO ERROR > THY_fnc_VO_playerVehicles: needs a player as parameter."; sleep 15}; _playerVehList  /* Returning. */};
	if (count _allowedVehTypes isEqualTo 0) exitWith {if VO_debug_isOn then {systemChat "VO ERROR > THY_fnc_VO_playerVehicles: check if fn_VO_management.sqf has the default list of recognized vehicles by doctrine."; sleep 15}; _playerVehList  /* Returning. */};

	// if player in a vehicle, it's avoid to search for new vehicles around:
	if (!isNull objectParent _player) exitWith {
		{
			// adds the current vehicle if it's a allowed doctrine type:
			if ( vehicle _player isKindOf _x ) exitWith { _playerVehList pushBackUnique (vehicle _player) };
		
		} forEach _allowedVehTypes;

		_playerVehList  // Returning.
	};

	sleep 0.5;
	
	_playerVehList = _player nearEntities [_allowedVehTypes, _range];

	_playerVehList  // returning
};


THY_fnc_VO_isOnSurface = {
	// This function checks if the object (station or player's vehicle) is on ground or water surface. Remember, unfortunately Arma 3 command "isTouchingGround" somehow is not reliable.
	// returns _isOnSurface bool.

	params [["_obj", objNull]];
	private ["_isOnSurface"];

	// Handling Errors:
	if (_obj isEqualTo objNull) exitWith {if VO_debug_isOn then {systemChat "VO ERROR > THY_fnc_VO_isOnSurface: needs an object (player or station) as parameter."; sleep 15}};

	_isOnSurface = true;

	// checks if the object's axis Y is NOT close enough to the ground of water surface:
	if ( ((getPos _obj) # 2) > 0.2 ) then { _isOnSurface = false };

	_isOnSurface  // returning
};


THY_fnc_VO_isStationRangeChanger = {
	// This function checks if the current station has the ability to change its service range to attemp planes only. If so, the range is increase where _servRng != _currentRng.
	// Returns the integer range _currentRng.

	params [["_stat", objNull], ["_veh", objNull], ["_hasRngChanger", false], ["_servRng", 20]];
	private ["_rangeChanger", "_currentRng", "_statType"];

	_rangeChanger = 80;
	_currentRng = _servRng;

	if !_hasRngChanger exitWith { _currentRng  /* Returning. */ };
	
	// Handling Errors:
	if (_stat isEqualTo objNull) exitWith {if VO_debug_isOn then {systemChat "VO ERROR > THY_fnc_VO_isStationRangeChanger: needs a station as parameter."; sleep 15}};
	if (_veh isEqualTo objNull) exitWith {if VO_debug_isOn then {systemChat "VO ERROR > THY_fnc_VO_isStationRangeChanger: needs a vehicle as parameter."; sleep 15}};

	_statType = typeOf _stat;

	// Range-Changer trigger to action:
	if ( _veh isKindOf "Plane" && _statType in VO_assetsRangeChanger ) then 
	{ 
		if ( _servRng < _rangeChanger ) then { _currentRng = _rangeChanger };

		if ( VO_debug_isOn && (_currentRng >= _rangeChanger) && ((_veh distance _stat) <= _currentRng) ) then
		{ 
			systemChat format [">> DEBUG > Station %1 is a RANGE-CHANGER, its service range increase to %2m for Planes.", _statType, _currentRng];
			sleep 3;
		};
	};
	
	_currentRng  // returning.
};


THY_fnc_VO_checkMobileStation = {
	// This function verify the station, if it's a mobile one, fits another conditions to work properly. Nowadays, it's used only for rearming sevice.
	// Returns _isBadAdvCond bool.
	
	params [["_player", objNull], ["_veh", objNull], ["_stat", objNull], ["_isNautic", false], ["_isStatRngChanger", false]];
	private ["_isBadAdvCond", "_isOnSurface", "_isRearmNeeded"];

	_isBadAdvCond = false;
	
	// Handling errors:
	if (_player isEqualTo objNull) exitWith {if VO_debug_isOn then {systemChat "VO ERROR > THY_fnc_VO_checkMobileStation: needs a player as parameter."; sleep 15; _isBadAdvCond  /* Returning. */}};
	if (_veh isEqualTo objNull) exitWith {if VO_debug_isOn then {systemChat "VO ERROR > THY_fnc_VO_checkMobileStation: needs a vehicle as parameter."; sleep 15; _isBadAdvCond  /* Returning. */}};
	if (_stat isEqualTo objNull) exitWith {if VO_debug_isOn then {systemChat "VO ERROR > THY_fnc_VO_checkMobileStation: needs a station as parameter."; sleep 15; _isBadAdvCond  /* Returning. */}};

	if ( _isNautic || _isStatRngChanger ) exitWith { _isBadAdvCond  /* Returning. */ }; 

	_isOnSurface = [_stat] call THY_fnc_VO_isOnSurface;
	_isRearmNeeded = [_veh] call THY_fnc_VO_isRearmNeeded;

	// checking the advanced stations conditions (to prevent madness with mobile-stations):
	if ( (underwater _stat) || (!_isOnSurface) || (speed _stat > 0.2) ) then	
	{ 
		_isBadAdvCond = true;
		
		// shows the message if the player ISN'T in a mobile-station, NOT in a helicopter-transporting-a-rearm-container, the player's vehicle needs rearm and the player IS almost stand still then...
		if ( !(_player in _stat) && !(_veh isKindOf "Helicopter") && _isRearmNeeded && abs (speed _player) < 10 ) then
		{
			[_player, _veh, _stat, "", 4] call THY_fnc_VO_serviceCanceled;
		};
	};

	sleep 10;

	_isBadAdvCond  // Returning.
};


THY_fnc_VO_isRearmNeeded = {
	// This function checks the mag capacity and how much ammo still remains within.
	// Returns _isRearmNeeded bool.
	
	params [["_veh", objNull]];
	private ["_isRearmNeeded", "_driverWeapons", "_gunnerWeapons", "_secGunnerWeapons", "_hasDriverNoWeapon", "_hasGunnerNoWeapon", "_hasSecGunnerNoWeapon", "_notWeaponWords", "_turretPath", "_vehMagsStr", "_vehMagDetail", "_ammoName", "_ammoInMag", "_capacityMag"];

	_isRearmNeeded = false;
	_driverWeapons = _veh weaponsTurret [-1];
	_gunnerWeapons = _veh weaponsTurret [0];
	_secGunnerWeapons = _veh weaponsTurret [1];
	_hasDriverNoWeapon = false;
	_hasGunnerNoWeapon = false;
	_hasSecGunnerNoWeapon = false;
	_notWeaponWords = ["horn", "flare"];  // add here the key-word that indicates "the ammo name" is NOT an ammo.
	
	// Handling Errors:
	if (_veh isEqualTo objNull) exitWith {if VO_debug_isOn then {systemChat "VO ERROR > THY_fnc_VO_isRearmNeeded: needs a vehicle as parameter."; sleep 15}; _isRearmNeeded /* Returning */};

	// Extra debug for rearming:
	if ( VO_debug_isOn && ((abs speed _veh) <= 2) ) then {
		_turretPath = [[-1], [0], [1], [0,0], [0,1], [1,0]];  // https://community.bistudio.com/wiki/Turret_Path
		{ systemChat format [">> DEBUG > Turret path %1 = %2", str _x, str (_veh weaponsTurret _x)]; sleep 2 } forEach _turretPath;
	};
	
	// Check if the turrets are not just a horn or other stuff in _notWeaponWords:
	if ( (count _driverWeapons) <= 1 ) then
	{
		if ( (count _driverWeapons) isEqualTo 0 ) exitWith {_hasDriverNoWeapon = true};		
		{ _hasDriverNoWeapon = [_x, (_driverWeapons # 0), false] call BIS_fnc_inString; if ( _hasDriverNoWeapon ) exitWith {} } forEach _notWeaponWords;
	};

	if ( (count _gunnerWeapons) <= 1 ) then
	{
		if ( (count _gunnerWeapons) isEqualTo 0 ) exitWith {_hasGunnerNoWeapon = true};		
		{ _hasGunnerNoWeapon = [_x, (_gunnerWeapons # 0), false] call BIS_fnc_inString; if ( _hasGunnerNoWeapon ) exitWith {} } forEach _notWeaponWords;
	};

	if ( (count _secGunnerWeapons) <= 1 ) then
	{
		if ( (count _secGunnerWeapons) isEqualTo 0 ) exitWith {_hasSecGunnerNoWeapon = true};	
		{ _hasSecGunnerNoWeapon = [_x, (_secGunnerWeapons # 0), false] call BIS_fnc_inString; if ( _hasSecGunnerNoWeapon ) exitWith {} } forEach _notWeaponWords;
	};

	// Exit if the vehicle has NO weaponry for gunner and for driver:
	if ( _hasDriverNoWeapon && _hasGunnerNoWeapon && _hasSecGunnerNoWeapon ) exitWith {if VO_debug_isOn then {systemChat format [">> DEBUG > %1 has NO weaponry, then rearm IS NOT needed.", typeOf _veh]; sleep 15}; _isRearmNeeded /* Returning */};
	
	_vehMagsStr = magazinesDetail _veh;  // "120mm (2/20)[id/cr:10000011/0]".

	if ( (count _vehMagsStr) > 0 ) then 
	{
		{
			_vehMagDetail = _x splitString "([]/:)";  // ["120mm", "2", "20", "id", "cr", "10000011", "0"]
			_ammoName = _vehMagDetail # 0;
			reverse _vehMagDetail;  // ["0", "10000011", "cr", "id", "20", "2", "120mm"] coz the current ammo and ammo capacity don't change their index when reversed.
			//systemChat str _vehMagDetail;  // Extra debug: checking the index of mag details.
			_ammoInMag = parseNumber (_vehMagDetail # 5);  // string "2" convert to number 2.
			_capacityMag = parseNumber (_vehMagDetail # 4);  // string "20" convert to number 20.
	
			// Checking if rearm is needed:
			if ( _ammoInMag < (_capacityMag / 2) ) exitWith 
			{ 
				if VO_debug_isOn then {systemChat format [">> DEBUG > Magazine [%1]: %2 ammo of %3 capacity. Rearm is needed!", _ammoName, _ammoInMag, _capacityMag]; sleep 3};
				_isRearmNeeded = true;
			};
	
			//if VO_debug_isOn then {systemChat format [">> DEBUG > Magazine [%1]: %2 ammo of %3 capacity. Rearm NOT needed.", _ammoName, _ammoInMag, _capacityMag]; sleep 3};
			
		} forEach _vehMagsStr;

	} else {

		// When the armed-vehicle has NO ammo-capacity (0% ammunition in its attributes) it will force the vehicle to rearm:
		_isRearmNeeded = true;
	};
	
	_isRearmNeeded // Returning...
};


THY_fnc_VO_serviceCanceled = {
	// This function displays a message if the service process is broken.
	// Returns nothing.

	params [["_player", objNull], ["_veh", objNull], ["_stat", objNull], ["_txtServ", "The service"], ["_case", 0]];
	private ["_msgPrefix","_msg"];

	// Handling Errors:
	if (_player isEqualTo objNull) exitWith {if VO_debug_isOn then {systemChat "VO ERROR > THY_fnc_VO_serviceCanceled: needs a player as parameter."; sleep 15}};
	if (_veh isEqualTo objNull) exitWith {if VO_debug_isOn then {systemChat "VO ERROR > THY_fnc_VO_serviceCanceled: needs a vehicle as parameter."; sleep 15}};
	if (_stat isEqualTo objNull) exitWith {if VO_debug_isOn then {systemChat "VO ERROR > THY_fnc_VO_serviceCanceled: needs a station as parameter."; sleep 15}};

	_msgPrefix = format ["%1 has been canceled!", _txtServ];

	switch _case do {
		case 0: {_msg = format [">> %1", _msgPrefix]};
		case 1: {_msg = format [">> %1 Keep the %2 engine OFF at station.", _msgPrefix, typeOf _veh]};
		case 2: {_msg = format [">> %1 The station needs to be closer to the ground.", _msgPrefix]};
		case 3: {_msg = format [">> %1 Keep your %2 on the ground.", _msgPrefix, typeOf _veh]};
		case 4: {_msg = format [">> The station %1 doesn't meet the conditions to rearm the %2 yet!", typeOf _stat, typeOf _veh]};
		//case 5: {_msg = format [">> To rearm, someone in control of a vehicle weapon is required (gunner or commander seat)."]};
		case 6: {_msg = format [">> %1 Careful, the %2 has NO ammo. Try to rearm!", _msgPrefix, typeOf _veh]};
	};
	// Finally it prints out feedback message:
	if ( _player in _veh ) then {
		format ["%1", _msg] remoteExec ["systemChat", crew _veh];
	} else {
		format ["%1", _msg] remoteExec ["systemChat", _player];
	};

	sleep 10;  // punishment fixed cooldown.

	true
};


THY_fnc_VO_busyService = {
	// This function prints a message out when some service station's busy.
	// Returns nothing.

	params [["_player", objNull], ["_stat", objNull]];

	// Handling Errors:
	if (_player isEqualTo objNull) exitWith {if VO_debug_isOn then {systemChat "VO ERROR > THY_fnc_VO_busyService: needs a player as parameter."; sleep 15}};
	if (_stat isEqualTo objNull) exitWith {if VO_debug_isOn then {systemChat "VO ERROR > THY_fnc_VO_busyService: needs a station as parameter."; sleep 15}};

	sleep 2;
	if ( _player in (vehicle _player) ) then 
	{
		format [">> Someone is using the service at %1. Hold...", typeOf _stat] remoteExec ["systemChat", crew (vehicle _player)];

	} else {

		format [">> %1, someone is using the service at %2. Hold...", name _player, typeOf _stat] remoteExec ["systemChat", _player];
	};

	true
};


THY_fnc_VO_preparingService = {
	// This function tells to the player some service will starts.
	// returns _isServProgrs bool;

	params [["_player", objNull], ["_stat", objNull], ["_veh", objNull], ["_currentRng", 20], ["_servCoolDown", 10], ["_isRearm", false], ["_isDroneConnected", false]];
	private ["_isServProgrs", "_waitTxt"];

	_isServProgrs = false;

	// Handling Errors:
	if (_player isEqualTo objNull) exitWith {if VO_debug_isOn then {systemChat "VO ERROR > THY_fnc_VO_preparingService: needs a player as parameter."; sleep 15}; _isServProgrs /* Returning */};
	if (_stat isEqualTo objNull) exitWith {if VO_debug_isOn then {systemChat "VO ERROR > THY_fnc_VO_preparingService: needs a station as parameter."; sleep 15}; _isServProgrs /* Returning */};
	if (_veh isEqualTo objNull) exitWith {if VO_debug_isOn then {systemChat "VO ERROR > THY_fnc_VO_preparingService: needs a vehicle as parameter."; sleep 15}; _isServProgrs /* Returning */};

	// Fist check if the vehicle is on ground or water surface:
	if !([_veh] call THY_fnc_VO_isOnSurface) exitWith {_isServProgrs /* Returning */};
	
	sleep 2;

	if ( alive _player && alive _stat && alive _veh ) then 
	{
		if ( (!VO_dronesNeedHuman && _isDroneConnected) || ((_player distance _stat) <= _currentRng) ) then 
		{
			_waitTxt = "";
			if ( _servCoolDown >= 5 ) then { _waitTxt = format ["Wait %1 secs...", _servCoolDown] };

			if ( _player in _veh ) then 
			{
				format [">> Preparing a service to %1 at station... %2", typeOf _veh, _waitTxt] remoteExec ["systemChat", crew _veh];

			} else {

				format [">> Preparing a service to %1 at station... %2", typeOf _veh, _waitTxt] remoteExec ["systemChat", _player];
			};

			sleep _servCoolDown;
		};
	};

	// Checks again if preparation of rearming the player's veh is on ground or water:
	if ( _isRearm && !([_veh] call THY_fnc_VO_isOnSurface) ) exitWith 
	{
		[_player, _veh, _stat, "The service", 3] call THY_fnc_VO_serviceCanceled;

		_isServProgrs  // Returning.
	};

	// Checks if preparation of repairing or refueling the player keeps the vehicle's engine off:
	if ( (!_isRearm && isEngineOn _veh) || !alive _player || !alive _stat || !alive _veh || (!_isDroneConnected && ((_player distance _stat) > _currentRng)) ) exitWith 
	{
		[_player, _veh, _stat, "The service", 0] call THY_fnc_VO_serviceCanceled;
		
		_isServProgrs  // Returning.
	};

	_isServProgrs = true; 

	_isServProgrs  // Returning.
};


THY_fnc_VO_soundEffect = {
	// This function adds a sound effect for each service.
	// Returns nothing.

	params [["_stat", objNull], ["_serv", ""], ["_isNautic", false]];

	// Handling Errors:
	if (_stat isEqualTo objNull) exitWith {if VO_debug_isOn then {systemChat "VO ERROR > THY_fnc_VO_soundEffect: needs a station as parameter."; sleep 15}};
	if (_serv == "resource") then {if VO_debug_isOn then {systemChat "VO ERROR > THY_fnc_VO_soundEffect NOT working properly: the function 'THY_fnc_VO_checkingMsg' needs a specific resource as parameter."; sleep 15}};  // if it happens, this condition wont stop the function, just warning the editor.

	if !_isNautic then {
		switch _serv do {
			case "damages": {playSound3D ["a3\sounds_f\characters\cutscenes\dirt_acts_carfixingwheel.wss", _stat]};  // repairing
			case "fuel": {playSound3D ["a3\sounds_f\characters\cutscenes\concrete_acts_walkingchecking.wss", _stat]};  // refueling
			case "ammunition": {playSound3D ["a3\sounds_f\characters\cutscenes\concrete_acts_walkingchecking.wss", _stat]};  // rearming
			case "resource": {playSound3D ["a3\sounds_f\characters\cutscenes\dirt_acts_carfixingwheel.wss", _stat]};
		};
	
	} else {
		switch _serv do {
			case "damages": {playSound3D ["a3\sounds_f\characters\cutscenes\water_acts_carfixingwheel.wss", _stat]};  // repairing
			case "fuel": {playSound3D ["a3\sounds_f\characters\cutscenes\water_acts_walkingchecking.wss", _stat]};  // refueling and rearming
			case "ammunition": {playSound3D ["a3\sounds_f\characters\cutscenes\water_acts_walkingchecking.wss", _stat]};  // rearming
			case "resource": {playSound3D ["a3\sounds_f\characters\cutscenes\water_acts_carfixingwheel.wss", _stat]};
		};
	};

	sleep 10;  // to give time for the sfx if the Editor sets a lower cooldown service in fn_VO_management.sqf.

	true
};


THY_fnc_VO_checkingMsg = {
	// This function tells to the player some service is running.
	// Returns nothing.

	params [["_player", objNull], ["_stat", objNull], ["_veh", objNull], ["_resource", "resource"], ["_isNautic", false]];

	// Handling Errors:
	if (_player isEqualTo objNull) exitWith {if VO_debug_isOn then {systemChat "VO ERROR > THY_fnc_VO_checkingMsg: needs a player as parameter."; sleep 15}};
	if (_stat isEqualTo objNull) exitWith {if VO_debug_isOn then {systemChat "VO ERROR > THY_fnc_VO_checkingMsg: needs a station as parameter."; sleep 15}};
	if (_veh isEqualTo objNull) exitWith {if VO_debug_isOn then {systemChat "VO ERROR > THY_fnc_VO_checkingMsg: needs a vehicle as parameter."; sleep 15}};

	if VO_isReporting then {
		if ( _player in _veh ) then {
			format [">> Checking the %1 of %2...", _resource, typeOf _veh] remoteExec ["systemChat", crew _veh];
		} else {
			format [">> Checking the %1 of %2...", _resource, typeOf _veh] remoteExec ["systemChat", _player];
		};
	};

	[_stat, _resource, _isNautic] call THY_fnc_VO_soundEffect;

	true
};


THY_fnc_VO_servRepair = {
	// This function: provides the repairing functionality for the vehicles parked at station.
	// Returns nothing.
	
	params [["_player", objNull], ["_veh", objNull], ["_serv", false], ["_servRng", 20],  ["_isServProgrs", false], ["_statAssets", []], ["_cooldown", 10], ["_isNautic", false], ["_hasRngChanger", false]];
	private ["_currentRng", "_isStatRngChanger", "_isDroneConnected"];
	
	if !_serv exitWith {};

	// Handling Errors:
	if (_player isEqualTo objNull) exitWith {if VO_debug_isOn then {systemChat "VO ERROR > THY_fnc_VO_servRepair: needs a player as parameter."; sleep 15}};
	if (_veh isEqualTo objNull) exitWith {if VO_debug_isOn then {systemChat "VO ERROR > THY_fnc_VO_servRepair: needs a vehicle as parameter."; sleep 15}};
	if (count _statAssets isEqualTo 0) exitWith {if VO_debug_isOn then {systemChat "VO ERROR > THY_fnc_VO_servRepair: no assets set up as repair station (or full service) for this doctrine in fn_VO_management.sqf."; sleep 15}};

	{ // forEach of _statAssets starts...
		// initial values:
		_isStatRngChanger = false;

		// Verifying if there's range changers available:
		_currentRng = [_x, _veh, _hasRngChanger, _servRng] call THY_fnc_VO_isStationRangeChanger;
		if (_currentRng isNotEqualTo _servRng) then {_isStatRngChanger = true};
		
		// checking the basic station (_x) conditions:
		if ( alive _x && (_veh distance _x) <= _currentRng && _veh isNotEqualTo _x && (abs speed _x) < 1 ) then {
			// checking the player's vehicle:
			if ( alive _veh && (abs speed _veh) < 2 && !(underwater _veh) && !(isEngineOn _veh) && (damage _veh) > VO_minRepairService ) then {
				// checking if the station is NOT busy:
				if !_isServProgrs then {
					// ACE Compatibility:
					//if ( VO_isACErun ) then { _veh setVariable ["ace_cookoff_enable", false, true]; if VO_debug_isOn then { ["ace_cookoff_enable = false"] remoteExec ["systemChat"] } };  // cook off disabled.

					_isDroneConnected = [_player] call THY_fnc_VO_isDroneConnected;

					_isServProgrs = [_player, _x, _veh, _currentRng, _cooldown, false, _isDroneConnected] call THY_fnc_VO_preparingService;

					if ( _isServProgrs ) then 
					{
						[_player, _x, _veh, "damages", _isNautic] call THY_fnc_VO_checkingMsg; 
						
						// before repairing, last check if the player's vehicle and station still on conditions:
						[_player, _x, _veh, "rep", _currentRng, _isStatRngChanger, _isNautic, _isDroneConnected, "repaired", "Repairing"] call THY_fnc_VO_serviceExecution; 
						
						_isServProgrs = false;  // station is free for the next service!

						// ACE Compatibility:
						//if ( VO_isACErun ) then { _veh setVariable ["ace_cookoff_enable", true, true]; if VO_debug_isOn then { ["ace_cookoff_enable = enable"] remoteExec ["systemChat"] } };  // cook off enable.
					};
				
				} else { [_player, _x] call THY_fnc_VO_busyService };
			};
		};
		
	} forEach _statAssets;

	true
};


THY_fnc_VO_servRefuel = {
	// This function: provides the refueling functionality for the vehicles parked at station.
	// Returns nothing.
	
	params [["_player", objNull], ["_veh", objNull], ["_serv", false], ["_servRng", 20], ["_isServProgrs", false], ["_statAssets", []], ["_cooldown", 10], ["_isNautic", false], ["_hasRngChanger", false]];
	private ["_currentRng", "_isStatRngChanger", "_isDroneConnected"];
	
	if !_serv exitWith {};

	// Handling Errors:
	if (_player isEqualTo objNull) exitWith {if VO_debug_isOn then {systemChat "VO ERROR > THY_fnc_VO_servRefuel: needs a player as parameter."; sleep 15}};
	if (_veh isEqualTo objNull) exitWith {if VO_debug_isOn then {systemChat "VO ERROR > THY_fnc_VO_servRefuel: needs a vehicle as parameter."; sleep 15}};
	if (count _statAssets isEqualTo 0) exitWith {if VO_debug_isOn then {systemChat "VO ERROR > THY_fnc_VO_servRefuel: no assets set up as refuel station (or full service) for this doctrine in fn_VO_management.sqf."; sleep 15}};

	{ // forEach of _statAssets starts...
		// initial values:
		_isStatRngChanger = false;

		// Verifying if there's range changers available:
		_currentRng = [_x, _veh, _hasRngChanger, _servRng] call THY_fnc_VO_isStationRangeChanger;
		if (_currentRng isNotEqualTo _servRng) then {_isStatRngChanger = true};

		// checking the basic station (_x) conditions:
		if ( (alive _x) && ( (_veh distance _x) <= _currentRng ) && (_veh isNotEqualTo _x) && (abs speed _x < 1) ) then 
		{
			// checking the player's vehicle:
			if ( (alive _veh) && (abs speed _veh < 2) && (!underwater _veh) && (!isEngineOn _veh) && (fuel _veh < VO_minRefuelService) ) then 
			{
				// checking if the station is NOT busy:
				if !_isServProgrs then {
					_isDroneConnected = [_player] call THY_fnc_VO_isDroneConnected;
					
					_isServProgrs = [_player, _x, _veh, _currentRng, _cooldown, false, _isDroneConnected] call THY_fnc_VO_preparingService;

					if ( _isServProgrs ) then 
					{
						[_player, _x, _veh, "fuel", _isNautic] call THY_fnc_VO_checkingMsg; 
						
						// before refueling, last check if the player's vehicle and station still on conditions:
						[_player, _x, _veh, "ref", _currentRng, _isStatRngChanger, _isNautic, _isDroneConnected, "refueled", "Refueling"] call THY_fnc_VO_serviceExecution;
						
						_isServProgrs = false;  // station is free for the next service!
					};
					
				} else { [_player, _x] call THY_fnc_VO_busyService };
			};
		};
		
	} forEach _statAssets;

	true
};


THY_fnc_VO_servRearm = {
	// This function: provides the rearming functionality for the armed vehicles parked at station.
	// Returns nothing.

	params [["_player", objNull], ["_veh", objNull], ["_serv", false], ["_servRng", 20], ["_isServProgrs", false], ["_statAssets", []], ["_cooldown", 10], ["_isNautic", false], ["_hasRngChanger", false]];
	private ["_currentRng", "_isStatRngChanger", "_isBadAdvCond", "_isRearmNeeded", "_isDroneConnected"];
	
	if !_serv exitWith {};

	// Handling Errors:
	if (_player isEqualTo objNull) exitWith {if VO_debug_isOn then {systemChat "VO ERROR > THY_fnc_VO_servRearm: needs a player as parameter."; sleep 15}};
	if (_veh isEqualTo objNull) exitWith {if VO_debug_isOn then {systemChat "VO ERROR > THY_fnc_VO_servRearm: needs a vehicle as parameter."; sleep 15}};
	if (count _statAssets isEqualTo 0) exitWith {if VO_debug_isOn then {systemChat "VO ERROR > THY_fnc_VO_servRearm: no assets set up as rearm station (or full service) for this doctrine in fn_VO_management.sqf."; sleep 15}};

	{ // forEach of _statAssets starts...
		// initial values:
		_isStatRngChanger = false;

		// Verifying if there's range changers available:
		_currentRng = [_x, _veh, _hasRngChanger, _servRng] call THY_fnc_VO_isStationRangeChanger;
		if (_currentRng isNotEqualTo _servRng) then {_isStatRngChanger = true};

		// checking the basic station (_x) conditions:
		if ( (alive _x) && ((_veh distance _x) <= _currentRng) && (_veh isNotEqualTo _x) ) then 
		{
			// checking the advanced station (_x) conditions:
			_isBadAdvCond = [_player, _veh, _x, _isNautic, _isStatRngChanger] call THY_fnc_VO_checkMobileStation;
			if ( _isBadAdvCond ) exitWith {};

			_isRearmNeeded = [_veh] call THY_fnc_VO_isRearmNeeded;

			// checking the player's vehicle:
			if ( (alive _veh) && (abs speed _veh < 2) && (!underwater _veh) && _isRearmNeeded ) then
			{

				// checking if the station is NOT busy:
				if !_isServProgrs then {
					_isDroneConnected = [_player] call THY_fnc_VO_isDroneConnected;
					
					_isServProgrs = [_player, _x, _veh, _currentRng, _cooldown, true, _isDroneConnected] call THY_fnc_VO_preparingService;

					if ( _isServProgrs ) then 
					{
						[_player, _x, _veh, "ammunition", _isNautic] call THY_fnc_VO_checkingMsg;
						
						// before rearming, last check if the player's vehicle and station still on conditions:
						[_player, _x, _veh, "rea", _currentRng, _isStatRngChanger, _isNautic, _isDroneConnected, "rearmed", "Rearming"] call THY_fnc_VO_serviceExecution;

						_isServProgrs = false;  // station is free for the next service!
					};
				
				} else { [_player, _x] call THY_fnc_VO_busyService };
			};
		};
	
	} forEach _statAssets;

	true
};


THY_fnc_VO_parkingHelper = {
	// This function: as it's not possible to maneuver planes inside hangars with a single entrance, this function provides a automatic help to reposition the player plane inside some buildings pre-configured in "fn_VO_management.sqf" file.
	// Returns nothing.
	
	params [["_veh", objNull], ["_assetsToHelp", []]];

	// Handling Errors:
	if (_veh isEqualTo objNull) exitWith {if VO_debug_isOn then {systemChat "VO ERROR > THY_fnc_VO_parkingHelper: needs a vehicle as parameter."; sleep 15}};
	if (count _assetsToHelp isEqualTo 0) exitWith {if VO_debug_isOn then {systemChat "VO ERROR > THY_fnc_VO_parkingHelper: check fn_VO_management.sqf > VO_airParkingHelperAssets list (looks empty)."; sleep 15}};

	// Parking plane helper:
	if ( (_veh isKindOf "Plane") && (!isEngineOn _veh) && (speed _veh isEqualTo 0) ) then 
	{
		{ // forEach _assetsToHelp...
			if ( (_veh distance _x) < VO_airServiceRange ) then 
			{
				_veh setVelocity  [0,0,0];  // set the vehicle velocity to zero.
				// Best pratices is olways to set the direction right before to set position. Never the opposite to avoid "invisivel" collision issues:
				[_veh, getDir _x - 180] remoteExec ["setDir", _veh];  // as 'setDir' is a LA, and some player pc can be the owner of the veh, send the command to the current PC.
				_veh setPos (_x getRelPos [0,0]);  // set the vehicle position in same place of the asset/station (_x). | object getRelPos [distance from the station center, direction degrees]
				// set the vehicle direction to the opposit of the asset/station (_x):
				sleep 20;
			};
		
		} forEach _assetsToHelp;
		sleep 5;
		
	} else { sleep 5 };

	true  // returning.
};


THY_fnc_VO_serviceExecution = {
	// This function: before the service execution, it makes a last check if the player's vehicle and station still on conditions to get the service.
	// Returns nothing.
	
	params [["_player", objNull], ["_stat", objNull], ["_veh", objNull], ["_service", ""], ["_currentRng", 20], ["_isStatRngChanger", false], ["_isNautic", false], ["_isDroneConnected", false], ["_txtServ1", "fixed"], ["_txtServ2", "The service"]];
	private ["_vehCrew", "_vehType", "_isObjOnSurface", "_isRepaired", "_isRefueled", "_isRearmed", "_vehMags", "_magsRemoved", "_magsLoopChecker", "_mag"];

	// Handling Errors:
	if (_player isEqualTo objNull) exitWith {if VO_debug_isOn then {systemChat "VO ERROR > THY_fnc_VO_serviceExecution: needs a player as parameter."; sleep 15}};
	if (_stat isEqualTo objNull) exitWith {if VO_debug_isOn then {systemChat "VO ERROR > THY_fnc_VO_serviceExecution: needs a service station as parameter."; sleep 15}};
	if (_veh isEqualTo objNull) exitWith {if VO_debug_isOn then {systemChat "VO ERROR > THY_fnc_VO_serviceExecution: needs a vehicle as parameter."; sleep 15}};
	if (_service isEqualTo "") exitWith {if VO_debug_isOn then {systemChat "VO ERROR > THY_fnc_VO_serviceExecution: needs a service as parameter."; sleep 15}};
	
	_vehCrew = crew _veh;
	_vehType = typeOf _veh;

	sleep 3;

	// checks the station and vehicle current conditions:
	if ( (_isStatRngChanger || !underwater _stat) && alive _stat && alive _veh && !(underwater _veh) && (speed _stat) < 1 && (speed _veh) < 1 && (_veh distance _stat) <= _currentRng ) then  // important: if the station is a range-changer, it's crucial considere large ship assets can be a bit under the water, that's why that "OR".
	{
		// Checks if player's vehicle is touching some surface:
		_isObjOnSurface = [_veh] call THY_fnc_VO_isOnSurface;
		if !_isObjOnSurface exitWith { [_player, _veh, _stat, _txtServ2, 3] call THY_fnc_VO_serviceCanceled };  // checking vehicle.
		
		// Checks if the station is touching some surface (ignore it for nautical stations):
		if !_isNautic then {
			_isObjOnSurface = [_stat] call THY_fnc_VO_isOnSurface;
			if ( !_isStatRngChanger && !_isObjOnSurface ) exitWith { [_player, _veh, _stat, _txtServ2, 2] call THY_fnc_VO_serviceCanceled };  // checking station.
		};

		// Initial services status values:
		_isRepaired = false;
		_isRefueled = false;
		_isRearmed = false;

		// Executes the service requested:
		if ( (alive _player) && (alive _stat) && (alive _veh) && (_isDroneConnected || ((_player distance _stat) <= _currentRng)) ) then 
		{
			switch  _service do {
				case "rep":  // REPAIRING
				{ 
					if ( isEngineOn _veh ) exitWith { [_player, _veh, _stat, _txtServ2, 1] call THY_fnc_VO_serviceCanceled };
					
					// Repairing done:
					playSound3D ["a3\sounds_f\sfx\ui\vehicles\vehicle_repair.wss", _veh];
					[[1, 5, 5]] remoteExec ["addCamShake", _vehCrew];  // [power, duration, frequency].
					sleep 1;
					_veh setDamage 0;  // setDamage is a global variable, it doesnt need remoteExec.

					_isRepaired = true;
				};
				
				case "ref":  // REFUELING
				{ 
					if ( isEngineOn _veh ) exitWith { [_player, _veh, _stat, _txtServ2, 1] call THY_fnc_VO_serviceCanceled };
					
					// Refueling done:
					playSound3D ["a3\sounds_f\sfx\ui\vehicles\vehicle_refuel.wss", _veh];
					[[0.3, 5, 2]] remoteExec ["addCamShake", _vehCrew];
					sleep 1;
					[_veh, 1] remoteExec ["setFuel", _veh]; // as 'setFuel' is a LA, and some player can be inside the veh, send the command to current PC that has the veh owership.

					_isRefueled = true;
				};
				
				case "rea":  // REARMING
				{
					
					if ( _veh isKindOf "Plane" || _veh isKindOf "Helicopter" ) then 
					{
						// Specific solution for vehicles with pylons (air) to simplify the rearming as they work differently to turrets:
						[_veh, 1] remoteExec ["setVehicleAmmo", _veh];  // as 'setVehicleAmmo' is a LA, and some player can be inside the veh, send the command to current PC that has the veh owership.

						// Effects:
						playSound3D ["a3\sounds_f\sfx\ui\vehicles\vehicle_rearm.wss", _veh];
						[[1, 6, 3]] remoteExec ["addCamShake", _vehCrew];
						
						sleep 3;
						_isRearmed = true;

					} else {
					
						// Mapping all vehicle mags capacity:
						_vehMags = magazinesAllTurrets _veh;  // list of all magazines (include the empty ones) and its additional data.
						_magsRemoved = [];
						_magsLoopChecker = true;
							
						{  // Looping for remove each mag from the vehicle:
							_mag = _x # 0;  // selecting only the magazine's classname;
							
							// Removing the mag:
							_veh removeMagazineTurret [_mag, [0]];  // [magazineClassname, [turretPath]] https://community.bistudio.com/wiki/Turret_Path
							_magsRemoved pushBack _mag;

						} forEach _vehMags;
						
						{  // Looping for add again each mapped mags:
							// Check service condition before each mag reload:
							if ( ((abs speed _veh) > 1) || ((abs speed _stat) > 1) || (!alive _stat) || ( (!_isDroneConnected) && ((_player distance _stat) > _currentRng) ) ) exitWith
							{ 
								{_veh removeMagazinesTurret [_x, [0]]} forEach _magsRemoved;  // Removes the all mags, including the loaded one to avoid automatic ammo repacking;
								{_veh addMagazineTurret [_x, [0], 1]} forEach _magsRemoved;  // Forces to add again all mags but with 1 ammo only as punishment. Wirhout this line, the code wont reload again when the vehicle return to rearm because it would have all its magazines to rearm.

								[_player, _veh, _stat, "Rearming", 6] call THY_fnc_VO_serviceCanceled;

								_magsLoopChecker = false;
							};
							
							// Adding a new mag:
							_veh addMagazineTurret [_x, [0]];
							if VO_isReporting then {
								if ( _player in _veh ) then {
									format [">> Ammo added: [%1]...", _x] remoteExec ["systemChat", _vehCrew];
								} else {
									format [">> Ammo added: [%1]...", _x] remoteExec ["systemChat", _player];
								};
							};

							// Effects:
							playSound3D ["a3\sounds_f\sfx\ui\vehicles\vehicle_rearm.wss", _veh];
							[[1, 3, 3]] remoteExec ["addCamShake", _vehCrew];
							sleep 1.5;

						} forEach _magsRemoved;

						// This (setVehicleAmmo) will force the rearming for all ammo-capacity of the vehicle:
						if _magsLoopChecker then { [_veh, 1] remoteExec ["setVehicleAmmo", _veh]; _isRearmed = true };
					};
				};
			};

		} else { [_player, _veh, _stat, _txtServ2, 0] call THY_fnc_VO_serviceCanceled };
	
		sleep 3;
		
		// Service successfully complete message:
		if ( alive _veh && (_isRepaired || _isRefueled || _isRearmed) ) then 
		{ 
			if ( _player in _veh ) then 
			{
				format [">> The %1 has been %2!", _vehType, toUpperANSI _txtServ1] remoteExec ["systemChat", _vehCrew];

			} else {

				format [">> The %1 has been %2!", _vehType, toUpperANSI _txtServ1] remoteExec ["systemChat", _player];
			}; 
		};
		
		sleep 3;

	} else { [_player, _veh, _stat, _txtServ2, 0] call THY_fnc_VO_serviceCanceled };

	true
};
