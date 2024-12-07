// VO v2.5
// File: your_mission\vehiclesOverhauling\fn_VO_management.sqf
// Documentation: https://github.com/aldolammel/Arma-3-Vehicles-Overhauling-Script/blob/main/_VO_Script_Documentation.pdf
// by thy (@aldolammel)

if !isServer exitWith {};

// PARAMETERS OF EDITOR'S OPTIONS:
VO_isOn = true;                    // Turn on or off the entire script without to touch your description.ext / Default: true;

// DEBUG:
	VO_debug_isOn      = true;    // true = turn on to test your script config / false = turn it off. Default: false;

// SERVER:
	VO_isReporting     = true;     // true = driver will see all station messages / false = turns it off, keeping the critical ones / Default: true;
	VO_dronesNeedHuman = false;    // true = player presence's mandatory to get a service / false = just a terminal connection is okay / Default: false;
	
// GROUND SERVICES
	VO_groundDoctrine  = true;         // true = the mission needs ground stations / false = doesn't need.
		VO_grdServRepair   = true;     // true = repair stations for ground veh are available / false = not available.
		VO_grdServRefuel   = true;     // true = refuel stations for ground veh are available / false = not available.
		VO_grdServRearm    = true;     // true = rearm stations for ground veh are available / false = not available.
		VO_grdServFull     = true;     // true = chosen assets will bring all available ground services in one place / false = no assets for full service.
		VO_grdServiceRange = 20;       // in meters, the area around the station that identifies the ground vehicle to be serviced. Default: 20;
		VO_grdCooldown     = 10;       // in seconds, time among each available ground services. Default: 10.

// AIR SERVICES
	VO_airDoctrine     = false;        // true = the mission needs air stations / false = doesn't need.
		VO_airServRepair   = true;     // true = repair stations for air veh are available / false = not available.
		VO_airServRefuel   = true;     // true = refuel stations for air veh are available / false = not available.
		VO_airServRearm    = true;     // true = rearm stations for air veh are available / false = not available.
		VO_airServFull     = true;     // true = chosen assets will bring all available air services in one place / false = no assets for full service. 
		VO_airServiceRange = 20;       // in meters, the area around the station that identifies the air vehicle to be serviced. Default: 20;
		VO_airCooldown     = 10;       // in seconds, time among each available air services. Default: 10.

// NAUTIC SERVICES
	VO_nauticDoctrine  = false;        // true = the mission needs nautic stations / false = doesn't need.
		VO_nauServRepair   = true;     // true = repair stations for nautic veh are available / false = not available.
		VO_nauServRefuel   = true;     // true = refuel stations for nautic veh are available / false = not available.
		VO_nauServRearm    = true;     // true = rearm stations for nautic veh are available / false = not available.
		VO_nauServFull     = true;     // true = chosen assets will bring all available nautic services in one place / false = no assets for full service.
		VO_nauServiceRange = 20;       // in meters, the area around the station that identifies the nautic vehicle to be serviced. Default: 20;
		VO_nauCooldown     = 10;       // in seconds, time among each available nautic services. Default: 10;.

// Define which assets (classnames) are ground full (repair, refuel, rearm) stations:
	VO_grdFullAssets = [
		"Land_RepairDepot_01_tan_F",
		"Land_RepairDepot_01_green_F",
		"Land_Carrier_01_hull_08_1_F",     // part of the aircraft carrier USS Freedom if your mission has airborne ground vehicles.
		"Land_Carrier_01_hull_07_1_F",     // part of the aircraft carrier USS Freedom if your mission has airborne ground vehicles.
		"Land_Carrier_01_hull_06_1_F",      // part of the aircraft carrier USS Freedom if your mission has airborne ground vehicles.
		// "Land_RepairDepot_01_civ_F",    // should be a full station 'coz it's a civilian station (with no ammunition).
		// "Land_Carrier_01_base_F",       // the entire aircraft carrier USS Freedom doesnt work well because this asset is too big.
		// from CDLC Western Sahara ..........................................................................................
		"Land_House_C_12_EP1_off_lxWS",
		// from MOD CUP ......................................................................................................
		"CUP_Type072_Main",                          // navy / doesn't work well 'coz the asset is too big.
		"CUP_B_LPD_SAN_ANTONIO_USMC_Empty",          // navy / doesn't work well 'coz the asset is too big.
		"CUP_B_LHD_WASP_USMC_Empty",                 // navy / doesn't work well 'coz the asset is too big.
		"CUP_B_LHD_WASP_RUNWAY_USMC_SEA_CONTROL",    // navy / doesn't work well 'coz the asset is too big.
		"CUP_B_LHD_WASP_RUNWAY_USMC"                 // navy / doesn't work well 'coz the asset is too big.
	];
	
// Define which assets (classnames) are ground repair stations:
	VO_grdRepairAssets = [
		"Land_RepairDepot_01_tan_F",
		"Land_RepairDepot_01_green_F",
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
		"B_APC_Tracked_01_CRV_F",               // APC CRV Bobcat
		"O_Heli_Transport_04_repair_F",         // Helicopter Taru + repair container
		"Land_Pod_Heli_Transport_04_repair_F",  // Taru repair pod
		"B_Slingload_01_Repair_F",              // Huron repair container
		"Land_Carrier_01_hull_08_1_F",   // part of the aircraft carrier USS Freedom if your mission has airborne ground vehicles.
		"Land_Carrier_01_hull_07_1_F",   // part of the aircraft carrier USS Freedom if your mission has airborne ground vehicles.
		"Land_Carrier_01_hull_06_1_F",   // part of the aircraft carrier USS Freedom if your mission has airborne ground vehicles.
		// from CDLC Western Sahara ..........................................................................................
		"B_D_Truck_01_Repair_lxWS",
		"B_UN_Truck_01_Repair_lxWS",
		"O_SFIA_Truck_02_box_lxWS",
		"C_IDAP_Truck_02_box_lxWS",
		// from CDLC Reaction Forces .........................................................................................
		"B_G_Pickup_repair_rf",
		"O_G_Pickup_repair_rf",
		"I_G_Pickup_repair_rf",
		// from CDLC Expeditionary Forces ....................................................................................
		"EF_B_Truck_01_Repair_MJTF_Des",
		"EF_B_Truck_01_Repair_MJTF_Wdl",
		// from MOD RHS ......................................................................................................
		"rhsgref_cdf_b_ural_repair",
		"rhsusf_M977A4_REPAIR_usarmy_d",
		"rhsusf_M977A4_REPAIR_usarmy_wd",
		"rhsusf_M977A4_REPAIR_BKIT_usarmy_d",
		"rhsusf_M977A4_REPAIR_BKIT_usarmy_wd",
		"rhsusf_M977A4_REPAIR_BKIT_M2_usarmy_d",
		"rhsusf_M977A4_REPAIR_BKIT_M2_usarmy_wd",
		// from MOD CUP ......................................................................................................
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
	VO_grdRefuelAssets = [
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
		"Land_Pod_Heli_Transport_04_fuel_F",   // Taru fuel pod
		"B_Slingload_01_Fuel_F",               // Huron fuel container
		"Land_dp_smallTank_old_F",        // building fuel storage
		"Land_dp_bigTank_old_F",          // building fuel storage
		"StorageBladder_01_fuel_forest_F",
		"StorageBladder_01_fuel_sand_F",
		"CargoNet_01_barrels_F",
		"Land_A_FuelStation_Feed",          // pump
		"Land_Ind_FuelStation_Feed_EP1",    // pump
		"Land_FuelStation_Feed_PMC",        // pump
		"Land_fuel_tank_small",
		"Land_Ind_TankSmall2_EP1", 
		"Land_Ind_TankSmall2", 
		"Land_Fuel_tank_big", 
		"Land_Fuel_tank_stairs", 
		"Land_Fuelstation", 
		"Land_Fuelstation_army",
		"Land_Benzina_schnell",
		"Land_Carrier_01_hull_08_1_F",   // part of the aircraft carrier USS Freedom if your mission has airborne ground vehicles.
		"Land_Carrier_01_hull_07_1_F",   // part of the aircraft carrier USS Freedom if your mission has airborne ground vehicles.
		"Land_Carrier_01_hull_06_1_F",   // part of the aircraft carrier USS Freedom if your mission has airborne ground vehicles.
		// "Land_MetalBarrel_F",          // too small to refuel many times. Not recommended.
		//"FlexibleTank_01_forest_F",     // too small to refuel many times. Not recommended.
		//"FlexibleTank_01_sand_F",       // too small to refuel many times. Not recommended.
		//"Land_CanisterFuel_F",          // too small to refuel many times. Not recommended.
		//"Land_CanisterFuel_Blue_F",     // too small to refuel many times. Not recommended.
		//"Land_CanisterFuel_Red_F",      // too small to refuel many times. Not recommended.
		//"Land_CanisterFuel_White_F",    // too small to refuel many times. Not recommended.
		//"Fuel_can",          // too small to refuel many times. Not recommended.
		//"Barrel5"           // too small to refuel many times. Not recommended.
		// from CDLC Western Sahara ..........................................................................................
		"B_D_Truck_01_fuel_lxWS",
		"B_UN_Truck_01_fuel_lxWS",
		"O_SFIA_Truck_02_fuel_lxWS",
		// from CDLC Reaction Forces .........................................................................................
		"B_G_Pickup_fuel_rf",
		"B_Tura_Pickup_01_fuel_RF",
		"O_G_Pickup_fuel_rf",
		"O_Tura_Pickup_01_fuel_RF",
		"I_G_Pickup_fuel_rf",
		"I_Tura_Pickup_fuel_rf",
		// from CDLC Expeditionary Forces ....................................................................................
		"EF_B_Truck_01_fuel_MJTF_Des",
		"EF_B_Truck_01_fuel_MJTF_Wdl",
		// from MOD RHS ......................................................................................................
		"RHS_Ural_Fuel_VDV_01",
		"RHS_Ural_Fuel_MSV_01",
		"RHS_Ural_Fuel_VV_01",
		"rhsgref_cdf_b_ural_fuel",
		"rhsgref_nat_van_fuel",
		"rhsgref_cdf_ural_fuel",
		"rhssaf_army_o_ural_fuel",
		"rhssaf_army_ural_fuel",
		// from MOD CUP ......................................................................................................
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
		"CUP_I_V3S_Refuel_TKG"
	];
	
// Define which assets (classnames) are ground rearm stations:
	VO_grdRearmAssets = [
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
		"Land_Pod_Heli_Transport_04_ammo_F",   // Taru ammo pod
		"B_Slingload_01_Ammo_F",     // Huron ammo container
		"Land_Garaz_bez_tanku",      // Ammo bunker
		"Land_Garaz_s_tankem",       // Ammo bunker
		"Land_Ammostore2",           // Ammo bunker
		"Land_Carrier_01_hull_08_1_F",   // part of the aircraft carrier USS Freedom if your mission has airborne ground vehicles.
		"Land_Carrier_01_hull_07_1_F",   // part of the aircraft carrier USS Freedom if your mission has airborne ground vehicles.
		"Land_Carrier_01_hull_06_1_F",   // part of the aircraft carrier USS Freedom if your mission has airborne ground vehicles.
		// from CDLC Western Sahara ..........................................................................................
		"B_D_Truck_01_ammo_lxWS",
		"B_UN_Truck_01_ammo_lxWS",
		"O_SFIA_Truck_02_Ammo_lxWS",
		// from CDLC Expeditionary Forces ....................................................................................
		"EF_B_Truck_01_ammo_MJTF_Des",
		"EF_B_Truck_01_ammo_MJTF_Wdl",
		// from MOD RHS ......................................................................................................
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
		// from MOD CUP ......................................................................................................
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

// Define which assets (classnames) are air full (repair, refuel, rearm) stations.
	VO_airFullAssets = [
		"Sign_Arrow_Direction_F",
		"Land_HelipadRescue_F",
		"Land_HelipadSquare_F",
		"Land_HelipadCircle_F",
		"Land_HelipadCivil_F",
		"Land_HelipadEmpty_F",
		"Sign_Arrow_Direction_Blue_F",
		"Sign_Arrow_Direction_Pink_F",
		"Sign_Arrow_Direction_Cyan_F",
		"Sign_Arrow_Direction_Green_F",
		"Sign_Arrow_Direction_Yellow_F",
		"Sign_Arrow_Large_F",
		"Sign_Arrow_Large_Blue_F",
		"Sign_Arrow_Large_Pink_F",
		"Sign_Arrow_Large_Cyan_F",
		"Sign_Arrow_Large_Green_F",
		"Sign_Arrow_Large_Yellow_F",
		"Land_Hangar_F",
		"Land_Airport_01_hangar_F", 
		"Land_TentHangar_V1_F",
		"Land_Carrier_01_hull_08_1_F",   // part of the aircraft carrier USS Freedom if your mission has airborne ground vehicles.
		"Land_Carrier_01_hull_07_1_F",   // part of the aircraft carrier USS Freedom if your mission has airborne ground vehicles.
		"Land_Carrier_01_hull_06_1_F",   // part of the aircraft carrier USS Freedom if your mission has airborne ground vehicles.
		//"Land_Carrier_01_base_F",       // the entire aircraft carrier USS Freedom doesnt work well because this asset is too big.
		//"Land_Destroyer_01_base_F",     // destroyer USS Liberty / doesnt work well 'coz the asset is too big.
		// from MOD CUP ......................................................................................................
		"CUP_Type072_Main",                     // navy / doesn't work well 'coz the asset is too big.
		"CUP_B_LPD_SAN_ANTONIO_USMC_Empty",     // navy / doesn't work well 'coz the asset is too big.
		"CUP_B_LHD_WASP_USMC",                  // navy / doesn't work well 'coz the asset is too big.
		"CUP_B_LHD_WASP_USMC_ASSAULT",          // navy / doesn't work well 'coz the asset is too big.
		"CUP_B_LHD_WASP_USMC_Empty",            // navy / doesn't work well 'coz the asset is too big.
		"CUP_B_LHD_WASP_USMC_SEA_CONTROL",      // navy / doesn't work well 'coz the asset is too big.
		"CUP_B_LHD_WASP_RUNWAY_USMC_SEA_CONTROL",     // navy / doesn't work well 'coz the asset is too big.
		"CUP_B_LHD_WASP_RUNWAY_USMC"                  // navy / doesn't work well 'coz the asset is too big.
	];
	
// Define which assets (classnames) are air repair stations:
	VO_airRepairAssets = [
		"Sign_Arrow_Direction_F",
		"Land_HelipadRescue_F",
		"Land_HelipadSquare_F",
		"Land_HelipadCircle_F",
		"Land_HelipadCivil_F",
		"Land_HelipadEmpty_F",
		"O_T_Truck_03_repair_F",
		"O_Truck_03_repair_F",
		"B_Truck_01_Repair_F",
		"B_T_Truck_01_Repair_F",
		"Land_Pod_Heli_Transport_04_repair_F",     // Taru repair pod
		"B_Slingload_01_Repair_F",                  // Huron repair container
		"Land_Carrier_01_hull_08_1_F",   // part of the aircraft carrier USS Freedom if your mission has airborne ground vehicles.
		"Land_Carrier_01_hull_07_1_F",   // part of the aircraft carrier USS Freedom if your mission has airborne ground vehicles.
		"Land_Carrier_01_hull_06_1_F",   // part of the aircraft carrier USS Freedom if your mission has airborne ground vehicles.
		// from MOD RHS ......................................................................................................
		"rhsusf_M977A4_REPAIR_usarmy_d",
		"rhsusf_M977A4_REPAIR_usarmy_wd",
		"rhsusf_M977A4_REPAIR_BKIT_usarmy_d",
		"rhsusf_M977A4_REPAIR_BKIT_usarmy_wd",
		"rhsusf_M977A4_REPAIR_BKIT_M2_usarmy_d",
		"rhsusf_M977A4_REPAIR_BKIT_M2_usarmy_wd",
		// from MOD CUP ......................................................................................................
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
	VO_airRefuelAssets = [
		"Sign_Arrow_Direction_F",
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
		"Land_Pod_Heli_Transport_04_fuel_F",   // Taru fuel pod
		"B_Slingload_01_Fuel_F",               // Huron fuel container
		"Land_fuel_tank_small",
		"Land_Ind_TankSmall2_EP1",
		"Land_Ind_TankSmall2",
		"Land_Fuel_tank_big", 
		"Land_Fuel_tank_stairs", 
		"Land_Fuelstation",  
		"Land_Fuelstation_army",
		"StorageBladder_01_fuel_forest_F", 
		"StorageBladder_01_fuel_sand_F", 
		"CargoNet_01_barrels_F",
		"Land_Carrier_01_hull_08_1_F",   // part of the aircraft carrier USS Freedom if your mission has airborne ground vehicles.
		"Land_Carrier_01_hull_07_1_F",   // part of the aircraft carrier USS Freedom if your mission has airborne ground vehicles.
		"Land_Carrier_01_hull_06_1_F",   // part of the aircraft carrier USS Freedom if your mission has airborne ground vehicles.
		// "Land_MetalBarrel_F",               // too small to refuel many times. Not recommended.
		//"FlexibleTank_01_forest_F",          // too small to refuel many times. Not recommended.
		//"FlexibleTank_01_sand_F",            // too small to refuel many times. Not recommended.
		//"Land_CanisterFuel_F",               // too small to refuel many times. Not recommended.
		//"Land_CanisterFuel_Blue_F",          // too small to refuel many times. Not recommended.
		//"Land_CanisterFuel_Red_F",           // too small to refuel many times. Not recommended.
		//"Land_CanisterFuel_White_F",         // too small to refuel many times. Not recommended.
		//"Fuel_can",          // too small to refuel many times. Not recommended.
		//"Barrel5"          // too small to refuel many times. Not recommended.
		
		// from MOD RHS ......................................................................................................
		"RHS_Ural_Fuel_VDV_01",
		"RHS_Ural_Fuel_MSV_01",
		"RHS_Ural_Fuel_VV_01",
		"rhsgref_cdf_b_ural_fuel",
		"rhsgref_nat_van_fuel",
		"rhsgref_cdf_ural_fuel",
		"rhssaf_army_o_ural_fuel",
		"rhssaf_army_ural_fuel",
		// from MOD CUP ......................................................................................................
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
		"CUP_I_V3S_Refuel_TKG"
	];
	
// Define which assets (classnames) are air rearm stations:
	VO_airRearmAssets = [
		"Sign_Arrow_Direction_F",
		"Land_MobileLandingPlatform_01_F",
		"Land_Missle_Trolley_02_F",        // Missiles pod 
		"Land_Bomb_Trolley_01_F",          // Bombs pod 
		"O_T_Truck_03_ammo_ghex_F", 
		"O_Truck_03_ammo_F", 
		"B_T_Truck_01_ammo_F",
		"B_Truck_01_ammo_F",
		"Land_Pod_Heli_Transport_04_ammo_F",     // Taru ammo pod
		"B_Slingload_01_Ammo_F",                // Huron ammo container
		"Land_Carrier_01_hull_08_1_F",   // part of the aircraft carrier USS Freedom if your mission has airborne ground vehicles.
		"Land_Carrier_01_hull_07_1_F",   // part of the aircraft carrier USS Freedom if your mission has airborne ground vehicles.
		"Land_Carrier_01_hull_06_1_F",   // part of the aircraft carrier USS Freedom if your mission has airborne ground vehicles.
		
		// from MOD RHS ......................................................................................................
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
		// from MOD CUP ......................................................................................................
		"CUP_B_MTVR_Ammo_USA",
		"CUP_B_MTVR_Ammo_USMC", 
		"CUP_I_MTVR_Ammo_RACS",
		"CUP_I_T810_Reammo_LDF"
	];
	
// Define which assets (classnames) are allowed to automatically turn parked planes backwards:
	VO_airParkingHelperAssets = [
		"Sign_Arrow_Direction_F",  // use this DIRECTION-RED-ARROW to set a non-editable-map-building as station w/ parking helper, putting it into the building, pointing to indoor.
		"Land_Hangar_F",
		"Land_Airport_01_hangar_F",
		"Land_TentHangar_V1_F"
		// "Sign_Arrow_Direction_Blue_F",
		// "Sign_Arrow_Direction_Pink_F",
		// "Sign_Arrow_Direction_Cyan_F",
		// "Sign_Arrow_Direction_Green_F",
		// "Sign_Arrow_Direction_Yellow_F"
	];

// Define which assets (classnames) are nautic full (repair, refuel, rearm) stations:
	VO_nauFullAssets = [
		"Land_TBox_F"
		//"Land_Destroyer_01_base_F",              // destroyer USS Liberty / doesnt work well 'coz the asset is too big.
		//"Land_Carrier_01_base_F"                 // the entire aircraft carrier USS Freedom doesnt work well because this asset is too big.
		// from CDLC Expeditionary Forces: ----------------
		// "Land_EF_LPD_base",                     // the entire navy doesnt work well because this asset is too big.
		// from MOD CUP:  -----------------------
		// "CUP_Type072_Main",                     // navy / doesn't work well 'coz the asset is too big.
		// "CUP_B_LPD_SAN_ANTONIO_USMC_Empty",     // navy / doesn't work well 'coz the asset is too big.
		// "CUP_B_LHD_WASP_USMC",                  // navy / doesn't work well 'coz the asset is too big.
		// "CUP_B_LHD_WASP_USMC_ASSAULT",          // navy / doesn't work well 'coz the asset is too big.
		// "CUP_B_LHD_WASP_USMC_Empty",            // navy / doesn't work well 'coz the asset is too big.
		// "CUP_B_LHD_WASP_USMC_SEA_CONTROL",      // navy / doesn't work well 'coz the asset is too big.
		// "CUP_B_LHD_WASP_RUNWAY_USMC_SEA_CONTROL",    // navy / doesn't work well 'coz the asset is too big.
		// "CUP_B_LHD_WASP_RUNWAY_USMC"                 // navy / doesn't work well 'coz the asset is too big.
	];
	
// Define which assets (classnames) are nautic repair stations:
	VO_nauRepairAssets = [
		"Land_TBox_F",
		"O_T_Truck_03_repair_F",
		"O_Truck_03_repair_F",
		"B_Truck_01_Repair_F",
		"B_T_Truck_01_Repair_F",
		"O_Heli_Transport_04_ammo_F",             // Helicopter Taru + ammo container
		"Land_Pod_Heli_Transport_04_repair_F",    // Taru repair pod
		"B_Slingload_01_Repair_F",                 // Huron repair container
		// from MOD RHS ......................................................................................................
		"rhsgref_cdf_b_ural_repair",
		"rhsusf_M977A4_REPAIR_usarmy_d",
		"rhsusf_M977A4_REPAIR_usarmy_wd",
		"rhsusf_M977A4_REPAIR_BKIT_usarmy_d",
		"rhsusf_M977A4_REPAIR_BKIT_usarmy_wd",
		"rhsusf_M977A4_REPAIR_BKIT_M2_usarmy_d",
		"rhsusf_M977A4_REPAIR_BKIT_M2_usarmy_wd",
		// from MOD CUP ......................................................................................................
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
	VO_nauRefuelAssets = [
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
		"O_Heli_Transport_04_fuel_F",           // Helicopter Taru + fuel container.
		"Land_FuelStation_02_workshop_F",
		"Land_Pod_Heli_Transport_04_fuel_F",    // Taru fuel pod
		"B_Slingload_01_Fuel_F",                // Huron fuel container
		"StorageBladder_01_fuel_forest_F", 
		"StorageBladder_01_fuel_sand_F", 
		"CargoNet_01_barrels_F",
		"Land_A_FuelStation_Feed",          // pump
		"Land_Ind_FuelStation_Feed_EP1",    // pump
		"Land_FuelStation_Feed_PMC",        // pump
		"Land_fuel_tank_small", 
		"Land_Ind_TankSmall2_EP1", 
		"Land_Ind_TankSmall2",  
		"Land_Fuel_tank_big", 
		"Land_Fuel_tank_stairs",
		// "Land_MetalBarrel_F",          // too small to refuel many times. Not recommended.
		//"FlexibleTank_01_forest_F",     // too small to refuel many times. Not recommended.
		//"FlexibleTank_01_sand_F",       // too small to refuel many times. Not recommended.
		//"Land_CanisterFuel_F",          // too small to refuel many times. Not recommended.
		//"Land_CanisterFuel_Blue_F",     // too small to refuel many times. Not recommended.
		//"Land_CanisterFuel_Red_F",      // too small to refuel many times. Not recommended.
		//"Land_CanisterFuel_White_F",    // too small to refuel many times. Not recommended.
		//"Fuel_can",          // too small to refuel many times. Not recommended.
		//"Barrel5"            // too small to refuel many times. Not recommended.
		// from MOD RHS ......................................................................................................
		"RHS_Ural_Fuel_VDV_01",
		"RHS_Ural_Fuel_MSV_01",
		"RHS_Ural_Fuel_VV_01",
		"rhsgref_cdf_b_ural_fuel",
		"rhsgref_nat_van_fuel",
		"rhsgref_cdf_ural_fuel",
		"rhssaf_army_o_ural_fuel",
		"rhssaf_army_ural_fuel",
		// from MOD CUP ......................................................................................................
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
		"CUP_I_V3S_Refuel_TKG"
	];
	
// Define which assets (classnames) are nautic rearm stations:
	VO_nauRearmAssets = [
		"O_T_Truck_03_ammo_ghex_F", 
		"O_Truck_03_ammo_F", 
		"B_T_Truck_01_ammo_F",
		"B_Truck_01_ammo_F",
		"Land_Pod_Heli_Transport_04_ammo_F",    // Taru ammo pod
		"B_Slingload_01_Ammo_F",                // Huron ammo container
		// from MOD RHS ......................................................................................................
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
		// from MOD CUP ......................................................................................................
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
	









	// VO VORE / TRY TO CHANGE NOTHING BELOW!!! ---------------------------------------------------------------------
		VO_txtDebugHeader = toUpper "VO DEBUG >";
		VO_txtWarnHeader  = toUpper "VO WARNING >";
		VO_prefix         = toUpper "VO";  // CAUTION: NEVER include/insert the VO_spacer character as part of the VO_prefix too.
		VO_spacer         = toUpper "_";    // CAUTION: try do not change it!
		// Global escape:
		if !VO_isOn exitWith {if VO_debug_isOn then {publicVariable "VO_isOn"; systemChat format ["%1 The script was turned off manually via 'fn_VO_management.sqf' file.", VO_txtWarnHeader]}};
		if (VO_isOn && !VO_groundDoctrine && !VO_airDoctrine && !VO_nauticDoctrine) exitWith {VO_isOn=false; publicVariable "VO_isOn"; systemChat format ["%1 You turned off all doctrine services but you're keeping the 'VO_isOn' as 'true' in fn_VO_management.sqf file. To fix it, turn one or more doctrine services 'true', or turn the 'VO_isOn' to 'false'. The script stopped automatically!", VO_txtWarnHeader]};
		// Vehicle types recognized by doctrine:
		VO_grdVehicleTypes = [ "Car","Motorcycle","Tank","WheeledAPC","TrackedAPC" ];
		VO_airVehicleTypes = [ "Helicopter","Plane" ];
		VO_nauVehicleTypes = [ "Ship","Submarine" ];
		// Huge assets with ability to change the editor's service range choice:
		VO_assetsRangeChanger = ["Land_Carrier_01_hull_08_1_F","Land_Carrier_01_hull_07_1_F","Land_Carrier_01_hull_06_1_F"]; 
		VO_hasAirRngChanger = false; /* VO_hasGrdRngChanger = false; VO_hasNauRngChanger = false; */
		// ACE detection for server:
		if ( isClass(configfile >> "CfgPatches" >> "ace_medical") || isClass(configfile >> "CfgPatches" >> "ace_repair") ) then { VO_isACErun = true } else { VO_isACErun = false };
		// Minimal vehicle conditions for overhauling:
		VO_minRefuelService = 0.8;
		if VO_isACErun then	{if ace_vehicle_damage_enabled then { ["ACE-Vehicle-Damage is ON on server. Highly recommended to turn it OFF."] remoteExec ["systemChat"]; VO_minRepairService = 0 } else { VO_minRepairService = 0.1 }} else { VO_minRepairService = 0.1 };
		// Debug initial counting:
		VO_grdCyclesDone = 0; VO_airCyclesDone = 0; VO_nauCyclesDone = 0; VO_grdStationsAmount = 0; VO_airStationsAmount = 0; VO_nauStationsAmount = 0;
		// checking if this file is properly configured:
		VO_isStationsOkay = false; VO_isServicesOkay = false;
		if (VO_groundDoctrine || VO_airDoctrine || VO_nauticDoctrine) then {
			VO_isStationsOkay = true;
			if VO_groundDoctrine then {
				//{ if (_x in (VO_grdFullAssets + VO_grdRepairAssets + VO_grdRefuelAssets + VO_grdRearmAssets)) exitWith {VO_hasGrdRngChanger = true}} forEach VO_assetsRangeChanger;
				if ( VO_grdServRepair || VO_grdServRefuel || VO_grdServRearm ) then {VO_isServicesOkay = true} else {systemChat format ["%1 fn_VO_management.sqf > No GROUND services set as TRUE!", VO_txtWarnHeader]}; 
				if ( VO_grdServRepair && count (VO_grdRepairAssets + VO_grdFullAssets) isEqualTo 0 ) then {systemChat format ["%1 fn_VO_management.sqf > No GROUND REPAIR assets configured!", VO_txtWarnHeader]};
				if ( VO_grdServRefuel && count (VO_grdRefuelAssets + VO_grdFullAssets) isEqualTo 0 ) then {systemChat format ["%1 fn_VO_management.sqf > No GROUND REFUEL assets configured!", VO_txtWarnHeader]};
				if ( VO_grdServRearm && count (VO_grdRearmAssets + VO_grdFullAssets) isEqualTo 0 ) then {systemChat format ["%1 fn_VO_management.sqf > No GROUND REARM assets configured!", VO_txtWarnHeader]}};
			if VO_airDoctrine then {
				{ if (_x in (VO_airFullAssets + VO_airRepairAssets + VO_airRefuelAssets + VO_airRearmAssets)) exitWith {VO_hasAirRngChanger = true}} forEach VO_assetsRangeChanger;
				if ( VO_airServRepair || VO_airServRefuel || VO_airServRearm ) then {VO_isServicesOkay = true} else {systemChat format ["%1 fn_VO_management.sqf > No AIR services set as TRUE!", VO_txtWarnHeader]};
				if ( VO_airServRepair && count (VO_airRepairAssets + VO_airFullAssets) isEqualTo 0 ) then {systemChat format ["%1 fn_VO_management.sqf > No AIR REPAIR assets configured!", VO_txtWarnHeader]};
				if ( VO_airServRefuel && count (VO_airRefuelAssets + VO_airFullAssets) isEqualTo 0 ) then {systemChat format ["%1 fn_VO_management.sqf > No AIR REFUEL assets configured!", VO_txtWarnHeader]};
				if ( VO_airServRearm && count (VO_airRearmAssets + VO_airFullAssets) isEqualTo 0 ) then {systemChat format ["%1 fn_VO_management.sqf > No AIR REARM assets configured!", VO_txtWarnHeader]}};
			if VO_nauticDoctrine then {
				//{ if (_x in (VO_nauFullAssets + VO_nauRepairAssets + VO_nauRefuelAssets + VO_nauRearmAssets)) exitWith {VO_hasNauRngChanger = true}} forEach VO_assetsRangeChanger;
				if ( VO_nauServRepair || VO_nauServRefuel || VO_nauServRearm ) then {VO_isServicesOkay = true} else {systemChat format ["%1 fn_VO_management.sqf > No NAUTIC services set as TRUE!", VO_txtWarnHeader]};
				if ( VO_nauServRepair && count (VO_nauRepairAssets + VO_nauFullAssets) isEqualTo 0 ) then {systemChat format ["%1 fn_VO_management.sqf > No AIR REPAIR assets configured!", VO_txtWarnHeader]};
				if ( VO_nauServRefuel && count (VO_nauRefuelAssets + VO_nauFullAssets) isEqualTo 0 ) then {systemChat format ["%1 fn_VO_management.sqf > No AIR REFUEL assets configured!", VO_txtWarnHeader]};
				if ( VO_nauServRearm && count (VO_nauRearmAssets + VO_nauFullAssets) isEqualTo 0 ) then {systemChat format ["%1 fn_VO_management.sqf > No AIR REARM assets configured!", VO_txtWarnHeader]}};
		} else {systemChat format ["%1 fn_VO_management.sqf > Vehicle Overhauling script is NOT running!", VO_txtWarnHeader]};
		// Broadcasting public variables:
		publicVariable "VO_isOn"; publicVariable "VO_debug_isOn"; publicVariable "VO_txtDebugHeader"; publicVariable "VO_txtWarnHeader"; publicVariable "VO_prefix"; publicVariable "VO_spacer"; publicVariable "VO_isReporting"; publicVariable "VO_dronesNeedHuman"; publicVariable "VO_groundDoctrine"; publicVariable "VO_grdServRepair"; publicVariable "VO_grdServRefuel"; publicVariable "VO_grdServRearm"; publicVariable "VO_grdServFull"; publicVariable "VO_grdServiceRange"; publicVariable "VO_grdCooldown"; publicVariable "VO_airDoctrine"; publicVariable "VO_airServRepair"; publicVariable "VO_airServRefuel"; publicVariable "VO_airServRearm"; publicVariable "VO_airServFull"; publicVariable "VO_airServiceRange"; publicVariable "VO_airCooldown"; publicVariable "VO_nauticDoctrine"; publicVariable "VO_nauServRepair"; publicVariable "VO_nauServRefuel"; publicVariable "VO_nauServRearm"; publicVariable "VO_nauServFull"; publicVariable "VO_nauServiceRange"; publicVariable "VO_nauCooldown"; publicVariable "VO_grdFullAssets"; publicVariable "VO_grdRepairAssets"; publicVariable "VO_grdRefuelAssets"; publicVariable "VO_grdRearmAssets"; publicVariable "VO_airFullAssets"; publicVariable "VO_airRepairAssets"; publicVariable "VO_airRefuelAssets"; publicVariable "VO_airRearmAssets"; publicVariable "VO_airParkingHelperAssets"; publicVariable "VO_nauFullAssets"; publicVariable "VO_nauRepairAssets"; publicVariable "VO_nauRefuelAssets"; publicVariable "VO_nauRearmAssets"; publicVariable "VO_grdVehicleTypes"; publicVariable "VO_airVehicleTypes"; publicVariable "VO_nauVehicleTypes"; publicVariable "VO_assetsRangeChanger"; publicVariable "VO_hasAirRngChanger"; publicVariable "VO_minRefuelService"; publicVariable "VO_isACErun"; publicVariable "VO_grdCyclesDone"; publicVariable "VO_airCyclesDone"; publicVariable "VO_nauCyclesDone"; publicVariable "VO_grdStationsAmount"; publicVariable "VO_airStationsAmount"; publicVariable "VO_nauStationsAmount"; publicVariable "VO_isStationsOkay"; publicVariable "VO_isServicesOkay"; publicVariable "VO_minRepairService";