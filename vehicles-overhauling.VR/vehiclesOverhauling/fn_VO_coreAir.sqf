private ["_arrayAirFullAssets","_arrayAirRepairAssets","_arrayAirRefuelAssets","_arrayAirRearmAssets","_arrayAirFullAndRepairServ","_arrayAirFullAndRefuelServ","_arrayAirFullAndRearmServ","_minDamage","_minFuel",/* "_minAmmo", */"_airVehicles","_serviceInProgress","_eachAirStation","_eachAirVeh","_eachHumamPlayer"];

if ( !airVehiclesOverhauling ) exitWith {};

// AIR SERVICES CORE / BE CAREFUL BELOW:

[] spawn 
{
	// arrays that will be populated only with the objects found out more below:
	_arrayAirFullAssets = [];
	_arrayAirRepairAssets = [];
	_arrayAirRefuelAssets = [];
	_arrayAirRearmAssets = [];
	
	// initial services condition:
	_serviceInProgress = false; 
	
	// if the services are allowed, find out only the assets (classnames) listed through fn_VO_parameters.sqf file:
	if ( VO_airServFull ) then { { _arrayAirFullAssets = _arrayAirFullAssets + allMissionObjects _x } forEach VO_airFullStationAssets	};	
	if ( VO_airServRepair ) then { { _arrayAirRepairAssets = _arrayAirRepairAssets + allMissionObjects _x } forEach VO_airRepairStationAssets };	
	if ( VO_airServRefuel ) then { { _arrayAirRefuelAssets = _arrayAirRefuelAssets + allMissionObjects _x } forEach VO_airRefuelStationAssets };	
	if ( VO_airServRearm ) then { { _arrayAirRearmAssets = _arrayAirRearmAssets + allMissionObjects _x } forEach VO_airRearmStationAssets };
	
	// main air assets arrays:
	_arrayAirFullAndRepairServ = _arrayAirRepairAssets + _arrayAirFullAssets;
	_arrayAirFullAndRefuelServ = _arrayAirRefuelAssets + _arrayAirFullAssets;
	_arrayAirFullAndRearmServ = _arrayAirRearmAssets + _arrayAirFullAssets;
	
	// minimal vehicle conditions for overhauling:
	_minDamage = 0.1;
	_minFuel = 0.8;
	//_minAmmo = WIP;	
	
	// It removes repairing, refueling and rearming from A3 vanilla's vehicles got those cargo proprieties: 
	{ _x setRepairCargo 0; _x setFuelCargo 0; _x setAmmoCargo 0; } forEach _arrayAirFullAssets + _arrayAirRepairAssets + _arrayAirRefuelAssets + _arrayAirRearmAssets;


	while { VO_airServFull OR VO_airServRepair OR VO_airServRefuel OR VO_airServRearm } do
	{
		// debug:
		if ( VO_debugMonitor ) then	{ call THY_fnc_VO_debugMonitor };
		
		// check who's human here:
		call THY_fnc_VO_humanPlayersAlive;
		
		{ // VO_humanPlayersAlive forEach starts...
			
			_eachHumamPlayer = _x;
			
			// defining the air veh of _eachHumamPlayer (_x) into XXm radius:
			_airVehicles = _x nearEntities [VO_airVehicleTypes, 20];
			
			{ // forEach of _airVehicles starts... 
				
				_eachAirVeh = _x;
						
				// AIR REPAIR
				{ // forEach of _arrayAirFullAndRepairServ starts...
				
					if ( ( VO_airServRepair ) AND ( (_eachAirVeh distance _x) < VO_airActRange ) ) then 
					{
						if ( (alive _eachAirVeh) AND (damage _eachAirVeh > _minDamage) AND (isEngineOn _eachAirVeh == false) AND (isTouchingGround _eachAirVeh) AND (speed _eachAirVeh < 1) AND (_serviceInProgress == false) ) then
						{					
							_serviceInProgress = true; 
							sleep 3;
							
							if ( VO_feedbackMsgs ) then 
							{
								["Checking the vehicle damages..."] remoteExec ["systemChat", _eachAirVeh];               // it shows the message only for who has the _eachAirVeh locally.
							};
							
							playSound3D ["a3\sounds_f\characters\cutscenes\dirt_acts_carfixingwheel.wss", _x];
							sleep 3;               
							playSound3D ["a3\sounds_f\sfx\ui\vehicles\vehicle_repair.wss", _eachAirVeh];
							
							// if player inside the vehicle:
							if (!isNull objectParent _eachHumamPlayer) then 
							{
								[[1, 5, 5]] remoteExec ["addCamShake", _eachHumamPlayer];               // [power, duration, frequency].
							};
							
							_eachAirVeh setDammage 0;               //setDammage is a global variable, it doesnt need remoteExec.
							
							sleep 3;
							if ( VO_feedbackMsgs ) then 
							{
								["Air vehicle has been repaired!"] remoteExec ["systemChat", _eachAirVeh];
								sleep 2;
								
								// checking the vehicle needs and if another service is available for that station:
								if ( ( VO_airServRefuel AND ( _x in _arrayAirRefuelAssets ) AND ( fuel _eachAirVeh < _minFuel ) ) OR ( VO_airServRearm AND ( _x in _arrayAirRearmAssets ) AND ( ({getNumber (configFile >> "CfgMagazines" >> _x select 0 >> "count") != _x select 1} count (magazinesAmmo _eachAirVeh)) > 0 ) ) ) then
								{
									["Preparing to the next service..."] remoteExec ["systemChat", _eachAirVeh];
								};
							};
							
							sleep VO_airCooldown;
							_serviceInProgress = false;               // station is free for the next service!
						};
					};
					
				} forEach _arrayAirFullAndRepairServ;
						
				// AIR REFUEL
				{ // forEach of _arrayAirFullAndRefuelServ starts....
				
					if ( ( VO_airServRefuel ) AND ( (_eachAirVeh distance _x) < VO_airActRange ) ) then  
					{
						if ( (alive _eachAirVeh) AND (fuel _eachAirVeh < _minFuel) AND (isEngineOn _eachAirVeh == false) AND (isTouchingGround _eachAirVeh) AND (speed _eachAirVeh < 1) AND (_serviceInProgress == false) ) then
						{	
							_serviceInProgress = true; 
							sleep 3;
							
							if ( VO_feedbackMsgs ) then 
							{
								["Checking the fuel..."] remoteExec ["systemChat", _eachAirVeh];
							};
												
							playSound3D ["a3\sounds_f\characters\cutscenes\concrete_acts_walkingchecking.wss", _x];
							sleep 3;
							playSound3D ["a3\sounds_f\sfx\ui\vehicles\vehicle_refuel.wss", _eachAirVeh]; 
							
							if (!isNull objectParent _eachHumamPlayer) then 
							{
								[[0.3, 5, 2]] remoteExec ["addCamShake", _eachHumamPlayer];               // [power, duration, frequency].
							};
							
							[_eachAirVeh, 1] remoteExec ["setFuel", _eachAirVeh];               //the same as "_eachAirVeh setFuel 1;" but for multiplayer when the variable (setFuel) is not global variable.
							
							sleep 3;
							if ( VO_feedbackMsgs ) then 
							{
								["Air vehicle has been refueled!"] remoteExec ["systemChat", _eachAirVeh];
								sleep 2;
								
								// checking the vehicle needs and if another service is available for that station:
								if ( ( VO_airServRearm AND ( _x in _arrayAirRearmAssets ) AND ( ({getNumber (configFile >> "CfgMagazines" >> _x select 0 >> "count") != _x select 1} count (magazinesAmmo _eachAirVeh)) > 0 ) ) OR ( VO_airServRepair AND ( _x in _arrayAirRepairAssets ) AND ( damage _eachAirVeh > _minDamage ) ) ) then
								{
									["Preparing to the next service..."] remoteExec ["systemChat", _eachAirVeh];
								};
							};
							
							sleep VO_airCooldown;
							_serviceInProgress = false;
						};
					};
						
				} forEach _arrayAirFullAndRefuelServ;
						
				// AIR REARM
				{ // forEach of _arrayAirFullAndRearmServ starts....
				
					if ( ( VO_airServRearm ) AND ( (_eachAirVeh distance _x) < VO_airActRange ) ) then  
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
						
						if ( (alive _eachAirVeh) AND ( ({getNumber (configFile >> "CfgMagazines" >> _x select 0 >> "count") != _x select 1} count (magazinesAmmo _eachAirVeh)) > 0 ) AND (isTouchingGround _eachAirVeh) AND (speed _eachAirVeh < 1) AND (_serviceInProgress == false) ) then 
						{
							if (true /* fix this condition: if some available mag is not full, then */) then 
							{
								_serviceInProgress = true;
								sleep 3;
								
								if ( VO_feedbackMsgs ) then 
								{
									["Checking the vehicle ammunition..."] remoteExec ["systemChat", _eachAirVeh];
								};
								
								playSound3D ["a3\sounds_f\characters\cutscenes\concrete_acts_walkingchecking.wss", _x];									
								sleep 3;
								playSound3D ["a3\sounds_f\sfx\ui\vehicles\vehicle_rearm.wss", _eachAirVeh];
								
								if (!isNull objectParent _eachHumamPlayer) then
								{
									[[1, 5, 3]] remoteExec ["addCamShake", _eachHumamPlayer];               // [power, duration, frequency]. 
								};
								
								[_eachAirVeh, 1] remoteExec ["setVehicleAmmo", _eachAirVeh];       // the same as "_eachAirVeh setVehicleAmmo 1" but for multiplayer, because "setVehicleAmmo" is not a global variable.
								
								sleep 3;
								if ( VO_feedbackMsgs ) then 
								{
									["Air vehicle has been rearmed!"] remoteExec ["systemChat", _eachAirVeh];
									sleep 2;
									
									if ( ( VO_airServRepair AND ( _x in _arrayAirFullAndRepairServ ) AND ( damage _eachAirVeh > _minDamage ) ) OR ( VO_airServRefuel AND ( _x in _arrayAirFullAndRefuelServ ) AND ( fuel _eachAirVeh < _minFuel ) ) ) then
									{
										if (isEngineOn _eachAirVeh == false) then
										{
											["Preparing to the next service..."] remoteExec ["systemChat", _eachAirVeh];
											
										} 
										else 
										{
											["For the next service, turn off the engine!"] remoteExec ["systemChat", _eachAirVeh];
										};
									};
								};
								
								sleep VO_airCooldown;
								_serviceInProgress = false; 
							};
						};
					};

				} forEach _arrayAirFullAndRearmServ;

			} forEach _airVehicles;
		
		} forEach VO_humanPlayersAlive;
		
		sleep 5;
		if ( VO_debugMonitor ) then { VO_airCyclesDone = (VO_airCyclesDone + 1) };
		
	};  // while-looping ends.

};  // spawn ends.