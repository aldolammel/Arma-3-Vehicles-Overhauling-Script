// File: your_mission\vehiclesOverhauling\fn_VO_globalFunctions.sqf
// by thy (@aldolammel)


THY_fnc_VO_debugMonitor =   // <!----------------------------------------------------------------------- WIP
{
	// This function: helps the editor to find errors and needed adjustments. 
	
	hint format ["\n\nDEBUG MONITOR\n\n- - - THE VEHICLE - - -\nType = %1.\n\n- - - GROUND - - -\nIs there the service = %2.\nAction range= %3m.\nIs there repairing = %4.\nIs there refueling = %5.\nIs there rearming = %6.\nGround while-cycles done: %17x.\n\n- - - AIR - - -\nIs there the service = %7.\nAction range = %8m.\nIs there repairing = %9.\nIs there refueling = %10.\nIs there rearming = %11.\nAir while-cycles done: %18x.\n\n- - - NAUTIC - - -\nIs there the service = %12.\nAction range = %13m.\nIs there repairing = %14.\nIs there refueling = %15.\nIs there rearming = %16.\nNautic while-cycles done: %19x.\n\n", [vehicle player] call BIS_fnc_objectType, groundVehiclesOverhauling, VO_grdServiceRange, VO_grdServRepair, VO_grdServRefuel, VO_grdServRearm, airVehiclesOverhauling, VO_airServiceRange, VO_airServRepair, VO_airServRefuel, VO_airServRearm, nauticVehiclesOverhauling, VO_nauServiceRange, VO_nauServRepair, VO_nauServRefuel, VO_nauServRearm, VO_grdCyclesDone, VO_airCyclesDone, VO_nauCyclesDone];
};


// ---------------------------------------------------------------


THY_fnc_VO_A3CargoOff = 
{
	// This function: removes repairing, refueling and rearming attributes from A3 vanilla's assets.
	
	params ["_fullAssets", "_repAssets", "_refAssets", "_reaAssets"];
	
	{ _x setRepairCargo 0; _x setFuelCargo 0; _x setAmmoCargo 0; } forEach _fullAssets + _repAssets + _refAssets + _reaAssets;
};


// ---------------------------------------------------------------


THY_fnc_VO_servRepair = 
{
	// This function: provides the repairing functionality for the vehicles parked at station.
	
	params ["_serv", "_veh", "_servRng", "_isServProgrs", "_fullAndRepAssets", "_servRefuel", "_fullAndRefAssets", "_servRearm", "_fullAndReaAssets", "_cooldown", ["_isNautic", false]];

	{ // forEach of _fullAndRepAssets starts...
					
		if ( !_serv ) exitWith {};
	
		// checking the basic station (_x) conditions:
		if ( (alive _x) AND ( (_veh distance _x) < _servRng ) AND (_veh != _x) ) then 
		{
			// checking the player veh: 
			if ( (alive _veh) AND (abs speed _veh < 2) AND (!underwater _veh) AND ((getPos _veh) select 2 < 0.1) AND (!_isServProgrs) AND (!isEngineOn _veh) AND (damage _veh > VO_minRepairService) ) then
			{					
				if ( VO_feedbackMsgs ) then 
				{				
					format ["Preparing a service... Wait %1 seconds...", _cooldown] remoteExec ["systemChat", _veh];
				};
				sleep _cooldown;
				
				_isServProgrs = true;
				
				if ( VO_feedbackMsgs ) then 
				{
					["Checking the vehicle damages..."] remoteExec ["systemChat", _veh];               // it shows the message only for who has the _veh locally.
				};
				
				if (!_isNautic) then               // check if the vehicle is nautic to adapt the sound effect.
				{
					playSound3D ["a3\sounds_f\characters\cutscenes\dirt_acts_carfixingwheel.wss", _x];
				} else {
					playSound3D ["a3\sounds_f\characters\cutscenes\water_acts_carfixingwheel.wss", _x]; 
				}; 
				
				// before repairing, last check if the player's vehicle and station still on conditions:
				[_x, _veh, _servRng, _isNautic, "rep", "repaired", "Repairing"] call THY_fnc_VO_stillOnCondition;	
				
				_isServProgrs = false;               // station is free for the next service!
			};
		};
		
	} forEach _fullAndRepAssets;
};


// ---------------------------------------------------------------


THY_fnc_VO_servRefuel = 
{
	// This function: provides the refueling functionality for the vehicles parked at station.
	
	params ["_serv", "_veh", "_servRng", "_isServProgrs", "_fullAndRefAssets", "_servRearm", "_fullAndReaAssets", "_servRepair", "_fullAndRepAssets", "_cooldown", ["_isNautic", false]];
	
	{ // forEach of _fullAndRefAssets starts....
				
		if ( !_serv ) exitWith {};
		
		// checking the basic station (_x) conditions:
		if ( (alive _x) AND ( (_veh distance _x) < _servRng ) AND (_veh != _x) ) then 
		{
			if ( (alive _veh) AND (abs speed _veh < 2) AND (!underwater _veh) AND ((getPos _veh) select 2 < 0.1) AND (!_isServProgrs) AND (!isEngineOn _veh) AND (fuel _veh < VO_minRefuelService) ) then 
			{	
				if ( VO_feedbackMsgs ) then 
				{				
					format ["Preparing a service... Wait %1 seconds...", _cooldown] remoteExec ["systemChat", _veh];
				};
				sleep _cooldown;
				
				_isServProgrs = true;
				
				if ( VO_feedbackMsgs ) then 
				{
					["Checking the fuel..."] remoteExec ["systemChat", _veh];
				};
									
				if (!_isNautic) then               // check if the vehicle is nautic to adapt the sound effect.
				{
					playSound3D ["a3\sounds_f\characters\cutscenes\concrete_acts_walkingchecking.wss", _x];
				} else {
					playSound3D ["a3\sounds_f\characters\cutscenes\water_acts_walkingchecking.wss", _x]; 
				}; 
				
				// before refueling, last check if the player's vehicle and station still on conditions:
				[_x, _veh, _servRng, _isNautic, "ref", "refueled", "Refueling"] call THY_fnc_VO_stillOnCondition;	
				
				_isServProgrs = false;
			};
		};
		
	} forEach _fullAndRefAssets;
};


// ---------------------------------------------------------------


THY_fnc_VO_servRearm = 
{
	// This function: provides the rearming functionality for the armed vehicles parked at station.
	
	params ["_serv", "_veh", "_servRng", "_player", "_isServProgrs", "_fullAndReaAssets", "_servRepair", "_fullAndRepAssets", "_servRefuel", "_fullAndRefAssets", "_cooldown", ["_isNautic", false]];
	
	{ // forEach of _fullAndReaAssets starts....
				
		if ( !_serv ) exitWith {};
	
		// checking the basic station (_x) conditions:
		if ( (alive _x) AND ((_veh distance _x) < _servRng) AND (_veh != _x) ) then 
		{
			if (!_isNautic) then 
			{
				// checking the advanced stations (_x) conditions (to prevent madness with mobile-stations):
				if ( (underwater _x) OR !((getPos _x) select 2 < 0.1) OR (speed _x > 0) ) exitWith              // Important: "!(isTouchingGround)" is not working reliable!
				{ 
					// checking the player's vehicle:
					if ( !(_player in _x) AND !(vehicle _player isKindOf "Helicopter") AND (count weapons _veh > 0) ) then   // if the player ISN'T in a mobile-station and NOT in a helicopter-transporting-a-rearm-container when the VO_airServiceRange is too large and vehicle has weaponry.
					{
						sleep(2);
						["The station doesn't meet the conditions to work properly. Try later..."] remoteExec ["systemChat", _player];
						sleep(1);
					};
				};
			};
			// checking the player's vehicle conditions:
			if ( (alive _veh) AND (count weapons _veh > 0) AND (abs speed _veh < 2) AND (!underwater _veh) AND ((getPos _veh) select 2 < 0.1) AND (!_isServProgrs) AND (({getNumber (configFile >> "CfgMagazines" >> _x select 0 >> "count") != _x select 1} count (magazinesAmmo _veh)) > 0) ) then
			{
				if ( VO_feedbackMsgs ) then 
				{				
					format ["Preparing a service... Wait %1 seconds...", _cooldown] remoteExec ["systemChat", _veh];
				};
				sleep _cooldown;
				
				_isServProgrs = true; 
				
				if ( VO_feedbackMsgs ) then 
				{
					["Checking the vehicle ammunition..."] remoteExec ["systemChat", _veh];
				};
				
				// check if the vehicle is nautic to adapt the sound effect:
				if (!_isNautic) then
				{
					playSound3D ["a3\sounds_f\characters\cutscenes\concrete_acts_walkingchecking.wss", _x];
				} else {
					playSound3D ["a3\sounds_f\characters\cutscenes\water_acts_carfixingwheel.wss", _x]; 
				}; 
				
				// before rearming, last check if the player's vehicle and station still on conditions:
				[_x, _veh, _servRng, _isNautic, "rea", "rearmed", "Rearming"] call THY_fnc_VO_stillOnCondition;
				
				_isServProgrs = false;
			};
		};
	
	} forEach _fullAndReaAssets;
};


// ---------------------------------------------------------------


THY_fnc_VO_parkingHelper = 
{
	// This function: as it's not possible to maneuver planes inside hangars with a single entrance, this function provides a automatic help to reposition the player plane inside some buildings pre-configured in "fn_VO_parameters" file.
	
	params ["_veh", "_assetsToHelp"];
	
	// Parking plane helper:
	if ( (_veh isKindOf "Plane") AND (!isEngineOn _veh) AND (speed _veh == 0) ) then 
	{
		{
			if ( (_veh distance _x) < VO_airServiceRange ) then 
			{
				_veh setVelocity  [0,0,0];                //  set the vehicle velocity to zero.
				_veh setPos (_x getRelPos [0,0]);               // set the vehicle position in same place of the asset/station (_x). | object getRelPos [distance from the station center, direction degrees]
				//[getDir _x - 180] remoteExec ["setDir", _veh];				// set the vehicle direction to the same spot as the asset/station (_x). 
				_veh setDir (getDir _x - 180);               // set the vehicle direction to the same spot as the asset/station (_x).
				sleep(15)               // prevent the plane to re-position over and over again when a player around. 
			};
		
		} forEach _assetsToHelp;
	};
};


// ---------------------------------------------------------------


THY_fnc_VO_stillOnCondition = 
{
	// This function: before the service execution, it makes a last check if the player's vehicle and station still on conditions to get the service.
	
	params ["_stat", "_veh", "_servRng", "_isNautic", "_soundFx", ["_msg1", "fixed"], ["_msg2", "The service"]];
	private ["_crewVeh", "_isReady", "_noTouching"];
	
	_crewVeh = crew _veh;
	_isReady = false;
	_noTouching = false;
	
	if ( (alive _stat) AND (alive _veh) AND !(underwater _stat) AND !(underwater _veh) AND (speed _stat < 1) AND (speed _veh < 1) AND ((_veh distance _stat) < _servRng) ) then 
	{
		sleep 3;
		
		// REPAIRING
		if (_soundFx == "rep") then
		{ 
			if (isEngineOn _veh) exitWith 
			{ 
				format ["%1 canceled! Keep the engine OFF at station.", str(_msg2)] remoteExec ["systemChat", _veh];
			};
			if ( !_isNautic ) then                // Ground and air services need vehicles and the station itself are touching the ground.
			{
				if ( !((getPos _stat) select 2 < 0.1) AND !((getPos _veh) select 2 < 0.1) ) then
				{
					format ["%1 canceled! Keep the vehicle and the station on the ground.", str(_msg2)] remoteExec ["systemChat", _veh];
					_noTouching = true;
				};
			};
			if (_noTouching) exitWith {};                // if true, it will stop the scope right here, prevent to run the scope lines below.
			playSound3D ["a3\sounds_f\sfx\ui\vehicles\vehicle_repair.wss", _veh];
			[[1, 5, 5]] remoteExec ["addCamShake", _crewVeh];                // [power, duration, frequency].
			_veh setDammage 0;                // setDammage is a global variable, it doesnt need remoteExec.
			_isReady = true;
		};
		
		// REFUELING
		if (_soundFx == "ref") then
		{ 
			if (isEngineOn _veh) exitWith
			{
				format ["%1 canceled! Keep the engine OFF at station.", str(_msg2)] remoteExec ["systemChat", _veh];
			}; 
			if ( !_isNautic ) then                // Ground and air services need vehicles and the station itself are touching the ground.
			{
				if ( !((getPos _stat) select 2 < 0.1) AND !((getPos _veh) select 2 < 0.1) ) then
				{
					format ["%1 canceled! Keep the vehicle and the station on the ground.", str(_msg2)] remoteExec ["systemChat", _veh];
					_noTouching = true;
				};
			};
			if (_noTouching) exitWith {};                // if true, it will stop the scope right here, prevent to run the scope lines below.
			playSound3D ["a3\sounds_f\sfx\ui\vehicles\vehicle_refuel.wss", _veh];
			[[0.3, 5, 2]] remoteExec ["addCamShake", _crewVeh];
			[_veh, 1] remoteExec ["setFuel", _veh];               //the same as "_veh setFuel 1;" but for multiplayer when the variable (setFuel) is not global variable.
			_isReady = true;
		};
		
		// REARMING
		if (_soundFx == "rea") then
		{ 
			if ( !_isNautic ) then                // Ground and air services need vehicles and the station itself are touching the ground.
			{
				if ( !((getPos _stat) select 2 < 0.1) AND !((getPos _veh) select 2 < 0.1) ) then
				{
					format ["%1 canceled! Keep the vehicle and the station on the ground.", str(_msg2)] remoteExec ["systemChat", _veh];
					_noTouching = true;
				};
			};
			if (_noTouching) exitWith {};                // if true, it will stop the scope right here, prevent to run the scope lines below.
			playSound3D ["a3\sounds_f\sfx\ui\vehicles\vehicle_rearm.wss", _veh]; 
			[[1, 5, 3]] remoteExec ["addCamShake", _crewVeh];
			[_veh, 1] remoteExec ["setVehicleAmmo", _veh];               // the same as "_veh setVehicleAmmo 1" but for multiplayer, because "setVehicleAmmo" is not a global variable.
			_isReady = true;
		};
	
		sleep 3;
		if ( VO_feedbackMsgs AND _isReady ) then 
		{
			format ["Vehicle has been %1!", str(_msg1)] remoteExec ["systemChat", _veh];
		};
		sleep 2;
	} else {
		format ["%1 has been canceled!", str(_msg2)] remoteExec ["systemChat", _veh];
		sleep 5;
	};
};

