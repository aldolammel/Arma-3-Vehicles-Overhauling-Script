//if (!isServer) exitWith {};

// CORE / BE CAREFUL BELOW:

private ["_arrayNauticStations","_nauticVehicles","_serviceInProgress","_eachNauticStation",/* "_nauRepairNeeded","_nauRefuelNeeded","_nauRearmNeeded", */"_eachHumamPlayer"];

[] spawn 
{

	// arrays that will be populated only with the objects classnames listed by VO_nauStationAssets.
	_arrayNauticStations = [];

	// initial services condition
	_serviceInProgress = false; 

	// if ground services is allowed... finding out only the objects of classnames listed in _willBeStationForGround through the allMissionsObjects. 
	if (nauticVehiclesOverhauling) then { { _arrayNauticStations = _arrayNauticStations + allMissionObjects _x } forEach VO_nauStationAssets };

	// check whether or not run this while-looping / if some or all services are on, bota pra foder...
	while { nauticVehiclesOverhauling } do
	{
		// check who's human here:
		call THY_fnc_VO_humanPlayersAlive; 
		
		{ // VO_humanPlayersAlive forEach starts...
			
			_eachHumamPlayer = _x;
			
			if ( VO_debugMonitor == true ) then { call THY_fnc_VO_debugMonitor };
			
			// defining the nautic veh of _eachHumamPlayer (_x) into XXm radius:
			_nauticVehicles = _x nearEntities [["Ship", "Submarine"], 20];
			
			{ // forEach of _arrayNauticStations starts...
				
				_eachNauticStation = _x;
			
				{ // forEach of _nauticVehicles starts...
				
					if ( (_x distance _eachNauticStation) < VO_nauActRange ) then
					{						
						sleep 3; // a breath before the any nautic service.
						
						// Nautic Repair
						if (VO_nauticServRepair == true) then 
						{
							if ( (alive _x) AND (damage _x > 0.1) AND (isEngineOn _x == false) AND (!underwater _x) AND (speed _x < 2) AND (_serviceInProgress == false) ) then
							{					
								_serviceInProgress = true;
								sleep 3;
								
								if (VO_feedbackMsgs == true) then 
								{
									systemChat "Checking the damages...";
								};
								
								playSound3D ["a3\sounds_f\characters\cutscenes\water_acts_carfixingwheel.wss", _eachNauticStation];
								sleep 3;               
								playSound3D ["a3\sounds_f\sfx\ui\vehicles\vehicle_repair.wss", _x];
								
								// if player inside the vehicle:
								if (!isNull objectParent _eachHumamPlayer) then
								{
									addCamShake [1, 5, 5];
								};
								
								_x setDammage 0; 
								
								sleep 3;
								if (VO_feedbackMsgs == true) then 
								{
									systemChat "Nautic vehicle has been repaired!";
									sleep 2;
									
									if  ( ( (VO_nauticServRefuel == true) OR (VO_nauticServRearm == true) ) AND ( (fuel _x < 0.8) OR ( ({getNumber (configFile >> "CfgMagazines" >> _x select 0 >> "count") != _x select 1} count (magazinesAmmo _x)) > 0 ) ) ) then
									{
										systemChat "Preparing to the next service...";
									};
								};
								
								sleep VO_nauCooldown;
								_serviceInProgress = false; 
							};
						};
						
						// Nautic Refuel
						if (VO_nauticServRefuel == true) then 
						{
							if ( (alive _x) AND (fuel _x < 0.8) AND (isEngineOn _x == false) AND (!underwater _x) AND (speed _x < 2) AND (_serviceInProgress == false) ) then
							{	
								_serviceInProgress = true;  
								sleep 3;
								
								if (VO_feedbackMsgs == true) then 
								{
									systemChat "Checking the fuel...";
								};
													
								playSound3D ["a3\sounds_f\characters\cutscenes\water_acts_walkingchecking.wss", _eachNauticStation];
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
									systemChat "Nautic vehicle has been refueled!";
									sleep 2;
									
									if  ( ( (VO_nauticServRepair == true) OR (VO_nauticServRearm == true) ) AND ( (damage _x > 0.1) OR ( ({getNumber (configFile >> "CfgMagazines" >> _x select 0 >> "count") != _x select 1} count (magazinesAmmo _x)) > 0 ) ) ) then
									{
										systemChat "Preparing to the next service...";
									};
								};
								
								sleep VO_nauCooldown;
								_serviceInProgress = false; 
							};
							
						};
						
						// Nautic Rearm
						if (VO_nauticServRearm == true) then 
						{
							if ( (alive _x) AND ( ({getNumber (configFile >> "CfgMagazines" >> _x select 0 >> "count") != _x select 1} count (magazinesAmmo _x)) > 0 ) AND (!underwater _x) AND (speed _x < 2) AND (_serviceInProgress == false) ) then 
							{
								_serviceInProgress = true; 
								sleep 3;
								
								if (VO_feedbackMsgs == true) then 
								{
									systemChat "Checking the ammunition...";
								};
								
								playSound3D ["a3\sounds_f\characters\cutscenes\water_acts_walkingchecking.wss", _eachNauticStation];									
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
									systemChat "Nautic vehicle has been rearmed!";
									sleep 2;
									
									if  ( ( (VO_nauticServRepair == true) OR (VO_nauticServRefuel == true) ) AND ( (damage _x > 0.1) OR (fuel _x < 0.8) ) ) then 
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
								
								sleep VO_nauCooldown;
								_serviceInProgress = false; 
							};
						};
					};

				} forEach _nauticVehicles;

			} forEach _arrayNauticStations;
		
		} forEach VO_humanPlayersAlive;
		
		sleep 5;
	};

}; // spawn ends.