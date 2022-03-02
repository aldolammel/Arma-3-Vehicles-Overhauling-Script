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
		call THY_fnc_VO_humanPlayersAlive; 
		
		{ // VO_humanPlayersAlive forEach starts...
			
			_eachHumamPlayer = _x;
			
			// defining the nautic veh of _eachHumamPlayer (_x) into XXm radius:
			_nauticVehicles = _x nearEntities [VO_nauVehicleTypes, 20];
			
			{ // forEach of _nauticVehicles starts...
				
				_eachNauVeh = _x;
			
				// NAUTIC REPAIR
				{ // forEach of _arrayNauFullAndRepairServ starts...
				
					if ( ( VO_nauticServRepair ) AND ( (_eachNauVeh distance _x) < VO_nauActRange ) ) then 
					{
						if ( (alive _eachNauVeh) AND (damage _eachNauVeh > _minDamage) AND (isEngineOn _eachNauVeh == false) AND (!underwater _eachNauVeh) AND (speed _eachNauVeh < 2) AND (_serviceInProgress == false) ) then
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
							
							// if player inside the vehicle:
							if (!isNull objectParent _eachHumamPlayer) then
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
								if ( ( VO_nauticServRefuel AND ( _x in _arrayNauRefuelAssets ) AND ( fuel _eachNauVeh < _minFuel ) ) OR ( VO_nauticServRearm AND ( _x in _arrayNauRearmAssets ) AND ( ({getNumber (configFile >> "CfgMagazines" >> _x select 0 >> "count") != _x select 1} count (magazinesAmmo _eachNauVeh)) > 0 ) ) ) then
								{
									["Preparing to the next service..."] remoteExec ["systemChat", _eachNauVeh];
								};
							};
							
							sleep VO_nauCooldown;
							_serviceInProgress = false;                // station is free for the next service!
						};
					};
					
				} forEach _arrayNauFullAndRepairServ; 
						
				// NAUTIC REFUEL
				{ // forEach of _arrayNauFullAndRefuelServ starts....
				
					if ( ( VO_nauticServRefuel ) AND ( (_eachNauVeh distance _x) < VO_nauActRange ) ) then 
					{
						if ( (alive _eachNauVeh) AND (fuel _eachNauVeh < _minFuel) AND (isEngineOn _eachNauVeh == false) AND (!underwater _eachNauVeh) AND (speed _eachNauVeh < 2) AND (_serviceInProgress == false) ) then
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
							
							if (!isNull objectParent _eachHumamPlayer) then  
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
								if ( ( VO_nauticServRearm AND ( _x in _arrayNauRearmAssets ) AND ( ({getNumber (configFile >> "CfgMagazines" >> _x select 0 >> "count") != _x select 1} count (magazinesAmmo _eachNauVeh)) > 0 ) ) OR ( VO_nauticServRepair AND ( _x in _arrayNauRepairAssets ) AND ( damage _eachNauVeh > _minDamage ) ) ) then
								{
									["Preparing to the next service..."] remoteExec ["systemChat", _eachNauVeh];
								};
							};
							
							sleep VO_nauCooldown;
							_serviceInProgress = false; 
						};
					};
				
				} forEach _arrayNauFullAndRefuelServ;
						
				// NAUTIC REARM
				{ // forEach of _arrayNauFullAndRearmServ starts....
					
					if ( ( VO_nauticServRearm ) AND ( (_eachNauVeh distance _x) < VO_nauActRange ) ) then  
					{
						// checking the mobile stations are in good conditions to work:
						if (  /* !(isTouchingGround _x) OR */ ( underwater _x ) OR ( speed _x > 0 ) ) exitWith              // <<---- !isTouchingGround is not working reliable!
						{ 
							// checking if the player is NOT in a vehicle-station:
							if !(_eachHumamPlayer in _x) then
							{
								["The station doesn't meet the conditions to work! Try later..."] remoteExec ["systemChat", _eachHumamPlayer];
							};
						};
						
						if ( (alive _eachNauVeh) AND ( ({getNumber (configFile >> "CfgMagazines" >> _x select 0 >> "count") != _x select 1} count (magazinesAmmo _eachNauVeh)) > 0 ) AND (!underwater _eachNauVeh) AND (speed _eachNauVeh < 2) AND (_serviceInProgress == false) ) then 
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
								
								if (!isNull objectParent _eachHumamPlayer) then 
								{
									[[1, 5, 3]] remoteExec ["addCamShake", _eachHumamPlayer];               // [power, duration, frequency].
								};
								
								[_eachNauVeh, 1] remoteExec ["setVehicleAmmo", _eachNauVeh];      // the same as "_eachNauVeh setVehicleAmmo 1" but for multiplayer, because "setVehicleAmmo" is not a global variable.	
								
								sleep 3;
								if ( VO_feedbackMsgs ) then 
								{
									["Nautic vehicle has been rearmed!"] remoteExec ["systemChat", _eachNauVeh];
									sleep 2;
									
									if ( ( VO_nauticServRepair AND ( _x in _arrayNauFullAndRepairServ ) AND ( damage _eachNauVeh > _minDamage ) ) OR ( VO_nauticServRefuel AND ( _x in _arrayNauFullAndRefuelServ ) AND ( fuel _eachNauVeh < _minFuel ) ) ) then 
									{
										if (isEngineOn _eachNauVeh == false) then
										{
											["Preparing to the next service..."] remoteExec ["systemChat", _eachNauVeh];
											
										} 
										else 
										{
											["For the next service, turn off the engine!"] remoteExec ["systemChat", _eachNauVeh];
										};
									};
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