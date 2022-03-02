if (!isServer) exitWith {};

// EDITOR'S OPTIONS:

	VO_debugMonitor = false;          // true = turn on the editor hints / false = turn it off.
	VO_feedbackMsgs = true;          // true = the station shows service messages in-game for the player (highly recommended) / false = turn it off.
	//VO_dronesNeedHuman = false;          // true = drones will need a human player close to get the services / false = turn it off. (WIP)
	
	
	// GROUND SERVICES
	groundVehiclesOverhauling = true;          // true = the mission needs ground stations / false = doesn't need.

		VO_groundServFull = true;          // true = chosen assets will bring all ground services available / false = no full service. 
		VO_groundServRepair = true;          // true = repair stations for ground veh are available / false = not available / highly recommended turn it on if you want also to refueling.
		VO_groundServRefuel = true;          // true = refuel stations for ground veh are available / false = not available.
		VO_groundServRearm = true;          // true = rearm stations for ground veh are available / false = not available.
		VO_grdActRange = 10;          // in meters, the area around the station that identifies the ground vehicle to be serviced. Default 10.
		VO_grdCooldown = 10;          // in seconds, time among each available ground services. Default 10.
		
		// Define which assets (classnames) are ground full (repair, refuel, rearm) stations:
		VO_grdFullStationAssets =          
		[
			"Land_RepairDepot_01_green_F",
			"Land_RepairDepot_01_tan_F",
			//"Land_Carrier_01_base_F",          // aircraft carrier USS Freedom / it doesnt work well because the asset is too big.
			"Land_RepairDepot_01_civ_F"
			
		];
		
		// Define which assets (classnames) are ground repair stations:
		VO_grdRepairStationAssets =          
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
			"Land_Pod_Heli_Transport_04_repair_F",          // Taru repair pod
			"B_Slingload_01_Repair_F"          // Huron repair container
		];
		
		// Define which assets (classnames) are ground refuel stations:
		VO_grdRefuelStationAssets =          
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
		VO_grdRearmStationAssets =          
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

		VO_airServFull = true;          // true = chosen assets will bring all air services available / false = no full service. 
		VO_airServRepair = true;          // true = repair stations for air veh are available / false = not available / highly recommended turn it on if you want also to refueling.
		VO_airServRefuel = true;          // true = refuel stations for air veh are available / false = not available.
		VO_airServRearm = true;          // true = rearm stations for air veh are available / false = not available.
		VO_airActRange = 20;          // in meters, the area around the station that identifies the air vehicle to be serviced. Default 20.
		VO_airCooldown = 10;          // in seconds, time among each available air services. Default 10.
		
		// Define which assets (classnames) are air full (repair, refuel, rearm) stations:
		VO_airFullStationAssets =          
		[
			"Land_HelipadRescue_F",
			"Land_HelipadSquare_F",
			"Land_HelipadCircle_F",
			"Land_HelipadCivil_F",
			"Land_HelipadEmpty_F",  
			"Land_Hangar_F",
			//"Land_Destroyer_01_base_F",           // destroyer USS Liberty / it doesnt work well because the asset is too big.
			//"Land_Carrier_01_base_F",          // aircraft carrier USS Freedom / it doesnt work well because the asset is too big.
			"Land_TentHangar_V1_F"
			
		];
		
		// Define which assets (classnames) are air repair stations:
		VO_airRepairStationAssets =          
		[ 
			"O_T_Truck_03_repair_F",
			"O_Truck_03_repair_F",
			"B_Truck_01_Repair_F",
			"B_T_Truck_01_Repair_F",
			"Land_Pod_Heli_Transport_04_repair_F",          // Taru repair pod
			"B_Slingload_01_Repair_F"          // Huron repair container
		];
		
		// Define which assets (classnames) are air refuel stations:
		VO_airRefuelStationAssets =          
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
		VO_airRearmStationAssets =          
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
	
	
	// NAUTIC SERVICES
	nauticVehiclesOverhauling = true;          // true = the mission needs nautic stations / false = doesn't need.

		VO_nauticServFull = true;          // true = chosen assets will bring all nautic services available / false = no full service. 
		VO_nauticServRepair = true;          // true = repair stations for nautic veh are available / false = not available / highly recommended turn it on if you want also to refueling.
		VO_nauticServRefuel = true;          // true = refuel stations for nautic veh are available / false = not available.
		VO_nauticServRearm = true;          // true = rearm stations for nautic veh are available / false = not available.
		VO_nauActRange = 15;          // in meters, the area around the station that identifies the nautic vehicle to be serviced. Default 15.
		VO_nauCooldown = 10;          // in seconds, time among each available nautic services. Default 10.
		
		// Define which assets (classnames) are nautic full (repair, refuel, rearm) stations:
		VO_nauFullStationAssets =          
		[
			"Land_TBox_F"
			//"Land_Destroyer_01_base_F",           // destroyer USS Liberty / it doesnt work well because the asset is too big.
			//"Land_Carrier_01_base_F"          // aircraft carrier USS Freedom / it doesnt work well because the asset is too big.
		];
		
		// Define which assets (classnames) are nautic repair stations:
		VO_nauRepairStationAssets =          
		[
			"O_T_Truck_03_repair_F",
			"O_Truck_03_repair_F",
			"B_Truck_01_Repair_F",
			"B_T_Truck_01_Repair_F",
			"Land_Pod_Heli_Transport_04_repair_F",          // Taru repair pod
			"B_Slingload_01_Repair_F"          // Huron repair container
		];
		
		// Define which assets (classnames) are nautic refuel stations:
		VO_nauRefuelStationAssets =          
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
		VO_nauRearmStationAssets =          
		[
			"O_T_Truck_03_ammo_ghex_F", 
			"O_Truck_03_ammo_F", 
			"B_T_Truck_01_ammo_F",
			"B_Truck_01_ammo_F",
			"Land_Pod_Heli_Transport_04_ammo_F",          // Taru ammo pod
			"B_Slingload_01_Ammo_F"          // Huron ammo container
		];
		
		
	// BE CAREFUL, HIGHLY RECOMMENDED DO NOT CHANGE ANY BELOW: 
	
		// types of vehicles recognized by VO script:
		VO_grdVehicleTypes = [ "Car","Motorcycle","Tank","WheeledAPC","TrackedAPC" ];
		VO_airVehicleTypes = [ "Helicopter","Plane" ];
		VO_nauVehicleTypes = [ "Ship","Submarine" ];
		
		// Debug initial counting of while-cycles:
		VO_nauCyclesDone = 0; VO_airCyclesDone = 0;	VO_grdCyclesDone = 0;

	true
