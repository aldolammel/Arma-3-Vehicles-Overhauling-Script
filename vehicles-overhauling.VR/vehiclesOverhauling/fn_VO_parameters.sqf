
// EDITOR'S OPTIONS:

	VO_debugMonitor = false;          // true = turn on the editor hints / false = turn it off.
	VO_feedbackMsgs = true;          // true = the station shows service messages in-game for the player (highly recommended) / false = turn it off.
	
	// GROUND SERVICES
	groundVehiclesOverhauling = true;          // true = the station accepts ground vehicles / false = doesn't accept.

		VO_groundServRepair = true;          // true = repairing for ground veh is available / false = not available / highly recommended turn it on if you want also to refueling.
		VO_groundServRefuel = true;          // true = refueling for ground veh is available / false = not available.
		VO_groundServRearm = true;          // true = rearming for ground veh is available / false = not available.
		VO_grdActRange = 10;          // in meters, the area around the station that identifies the ground vehicle to be serviced. Default 10.
		VO_grdCooldown = 10;          // in seconds, time among each available ground services. Default 10.
		VO_grdStationAssets =          // which assets (classnames) will be automatically ground stations on mission.
		[
			"Land_RepairDepot_01_green_F",
			"Land_RepairDepot_01_tan_F"
		];

	// AIR SERVICES
	airVehiclesOverhauling = true;          // true = the station accepts air vehicles / false = doesn't accept.

		VO_airServRepair = true;          // true = repairing for air veh is available / false = not available / highly recommended turn it on if you want also to refueling.
		VO_airServRefuel = true;          // true = refueling for air veh is available / false = not available.
		VO_airServRearm = true;          // true = rearming for air veh is available / false = not available.
		VO_airActRange = 20;          // in meters, the area around the station that identifies the air vehicle to be serviced. Default 10.
		VO_airCooldown = 10;          // in seconds, time among each available air services. Default 10.
		VO_airStationAssets =          // which assets (classnames) will be automatically air stations on mission.
		[
			"Land_HelipadRescue_F",
			"Land_HelipadSquare_F",
			"Land_HelipadCircle_F",
			"Land_HelipadCivil_F"
		];
	
	// NAUTIC SERVICES
	nauticVehiclesOverhauling = true;          // true = the station accepts nautic vehicles / false = doesn't accept.

		VO_nauticServRepair = true;          // true = repairing for nautic veh is available / false = not available / highly recommended turn it on if you want also to refueling.
		VO_nauticServRefuel = true;          // true = refueling for nautic veh is available / false = not available.
		VO_nauticServRearm = true;          // true = rearming for nautic veh is available / false = not available.
		VO_nauActRange = 25;          // in meters, the area around the station that identifies the nautic vehicle to be serviced. Default 10.
		VO_nauCooldown = 10;          // in seconds, time among each available nautic services. Default 10.
		VO_nauStationAssets =          // which assets (classnames) will be automatically nautic stations on mission.
		[
			"Land_TBox_F"
		];


	true
