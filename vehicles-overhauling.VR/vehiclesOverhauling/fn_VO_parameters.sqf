// VO v1.7
// File: your_mission\vehiclesOverhauling\fn_VO_parameters.sqf
// Documentation: https://docs.google.com/document/d/1l0MGrLNk6DXZdtq41brhtQLgSxpgPQ4hOj_5fm_KaI8/edit?usp=sharing
// by thy (@aldolammel)

if (!isServer) exitWith {};

// EDITOR'S OPTIONS:

	VO_debugMonitor = true;          // true = turn on to test the script config / false = turn it off. Default: false.
	VO_feedbackMsgs = true;          // true = the station shows all service messages of feedback for the driver (recommended) / false = turns off the most feedbacks messages, keeping the critical ones. Default: true.
	VO_dronesNeedHuman = false;          // true = player presence is mandatory for the vehicle to get a service / false = to get a service, player to be close to drone OR it's enough a connection between player's UAV terminal and drone itself. Default: false. 
	
	// GROUND SERVICES
	groundVehiclesOverhauling = true;          // true = the mission needs ground stations / false = doesn't need.
 
		VO_grdServRepair = true;          // true = repair stations for ground veh are available / false = not available.
		VO_grdServRefuel = true;          // true = refuel stations for ground veh are available / false = not available.
		VO_grdServRearm = true;          // true = rearm stations for ground veh are available / false = not available.
		VO_grdServFull = true;          // true = chosen assets will bring all available ground services in one place / false = no full service.
		VO_grdServiceRange = 20;          // in meters, the area around the station that identifies the ground vehicle to be serviced. Default: 20.
		VO_grdCooldown = 10;          // in seconds, time among each available ground services. Default: 10.
		
		// Define which assets (classnames) are ground full (repair, refuel, rearm) stations:
		VO_grdFullAssets = 
		[
			"Land_RepairDepot_01_green_F",
			"Land_RepairDepot_01_tan_F"
			//"Land_RepairDepot_01_civ_F",          // should be a full station 'coz it's a civilian station (with no ammunition).
			//"Land_Carrier_01_base_F",          // aircraft carrier USS Freedom / doesnt work well 'coz the asset is too big.
			// from CUP:
			// "CUP_Type072_Main",          // navy / doesn't work well 'coz the asset is too big.
			// "CUP_B_LPD_SAN_ANTONIO_USMC_Empty",          // navy / doesn't work well 'coz the asset is too big.
			// "CUP_B_LHD_WASP_USMC_Empty",          // navy / doesn't work well 'coz the asset is too big.
			// "CUP_B_LHD_WASP_RUNWAY_USMC_SEA_CONTROL",          // navy / doesn't work well 'coz the asset is too big.
			// "CUP_B_LHD_WASP_RUNWAY_USMC"          // navy / doesn't work well 'coz the asset is too big.
		];
		
		// Define which assets (classnames) are ground repair stations:
		VO_grdRepairAssets =          
		[
			"Land_RepairDepot_01_civ_F",
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
			"O_Heli_Transport_04_repair_F",          // Helicopter Taru + repair container
			"Land_Pod_Heli_Transport_04_repair_F",          // Taru repair pod
			"B_Slingload_01_Repair_F",          // Huron repair container
			// from RHS:
			"rhsgref_cdf_b_ural_repair",
			"rhsusf_M977A4_REPAIR_usarmy_d",
			"rhsusf_M977A4_REPAIR_usarmy_wd",
			"rhsusf_M977A4_REPAIR_BKIT_usarmy_d",
			"rhsusf_M977A4_REPAIR_BKIT_usarmy_wd",
			"rhsusf_M977A4_REPAIR_BKIT_M2_usarmy_d",
			"rhsusf_M977A4_REPAIR_BKIT_M2_usarmy_wd",
			// from CUP:
			"CUP_B_T810_Repair_CZ_WDL", 
			"CUP_B_T810_Repair_CZ_DES", 
			"CUP_B_MTVR_Repair_BAF_WOOD", 
			"CUP_B_MTVR_Repair_BAF_DES", 
			"CUP_B_M113A3_Repair_GER", 
			"CUP_B_Kamaz_Repair_CDF", 
			"CUP_B_Ural_Repair_CDF", 
			"CUP_B_MTVR_Repair_HIL", 
			"CUP_B_nM1038_Repair_NATO", 
			"CUP_B_nM1038_Repair_DF_NATO", 
			"CUP_B_nM1038_Repair_NATO_T", 
			"CUP_B_nM1038_Repair_DF_NATO_T", 
			"CUP_B_M113A3_Repair_desert_USA", 
			"CUP_B_M113A3_Repair_olive_USA", 
			"CUP_B_M113A3_Repair_USA", 
			"CUP_B_nM1038_Repair_USA_DES", 
			"CUP_B_nM1038_Repair_DF_USA_DES", 
			"CUP_B_MTVR_Repair_USA", 
			"CUP_B_nM1038_Repair_USA_WDL", 
			"CUP_B_nM1038_Repair_DF_USA_WDL", 
			"CUP_B_nM1038_Repair_USMC_WDL", 
			"CUP_B_nM1038_Repair_DF_USMC_WDL", 
			"CUP_B_MTVR_Repair_USMC", 
			"CUP_B_nM1038_Repair_USMC_DES", 
			"CUP_B_nM1038_Repair_DF_USMC_DES", 
			"CUP_O_Kamaz_Repair_RU", 
			"CUP_O_Ural_Repair_RU", 
			"CUP_O_Ural_Repair_CHDKZ", 
			"CUP_O_Ural_Repair_SLA", 
			"CUP_O_M113A3_Repair_TKA", 
			"CUP_O_V3S_Repair_TKA", 
			"CUP_O_Ural_Repair_TKA", 
			"CUP_O_V3S_Repair_TKM", 
			"CUP_I_M113A3_Repair_AAF", 
			"CUP_I_nM1038_Repair_ION", 
			"CUP_I_nM1038_Repair_DF_ION", 
			"CUP_I_Van_Repair_ION", 
			"CUP_I_nM1038_Repair_ION_WIN", 
			"CUP_I_nM1038_Repair_DF_ION_WIN", 
			"CUP_I_T810_Repair_LDF", 
			"CUP_I_M113A3_Repair_RACS", 
			"CUP_I_MTVR_Repair_RACS", 
			"CUP_I_V3S_Repair_TKG", 
			"CUP_I_M113A3_Repair_UN", 
			"CUP_I_Ural_Repair_UN"
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
			"O_Heli_Transport_04_fuel_F",          // Helicopter Taru + fuel container.
			"Land_FuelStation_02_workshop_F",
			"Land_Pod_Heli_Transport_04_fuel_F",          // Taru fuel pod
			"B_Slingload_01_Fuel_F",          // Huron fuel container
			"Land_dp_smallTank_old_F",          // building fuel storage
			"Land_dp_bigTank_old_F",          // building fuel storage
			// "Land_MetalBarrel_F",          // too small to refuel many times. Not recommended.
			//"FlexibleTank_01_forest_F",          // too small to refuel many times. Not recommended.
			//"FlexibleTank_01_sand_F",          // too small to refuel many times. Not recommended.
			//"Land_CanisterFuel_F",          // too small to refuel many times. Not recommended.
			//"Land_CanisterFuel_Blue_F",          // too small to refuel many times. Not recommended.
			//"Land_CanisterFuel_Red_F",          // too small to refuel many times. Not recommended.
			//"Land_CanisterFuel_White_F",          // too small to refuel many times. Not recommended.
			"StorageBladder_01_fuel_forest_F", 
			"StorageBladder_01_fuel_sand_F", 
			"CargoNet_01_barrels_F",
			// from RHS:
			"RHS_Ural_Fuel_VDV_01",
			"RHS_Ural_Fuel_MSV_01",
			"RHS_Ural_Fuel_VV_01",
			"rhsgref_cdf_b_ural_fuel",
			"rhsgref_nat_van_fuel",
			"rhsgref_cdf_ural_fuel",
			"rhssaf_army_o_ural_fuel",
			"rhssaf_army_ural_fuel",
			// from CUP:
			"CUP_B_MTVR_Refuel_BAF_DES",
			"CUP_B_MTVR_Refuel_BAF_WOOD",
			"CUP_B_Ural_Refuel_CDF",
			"CUP_B_MTVR_Refuel_HIL",
			"CUP_B_MTVR_Refuel_USA",
			"CUP_B_MTVR_Refuel_USMC",
			"CUP_O_Ural_Refuel_RU",
			"CUP_O_Ural_Refuel_CHDKZ",
			"CUP_O_Ural_Refuel_SLA",
			"CUP_O_V3S_Refuel_TKA",
			"CUP_O_Ural_Refuel_TKA",
			"CUP_O_V3S_Refuel_TKM",
			"CUP_I_MTVR_Refuel_RACS",
			"CUP_I_V3S_Refuel_TKG",
			//"Fuel_can",          // too small to refuel many times. Not recommended.
			//"Barrel5",          // too small to refuel many times. Not recommended.
			"Land_A_FuelStation_Feed",          // pump
			"Land_Ind_FuelStation_Feed_EP1",          // pump
			"Land_FuelStation_Feed_PMC",          // pump
			"Land_fuel_tank_small",
			"Land_Ind_TankSmall2_EP1", 
			"Land_Ind_TankSmall2", 
			"Land_Fuel_tank_big", 
			"Land_Fuel_tank_stairs", 
			"Land_Fuelstation", 
			"Land_Fuelstation_army",
			"Land_Benzina_schnell" 
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
			"O_Heli_Transport_04_ammo_F",          // Helicopter Taru + ammo container
			"Land_Pod_Heli_Transport_04_ammo_F",          // Taru ammo pod
			"B_Slingload_01_Ammo_F",          // Huron ammo container
			"Land_Garaz_bez_tanku",          // Ammo bunker
			"Land_Garaz_s_tankem",          // Ammo bunker
			"Land_Ammostore2",          // Ammo bunker
			// from RHS:
			"rhsgref_cdf_b_gaz66_ammo",
			"rhsgref_cdf_gaz66_ammo",
			"rhsgref_ins_g_gaz66_ammo",
			"rhs_gaz66_ammo_vv",
			"rhs_gaz66_ammo_vdv",
			"rhs_gaz66_ammo_vmf",
			"rhs_gaz66_ammo_msv",
			"rhs_kamaz5350_ammo_vv",
			"rhs_kamaz5350_ammo_msv",
			"rhs_kamaz5350_ammo_vmf",
			"rhs_kamaz5350_ammo_vdv",
			"RHS_Ural_Ammo_VDV_01",
			"RHS_Ural_Ammo_VMF_01",
			"RHS_Ural_Ammo_VV_01",
			"rhsusf_m113_usarmy_supply",
			"rhsusf_m113d_usarmy_supply",
			"rhsusf_M977A4_AMMO_usarmy_d",
			"rhsusf_M977A4_AMMO_usarmy_wd",
			"rhsusf_M977A4_AMMO_BKIT_usarmy_d",
			"rhsusf_M977A4_AMMO_BKIT_usarmy_wd",
			"rhsusf_M977A4_AMMO_BKIT_M2_usarmy_d",
			"rhsusf_M977A4_AMMO_BKIT_M2_usarmy_wd",
			// from CUP:
			"CUP_B_M113A3_Reammo_GER", 
			"CUP_B_Kamaz_Reammo_CDF",
			"CUP_B_Ural_Reammo_CDF", 
			"CUP_B_MTVR_Ammo_HIL", 
			"CUP_B_M113A3_Reammo_desert_USA", 
			"CUP_B_M113A3_Reammo_olive_USA",
			"CUP_B_M113A3_Reammo_USA", 
			"CUP_B_MTVR_Ammo_USA",
			"CUP_B_MTVR_Ammo_USMC", 
			"CUP_O_Kamaz_Reammo_RU",
			"CUP_O_Ural_Reammo_RU", 
			"CUP_O_Ural_Reammo_CHDKZ",
			"CUP_O_Ural_Reammo_SLA", 
			"CUP_O_M113A3_Reammo_TKA",
			"CUP_O_Ural_Reammo_TKA", 
			"CUP_I_M113A3_Reammo_AAF",
			"CUP_I_Van_ammo_ION", 
			"CUP_I_T810_Reammo_LDF",
			"CUP_I_M113A3_Reammo_RACS", 
			"CUP_I_MTVR_Ammo_RACS",
			"CUP_I_M113A3_Reammo_UN", 
			"CUP_I_Ural_Reammo_UN"
		];


	// AIR SERVICES
	airVehiclesOverhauling = true;          // true = the mission needs air stations / false = doesn't need.

		VO_airServRepair = true;          // true = repair stations for air veh are available / false = not available.
		VO_airServRefuel = true;          // true = refuel stations for air veh are available / false = not available.
		VO_airServRearm = true;          // true = rearm stations for air veh are available / false = not available.
		VO_airServFull = true;          // true = chosen assets will bring all available air services in one place / false = no full service. 
		VO_airServiceRange = 20;          // in meters, the area around the station that identifies the air vehicle to be serviced. Default: 20.
		VO_airCooldown = 10;          // in seconds, time among each available air services. Default: 10.
		
		// Define which assets (classnames) are air full (repair, refuel, rearm) stations:
		VO_airFullAssets =          
		[
			"Land_HelipadRescue_F",
			"Land_HelipadSquare_F",
			"Land_HelipadCircle_F",
			"Land_HelipadCivil_F",
			"Land_HelipadEmpty_F",
			//"Land_Destroyer_01_base_F",           // destroyer USS Liberty / doesnt work well 'coz the asset is too big.
			//"Land_Carrier_01_base_F",          // aircraft carrier USS Freedom / doesnt work well 'coz the asset is too big.
			"Sign_Arrow_Direction_F",
			"Sign_Arrow_Direction_Blue_F",
			"Sign_Arrow_Direction_Pink_F",
			"Sign_Arrow_Direction_Cyan_F",
			"Sign_Arrow_Direction_Green_F",
			"Sign_Arrow_Direction_Yellow_F",			
			"Land_Hangar_F",
			"Land_Airport_01_hangar_F", 
			"Land_TentHangar_V1_F"
			// from CUP:
			// "CUP_Type072_Main",          // navy / doesn't work well 'coz the asset is too big.
			// "CUP_B_LPD_SAN_ANTONIO_USMC_Empty",          // navy / doesn't work well 'coz the asset is too big.
			// "CUP_B_LHD_WASP_USMC",          // navy / doesn't work well 'coz the asset is too big.
			// "CUP_B_LHD_WASP_USMC_ASSAULT",          // navy / doesn't work well 'coz the asset is too big.
			// "CUP_B_LHD_WASP_USMC_Empty",          // navy / doesn't work well 'coz the asset is too big.
			// "CUP_B_LHD_WASP_USMC_SEA_CONTROL",          // navy / doesn't work well 'coz the asset is too big.
			// "CUP_B_LHD_WASP_RUNWAY_USMC_SEA_CONTROL",          // navy / doesn't work well 'coz the asset is too big.
			// "CUP_B_LHD_WASP_RUNWAY_USMC"          // navy / doesn't work well 'coz the asset is too big.
		];
		
		// Define which assets (classnames) are air repair stations:
		VO_airRepairAssets =          
		[ 
			"O_T_Truck_03_repair_F",
			"O_Truck_03_repair_F",
			"B_Truck_01_Repair_F",
			"B_T_Truck_01_Repair_F",
			"Land_Pod_Heli_Transport_04_repair_F",          // Taru repair pod
			"B_Slingload_01_Repair_F",          // Huron repair container
			// from RHS:
			"rhsusf_M977A4_REPAIR_usarmy_d",
			"rhsusf_M977A4_REPAIR_usarmy_wd",
			"rhsusf_M977A4_REPAIR_BKIT_usarmy_d",
			"rhsusf_M977A4_REPAIR_BKIT_usarmy_wd",
			"rhsusf_M977A4_REPAIR_BKIT_M2_usarmy_d",
			"rhsusf_M977A4_REPAIR_BKIT_M2_usarmy_wd",
			// from CUP:
			"CUP_B_MTVR_Repair_BAF_WOOD", 
			"CUP_B_MTVR_Repair_BAF_DES", 
			"CUP_B_MTVR_Repair_HIL", 
			"CUP_B_MTVR_Repair_USA", 
			"CUP_B_MTVR_Repair_USMC", 
			"CUP_I_MTVR_Repair_RACS",
			"CUP_B_T810_Repair_CZ_WDL", 
			"CUP_B_T810_Repair_CZ_DES", 
			"CUP_I_T810_Repair_LDF"
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
			"O_Heli_Transport_04_fuel_F",          // Helicopter Taru + fuel container.
			"Land_FuelStation_02_workshop_F",
			"Land_Pod_Heli_Transport_04_fuel_F",          // Taru fuel pod
			"B_Slingload_01_Fuel_F",          // Huron fuel container
			// "Land_MetalBarrel_F",          // too small to refuel many times. Not recommended.
			//"FlexibleTank_01_forest_F",          // too small to refuel many times. Not recommended.
			//"FlexibleTank_01_sand_F",          // too small to refuel many times. Not recommended.
			//"Land_CanisterFuel_F",          // too small to refuel many times. Not recommended.
			//"Land_CanisterFuel_Blue_F",          // too small to refuel many times. Not recommended.
			//"Land_CanisterFuel_Red_F",          // too small to refuel many times. Not recommended.
			//"Land_CanisterFuel_White_F",          // too small to refuel many times. Not recommended.
			"StorageBladder_01_fuel_forest_F", 
			"StorageBladder_01_fuel_sand_F", 
			"CargoNet_01_barrels_F",
			// from RHS:
			"RHS_Ural_Fuel_VDV_01",
			"RHS_Ural_Fuel_MSV_01",
			"RHS_Ural_Fuel_VV_01",
			"rhsgref_cdf_b_ural_fuel",
			"rhsgref_nat_van_fuel",
			"rhsgref_cdf_ural_fuel",
			"rhssaf_army_o_ural_fuel",
			"rhssaf_army_ural_fuel",
			// from CUP:
			"CUP_B_MTVR_Refuel_BAF_DES",
			"CUP_B_MTVR_Refuel_BAF_WOOD",
			"CUP_B_Ural_Refuel_CDF",
			"CUP_B_MTVR_Refuel_HIL",
			"CUP_B_MTVR_Refuel_USA",
			"CUP_B_MTVR_Refuel_USMC",
			"CUP_O_Ural_Refuel_RU",
			"CUP_O_Ural_Refuel_CHDKZ",
			"CUP_O_Ural_Refuel_SLA",
			"CUP_O_V3S_Refuel_TKA",
			"CUP_O_Ural_Refuel_TKA",
			"CUP_O_V3S_Refuel_TKM",
			"CUP_I_MTVR_Refuel_RACS",
			"CUP_I_V3S_Refuel_TKG",
			//"Fuel_can",          // too small to refuel many times. Not recommended.
			//"Barrel5",          // too small to refuel many times. Not recommended.
			"Land_fuel_tank_small",
			"Land_Ind_TankSmall2_EP1",
			"Land_Ind_TankSmall2",
			"Land_Fuel_tank_big", 
			"Land_Fuel_tank_stairs", 
			"Land_Fuelstation",  
			"Land_Fuelstation_army" 
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
			"B_Slingload_01_Ammo_F",          // Huron ammo container
			// from RHS:
			"rhs_kamaz5350_ammo_vv",
			"rhs_kamaz5350_ammo_msv",
			"rhs_kamaz5350_ammo_vmf",
			"rhs_kamaz5350_ammo_vdv",
			"RHS_Ural_Ammo_VDV_01",
			"RHS_Ural_Ammo_VMF_01",
			"RHS_Ural_Ammo_VV_01",
			"rhsusf_M977A4_AMMO_usarmy_d",
			"rhsusf_M977A4_AMMO_usarmy_wd",
			"rhsusf_M977A4_AMMO_BKIT_usarmy_d",
			"rhsusf_M977A4_AMMO_BKIT_usarmy_wd",
			"rhsusf_M977A4_AMMO_BKIT_M2_usarmy_d",
			"rhsusf_M977A4_AMMO_BKIT_M2_usarmy_wd",
			// from CUP:
			"CUP_B_MTVR_Ammo_USA",
			"CUP_B_MTVR_Ammo_USMC", 
			"CUP_I_MTVR_Ammo_RACS",
			"CUP_I_T810_Reammo_LDF"
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
		VO_nauCooldown = 10;          // in seconds, time among each available nautic services. Default: 10.
		
		// Define which assets (classnames) are nautic full (repair, refuel, rearm) stations:
		VO_nauFullAssets =          
		[
			"Land_TBox_F"
			//"Land_Destroyer_01_base_F",           // destroyer USS Liberty / doesnt work well 'coz the asset is too big.
			//"Land_Carrier_01_base_F",          // aircraft carrier USS Freedom / doesnt work well 'coz the asset is too big.
			// "CUP_Type072_Main",          // navy / doesn't work well 'coz the asset is too big.
			// "CUP_B_LPD_SAN_ANTONIO_USMC_Empty",          // navy / doesn't work well 'coz the asset is too big.
			// "CUP_B_LHD_WASP_USMC",          // navy / doesn't work well 'coz the asset is too big.
			// "CUP_B_LHD_WASP_USMC_ASSAULT",          // navy / doesn't work well 'coz the asset is too big.
			// "CUP_B_LHD_WASP_USMC_Empty",          // navy / doesn't work well 'coz the asset is too big.
			// "CUP_B_LHD_WASP_USMC_SEA_CONTROL",          // navy / doesn't work well 'coz the asset is too big.
			// "CUP_B_LHD_WASP_RUNWAY_USMC_SEA_CONTROL",          // navy / doesn't work well 'coz the asset is too big.
			// "CUP_B_LHD_WASP_RUNWAY_USMC"          // navy / doesn't work well 'coz the asset is too big.
		];
		
		// Define which assets (classnames) are nautic repair stations:
		VO_nauRepairAssets =          
		[
			"O_T_Truck_03_repair_F",
			"O_Truck_03_repair_F",
			"B_Truck_01_Repair_F",
			"B_T_Truck_01_Repair_F",
			"O_Heli_Transport_04_ammo_F",          // Helicopter Taru + ammo container
			"Land_Pod_Heli_Transport_04_repair_F",          // Taru repair pod
			"B_Slingload_01_Repair_F",          // Huron repair container
			// from RHS:
			"rhsgref_cdf_b_ural_repair",
			"rhsusf_M977A4_REPAIR_usarmy_d",
			"rhsusf_M977A4_REPAIR_usarmy_wd",
			"rhsusf_M977A4_REPAIR_BKIT_usarmy_d",
			"rhsusf_M977A4_REPAIR_BKIT_usarmy_wd",
			"rhsusf_M977A4_REPAIR_BKIT_M2_usarmy_d",
			"rhsusf_M977A4_REPAIR_BKIT_M2_usarmy_wd",
			// from CUP:
			"CUP_B_MTVR_Repair_BAF_WOOD", 
			"CUP_B_MTVR_Repair_BAF_DES", 
			"CUP_B_MTVR_Repair_HIL", 
			"CUP_B_MTVR_Repair_USA", 
			"CUP_B_MTVR_Repair_USMC", 
			"CUP_I_MTVR_Repair_RACS",
			"CUP_B_T810_Repair_CZ_WDL", 
			"CUP_B_T810_Repair_CZ_DES", 
			"CUP_I_T810_Repair_LDF"
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
			"O_Heli_Transport_04_fuel_F",          // Helicopter Taru + fuel container.
			"Land_FuelStation_02_workshop_F",
			"Land_Pod_Heli_Transport_04_fuel_F",          // Taru fuel pod
			"B_Slingload_01_Fuel_F",          // Huron fuel container
			// "Land_MetalBarrel_F",          // too small to refuel many times. Not recommended.
			//"FlexibleTank_01_forest_F",          // too small to refuel many times. Not recommended.
			//"FlexibleTank_01_sand_F",          // too small to refuel many times. Not recommended.
			//"Land_CanisterFuel_F",          // too small to refuel many times. Not recommended.
			//"Land_CanisterFuel_Blue_F",          // too small to refuel many times. Not recommended.
			//"Land_CanisterFuel_Red_F",          // too small to refuel many times. Not recommended.
			//"Land_CanisterFuel_White_F",          // too small to refuel many times. Not recommended.
			"StorageBladder_01_fuel_forest_F", 
			"StorageBladder_01_fuel_sand_F", 
			"CargoNet_01_barrels_F",
			// from RHS:
			"RHS_Ural_Fuel_VDV_01",
			"RHS_Ural_Fuel_MSV_01",
			"RHS_Ural_Fuel_VV_01",
			"rhsgref_cdf_b_ural_fuel",
			"rhsgref_nat_van_fuel",
			"rhsgref_cdf_ural_fuel",
			"rhssaf_army_o_ural_fuel",
			"rhssaf_army_ural_fuel",
			// from CUP:
			"CUP_B_MTVR_Refuel_BAF_DES",
			"CUP_B_MTVR_Refuel_BAF_WOOD",
			"CUP_B_Ural_Refuel_CDF",
			"CUP_B_MTVR_Refuel_HIL",
			"CUP_B_MTVR_Refuel_USA",
			"CUP_B_MTVR_Refuel_USMC",
			"CUP_O_Ural_Refuel_RU",
			"CUP_O_Ural_Refuel_CHDKZ",
			"CUP_O_Ural_Refuel_SLA",
			"CUP_O_V3S_Refuel_TKA",
			"CUP_O_Ural_Refuel_TKA",
			"CUP_O_V3S_Refuel_TKM",
			"CUP_I_MTVR_Refuel_RACS",
			"CUP_I_V3S_Refuel_TKG",
			//"Fuel_can",          // too small to refuel many times. Not recommended.
			//"Barrel5",          // too small to refuel many times. Not recommended.
			"Land_A_FuelStation_Feed",          // pump
			"Land_Ind_FuelStation_Feed_EP1",          // pump
			"Land_FuelStation_Feed_PMC",          // pump
			"Land_fuel_tank_small", 
			"Land_Ind_TankSmall2_EP1", 
			"Land_Ind_TankSmall2",  
			"Land_Fuel_tank_big", 
			"Land_Fuel_tank_stairs"
		];
		
		// Define which assets (classnames) are nautic rearm stations:
		VO_nauRearmAssets =          
		[
			"O_T_Truck_03_ammo_ghex_F", 
			"O_Truck_03_ammo_F", 
			"B_T_Truck_01_ammo_F",
			"B_Truck_01_ammo_F",
			"Land_Pod_Heli_Transport_04_ammo_F",          // Taru ammo pod
			"B_Slingload_01_Ammo_F",          // Huron ammo container
			// from RHS:
			"rhs_kamaz5350_ammo_vv",
			"rhs_kamaz5350_ammo_msv",
			"rhs_kamaz5350_ammo_vmf",
			"rhs_kamaz5350_ammo_vdv",
			"RHS_Ural_Ammo_VDV_01",
			"RHS_Ural_Ammo_VMF_01",
			"RHS_Ural_Ammo_VV_01",
			"rhsusf_M977A4_AMMO_usarmy_d",
			"rhsusf_M977A4_AMMO_usarmy_wd",
			"rhsusf_M977A4_AMMO_BKIT_usarmy_d",
			"rhsusf_M977A4_AMMO_BKIT_usarmy_wd",
			"rhsusf_M977A4_AMMO_BKIT_M2_usarmy_d",
			"rhsusf_M977A4_AMMO_BKIT_M2_usarmy_wd",
			// from CUP:
			"CUP_B_M113A3_Reammo_GER", 
			"CUP_B_Kamaz_Reammo_CDF",
			"CUP_B_Ural_Reammo_CDF", 
			"CUP_B_MTVR_Ammo_HIL", 
			"CUP_B_M113A3_Reammo_desert_USA", 
			"CUP_B_M113A3_Reammo_olive_USA",
			"CUP_B_M113A3_Reammo_USA", 
			"CUP_B_MTVR_Ammo_USA",
			"CUP_B_MTVR_Ammo_USMC", 
			"CUP_O_Kamaz_Reammo_RU",
			"CUP_O_Ural_Reammo_RU", 
			"CUP_O_Ural_Reammo_CHDKZ",
			"CUP_O_Ural_Reammo_SLA", 
			"CUP_O_M113A3_Reammo_TKA",
			"CUP_O_Ural_Reammo_TKA", 
			"CUP_I_M113A3_Reammo_AAF",
			"CUP_I_Van_ammo_ION", 
			"CUP_I_T810_Reammo_LDF",
			"CUP_I_M113A3_Reammo_RACS", 
			"CUP_I_MTVR_Ammo_RACS",
			"CUP_I_M113A3_Reammo_UN", 
			"CUP_I_Ural_Reammo_UN"
		];
		
		
	// BE CAREFUL, HIGHLY RECOMMENDED DO NOT CHANGE ANY BELOW: 
		// Vehicle types recognized by VO script:
		VO_grdVehicleTypes = [ "Car","Motorcycle","Tank","WheeledAPC","TrackedAPC" ];
		VO_airVehicleTypes = [ "Helicopter","Plane" ];
		VO_nauVehicleTypes = [ "Ship","Submarine" ];
		// ACE detection for server:
		if ( isClass(configfile >> "CfgPatches" >> "ace_medical") OR isClass(configfile >> "CfgPatches" >> "ace_repair") ) then { VO_isACErun = true } else { VO_isACErun = false };
		// Minimal vehicle conditions for overhauling:
		VO_minRefuelService = 0.8;
		if ( VO_isACErun ) then	{
			if ( ace_vehicle_damage_enabled ) then { ["ACE-Vehicle-Damage is ON on server. Highly recommended to turn it OFF."] remoteExec ["systemChat"]; VO_minRepairService = 0 } else { VO_minRepairService = 0.1 };
		} else { VO_minRepairService = 0.1 };
		// Debug initial counting of while-cycles:
		VO_grdCyclesDone = 0; VO_airCyclesDone = 0; VO_nauCyclesDone = 0; 
		// checking if this file is properly configured:
		isStationsOkay = false;
		isServicesOkay = false;
		if (groundVehiclesOverhauling OR airVehiclesOverhauling OR nauticVehiclesOverhauling) then { 
			isStationsOkay = true;
			if ( groundVehiclesOverhauling ) then {	if ( VO_grdServRepair OR VO_grdServRefuel OR VO_grdServRearm ) then {	isServicesOkay = true; } else { ["VEHICLES OVERHAULING > fn_VO_parameters.sqf > No GROUND services set as TRUE!"] remoteExec ["systemChat"]; }; };
			if ( airVehiclesOverhauling ) then { if ( VO_airServRepair OR VO_airServRefuel OR VO_airServRearm ) then { isServicesOkay = true; } else { ["VEHICLES OVERHAULING > fn_VO_parameters.sqf > No AIR services set as TRUE!"] remoteExec ["systemChat"]; }; };
			if ( nauticVehiclesOverhauling ) then { if ( VO_nauServRepair OR VO_nauServRefuel OR VO_nauServRearm ) then { isServicesOkay = true; } else { ["VEHICLES OVERHAULING > fn_VO_parameters.sqf > No NAUTIC services set as TRUE!"] remoteExec ["systemChat"]; }; };
		} else { ["VEHICLES OVERHAULING > fn_VO_parameters.sqf > The script is NOT running!"] remoteExec ["systemChat"]; };

	true
