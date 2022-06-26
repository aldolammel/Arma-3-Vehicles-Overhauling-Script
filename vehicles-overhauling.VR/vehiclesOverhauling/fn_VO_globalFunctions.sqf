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
	
	params ["_serv", "_veh", "_servRng", "_servProgrs", "_fullAndRepAssets", "_servRefuel", "_fullAndRefAssets", "_servRearm", "_fullAndReaAssets", "_cooldown", ["_nautic", false]];
	private ["_crewVeh"];

	{ // forEach of _fullAndRepAssets starts...
					
		if ( !_serv ) exitWith {};
	
		// checking the basic station (_x) conditions:
		if ( (alive _x) AND ( (_veh distance _x) < _servRng ) AND (_veh != _x) ) then 
		{
			// checking the player veh: 
			if ( (alive _veh) AND (abs speed _veh < 2) AND (!underwater _veh) AND ((getPos _veh) select 2 < 0.1) AND (!_servProgrs) AND (!isEngineOn _veh) AND (damage _veh > VO_minRepairService) ) then
			{					
				if ( VO_feedbackMsgs ) then 
				{				
					format ["Preparing a service... Wait %1 seconds...", _cooldown] remoteExec ["systemChat", _veh];
				};
				sleep _cooldown;
				
				_servProgrs = true;
				
				if ( VO_feedbackMsgs ) then 
				{
					["Checking the vehicle damages..."] remoteExec ["systemChat", _veh];               // it shows the message only for who has the _veh locally.
				};
				
				if (!_nautic) then               // check if the vehicle is nautic to adapt the sound effect.
				{
					playSound3D ["a3\sounds_f\characters\cutscenes\dirt_acts_carfixingwheel.wss", _x];
				} else {
					playSound3D ["a3\sounds_f\characters\cutscenes\water_acts_carfixingwheel.wss", _x]; 
				}; 
				
				// before repair it, last check if the player's vehicle still on conditions:
				if ( ( (_veh distance _x) < _servRng ) AND (!isEngineOn _veh) ) then 
				{
					sleep 3;               
					playSound3D ["a3\sounds_f\sfx\ui\vehicles\vehicle_repair.wss", _veh];
				
					_crewVeh = crew _veh;
					[[1, 5, 5]] remoteExec ["addCamShake", _crewVeh];               // [power, duration, frequency].
					
					_veh setDammage 0;               // setDammage is a global variable, it doesnt need remoteExec.
					
					sleep 3;
					if ( VO_feedbackMsgs ) then 
					{
						["Vehicle has been repaired!"] remoteExec ["systemChat", _veh];
					};
					sleep 2;
				} else {
					format ["The repairing has been canceled!"] remoteExec ["systemChat", _veh];
					sleep 5;
				};
				
				_servProgrs = false;               // station is free for the next service!
			};
		};
		
	} forEach _fullAndRepAssets;
};


// ---------------------------------------------------------------


THY_fnc_VO_servRefuel = 
{
	// This function: provides the refueling functionality for the vehicles parked at station.
	
	params ["_serv", "_veh", "_servRng", "_servProgrs", "_fullAndRefAssets", "_servRearm", "_fullAndReaAssets", "_servRepair", "_fullAndRepAssets", "_cooldown", ["_nautic", false]];
	private ["_crewVeh"];
	
	{ // forEach of _fullAndRefAssets starts....
				
		if ( !_serv ) exitWith {};
		
		// checking the basic station (_x) conditions:
		if ( (alive _x) AND ( (_veh distance _x) < _servRng ) AND (_veh != _x) ) then 
		{
			if ( (alive _veh) AND (abs speed _veh < 2) AND (!underwater _veh) AND ((getPos _veh) select 2 < 0.1) AND (!_servProgrs) AND (!isEngineOn _veh) AND (fuel _veh < VO_minRefuelService) ) then 
			{	
				if ( VO_feedbackMsgs ) then 
				{				
					format ["Preparing a service... Wait %1 seconds...", _cooldown] remoteExec ["systemChat", _veh];
				};
				sleep _cooldown;
				
				_servProgrs = true;
				
				if ( VO_feedbackMsgs ) then 
				{
					["Checking the fuel..."] remoteExec ["systemChat", _veh];
				};
									
				if (!_nautic) then               // check if the vehicle is nautic to adapt the sound effect.
				{
					playSound3D ["a3\sounds_f\characters\cutscenes\concrete_acts_walkingchecking.wss", _x];
				} else {
					playSound3D ["a3\sounds_f\characters\cutscenes\water_acts_walkingchecking.wss", _x]; 
				}; 
				
				// before refuel it, last check if the player's vehicle still on conditions:
				if ( ( (_veh distance _x) < _servRng ) AND (!isEngineOn _veh) ) then 
				{
					sleep 3;               
					playSound3D ["a3\sounds_f\sfx\ui\vehicles\vehicle_refuel.wss", _veh];

					_crewVeh = crew _veh;
					[[0.3, 5, 2]] remoteExec ["addCamShake", _crewVeh];               // [power, duration, frequency].
					
					[_veh, 1] remoteExec ["setFuel", _veh];               //the same as "_veh setFuel 1;" but for multiplayer when the variable (setFuel) is not global variable.
					
					sleep 3;
					if ( VO_feedbackMsgs ) then 
					{
						["Vehicle has been refueled!"] remoteExec ["systemChat", _veh];
					};
					sleep 2;
				} else {
					format ["The refueling has been canceled!"] remoteExec ["systemChat", _veh];
					sleep 5;
				};
				
				_servProgrs = false;
			};
		};
		
	} forEach _fullAndRefAssets;
};


// ---------------------------------------------------------------


THY_fnc_VO_servRearm = 
{
	// This function: provides the rearming functionality for the armed vehicles parked at station.
	
	params ["_serv", "_veh", "_servRng", "_player", "_servProgrs", "_fullAndReaAssets", "_servRepair", "_fullAndRepAssets", "_servRefuel", "_fullAndRefAssets", "_cooldown", ["_nautic", false]];
	private ["_crewVeh"];
	
	{ // forEach of _fullAndReaAssets starts....
				
		if ( !_serv ) exitWith {};
	
		// checking the basic station (_x) conditions + if the vehicle has weaponry:
		if ( (alive _x) AND ( (_veh distance _x) < _servRng ) AND (_veh != _x) ) then 
		{
			// checking the advanced station conditions (for mobile-stations):
			if ( (underwater _x) OR !((getPos _x) select 2 < 0.1) OR (speed _x > 0) ) exitWith              // <<---- "!(isTouchingGround)" is not working reliable!
			{ 
				// checking the player's vehicle:
				if ( !(_player in _x) AND !(vehicle _player isKindOf "Helicopter") AND (count weapons _veh > 0) ) then   // if the player ISN'T in a mobile-station and NOT in a helicopter-transporting-a-rearm-container when the VO_airServiceRange is too large and vehicle has weaponry.
				{
					["The station doesn't meet the conditions to work properly. Try later..."] remoteExec ["systemChat", _player];
					sleep(2);
				};
			};
			
			// checking the player's vehicle conditions:
			if ( (alive _veh) AND (count weapons _veh > 0) AND (abs speed _veh < 2) AND (!underwater _veh) AND ((getPos _veh) select 2 < 0.1) AND (!_servProgrs) AND (({getNumber (configFile >> "CfgMagazines" >> _x select 0 >> "count") != _x select 1} count (magazinesAmmo _veh)) > 0) ) then
			{
				if ( VO_feedbackMsgs ) then 
				{				
					format ["Preparing a service... Wait %1 seconds...", _cooldown] remoteExec ["systemChat", _veh];
				};
				sleep _cooldown;
				
				_servProgrs = true; 
				
				if ( VO_feedbackMsgs ) then 
				{
					["Checking the vehicle ammunition..."] remoteExec ["systemChat", _veh];
				};
				
				// check if the vehicle is nautic to adapt the sound effect:
				if (!_nautic) then
				{
					playSound3D ["a3\sounds_f\characters\cutscenes\concrete_acts_walkingchecking.wss", _x];
				} else {
					playSound3D ["a3\sounds_f\characters\cutscenes\water_acts_carfixingwheel.wss", _x]; 
				}; 
				
				if ( (_veh distance _x) < _servRng ) then 
				{
					sleep 3;               
					playSound3D ["a3\sounds_f\sfx\ui\vehicles\vehicle_rearm.wss", _veh];
					
					_crewVeh = crew _veh;
					[[1, 5, 3]] remoteExec ["addCamShake", _crewVeh];               // [power, duration, frequency].
					
					[_veh, 1] remoteExec ["setVehicleAmmo", _veh];    // the same as "_veh setVehicleAmmo 1" but for multiplayer, because "setVehicleAmmo" is not a global variable.
				
					sleep 3;
					if ( VO_feedbackMsgs ) then 
					{
						["Vehicle has been rearmed!"] remoteExec ["systemChat", _veh];
					};
					sleep 2;
				} else {
					format ["The rearming has been canceled!"] remoteExec ["systemChat", _veh];
					sleep 5;
				};
				
				_servProgrs = false;
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
