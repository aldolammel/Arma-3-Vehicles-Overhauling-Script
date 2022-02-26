//if (!isServer) exitWith {};

// CORE / BE CAREFUL BELOW:

private ["_arrayAirStations","_airVehicles","_serviceInProgress","_eachAirStation",/*"_airRepairNeeded","_airRefuelNeeded","_airRearmNeeded",*/"_eachHumamPlayer"];

[] spawn 
{

	// arrays that will be populated only with the objects classnames listed by VO_airStationAssets.
	_arrayAirStations = [];

	// initial services condition
	_serviceInProgress = false; 

	// if ground services is allowed... finding out only the objects of classnames listed in _willBeStationForGround through the allMissionsObjects. 
	if ( airVehiclesOverhauling == true ) then { { _arrayAirStations = _arrayAirStations + allMissionObjects _x	} forEach VO_airStationAssets };

	// check whether or not run this while-looping / if some or all services are on, bota pra foder...
	while { airVehiclesOverhauling == true } do
	{
		// check who's human here:
		call THY_fnc_VO_humanPlayersAlive;
		
		{ // VO_humanPlayersAlive forEach starts...
			
			_eachHumamPlayer = _x;
			
			if ( VO_debugMonitor == true ) then { call THY_fnc_VO_debugMonitor };
			
			// defining the air veh of _eachHumamPlayer (_x) into XXm radius:
			_airVehicles = _x nearEntities [["Helicopter", "Plane"], 20];
			
			{ // forEach of _arrayAirStations starts... 
				
				_eachAirStation = _x;
			
				{ // forEach of _airVehicles starts...
					
					if ( (_x distance _eachAirStation) < VO_airActRange ) then
					{
						sleep 3; // a breath before the any air service.
						
						// Air Repair
						if (VO_airServRepair == true) then 
						{
							if ( (alive _x) AND (damage _x > 0.1) AND (isEngineOn _x == false) AND (isTouchingGround _x) AND (speed _x < 1) AND (_serviceInProgress == false) ) then
							{					
								_serviceInProgress = true; 
								sleep 3;
								
								if (VO_feedbackMsgs == true) then 
								{
									systemChat "Checking the damages...";
								};
								
								playSound3D ["a3\sounds_f\characters\cutscenes\dirt_acts_carfixingwheel.wss", _eachAirStation];
								sleep 3;               
								playSound3D ["a3\sounds_f\sfx\ui\vehicles\vehicle_repair.wss", _x];
								
								// if player inside the vehicle:
								if (!isNull objectParent _eachHumamPlayer) then 
								{
									addCamShake [1, 5, 5]; // [power, duration, frequency].
								};
								
								_x setDammage 0;
								
								sleep 3;
								if (VO_feedbackMsgs == true) then 
								{
									systemChat "Air vehicle has been repaired!";
									sleep 2;
									
									if  ( ( (VO_airServRefuel == true) OR (VO_airServRearm == true) ) AND ( (fuel _x < 0.8) OR ( ({getNumber (configFile >> "CfgMagazines" >> _x select 0 >> "count") != _x select 1} count (magazinesAmmo _x)) > 0 ) ) ) then
									{
										systemChat "Preparing to the next service...";
									};
								};
								
								sleep VO_airCooldown;
								_serviceInProgress = false; // station is free for the next service!
							};
						};
						
						// Air Refuel
						if (VO_airServRefuel == true) then 
						{
							if ( (alive _x) AND (fuel _x < 0.8) AND (isEngineOn _x == false) AND (isTouchingGround _x) AND (speed _x < 1) AND (_serviceInProgress == false) ) then
							{	
								_serviceInProgress = true; 
								sleep 3;
								
								if (VO_feedbackMsgs == true) then 
								{
									systemChat "Checking the fuel...";
								};
													
								playSound3D ["a3\sounds_f\characters\cutscenes\concrete_acts_walkingchecking.wss", _eachAirStation];
								sleep 3;
								playSound3D ["a3\sounds_f\sfx\ui\vehicles\vehicle_refuel.wss", _x]; 
								
								if (!isNull objectParent _eachHumamPlayer) then 
								{
									addCamShake [0.3, 5, 2];
								};
								
								_x setFuel 1;
								
								sleep 3;
								if (VO_feedbackMsgs == true) then 
								{
									systemChat "Air vehicle has been refueled!";
									sleep 2;
									
									if  ( ( (VO_airServRepair == true) OR (VO_airServRearm == true) ) AND ( (damage _x > 0.1) OR ( ({getNumber (configFile >> "CfgMagazines" >> _x select 0 >> "count") != _x select 1} count (magazinesAmmo _x)) > 0 ) ) ) then
									{
										systemChat "Preparing to the next service...";
									};
								};
								
								sleep VO_airCooldown;
								_serviceInProgress = false;
							};
							
						};
						
						// Air Rearm
						if (VO_airServRearm == true) then 
						{
							if ( (alive _x) AND ( ({getNumber (configFile >> "CfgMagazines" >> _x select 0 >> "count") != _x select 1} count (magazinesAmmo _x)) > 0 ) AND (isTouchingGround _x) AND (speed _x < 1) AND (_serviceInProgress == false) ) then 
							{
								_serviceInProgress = true;
								sleep 3;
								
								if (VO_feedbackMsgs == true) then 
								{
									systemChat "Checking the ammunition...";
								};
								
								playSound3D ["a3\sounds_f\characters\cutscenes\concrete_acts_walkingchecking.wss", _eachAirStation];									
								sleep 3;
								playSound3D ["a3\sounds_f\sfx\ui\vehicles\vehicle_rearm.wss", _x];
								
								if (!isNull objectParent _eachHumamPlayer) then
								{
									addCamShake [1, 5, 3]; 
								};
								
								_x setVehicleAmmo 1;
								
								sleep 3;
								if (VO_feedbackMsgs == true) then 
								{
									systemChat "Air vehicle has been rearmed!";
									sleep 2;
									
									if  ( ( (VO_airServRepair == true) OR (VO_airServRefuel == true) ) AND ( (damage _x > 0.1) OR (fuel _x < 0.8) ) ) then 
									{
										if (isEngineOn _x == false) then
										{
											systemChat "Preparing to the next service...";
											
										} else 
										{
											systemChat "For the next service, turn off the engine!";
										};
									};
								};
								
								sleep VO_airCooldown;
								_serviceInProgress = false; 
							};
						};
					};

				} forEach _airVehicles;

			} forEach _arrayAirStations;
		
		} forEach VO_humanPlayersAlive;
		
		sleep 5;
	};
	
}; // spawn ends.