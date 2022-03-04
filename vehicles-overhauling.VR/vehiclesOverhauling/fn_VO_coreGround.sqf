private ["_arrayGrdFullAssets","_arrayGrdRepairAssets","_arrayGrdRefuelAssets","_arrayGrdRearmAssets","_arrayGrdFullAndRepairServ","_arrayGrdFullAndRefuelServ","_arrayGrdFullAndRearmServ","_minDamage","_minFuel",/* "_minAmmo", */"_groundVehicles","_serviceInProgress","_eachGrdVeh","_eachHumamPlayer"];

if ( !groundVehiclesOverhauling ) exitWith {};

// GROUND SERVICES CORE / BE CAREFUL BELOW:

[] spawn 
{ 
	// arrays that will be populated only with the objects found out more below:
	_arrayGrdFullAssets = [];
	_arrayGrdRepairAssets = [];
	_arrayGrdRefuelAssets = [];
	_arrayGrdRearmAssets = [];

	// initial services condition: no one is on any station.
	_serviceInProgress = false; 

	// if the services are allowed, find out only the assets (classnames) listed through fn_VO_parameters.sqf file:
	if ( VO_groundServFull ) then { { _arrayGrdFullAssets = _arrayGrdFullAssets + allMissionObjects _x } forEach VO_grdFullStationAssets	};	
	if ( VO_groundServRepair ) then { { _arrayGrdRepairAssets = _arrayGrdRepairAssets + allMissionObjects _x } forEach VO_grdRepairStationAssets };	
	if ( VO_groundServRefuel ) then { { _arrayGrdRefuelAssets = _arrayGrdRefuelAssets + allMissionObjects _x } forEach VO_grdRefuelStationAssets };	
	if ( VO_groundServRearm ) then { { _arrayGrdRearmAssets = _arrayGrdRearmAssets + allMissionObjects _x } forEach VO_grdRearmStationAssets };
	
	// main ground assets arrays:
	_arrayGrdFullAndRepairServ = _arrayGrdRepairAssets + _arrayGrdFullAssets;
	_arrayGrdFullAndRefuelServ = _arrayGrdRefuelAssets + _arrayGrdFullAssets;
	_arrayGrdFullAndRearmServ = _arrayGrdRearmAssets + _arrayGrdFullAssets;
	
	// minimal vehicle conditions for overhauling:
	_minDamage = 0.1;
	_minFuel = 0.8;
	//_minAmmo = WIP;	
	
	// It removes repairing, refueling and rearming from A3 vanilla's vehicles got those cargo proprieties: 
	{ _x setRepairCargo 0; _x setFuelCargo 0; _x setAmmoCargo 0; } forEach _arrayGrdFullAssets + _arrayGrdRepairAssets + _arrayGrdRefuelAssets + _arrayGrdRearmAssets;
	
	
	while { VO_groundServFull OR VO_groundServRepair OR VO_groundServRefuel OR VO_groundServRearm } do
	{
		// debug:
		if ( VO_debugMonitor ) then	{ call THY_fnc_VO_debugMonitor };
		
		// check who's human here:
		[] call THY_fnc_VO_humanPlayersAlive;
		
		{ // VO_humanPlayersAlive forEach starts...
		
			_eachHumamPlayer = _x;
			
			// defining the ground veh of _eachHumamPlayer into XXm radius:
			_groundVehicles = _x nearEntities [VO_grdVehicleTypes, 10];
			
			{ // forEach of _groundVehicles starts...  
			
				_eachGrdVeh = _x;
				
				// GROUND REPAIR
				{ // forEach of _arrayGrdFullAndRepairServ starts...
				
					// checking the station: if the service is available, the station is alive, the player's veh is close enought, and the station is NOT serving itself, then...
					if ( (VO_groundServRepair) AND (alive _x) AND ( (_eachGrdVeh distance _x) < VO_grdActRange ) AND (_eachGrdVeh != _x) ) then 
					{
						// checking the player veh: 
						if ( (alive _eachGrdVeh) AND (damage _eachGrdVeh > _minDamage) AND (isEngineOn _eachGrdVeh == false) AND (speed _eachGrdVeh < 2 AND speed _eachGrdVeh > -2) AND (_serviceInProgress == false) ) then
						{					
							_serviceInProgress = true;
							sleep 3;
							
							if ( VO_feedbackMsgs ) then 
							{
								["Checking the vehicle damages..."] remoteExec ["systemChat", _eachGrdVeh];               // it shows the message only for who has the _eachGrdVeh locally.
							};
							
							playSound3D ["a3\sounds_f\characters\cutscenes\dirt_acts_carfixingwheel.wss", _x];
							sleep 3;               
							playSound3D ["a3\sounds_f\sfx\ui\vehicles\vehicle_repair.wss", _eachGrdVeh];
							
							// if player inside the vehicle in service:
							if (_eachHumamPlayer in _eachGrdVeh) then
							{     
								[[1, 5, 5]] remoteExec ["addCamShake", _eachHumamPlayer];               // [power, duration, frequency].
							};
							
							_eachGrdVeh setDammage 0;               //setDammage is a global variable, it doesnt need remoteExec.
							
							sleep 3;
							if ( VO_feedbackMsgs ) then 
							{
								["Ground vehicle has been repaired!"] remoteExec ["systemChat", _eachGrdVeh];
								sleep 2;
								
								// checking the vehicle needs and if another service is available for that station:
								[VO_groundServRefuel, _x, _arrayGrdFullAndRefuelServ, _eachGrdVeh, VO_groundServRearm, _arrayGrdFullAndRearmServ, VO_grdCooldown] call THY_fnc_VO_checkNextServiceRefuelOrRearm;
							};
							
							sleep VO_grdCooldown;
							_serviceInProgress = false;               // station is free for the next service!
						};
					};
					
				} forEach _arrayGrdFullAndRepairServ;
				
				// GROUND REFUEL
				{ // forEach of _arrayGrdFullAndRefuelServ starts....
				
					if ( (VO_groundServRefuel) AND (alive _x) AND ( (_eachGrdVeh distance _x) < VO_grdActRange ) AND (_eachGrdVeh != _x) ) then 
					{
						if ( (alive _eachGrdVeh) AND (fuel _eachGrdVeh < _minFuel) AND (isEngineOn _eachGrdVeh == false) AND (speed _eachGrdVeh < 2 AND speed _eachGrdVeh > -2) AND (_serviceInProgress == false) ) then
						{	
							_serviceInProgress = true;
							sleep 3;
							
							if ( VO_feedbackMsgs ) then 
							{
								["Checking the fuel..."] remoteExec ["systemChat", _eachGrdVeh];
							};
												
							playSound3D ["a3\sounds_f\characters\cutscenes\concrete_acts_walkingchecking.wss", _x];
							sleep 3;
							playSound3D ["a3\sounds_f\sfx\ui\vehicles\vehicle_refuel.wss", _eachGrdVeh];
							
							if (_eachHumamPlayer in _eachGrdVeh) then
							{
								[[0.3, 5, 2]] remoteExec ["addCamShake", _eachHumamPlayer];               // [power, duration, frequency].
							};
							
							[_eachGrdVeh, 1] remoteExec ["setFuel", _eachGrdVeh];               //the same as "_eachGrdVeh setFuel 1;" but for multiplayer when the variable (setFuel) is not global variable.
							
							sleep 3;
							if ( VO_feedbackMsgs ) then 
							{
								["Ground vehicle has been refueled!"] remoteExec ["systemChat", _eachGrdVeh];
								sleep 2;
								
								// checking the vehicle needs and if another service is available for that station:
								[VO_groundServRearm, _x, _arrayGrdFullAndRearmServ, _eachGrdVeh, VO_groundServRepair, _arrayGrdFullAndRepairServ, VO_grdCooldown] call THY_fnc_VO_checkNextServiceRearmOrRepair;
							};
							
							sleep VO_grdCooldown;
							_serviceInProgress = false;
						};
					};
					
				} forEach _arrayGrdFullAndRefuelServ;
				
				// GROUND REARM
				{ // forEach of _arrayGrdFullAndRearmServ starts....
				
					if ( (VO_groundServRearm) AND (alive _x) AND ( (_eachGrdVeh distance _x) < VO_grdActRange ) AND (_eachGrdVeh != _x) ) then 
					{
						// checking advanced condition of station:
						[_x, _eachHumamPlayer] call THY_fnc_VO_stationAdvCondition;
						
						if ( (alive _eachGrdVeh) AND ( ({getNumber (configFile >> "CfgMagazines" >> _x select 0 >> "count") != _x select 1} count (magazinesAmmo _eachGrdVeh)) > 0 ) AND (speed _eachGrdVeh < 2 AND speed _eachGrdVeh > -2) AND (_serviceInProgress == false) ) then 
						{
							if (true /* fix this condition: if some available mag is not full, then */) then 
							{
								_serviceInProgress = true; 
								sleep 3;
								
								if ( VO_feedbackMsgs ) then 
								{
									["Checking the vehicle ammunition..."] remoteExec ["systemChat", _eachGrdVeh];
								};
								
								playSound3D ["a3\sounds_f\characters\cutscenes\concrete_acts_walkingchecking.wss", _x];									
								sleep 3;
								playSound3D ["a3\sounds_f\sfx\ui\vehicles\vehicle_rearm.wss", _eachGrdVeh];
								
								if (_eachHumamPlayer in _eachGrdVeh) then
								{
									[[1, 5, 3]] remoteExec ["addCamShake", _eachHumamPlayer];               // [power, duration, frequency].
								};
								
								[_eachGrdVeh, 1] remoteExec ["setVehicleAmmo", _eachGrdVeh];    // the same as "_eachGrdVeh setVehicleAmmo 1" but for multiplayer, because "setVehicleAmmo" is not a global variable.
								
								sleep 3;
								if ( VO_feedbackMsgs ) then 
								{
									["Ground vehicle has been rearmed!"] remoteExec ["systemChat", _eachGrdVeh];
									sleep 2;
									
									// checking the vehicle needs and if another service is available for that station:
									[VO_groundServRepair, _x, _arrayGrdFullAndRepairServ, _eachGrdVeh, VO_groundServRefuel, _arrayGrdFullAndRefuelServ, VO_grdCooldown] call THY_fnc_VO_checkNextServiceRepairOrRefuel;
								};
								
								sleep VO_grdCooldown;
								_serviceInProgress = false;
							}; 
						};
					};
				
				} forEach _arrayGrdFullAndRearmServ;

			} forEach _groundVehicles;
			
		} forEach VO_humanPlayersAlive;
		
		sleep 5;
		if ( VO_debugMonitor ) then { VO_grdCyclesDone = (VO_grdCyclesDone + 1) };
		
	};  // while-looping ends.

};  // spawn ends.