private ["_side", "_u"];

_side = _this;

missionNamespace setVariable [format["CTI_%1_Commander", _side], "O_officer_F"];
missionNamespace setVariable [format["CTI_%1_Worker", _side], "O_Soldier_lite_F"];

missionNamespace setVariable [format["CTI_%1_Diver", _side], "O_diver_F"];
missionNamespace setVariable [format["CTI_%1_Soldier", _side], "O_Soldier_F"];
missionNamespace setVariable [format["CTI_%1_Crew", _side], "O_crew_F"];
missionNamespace setVariable [format["CTI_%1_Pilot", _side], "O_Helipilot_F"];

missionNamespace setVariable [format["CTI_%1_Vehicles_Startup", _side], [
	["O_Truck_03_medical_F", [
		["arifle_Katiba_GL_ARCO_pointer_F", 2], ["30rnd_65x39_caseless_green", 20], ["30Rnd_65x39_caseless_green_mag_Tracer", 4],
		["srifle_DMR_01_ARCO_F", 1], ["10Rnd_762x54_Mag", 10],
		["launch_RPG32_F", 1], ["RPG32_F", 20],
		["launch_RPG7_F", 1], ["RPG7_F", 5],
		["HandGrenade", 15],
		["30Rnd_556x45_Stanag", 10],
		["1Rnd_HE_Grenade_shell", 18],
		["firstaidkit", 10],
		["optic_MRCO", 5],
		["Toolkit", 1]
	]],
	["C_IDAP_Van_02_medevac_F", [	
		["firstaidkit", 10],
		["30Rnd_556x45_Stanag", 15],
		["launch_RPG32_F", 1], ["RPG32_F", 15],
		["launch_RPG7_F", 1], ["RPG7_F", 5]
	]]
	//,	["O_Heli_Light_02_unarmed_F", []]
]];

//--- Units - Barracks

_u =  ['O_Soldier_lite_F'];
_u = _u		+ ['O_crew_F'];
_u = _u		+ ['O_Soldier_F'];
_u = _u		+ ['O_soldierU_F'];
_u = _u		+ ['O_Helipilot_F'];
_u = _u		+ ['O_diver_F'];
_u = _u		+ ['O_soldier_UAV_F'];
_u = _u		+ ['O_recon_F'];
_u = _u		+ ['O_soldier_AR_F'];
_u = _u		+ ['O_soldierU_AR_F'];
_u = _u		+ ['O_HeavyGunner_F'];
_u = _u		+ ['O_Urban_HeavyGunner_F'];
_u = _u		+ ['O_Soldier_GL_F'];
_u = _u		+ ['O_SoldierU_GL_F'];
_u = _u		+ ['O_R_Patrol_Soldier_AR_F']; // new
_u = _u		+ ['O_R_Soldier_LAT_F']; // new
_u = _u		+ ['O_R_soldier_M_F'];   // new
_u = _u		+ ['O_R_JTAC_F'];        // new
_u = _u		+ ['O_soldier_LAT_F'];
_u = _u		+ ['O_soldierU_LAT_F'];
_u = _u		+ ['O_recon_LAT_F'];
_u = _u		+ ['O_soldier_M_F'];
_u = _u		+ ['O_soldierU_M_F'];
_u = _u		+ ['O_Sharpshooter_F'];
_u = _u		+ ['O_Urban_Sharpshooter_F'];
_u = _u		+ ['O_recon_M_F'];
_u = _u		+ ['O_Pathfinder_F'];
_u = _u		+ ['O_medic_F'];
_u = _u		+ ['O_soldierU_medic_F'];
_u = _u		+ ['O_recon_medic_F'];
_u = _u		+ ['O_soldier_repair_F'];
_u = _u		+ ['O_soldierU_repair_F'];
_u = _u		+ ['O_engineer_F'];
_u = _u		+ ['O_engineer_U_F'];
_u = _u		+ ['O_soldier_exp_F'];
_u = _u		+ ['O_soldierU_exp_F'];
_u = _u		+ ['O_recon_exp_F'];
_u = _u		+ ['O_soldier_PG_F'];
_u = _u		+ ['O_soldier_AA_F'];
_u = _u		+ ['O_soldierU_AA_F'];
_u = _u		+ ['O_soldier_AT_F'];
_u = _u		+ ['O_soldierU_AT_F'];
_u = _u		+ ['O_spotter_F'];
_u = _u		+ ['O_recon_JTAC_F'];
_u = _u		+ ['O_sniper_F'];
_u = _u		+ ['O_ghillie_lsh_F'];
_u = _u		+ ['O_ghillie_sard_F'];
_u = _u		+ ['O_ghillie_ard_F'];



missionNamespace setVariable [format ["CTI_%1_%2Units", _side, CTI_BARRACKS], _u];

_u 			= ['O_Quadbike_01_F'];
_u = _u		+ ['C_Kart_01_F'];
_u = _u		+ ["C_Kart_01_black_F"];    // cart dlc
_u = _u		+ ['SUV_01_base_red_F'];
_u = _u		+ ['C_Hatchback_01_sport_F'];
_u = _u		+ ["O_G_Van_02_transport_F"];
_u = _u		+ ["O_G_Van_02_vehicle_F"];
_u = _u		+ ["I_C_Offroad_02_unarmed_F"];
_u = _u		+ ["C_Offroad_02_unarmed_F"];
_u = _u		+ ["O_G_Offroad_01_F"];
_u = _u		+ ["O_G_Offroad_01_armed_F"];
_u = _u		+ ['O_Truck_02_transport_F'];
_u = _u		+ ['O_Truck_03_transport_F'];
_u = _u		+ ['O_MRAP_02_F'];
_u = _u		+ ['O_MRAP_02_hmg_F'];
_u = _u		+ ['O_MRAP_02_gmg_F'];
_u = _u		+ ['O_LSV_02_unarmed_F'];
_u = _u		+ ['O_LSV_02_armed_F'];
_u = _u		+ ['O_T_LSV_02_AT_F']; // new
_u = _u		+ ['O_UGV_01_F'];
_u = _u		+ ['O_UGV_01_rcws_F'];
_u = _u		+ ['O_UGV_02_Demining_F']; // new
_u = _u		+ ['O_UGV_02_Science_F']; // new
_u = _u		+ ['O_Truck_03_medical_F'];
_u = _u		+ ['O_Truck_02_medical_F'];
_u = _u		+ ['C_IDAP_Van_02_medevac_F'];
_u = _u		+ ['I_MRAP_03_F'];
_u = _u		+ ['I_MRAP_03_hmg_F'];
_u = _u		+ ['I_MRAP_03_gmg_F'];
_u = _u		+ ['O_G_Van_01_transport_F'];
_u = _u		+ ["C_Truck_02_transport_F"];    // truck dlc





missionNamespace setVariable [format ["CTI_%1_%2Units", _side, CTI_LIGHT], _u];

_u 			= ["O_APC_Tracked_02_cannon_F"];
_u = _u		+ ['O_APC_Wheeled_02_rcws_F'];
_u = _u		+ ["O_MBT_02_cannon_F"];
_u = _u		+ ["O_APC_Tracked_02_AA_F"];
_u = _u		+ ["O_MBT_04_cannon_F"];   // tank dlc
_u = _u		+ ["O_MBT_04_command_F"];  // tank dlc
_u = _u		+ ['I_APC_Wheeled_03_cannon_F'];
_u = _u		+ ['I_APC_tracked_03_cannon_F'];
_u = _u		+ ["I_LT_01_scout_F"];     // tank dlc
_u = _u		+ ["I_LT_01_cannon_F"];    // tank dlc
_u = _u		+ ["I_LT_01_AA_F"];        // tank dlc
_u = _u		+ ["I_LT_01_AT_F"];        // tank dlc
_u = _u		+ ['I_MBT_03_cannon_F'];
_u = _u		+ ["I_Truck_02_MRL_F"];    // tank dlc
_u = _u		+ ["O_MBT_02_arty_F"];

missionNamespace setVariable [format ["CTI_%1_%2Units", _side, CTI_HEAVY], _u];

// =============================================
// OPFOR AVIATION - FIXED CLASSES
// =============================================

_u      = ['O_UAV_01_F'];                               // БПЛА (разведывательный)
_u = _u + ['C_IDAP_UAV_06_antimine_F'];                 // БПЛА (противоминный)
_u = _u + ['C_Plane_Civil_01_F'];                       // Самолет гражданский
_u = _u + ['O_Heli_Light_02_unarmed_F'];                // PO-30 Орка (без вооружения)

// ============ ВЕРТОЛЕТЫ (dynamicLoadout) ============
_u = _u + ['O_Heli_Transport_04_F'];                     // Ми-290 Тару
_u = _u + ['O_Heli_Transport_04_bench_F'];               // Ми-290 Тару (со скамьями)
_u = _u + ['O_Heli_Transport_04_covered_F'];             // Ми-290 Тару (крытый)
_u = _u + ['O_Heli_Light_02_dynamicLoadout_F'];          // PO-30 Орка (dynamicLoadout)
_u = _u + ['O_Heli_Attack_02_dynamicLoadout_F'];         // Ми-48 Кайман (dynamicLoadout)
_u = _u + ['O_Heli_Attack_02_black_F'];                  // Ми-48 Кайман (черный)

// ============ БПЛА (dynamicLoadout) ============
_u = _u + ['O_UAV_02_dynamicLoadout_F'];                 // БПЛА (ударный)
_u = _u + ['O_T_UAV_04_CAS_F'];                          // KH-3A Фэнхуан
_u = _u + ['O_UAV_02_F'];                                // БПЛА (разведывательный) - без dynamicLoadout

// ============ САМОЛЕТЫ (dynamicLoadout) ============
_u = _u + ['O_Plane_CAS_02_dynamicLoadout_F'];           // То-199 Неофрон (dynamicLoadout)
_u = _u + ['O_Plane_Fighter_02_F'];                      // То-201 Шикра
_u = _u + ['O_Plane_Fighter_02_Stealth_F'];              // То-201 Шикра (стелс)
_u = _u + ['O_Plane_Fighter_02_Cluster_F'];              // То-201 Шикра (кассетный)

// ============ КОНВЕРТОПЛАНЫ ============
_u = _u + ['O_T_VTOL_02_vehicle_dynamicLoadout_F'];      // Y-32 Сиань (грузовой)

// ============ INDEP ТЕХНИКА ============
_u = _u + ['I_Heli_light_03_unarmed_F'];                 // Hellcat (без вооружения)
_u = _u + ['I_Heli_light_03_F'];                         // Hellcat (вооруженный)
_u = _u + ['I_Heli_Transport_02_F'];                     // Вертолет транспортный
_u = _u + ['I_Plane_Fighter_03_dynamicLoadout_F'];        // A-143 Бузард (штурмовик)     
_u = _u + ['I_Plane_Fighter_03_AA_F'];                   // A-143 Бузард (ПВО)
_u = _u + ['I_Plane_Fighter_04_Cluster_F'];              // A-149 Грифон (кассетный)


// ============ МОДУЛИ ============
_u = _u + ['Land_Pod_Heli_Transport_04_medevac_F'];      // Медицинский модуль
_u = _u + ['Land_Device_slingloadable_F'];               // Устройство (подвесное)

// ============ ГРАЖДАНСКИЕ ============
_u = _u + ["C_Heli_Light_01_civil_F"];                   // Вертолет гражданский (air dlc)

missionNamespace setVariable [format ["CTI_%1_%2Units", _side, CTI_AIR], _u];

missionNamespace setVariable [format ["CTI_%1_%2Units", _side, CTI_AIR], _u];

_u 			= ["O_Truck_02_box_F"];
_u = _u		+ ["O_Truck_03_repair_F"];
_u = _u		+ ["CTI_Salvager_East"];
_u = _u		+ ["O_Truck_02_fuel_F"];
_u = _u		+ ["O_Truck_03_fuel_F"];
_u = _u		+ ['O_G_Van_01_fuel_F'];
_u = _u		+ ["Land_Pod_Heli_Transport_04_repair_F"];
_u = _u		+ ["Land_Pod_Heli_Transport_04_fuel_F"];
missionNamespace setVariable [format ["CTI_%1_%2Units", _side, CTI_REPAIR], _u];

_u 			= ["O_Truck_02_Ammo_F"];
_u = _u		+ ["O_Truck_03_Ammo_F"];
_u = _u		+ ["Land_Pod_Heli_Transport_04_ammo_F"];
missionNamespace setVariable [format ["CTI_%1_%2Units", _side, CTI_AMMO], _u];

_u 			= ['C_Scooter_Transport_01_F'];
_u = _u		+ ['O_Boat_Transport_01_F'];
_u = _u		+ ['O_Boat_Armed_01_hmg_F'];
_u = _u		+ ['O_SDV_01_F'];
_u = _u		+ ['C_Boat_Civil_01_police_F'];
missionNamespace setVariable [format ["CTI_%1_%2Units", _side, CTI_NAVAL], _u];



//--- Units - FLAG
_u = ['O_Soldier_F'];
_u = _u		+ ['Box_East_WpsLaunch_F'];
_u = _u		+ ['Box_East_AmmoOrd_F'];
_u = _u		+ ['Box_East_Wps_F'];
_u = _u		+ ['Box_East_WpsSpecial_F'];
_u = _u		+ ['Box_East_Ammo_F'];
_u = _u		+ ['Box_East_Grenades_F'];
_u = _u		+ ['Box_East_Support_F'];
_u = _u		+ ['O_supplyCrate_F'];
_u = _u		+ ['O_Quadbike_01_F'];
_u = _u		+ ['C_Tractor_01_F']; // new
_u = _u		+ ['SUV_01_base_red_F']; // new
_u = _u		+ ['O_G_Offroad_01_F'];
_u = _u		+ ['O_G_Offroad_01_armed_F'];

// _u = _u		+ ['B_AAA_System_01_F'];  // NEW
// _u = _u		+ ['B_SAM_System_01_F'];  // NEW
// _u = _u		+ ['B_SAM_System_02_F'];  // NEW


_u = _u		+ ['O_Mortar_01_F'];
_u = _u		+ ['O_UAV_01_F'];


/*
_u = _u		+ ['O_MRAP_02_F'];
_u = _u		+ ['O_MRAP_02_hmg_F'];
_u = _u		+ ['O_MRAP_02_gmg_F'];
_u = _u		+ ['O_Truck_02_covered_F'];

_u = _u		+ ['I_MRAP_03_F'];
_u = _u		+ ['I_MRAP_03_hmg_F'];
_u = _u		+ ['I_MRAP_03_gmg_F'];

_u = _u		+ ['O_G_Van_01_transport_F'];
_u = _u		+ ['O_G_Van_01_fuel_F'];
_u = _u		+ ['C_SUV_01_F'];
_u = _u		+ ['C_Hatchback_01_sport_F'];
_u = _u		+ ['C_Kart_01_F'];
*/

missionNamespace setVariable [format ["CTI_%1_%2Units", _side, CTI_FTOWN], _u];