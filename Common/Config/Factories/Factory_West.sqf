private ["_side", "_u"];

_side = _this;

missionNamespace setVariable [format["CTI_%1_Commander", _side], "B_officer_F"];
missionNamespace setVariable [format["CTI_%1_Worker", _side], "B_Soldier_lite_F"];

missionNamespace setVariable [format["CTI_%1_Diver", _side], "B_diver_f"];
missionNamespace setVariable [format["CTI_%1_Soldier", _side], "B_Soldier_F"];
missionNamespace setVariable [format["CTI_%1_Crew", _side], "B_crew_F"];
missionNamespace setVariable [format["CTI_%1_Pilot", _side], "B_Helipilot_F"];

missionNamespace setVariable [format["CTI_%1_Vehicles_Startup", _side], [
	["B_Truck_01_medical_F", [
		["arifle_MX_GL_Hamr_pointer_F", 2], ["30Rnd_65x39_caseless_mag", 20], ["30Rnd_65x39_caseless_mag_Tracer", 4],
		["arifle_MXM_Hamr_pointer_F", 1],
		["launch_NLAW_F", 1], ["NLAW_F", 20],
		["HandGrenade", 15],
		["30Rnd_556x45_Stanag", 10],
		["3Rnd_HE_Grenade_shell", 6],
		["firstaidkit", 10],
		["optic_MRCO", 5],
		["Toolkit", 1]
	]],
	["C_Van_02_medevac_F", [
		["firstaidkit", 10],
		["30Rnd_556x45_Stanag", 15],
		["launch_NLAW_F", 1], ["NLAW_F", 15]
	]]
	//,	["B_Heli_Transport_01_F", []]

]];

//--- Units - Barracks

_u = ["B_Soldier_lite_F"];
_u = _u		+ ["B_crew_F"];
_u = _u		+ ["B_Soldier_F"];
_u = _u		+ ["B_Helipilot_F"];
_u = _u		+ ["B_diver_F"];
_u = _u		+ ["B_soldier_UAV_F"];
_u = _u		+ ['B_recon_F'];
_u = _u		+ ["B_soldier_AR_F"];
_u = _u		+ ['B_HeavyGunner_F'];
_u = _u		+ ["B_Soldier_GL_F"];
_u = _u		+ ["B_soldier_LAT_F"];
_u = _u		+ ['B_recon_LAT_F'];
_u = _u		+ ["B_soldier_M_F"];
_u = _u		+ ['B_Sharpshooter_F'];
_u = _u		+ ['B_recon_M_F'];
_u = _u		+ ['B_Recon_Sharpshooter_F'];
_u = _u		+ ["B_medic_F"];
_u = _u		+ ['B_recon_medic_F'];
_u = _u		+ ["B_soldier_repair_F"];
_u = _u		+ ["B_engineer_F"];
_u = _u		+ ["B_soldier_exp_F"];
_u = _u		+ ['B_recon_exp_F'];
_u = _u		+ ["B_soldier_PG_F"];
_u = _u		+ ["B_soldier_AA_F"];
_u = _u		+ ["B_soldier_AT_F"];
_u = _u		+ ["B_spotter_F"];
_u = _u		+ ["B_recon_JTAC_F"];
_u = _u		+ ["B_sniper_F"];
_u = _u		+ ['B_ghillie_lsh_F'];
_u = _u		+ ['B_ghillie_sard_F'];
_u = _u		+ ['B_ghillie_ard_F'];


missionNamespace setVariable [format ["CTI_%1_%2Units", _side, CTI_BARRACKS], _u];

_u 			= ["B_Quadbike_01_F"];
_u = _u		+ ["B_G_Van_02_transport_F"];
_u = _u		+ ["B_G_Van_02_vehicle_F"];
_u = _u		+ ["I_C_Offroad_02_unarmed_F"];
_u = _u		+ ["C_Offroad_02_unarmed_F"];
_u = _u		+ ["B_G_Offroad_01_F"];
_u = _u		+ ["B_G_Offroad_01_armed_F"];
_u = _u		+ ["B_Truck_01_transport_F"];
_u = _u		+ ["B_MRAP_01_F"];
_u = _u		+ ["B_MRAP_01_hmg_F"];
_u = _u		+ ["B_MRAP_01_gmg_F"];
_u = _u		+ ['B_CTRG_LSV_01_light_F'];
_u = _u		+ ['B_LSV_01_unarmed_F'];
_u = _u		+ ['B_LSV_01_armed_F'];
_u = _u		+ ['B_T_LSV_01_AT_F']; // new
_u = _u		+ ["B_UGV_01_F"];
_u = _u		+ ["B_UGV_01_rcws_F"];
_u = _u		+ ["B_UGV_02_Demining_F"]; // new
_u = _u		+ ["B_UGV_02_Science_F"]; // new
_u = _u  	+ ["B_Truck_01_medical_F"];
_u = _u		+ ['I_Truck_02_medical_F'];
_u = _u		+ ['C_Van_02_medevac_F'];
_u = _u		+ ['I_MRAP_03_F'];
_u = _u		+ ['I_MRAP_03_hmg_F'];
_u = _u		+ ['I_MRAP_03_gmg_F'];
_u = _u		+ ['B_G_Van_01_transport_F'];
_u = _u		+ ['SUV_01_base_black_F'];
_u = _u		+ ['C_Hatchback_01_sport_F'];
_u = _u		+ ['C_Kart_01_F'];
_u = _u		+ ["C_Kart_01_black_F"];    // cart dlc
_u = _u		+ ["C_Truck_02_transport_F"];    // truck dlc

missionNamespace setVariable [format ["CTI_%1_%2Units", _side, CTI_LIGHT], _u];


_u 			= ["B_APC_Tracked_01_rcws_F"];
_u = _u  	+ ["B_APC_Tracked_01_CRV_F"];
_u = _u  	+ ["B_APC_Wheeled_01_cannon_F"];
_u = _u		+ ['B_AFV_Wheeled_01_cannon_F'];    // tank dls
_u = _u		+ ['B_AFV_Wheeled_01_up_cannon_F']; // tank dlc
_u = _u		+ ["B_APC_Tracked_01_AA_F"];
_u = _u		+ ["B_MBT_01_cannon_F"];
_u = _u		+ ["B_MBT_01_TUSK_F"];
_u = _u		+ ['I_APC_Wheeled_03_cannon_F'];
_u = _u		+ ['I_APC_tracked_03_cannon_F'];
_u = _u		+ ["I_LT_01_scout_F"];   // tank dlc
_u = _u		+ ["I_LT_01_cannon_F"];  // tank dlc
_u = _u		+ ["I_LT_01_AA_F"];      // tank dlc
_u = _u		+ ["I_LT_01_AT_F"];      // tank dlc
_u = _u		+ ['I_MBT_03_cannon_F'];
_u = _u		+ ["B_MBT_01_arty_F"];
_u = _u		+ ["B_MBT_01_mlrs_F"];


missionNamespace setVariable [format ["CTI_%1_%2Units", _side, CTI_HEAVY], _u];

// =============================================
// BLUFOR AVIATION - CLASSES
// =============================================

_u      = ["B_UAV_01_F"];                                  // БПЛА (разведывательный)
_u = _u	+ ['C_IDAP_UAV_06_antimine_F'];                    // БПЛА (противоминный)
// ============ БПЛА (UAV) ============
_u = _u + ['B_UAV_05_F'];                                // MQ-4A Greyhawk (разведывательный)
_u = _u + ['B_UAV_02_dynamicLoadout_F'];                 // MQ-12 Falcon (ударный)
_u = _u + ['B_T_UAV_03_dynamicLoadout_F'];               // MQ-9 Reaper (тяжелый ударный)

// ============ ВЕРТОЛЕТЫ (Helicopters) ============
_u = _u + ['B_Heli_Light_01_F'];                         // MH-9 Hummingbird (разведывательный/транспортный)
_u = _u + ['B_Heli_Light_01_dynamicLoadout_F'];          // MH-9 Hummingbird (легкий ударный)
_u = _u + ['B_Heli_Attack_01_dynamicLoadout_F'];         // AH-99 Blackfoot (ударный)
_u = _u + ['B_Heli_Attack_01_pylons_dynamicLoadout_F'];  // AH-99 Blackfoot (ударный с усиленными пилонами)
_u = _u + ['B_Heli_Transport_01_F'];                     // UH-80 Ghost Hawk (транспортный)
_u = _u + ['B_Heli_Transport_01_pylons_F'];              // UH-80 Ghost Hawk (транспортный с пилонами)
_u = _u + ['B_Heli_Transport_03_F'];                     // CH-67 Huron (тяжелый транспортный)
_u = _u + ['B_CTRG_Heli_Transport_01_Assault_F'];        // UH-80 Ghost Hawk (CTRG) — вариант Assault (штурмовой / транспортно-боевой).
_u = _u + ['B_CTRG_Heli_Transport_01_DAP_F'];            // UH-80 Ghost Hawk DAP (CTRG) — вариант DAP (Direct Action Penetrator / ударный).    


// ============ САМОЛЕТЫ (Planes) ============
_u = _u + ['B_Plane_CAS_01_dynamicLoadout_F'];           // A-10 Wipeout (штурмовик CAS)
_u = _u + ['B_Plane_Fighter_01_F'];                     // F-35B Black Wasp II (истребитель)
_u = _u + ['B_Plane_Fighter_01_Stealth_F'];             // F-35B Black Wasp II (стелс-истребитель)
_u = _u + ['B_Plane_Fighter_01_Cluster_F'];             // F-35B Black Wasp II (кассетный)

// ============ КОНВЕРТОПЛАНЫ (VTOL) ============
_u = _u + ['B_T_VTOL_01_armed_F'];                      // V-44 X (вооруженный конвертоплан)

// ============ INDEP ТЕХНИКА ============
_u = _u + ['I_Heli_light_03_unarmed_F'];                 // Hellcat (без вооружения)
_u = _u + ['I_Heli_light_03_F'];                         // Hellcat (вооруженный)
_u = _u + ['I_Heli_Transport_02_F'];                     // Вертолет транспортный
_u = _u + ['I_Plane_Fighter_03_dynamicLoadout_F'];        // A-143 Бузард (штурмовик)     
_u = _u + ['I_Plane_Fighter_03_AA_F'];                   // A-143 Бузард (ПВО)
_u = _u + ['I_Plane_Fighter_04_Cluster_F'];              // A-149 Грифон (кассетный)

_u = _u + ['B_Slingload_01_Medevac_F'];                      // Медицинский подвесной контейнер
_u = _u + ['Land_Device_slingloadable_F'];                   // Устройство (подвесное)

_u = _u + ["C_Heli_Light_01_civil_F"];                   // Вертолет гражданский (air dlc)


missionNamespace setVariable [format ["CTI_%1_%2Units", _side, CTI_AIR], _u];

_u 			= ["B_Truck_01_Repair_F"];
_u = _u		+ ["CTI_Salvager_West"];
_u = _u		+ ["B_Truck_01_fuel_F"];
_u = _u		+ ['B_G_Van_01_fuel_F'];
_u = _u		+ ['B_Slingload_01_Repair_F'];
_u = _u		+ ['B_Slingload_01_Fuel_F'];
_u = _u		+ ['B_Truck_01_mover_F'];

missionNamespace setVariable [format ["CTI_%1_%2Units", _side, CTI_REPAIR], _u];

_u 			= ["B_Truck_01_ammo_F"];
_u = _u		+ ['B_Slingload_01_Ammo_F'];
missionNamespace setVariable [format ["CTI_%1_%2Units", _side, CTI_AMMO], _u];

_u 			= ["C_Scooter_Transport_01_F"];
_u = _u		+ ["B_Boat_Transport_01_F"];
_u = _u		+ ["B_Boat_Armed_01_minigun_F"];
_u = _u		+ ["B_SDV_01_F"];
_u = _u		+ ["C_Boat_Civil_01_rescue_F"];
missionNamespace setVariable [format ["CTI_%1_%2Units", _side, CTI_NAVAL], _u];



//--- Units - FLAG
_u = ['B_Soldier_F'];
_u = _u		+ ['Box_NATO_WpsLaunch_F'];
_u = _u		+ ['Box_NATO_AmmoOrd_F'];
_u = _u		+ ['Box_NATO_Wps_F'];
_u = _u		+ ['Box_NATO_WpsSpecial_F'];
_u = _u		+ ['Box_NATO_Ammo_F'];
_u = _u		+ ['Box_NATO_Grenades_F'];
_u = _u		+ ['Box_NATO_Support_F'];
_u = _u		+ ['B_supplyCrate_F'];
_u = _u		+ ['B_Quadbike_01_F'];
_u = _u		+ ['SUV_01_base_black_F']; // new
_u = _u		+ ['B_G_Offroad_01_F'];
_u = _u		+ ['B_G_Offroad_01_armed_F'];


//_u = _u		+ ['B_AAA_System_01_F'];  // NEW
//_u = _u		+ ['B_SAM_System_01_F'];  // NEW
//_u = _u		+ ['B_SAM_System_02_F'];  // NEW
_u = _u		+ ['B_Mortar_01_F'];
_u = _u		+ ['B_UAV_01_F'];  

/*
_u = _u		+ ['B_MRAP_01_F'];
_u = _u		+ ['B_MRAP_01_hmg_F'];
_u = _u		+ ['B_MRAP_01_gmg_F'];
_u = _u		+ ['B_Truck_01_covered_F'];

_u = _u		+ ['I_MRAP_03_F'];
_u = _u		+ ['I_MRAP_03_hmg_F'];
_u = _u		+ ['I_MRAP_03_gmg_F'];

_u = _u		+ ['B_G_Van_01_transport_F'];
_u = _u		+ ['B_G_Van_01_fuel_F'];
_u = _u		+ ['C_SUV_01_F'];
_u = _u		+ ['C_Hatchback_01_sport_F'];
_u = _u		+ ['C_Kart_01_F'];
*/

missionNamespace setVariable [format ["CTI_%1_%2Units", _side, CTI_FTOWN], _u];