//if (!isServer) exitWith {};

// CORE / BE CAREFUL BELOW:

private ["_arrayGroundStations","_groundVehicles","_serviceInProgress","_eachGroundStation",/*"_grdRepairNeeded","_grdRefuelNeeded","_grdRearmNeeded",*/"_eachHumamPlayer"];

[] spawn 
{

	// arrays that will be populated only with the objects classnames listed by VO_grdStationAssets.
	_arrayGroundStations = [];

	// initial services condition
	_serviceInProgress = false; 

	// if ground services is allowed... finding out only the objects of classnames listed in VO_grdStationAssets through the allMissionsObjects. 
	if ( groundVehiclesOverhauling == true ) then {	{ _arrayGroundStations = _arrayGroundStations + allMissionObjects _x } forEach VO_grdStationAssets	};

	// check whether or not run this while-looping / if some or all services are on, bota pra foder...
	while { groundVehiclesOverhauling == true } do
	{
		// check who's human here:
		call THY_fnc_VO_humanPlayersAlive;
		
		{ // VO_humanPlayersAlive forEach starts...
		
			_eachHumamPlayer = _x;
			
			if ( VO_debugMonitor == true ) then	{ call THY_fnc_VO_debugMonitor };
			
			// defining the ground veh of _eachHumamPlayer (_x) into XXm radius:
			_groundVehicles = _x nearEntities [["Car", "Motorcycle", "Tank", "WheeledAPC", "TrackedAPC"], 10];
			
			{ // forEach of _arrayGroundStations starts...  
				
				_eachGroundStation = _x;
			
				{ // forEach of _groundVehicles starts...  
				
					if ( (_x distance _eachGroundStation) < VO_grdActRange ) then
					{
						sleep 3; // a breath before the any ground service.
						
						// GROUND REPAIR
						if (VO_groundServRepair == true) then 
						{
							if ( (alive _x) AND (damage _x > 0.1) AND (isEngineOn _x == false) AND (speed _x < 2) AND (_serviceInProgress == false) ) then
							{					
								_serviceInProgress = true;
								sleep 3;
								
								if (VO_feedbackMsgs == true) then 
								{
									systemChat "Checking the damages...";
								};
								
								playSound3D ["a3\sounds_f\characters\cutscenes\dirt_acts_carfixingwheel.wss", _eachGroundStation];
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
									systemChat "Ground vehicle has been repaired!";
									sleep 2;
									
									if  ( ( (VO_groundServRefuel == true) OR (VO_groundServRearm == true) ) AND ( (fuel _x < 0.8) OR ( ({getNumber (configFile >> "CfgMagazines" >> _x select 0 >> "count") != _x select 1} count (magazinesAmmo _x)) > 0 ) ) ) then
									{
										systemChat "Preparing to the next service...";
									};
								};
								
								sleep VO_grdCooldown;
								_serviceInProgress = false; // station is free for the next service!
							};
						};
						
						// GROUND REFUEL
						if (VO_groundServRefuel == true) then 
						{
							if ( (alive _x) AND (fuel _x < 0.8) AND (isEngineOn _x == false) AND (speed _x < 2) AND (_serviceInProgress == false) ) then
							{	
								_serviceInProgress = true;
								sleep 3;
								
								if (VO_feedbackMsgs == true) then 
								{
									systemChat "Checking the fuel...";
								};
													
								playSound3D ["a3\sounds_f\characters\cutscenes\concrete_acts_walkingchecking.wss", _eachGroundStation];
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
									systemChat "Ground vehicle has been refueled!";
									sleep 2;
									
									if  ( ( (VO_groundServRepair == true) OR (VO_groundServRearm == true) ) AND ( (damage _x > 0.1) OR ( ({getNumber (configFile >> "CfgMagazines" >> _x select 0 >> "count") != _x select 1} count (magazinesAmmo _x)) > 0 ) ) ) then
									{
										systemChat "Preparing to the next service...";
									};
								};
								
								sleep VO_grdCooldown;
								_serviceInProgress = false;
							};
							
						};
						
						// GROUND REARM
						if (VO_groundServRearm == true) then 
						{
							if ( (alive _x) AND ( ({getNumber (configFile >> "CfgMagazines" >> _x select 0 >> "count") != _x select 1} count (magazinesAmmo _x)) > 0 ) AND (speed _x < 2) AND (_serviceInProgress == false) ) then 
							{
								_serviceInProgress = true; 
								sleep 3;
								
								if (VO_feedbackMsgs == true) then 
								{
									systemChat "Checking the ammunition...";
								};
								
								playSound3D ["a3\sounds_f\characters\cutscenes\concrete_acts_walkingchecking.wss", _eachGroundStation];									
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
									systemChat "Ground vehicle has been rearmed!";
									sleep 2;
									
									if  ( ( (VO_groundServRepair == true) OR (VO_groundServRefuel == true) ) AND ( (damage _x > 0.1) OR (fuel _x < 0.8) ) ) then 
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
								
								sleep VO_grdCooldown;
								_serviceInProgress = false;
							};
						};
					};

				} forEach _groundVehicles;

			} forEach _arrayGroundStations;	
			
		} forEach VO_humanPlayersAlive;
		
		sleep 5;
	};

}; // spawn ends.