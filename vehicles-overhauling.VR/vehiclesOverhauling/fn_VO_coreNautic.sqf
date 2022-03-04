private ["_arrayNauFullAssets","_arrayNauRepairAssets","_arrayNauRefuelAssets","_arrayNauRearmAssets","_arrayNauFullAndRepairServ","_arrayNauFullAndRefuelServ","_arrayNauFullAndRearmServ","_minDamage","_minFuel",/* "_minAmmo", */"_nauticVehicles","_serviceInProgress","_eachNauVeh","_eachHumamPlayer"];

if ( !nauticVehiclesOverhauling ) exitWith {};

// NAUTIC SERVICES CORE / BE CAREFUL BELOW:

[] spawn 
{
	// arrays that will be populated only with the objects found out more below:
	_arrayNauFullAssets = [];
	_arrayNauRepairAssets = [];
	_arrayNauRefuelAssets = [];
	_arrayNauRearmAssets = [];

	// initial services condition: no one is on any station.
	_serviceInProgress = false; 

	// if the services are allowed, find out only the assets (classnames) listed through fn_VO_parameters.sqf file:
	if ( VO_nauticServFull ) then { { _arrayNauFullAssets = _arrayNauFullAssets + allMissionObjects _x } forEach VO_nauFullStationAssets	};	
	if ( VO_nauticServRepair ) then { { _arrayNauRepairAssets = _arrayNauRepairAssets + allMissionObjects _x } forEach VO_nauRepairStationAssets };	
	if ( VO_nauticServRefuel ) then { { _arrayNauRefuelAssets = _arrayNauRefuelAssets + allMissionObjects _x } forEach VO_nauRefuelStationAssets };	
	if ( VO_nauticServRearm ) then { { _arrayNauRearmAssets = _arrayNauRearmAssets + allMissionObjects _x } forEach VO_nauRearmStationAssets };
	
	// main ground assets arrays:
	_arrayNauFullAndRepairServ = _arrayNauRepairAssets + _arrayNauFullAssets;
	_arrayNauFullAndRefuelServ = _arrayNauRefuelAssets + _arrayNauFullAssets;
	_arrayNauFullAndRearmServ = _arrayNauRearmAssets + _arrayNauFullAssets;
	
	// minimal vehicle conditions for overhauling:
	_minDamage = 0.1;
	_minFuel = 0.8;
	//_minAmmo = WIP;	
	
	// It removes repairing, refueling and rearming from A3 vanilla's vehicles got those cargo proprieties: 
	{ _x setRepairCargo 0; _x setFuelCargo 0; _x setAmmoCargo 0; } forEach _arrayNauFullAssets + _arrayNauRepairAssets + _arrayNauRefuelAssets + _arrayNauRearmAssets;


	while { VO_nauticServFull OR VO_nauticServRepair OR VO_nauticServRefuel OR VO_nauticServRearm } do
	{
		// debug:
		if ( VO_debugMonitor ) then	{ call THY_fnc_VO_debugMonitor };
		
		// check who's human here:
		[] call THY_fnc_VO_humanPlayersAlive; 
		
		{ // VO_humanPlayersAlive forEach starts...
			
			_eachHumamPlayer = _x;
			
			// defining the nautic veh of _eachHumamPlayer (_x) into XXm radius:
			_nauticVehicles = _x nearEntities [VO_nauVehicleTypes, 20];
			
			{ // forEach of _nauticVehicles starts...
				
				_eachNauVeh = _x;
			
				// NAUTIC REPAIR
				{ // forEach of _arrayNauFullAndRepairServ starts...
				
					// checking the station: if the service is available, the station is alive, the player's veh is close enought, and the station is NOT serving itself, then...
					if ( (VO_nauticServRepair) AND (alive _x) AND ( (_eachNauVeh distance _x) < VO_nauActRange ) AND (_eachNauVeh != _x) ) then 
					{
						// checking the player veh:
						if ( (alive _eachNauVeh) AND (damage _eachNauVeh > _minDamage) AND (isEngineOn _eachNauVeh == false) AND (!underwater _eachNauVeh) AND (speed _eachNauVeh < 5 AND speed _eachNauVeh > -5) AND (_serviceInProgress == false) ) then
						{					
							_serviceInProgress = true;
							sleep 3;
							
							if ( VO_feedbackMsgs ) then 
							{
								["Checking the vehicle damages..."] remoteExec ["systemChat", _eachNauVeh];               // it shows the message only for who has the _eachNauVeh locally.
							};
							
							playSound3D ["a3\sounds_f\characters\cutscenes\water_acts_carfixingwheel.wss", _x];
							sleep 3;               
							playSound3D ["a3\sounds_f\sfx\ui\vehicles\vehicle_repair.wss", _eachNauVeh];
							
							// if player inside the vehicle in service:
							if (_eachHumamPlayer in _eachNauVeh) then
							{
								[[1, 5, 5]] remoteExec ["addCamShake", _eachHumamPlayer];               // [power, duration, frequency].
							};
							
							_eachNauVeh setDammage 0;                //setDammage is a global variable, it doesnt need remoteExec.
							
							sleep 3;
							if ( VO_feedbackMsgs ) then 
							{
								["Nautic vehicle has been repaired!"] remoteExec ["systemChat", _eachNauVeh];
								sleep 2;
								
								// checking the vehicle needs and if another service is available for that station:
								[VO_nauticServRefuel, _x, _arrayNauFullAndRefuelServ, _eachNauVeh, VO_nauticServRearm, _arrayNauFullAndRearmServ, VO_nauCooldown] call THY_fnc_VO_checkNextServiceRefuelOrRearm;
							};
							
							sleep VO_nauCooldown;
							_serviceInProgress = false;                // station is free for the next service!
						};
					};
					
				} forEach _arrayNauFullAndRepairServ; 
						
				// NAUTIC REFUEL
				{ // forEach of _arrayNauFullAndRefuelServ starts....
				
					if ( (VO_nauticServRefuel) AND (alive _x) AND ( (_eachNauVeh distance _x) < VO_nauActRange ) AND (_eachNauVeh != _x) ) then 
					{
						if ( (alive _eachNauVeh) AND (fuel _eachNauVeh < _minFuel) AND (isEngineOn _eachNauVeh == false) AND (!underwater _eachNauVeh) AND (speed _eachNauVeh < 5 AND speed _eachNauVeh > -5) AND (_serviceInProgress == false) ) then
						{	
							_serviceInProgress = true;  
							sleep 3;
							
							if ( VO_feedbackMsgs ) then 
							{
								["Checking the fuel..."] remoteExec ["systemChat", _eachNauVeh];
							};
												
							playSound3D ["a3\sounds_f\characters\cutscenes\water_acts_walkingchecking.wss", _x];
							sleep 3;
							playSound3D ["a3\sounds_f\sfx\ui\vehicles\vehicle_refuel.wss", _eachNauVeh];
							
							if (_eachHumamPlayer in _eachNauVeh) then  
							{
								[[0.3, 5, 2]] remoteExec ["addCamShake", _eachHumamPlayer];               // [power, duration, frequency].
							};
							
							[_eachNauVeh, 1] remoteExec ["setFuel", _eachNauVeh];               //the same as "_eachNauVeh setFuel 1;" but for multiplayer when the variable (setFuel) is not global variable.
							
							sleep 3;
							if ( VO_feedbackMsgs ) then 
							{
								["Nautic vehicle has been refueled!"] remoteExec ["systemChat", _eachNauVeh];
								sleep 2;
								
								// checking the vehicle needs and if another service is available for that station:
								[VO_nauticServRearm, _x, _arrayNauFullAndRearmServ, _eachNauVeh, VO_nauticServRepair, _arrayNauFullAndRepairServ, VO_nauCooldown] call THY_fnc_VO_checkNextServiceRearmOrRepair;
							};
							
							sleep VO_nauCooldown;
							_serviceInProgress = false; 
						};
					};
				
				} forEach _arrayNauFullAndRefuelServ;
						
				// NAUTIC REARM
				{ // forEach of _arrayNauFullAndRearmServ starts....
					
					if ( (VO_nauticServRearm) AND (alive _x) AND ( (_eachNauVeh distance _x) < VO_nauActRange ) AND (_eachNauVeh != _x) ) then  
					{
						// checking advanced condition of station:
						[_x, _eachHumamPlayer] call THY_fnc_VO_stationAdvCondition;
						
						if ( (alive _eachNauVeh) AND ( ({getNumber (configFile >> "CfgMagazines" >> _x select 0 >> "count") != _x select 1} count (magazinesAmmo _eachNauVeh)) > 0 ) AND (!underwater _eachNauVeh) AND (speed _eachNauVeh < 5 AND speed _eachNauVeh > -5) AND (_serviceInProgress == false) ) then 
						{
							if (true /* fix this condition: if some available mag is not full, then */) then 
							{
								_serviceInProgress = true; 
								sleep 3;
								
								if ( VO_feedbackMsgs ) then 
								{
									["Checking the vehicle ammunition..."] remoteExec ["systemChat", _eachNauVeh];
								};
								
								playSound3D ["a3\sounds_f\characters\cutscenes\water_acts_walkingchecking.wss", _x];									
								sleep 3;
								playSound3D ["a3\sounds_f\sfx\ui\vehicles\vehicle_rearm.wss", _eachNauVeh];
								
								if (_eachHumamPlayer in _eachNauVeh) then 
								{
									[[1, 5, 3]] remoteExec ["addCamShake", _eachHumamPlayer];               // [power, duration, frequency].
								};
								
								[_eachNauVeh, 1] remoteExec ["setVehicleAmmo", _eachNauVeh];      // the same as "_eachNauVeh setVehicleAmmo 1" but for multiplayer, because "setVehicleAmmo" is not a global variable.	
								
								sleep 3;
								if ( VO_feedbackMsgs ) then 
								{
									["Nautic vehicle has been rearmed!"] remoteExec ["systemChat", _eachNauVeh];
									sleep 2;
									
									// checking the vehicle needs and if another service is available for that station:
									[VO_nauticServRepair, _x, _arrayNauFullAndRepairServ, _eachNauVeh, VO_nauticServRefuel, _arrayNauFullAndRefuelServ, VO_nauCooldown] call THY_fnc_VO_checkNextServiceRepairOrRefuel;
								};
							
								sleep VO_nauCooldown;
								_serviceInProgress = false; 
							};
						};
					};

				} forEach _arrayNauFullAndRearmServ;

			} forEach _nauticVehicles;
		
		} forEach VO_humanPlayersAlive;
		
		sleep 5;
		if ( VO_debugMonitor ) then { VO_nauCyclesDone = (VO_nauCyclesDone + 1) };
		
	};  // while-looping ends.

};  // spawn ends.