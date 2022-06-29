// File: your_mission\vehiclesOverhauling\fn_VO_parameters.sqf
// Documentation: https://docs.google.com/document/d/1l0MGrLNk6DXZdtq41brhtQLgSxpgPQ4hOj_5fm_KaI8/edit?usp=sharing
// by thy (@aldolammel)

if (!isServer) exitWith {};

// EDITOR'S OPTIONS:

	VO_debugMonitor = false;          // true = turn on the editor hints / false = turn it off. Default: false.
	VO_feedbackMsgs = true;          // true = the station shows service messages in-game for the player (highly recommended) / false = turn it off. Default: true.
	VO_dronesNeedHuman = false;          // true = player presence is mandatory for the vehicle to get a service / false = to get a service, player to be close to drone OR it's enough a connection between player's UAV terminal and drone itself. Default: false. 
	ACE_isLoaded = false;          // true = ACE mod is loaded in the mission / false = not loaded in mission.
	
	
	// GROUND SERVICES
	groundVehiclesOverhauling = true;          // true = the mission needs ground stations / false = doesn't need.
 
		VO_grdServRepair = true;          // true = repair stations for ground veh are available / false = not available.
		VO_grdServRefuel = true;          // true = refuel stations for ground veh are available / false = not available.
		VO_grdServRearm = true;          // true = rearm stations for ground veh are available / false = not available.
		VO_grdServFull = true;          // true = chosen assets will bring all available ground services in one place / false = no full service.
		VO_grdServiceRange = 20;          // in meters, the area around the station that identifies the ground vehicle to be serviced. Default: 20.
		VO_grdCooldown = 10;          // in seconds, time among each available ground services. Default: 30.
		
		// Define which assets (classnames) are ground full (repair, refuel, rearm) stations:
		VO_grdFullAssets = 
		[
			"Land_RepairDepot_01_green_F",
			"Land_RepairDepot_01_tan_F",
			//"Land_Carrier_01_base_F",          // aircraft carrier USS Freedom / it doesnt work well because the asset is too big.
			"Land_RepairDepot_01_civ_F"
		];
		
		// Define which assets (classnames) are ground repair stations:
		VO_grdRepairAssets =          
		[
			"Land_FuelStation_02_workshop_F",
			"I_G_Offroad_01_repair_F",
			"O_G_Offroad_01_repair_F",
			"B_G_Offroad_01_repair_F",
			"C_Truck_02_box_F",
			"I_E_Truck_02_Box_F", 
			"I_Truck_02_box_F", 
			"O_T_Truck_02_Box_F", 
			"O_Truck_02_box_F", 
			"O_T_Truck_03_repair_F",
			"O_Truck_03_repair_F",
			"B_Truck_01_Repair_F",
			"B_T_Truck_01_Repair_F",
			"B_APC_Tracked_01_CRV_F",          // APC CRV Bobcat
			"Land_Pod_Heli_Transport_04_repair_F",          // Taru repair pod
			"B_Slingload_01_Repair_F"          // Huron repair container
		];
		
		// Define which assets (classnames) are ground refuel stations:
		VO_grdRefuelAssets =          
		[
			"Land_fs_feed_F", 
			"Land_FuelStation_Feed_F",
			"Land_FuelStation_03_pump_F",
			"Land_FuelStation_02_pump_F", 
			"Land_FuelStation_01_pump_malevil_F", 
			"Land_FuelStation_01_pump_F",
			"C_Van_01_fuel_F",
			"I_G_Van_01_fuel_F",
			"O_G_Van_01_fuel_F",
			"B_G_Van_01_fuel_F",
			"C_Truck_02_fuel_F",
			"I_E_Truck_02_fuel_F", 
			"I_Truck_02_fuel_F", 
			"O_T_Truck_02_fuel_F", 
			"O_Truck_02_fuel_F", 
			"O_T_Truck_03_fuel_ghex_F",
			"O_Truck_03_fuel_F",
			"B_T_Truck_01_fuel_F", 
			"B_Truck_01_fuel_F", 
			"Land_FuelStation_02_workshop_F",
			"Land_Pod_Heli_Transport_04_fuel_F",          // Taru fuel pod
			"B_Slingload_01_Fuel_F"          // Huron fuel container
		];
		
		// Define which assets (classnames) are ground rearm stations:
		VO_grdRearmAssets =          
		[
			"Land_MRL_Magazine_01_F",
			"I_E_Truck_02_Ammo_F", 
			"I_Truck_02_ammo_F", 
			"O_T_Truck_02_Ammo_F", 
			"O_Truck_02_Ammo_F", 
			"O_T_Truck_03_ammo_ghex_F", 
			"O_Truck_03_ammo_F", 
			"B_T_Truck_01_ammo_F",
			"B_Truck_01_ammo_F",
			"Land_Pod_Heli_Transport_04_ammo_F",          // Taru ammo pod
			"B_Slingload_01_Ammo_F"          // Huron ammo container
		];


	// AIR SERVICES
	airVehiclesOverhauling = true;          // true = the mission needs air stations / false = doesn't need.

		VO_airServRepair = true;          // true = repair stations for air veh are available / false = not available.
		VO_airServRefuel = true;          // true = refuel stations for air veh are available / false = not available.
		VO_airServRearm = true;          // true = rearm stations for air veh are available / false = not available.
		VO_airServFull = true;          // true = chosen assets will bring all available air services in one place / false = no full service. 
		VO_airServiceRange = 20;          // in meters, the area around the station that identifies the air vehicle to be serviced. Default: 20.
		VO_airCooldown = 10;          // in seconds, time among each available air services. Default: 30.
		
		// Define which assets (classnames) are air full (repair, refuel, rearm) stations:
		VO_airFullAssets =          
		[
			"Land_HelipadRescue_F",
			"Land_HelipadSquare_F",
			"Land_HelipadCircle_F",
			"Land_HelipadCivil_F",
			"Land_HelipadEmpty_F",
			"Sign_Arrow_Direction_F",
			"Sign_Arrow_Direction_Blue_F",
			"Sign_Arrow_Direction_Pink_F",
			"Sign_Arrow_Direction_Cyan_F",
			"Sign_Arrow_Direction_Green_F",
			"Sign_Arrow_Direction_Yellow_F",			
			"Land_Hangar_F",
			"Land_Airport_01_hangar_F", 
			//"Land_Destroyer_01_base_F",           // destroyer USS Liberty / it doesnt work well because the asset is too big.
			//"Land_Carrier_01_base_F",          // aircraft carrier USS Freedom / it doesnt work well because the asset is too big.
			"Land_TentHangar_V1_F"
		];
		
		// Define which assets (classnames) are air repair stations:
		VO_airRepairAssets =          
		[ 
			"O_T_Truck_03_repair_F",
			"O_Truck_03_repair_F",
			"B_Truck_01_Repair_F",
			"B_T_Truck_01_Repair_F",
			"Land_Pod_Heli_Transport_04_repair_F",          // Taru repair pod
			"B_Slingload_01_Repair_F"          // Huron repair container
		];
		
		// Define which assets (classnames) are air refuel stations:
		VO_airRefuelAssets =          
		[
			"Land_MobileLandingPlatform_01_F",
			"C_Van_01_fuel_F",
			"I_G_Van_01_fuel_F",
			"O_G_Van_01_fuel_F",
			"B_G_Van_01_fuel_F",
			"C_Truck_02_fuel_F",
			"I_E_Truck_02_fuel_F", 
			"I_Truck_02_fuel_F", 
			"O_T_Truck_02_fuel_F", 
			"O_Truck_02_fuel_F", 
			"O_T_Truck_03_fuel_ghex_F",
			"O_Truck_03_fuel_F",
			"B_T_Truck_01_fuel_F", 
			"B_Truck_01_fuel_F", 
			"Land_FuelStation_02_workshop_F",
			"Land_Pod_Heli_Transport_04_fuel_F",          // Taru fuel pod
			"B_Slingload_01_Fuel_F"          // Huron fuel container
		];
		
		// Define which assets (classnames) are air rearm stations:
		VO_airRearmAssets =          
		[
			"Land_MobileLandingPlatform_01_F",
			"Land_Missle_Trolley_02_F",          // Missiles pod 
			"Land_Bomb_Trolley_01_F",          // Bombs pod 
			"O_T_Truck_03_ammo_ghex_F", 
			"O_Truck_03_ammo_F", 
			"B_T_Truck_01_ammo_F",
			"B_Truck_01_ammo_F",
			"Land_Pod_Heli_Transport_04_ammo_F",          // Taru ammo pod
			"B_Slingload_01_Ammo_F"          // Huron ammo container
		];
		
		// Define which assets (classnames) are allowed to automatically turn parked planes backwards:
		VO_airParkingHelperAssets = 
		[
			"Sign_Arrow_Direction_F",          // TIP: use this arrow (any of 'Sign_Arrow_Direction') when you wanna set a non-editable-map-building as station for planes, putting the arrow into the building and pointing to inside.
			"Sign_Arrow_Direction_Blue_F",
			"Sign_Arrow_Direction_Pink_F",
			"Sign_Arrow_Direction_Cyan_F",
			"Sign_Arrow_Direction_Green_F",
			"Sign_Arrow_Direction_Yellow_F",
			"Land_Hangar_F",
			"Land_Airport_01_hangar_F",
			"Land_TentHangar_V1_F"
		];
	
	
	// NAUTIC SERVICES
	nauticVehiclesOverhauling = true;          // true = the mission needs nautic stations / false = doesn't need.

		VO_nauServRepair = true;          // true = repair stations for nautic veh are available / false = not available.
		VO_nauServRefuel = true;          // true = refuel stations for nautic veh are available / false = not available.
		VO_nauServRearm = true;          // true = rearm stations for nautic veh are available / false = not available.
		VO_nauServFull = true;          // true = chosen assets will bring all available nautic services in one place / false = no full service. 
		VO_nauServiceRange = 20;          // in meters, the area around the station that identifies the nautic vehicle to be serviced. Default: 20.
		VO_nauCooldown = 10;          // in seconds, time among each available nautic services. Default: 30.
		
		// Define which assets (classnames) are nautic full (repair, refuel, rearm) stations:
		VO_nauFullAssets =          
		[
			"Land_TBox_F"
			//"Land_Destroyer_01_base_F",           // destroyer USS Liberty / it doesnt work well because the asset is too big.
			//"Land_Carrier_01_base_F"          // aircraft carrier USS Freedom / it doesnt work well because the asset is too big.
		];
		
		// Define which assets (classnames) are nautic repair stations:
		VO_nauRepairAssets =          
		[
			"O_T_Truck_03_repair_F",
			"O_Truck_03_repair_F",
			"B_Truck_01_Repair_F",
			"B_T_Truck_01_Repair_F",
			"Land_Pod_Heli_Transport_04_repair_F",          // Taru repair pod
			"B_Slingload_01_Repair_F"          // Huron repair container
		];
		
		// Define which assets (classnames) are nautic refuel stations:
		VO_nauRefuelAssets =          
		[
			"Land_fs_feed_F", 
			"Land_FuelStation_Feed_F",
			"Land_FuelStation_03_pump_F",
			"Land_FuelStation_02_pump_F", 
			"Land_FuelStation_01_pump_malevil_F", 
			"Land_FuelStation_01_pump_F",
			"C_Van_01_fuel_F",
			"I_G_Van_01_fuel_F",
			"O_G_Van_01_fuel_F",
			"B_G_Van_01_fuel_F",
			"C_Truck_02_fuel_F",
			"I_E_Truck_02_fuel_F", 
			"I_Truck_02_fuel_F", 
			"O_T_Truck_02_fuel_F", 
			"O_Truck_02_fuel_F", 
			"O_T_Truck_03_fuel_ghex_F",
			"O_Truck_03_fuel_F",
			"B_T_Truck_01_fuel_F", 
			"B_Truck_01_fuel_F", 
			"Land_FuelStation_02_workshop_F",
			"Land_Pod_Heli_Transport_04_fuel_F",          // Taru fuel pod
			"B_Slingload_01_Fuel_F"          // Huron fuel container
		];
		
		// Define which assets (classnames) are nautic rearm stations:
		VO_nauRearmAssets =          
		[
			"O_T_Truck_03_ammo_ghex_F", 
			"O_Truck_03_ammo_F", 
			"B_T_Truck_01_ammo_F",
			"B_Truck_01_ammo_F",
			"Land_Pod_Heli_Transport_04_ammo_F",          // Taru ammo pod
			"B_Slingload_01_Ammo_F"          // Huron ammo container
		];
		
		
	// BE CAREFUL, HIGHLY RECOMMENDED DO NOT CHANGE ANY BELOW: 
	
		// Vehicle types recognized by VO script:
		VO_grdVehicleTypes = [ "Car","Motorcycle","Tank","WheeledAPC","TrackedAPC" ];
		VO_airVehicleTypes = [ "Helicopter","Plane" ];
		VO_nauVehicleTypes = [ "Ship","Submarine" ];
		
		// minimal vehicle conditions for overhauling:
		VO_minRepairService = 0.1; VO_minRefuelService = 0.8;	
		
		// Debug initial counting of while-cycles:
		VO_grdCyclesDone = 0; VO_airCyclesDone = 0; VO_nauCyclesDone = 0; 
		
		// checking if this file is properly configured:
		isStationsOkay = false;
		isServicesOkay = false;
		if (groundVehiclesOverhauling OR airVehiclesOverhauling OR nauticVehiclesOverhauling) then { 
			isStationsOkay = true;
			if ( groundVehiclesOverhauling ) then {	if ( VO_grdServRepair OR VO_grdServRefuel OR VO_grdServRearm ) then {	isServicesOkay = true; } else { systemChat "VEHICLES OVERHAULING > fn_VO_parameters.sqf > No GROUND services set as TRUE!"; }; };
			if ( airVehiclesOverhauling ) then { if ( VO_airServRepair OR VO_airServRefuel OR VO_airServRearm ) then { isServicesOkay = true; } else { systemChat "VEHICLES OVERHAULING > fn_VO_parameters.sqf > No AIR services set as TRUE!"; }; };
			if ( nauticVehiclesOverhauling ) then { if ( VO_nauServRepair OR VO_nauServRefuel OR VO_nauServRearm ) then { isServicesOkay = true; } else { systemChat "VEHICLES OVERHAULING > fn_VO_parameters.sqf > No NAUTIC services set as TRUE!";};};
		} else { systemChat "VEHICLES OVERHAULING > fn_VO_parameters.sqf > The script is NOT running!"; };

	true
