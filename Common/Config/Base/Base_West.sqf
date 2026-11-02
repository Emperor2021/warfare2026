_side = _this;

missionNamespace setVariable [format["CTI_%1_HQ", _side], "B_APC_Wheeled_01_cannon_F"];
missionNamespace setVariable [format["CTI_%1_Factories", _side], ["Barracks","Light","Heavy","Air","Ammo","Repair"]];

missionNamespace setVariable [format["CTI_%1_Base_Template", _side], [
	[CTI_BARRACKS, 180, [-23,33]],
	[CTI_LIGHT, 180, [23,33]],
	[CTI_CONTROLCENTER, 0, [30,-40]],
	[CTI_HEAVY, 0, [-30,-40]],
	[CTI_AIR, 180, [-60,37]],
	[CTI_REPAIR, 180, [60,37]],
	[CTI_AMMO, 180, [80,37]]
]];

// checks: structure -> not in WIP and still alive & kicking & can build with area?
// checks: upgrades -> not running
// iterate thru the path till what's done

//--- Commander course of action ["Action", Parameter(s), Condition]
missionNamespace setVariable [format["CTI_%1_Commander_Path", _side], [
	["build-structures", CTI_BARRACKS, {true}],
	["build-structures", CTI_LIGHT, {true}],
	["build-structures", CTI_CONTROLCENTER, {true}],
	["upgrade", [CTI_UPGRADE_BARRACKS, 1], {true}],
	["upgrade", [CTI_UPGRADE_GEAR, 1], {true}],
	["upgrade", [CTI_UPGRADE_LIGHT, 1], {true}],
	["upgrade", [CTI_UPGRADE_TOWNS, 1], {true}],
	["upgrade", [CTI_UPGRADE_GEAR, 2], {true}],
	["build-structures", CTI_HEAVY, {true}],
	["build-structures", CTI_REPAIR, {true}],
	["build-structures", CTI_AMMO, {true}],
	["upgrade", [CTI_UPGRADE_HEAVY, 1], {true}],
	["upgrade", [CTI_UPGRADE_GEAR, 3], {true}],
	["build-structures", CTI_AIR, {true}],
	["upgrade", [CTI_UPGRADE_TOWNS, 2], {true}],
	["upgrade", [CTI_UPGRADE_AIR, 1], {true}],
	["upgrade", [CTI_UPGRADE_AIR_CM, 1], {true}],
	["upgrade", [CTI_UPGRADE_AIR_AT, 1], {true}],
	["upgrade", [CTI_UPGRADE_AIR_FFAR, 1], {true}],
	["upgrade", [CTI_UPGRADE_AIR_AA, 1], {true}],
	["upgrade", [CTI_UPGRADE_TOWNS, 3], {true}],
	["upgrade", [CTI_UPGRADE_SATELLITE, 1], {true}],
	["upgrade", [CTI_UPGRADE_HEN, 1], {true}]
]];

//--- Structures
_headers = [];
_classes = [];
_prices = [];
_times = [];
_placements = [];
_specials = [];

/*
	Specials:
		- DMG_Alternative: Need to be used in case of bisterious buildings usage
				If a building is damaged, all the EH it had will bisteriously vanish... This "feature" will probably never get fixed so once again, we fix it ourself!
		- DMG_Reduce: Reduce the incoming damage on a building making it stronger if above 1.
*/


_headers = _headers 		+ [[CTI_BARRACKS, localize "STR_Up_Barracks", localize "STR_Up_Barracks"]];
_classes = _classes 		+ [["Land_Cargo_House_V1_F", "Land_Cargo_House_V1_ruins_F"]];
_prices = _prices 			+ [1000];
_times = _times 			+ [30];
_placements = _placements 	+ [[180, 15]];
_specials = _specials		+ [[["DMG_Reduce", 2]]];

_headers = _headers 		+ [[CTI_LIGHT, localize "STR_Light_Vehicle_Factory", localize "STR_Light_Vehicle_Factory_1"]];
_classes = _classes 		+ [["Land_i_Garage_V1_F", "Land_Garage_V1_ruins_F"]];
_prices = _prices 			+ [2000];
_times = _times 			+ [40];
_placements = _placements 	+ [[90, 20]];
_specials = _specials		+ [[["DMG_Alternative"],["DMG_Reduce", 0.7]]];

_headers = _headers 		+ [[CTI_CONTROLCENTER, localize "STR_Control_Center", localize "STR_Control_Center_1"]];
_classes = _classes 		+ [["Land_i_House_Small_03_V1_F", "Land_House_Small_03_V1_ruins_F", ["Land_i_House_Small_03_V1_dam_F"]]];
_prices = _prices 			+ [3000];
_times = _times 			+ [45];
_placements = _placements 	+ [[180, 20]];
_specials = _specials		+ [[["Connected"],["DMG_Alternative"],["DMG_Reduce", 0.4]]];

_headers = _headers 		+ [[CTI_HEAVY, localize "STR_Heavy_Vehicle_Factory", localize "STR_Heavy_Vehicle_Factory_1"]];
_classes = _classes 		+ [["Land_Cargo_HQ_V1_F", "Land_Cargo_HQ_V1_ruins_F"]];
_prices = _prices 			+ [3500];
_times = _times 			+ [60];
_placements = _placements 	+ [[90, 20]];
_specials = _specials		+ [[]];

_headers = _headers 		+ [[CTI_AIR, localize "STR_Aircraft_Factory", localize "STR_Aircraft_Factory_1"]];
_classes = _classes 		+ [["Land_Research_HQ_F", "Land_Research_HQ_ruins_F"]];
_prices = _prices 			+ [8000];
_times = _times 			+ [70];
_placements = _placements 	+ [[90, 35]];
_specials = _specials		+ [[]];

_headers = _headers 		+ [[CTI_AMMO, localize "STR_Ammo_Depot", localize "STR_Ammo_Depot_1"]];
_classes = _classes 		+ [["Land_TBox_F", "Land_TBox_ruins_F"]];
_prices = _prices 			+ [500];
_times = _times 			+ [20];
_placements = _placements 	+ [[0, 20]];
_specials = _specials		+ [[]];

_headers = _headers 		+ [[CTI_REPAIR, localize "STR_Repair_Depot", localize "STR_Repair_Depot_1"]];
_classes = _classes 		+ [["Land_FuelStation_Build_F", "Land_FuelStation_Build_ruins_F"]];
_prices = _prices 			+ [600];
_times = _times 			+ [35];
_placements = _placements 	+ [[180, 20]];
_specials = _specials		+ [[]];

_headers = _headers 		+ [[CTI_NAVAL, localize "STR_Naval_Yard", localize "STR_Naval_Yard_1"]];
_classes = _classes 		+ [["Land_Lighthouse_small_F", "Land_Lighthouse_small_ruins_F"]];
_prices = _prices 			+ [1500];
_times = _times 			+ [35];
_placements = _placements 	+ [[180, 25]];
_specials = _specials		+ [[]];

_headers = _headers 		+ [[CTI_RADAR, localize "STR_Radar", localize "STR_Radar_1"]];
_classes =  _classes 		+ [["Land_Radar_Small_F", "Land_Radar_Small_ruins_F"]];
_prices =  _prices 			+[8000];
_times =  _times 			+[60];
_placements =_placements 	+  [[180, 30]];
_specials = _specials		+ [[["DMG_Reduce", 0.2]]];

[_side, _headers, _classes, _prices, _times, _placements, _specials] call compile preprocessFileLineNumbers "Common\Config\Base\Set_Structures.sqf";

//--- Helper: get localized displayName from config
svb_getDisplayName = {
    private _class = _this;
    private _name = getText(configFile >> "CfgVehicles" >> _class >> "displayName");
    if (_name isEqualTo "") then { _name = _class };
    _name
};

//--- Defenses
_headers = [];
_classes = [];
_prices = [];
_placements = [];
_categories = [];


// === Новые объекты (локализация через getConfig displayName) ===

_headers = _headers 		+ ["B_HMG_01_high_F" call svb_getDisplayName];
_classes = _classes 		+ ["B_HMG_01_high_F"];
_prices = _prices 		+ [200];
_placements = _placements 	+ [[180, 5]];
_categories = _categories 	+ ["Defense"];

_headers = _headers 		+ ["B_HMG_01_F" call svb_getDisplayName];
_classes = _classes 		+ ["B_HMG_01_F"];
_prices = _prices 		+ [150];
_placements = _placements 	+ [[180, 5]];
_categories = _categories 	+ ["Defense"];

_headers = _headers 		+ ["B_HMG_01_A_F" call svb_getDisplayName];
_classes = _classes 		+ ["B_HMG_01_A_F"];
_prices = _prices 		+ [250];
_placements = _placements 	+ [[180, 5]];
_categories = _categories 	+ ["Defense"];

_headers = _headers 		+ ["B_GMG_01_high_F" call svb_getDisplayName];
_classes = _classes 		+ ["B_GMG_01_high_F"];
_prices = _prices 		+ [350];
_placements = _placements 	+ [[180, 5]];
_categories = _categories 	+ ["Defense"];

_headers = _headers 		+ ["B_GMG_01_F" call svb_getDisplayName];
_classes = _classes 		+ ["B_GMG_01_F"];
_prices = _prices 		+ [300];
_placements = _placements 	+ [[180, 5]];
_categories = _categories 	+ ["Defense"];

_headers = _headers 		+ ["B_GMG_01_A_F" call svb_getDisplayName];
_classes = _classes 		+ ["B_GMG_01_A_F"];
_prices = _prices 		+ [400];
_placements = _placements 	+ [[180, 5]];
_categories = _categories 	+ ["Defense"];

_headers = _headers 		+ ["B_G_HMG_02_high_F" call svb_getDisplayName];
_classes = _classes 		+ ["B_G_HMG_02_high_F"];
_prices = _prices 		+ [200];
_placements = _placements 	+ [[180, 5]];
_categories = _categories 	+ ["Defense"];

_headers = _headers 		+ ["B_G_HMG_02_F" call svb_getDisplayName];
_classes = _classes 		+ ["B_G_HMG_02_F"];
_prices = _prices 		+ [150];
_placements = _placements 	+ [[180, 5]];
_categories = _categories 	+ ["Defense"];

_headers = _headers 		+ ["B_GMG_01_high_F" call svb_getDisplayName];
_classes = _classes 		+ ["B_GMG_01_high_F"];
_prices = _prices 		+ [350];
_placements = _placements 	+ [[180, 5]];
_categories = _categories 	+ ["Defense"];

_headers = _headers 		+ ["B_static_AT_F" call svb_getDisplayName];
_classes = _classes 		+ ["B_static_AT_F"];
_prices = _prices 		+ [1000];
_placements = _placements 	+ [[180, 5]];
_categories = _categories 	+ ["Defense"];

_headers = _headers 		+ ["B_static_AA_F" call svb_getDisplayName];
_classes = _classes 		+ ["B_static_AA_F"];
_prices = _prices 		+ [1000];
_placements = _placements 	+ [[180, 5]];
_categories = _categories 	+ ["Defense"];

// корабельные установки 

_headers = _headers 		+ ["B_SAM_System_03_F" call svb_getDisplayName];
_classes = _classes 		+ ["B_SAM_System_03_F"];
_prices = _prices 			+ [120000];
_placements = _placements 	+ [[180, 10]];
_categories = _categories 	+ ["Defense"];

_headers = _headers 		+ ["B_Radar_System_01_F" call svb_getDisplayName];
_classes = _classes 		+ ["B_Radar_System_01_F"];
_prices = _prices 			+ [30000];
_placements = _placements 	+ [[180, 10]];
_categories = _categories 	+ ["Defense"];

_headers = _headers 		+ ["B_AAA_System_01_F" call svb_getDisplayName];
_classes = _classes 		+ ["B_AAA_System_01_F"];
_prices = _prices 			+ [20000];
_placements = _placements 	+ [[180, 10]];
_categories = _categories 	+ ["Defense"];

_headers = _headers 		+ ["B_SAM_System_01_F" call svb_getDisplayName];
_classes = _classes 		+ ["B_SAM_System_01_F"];
_prices = _prices 			+ [30000];
_placements = _placements 	+ [[10, 5]];
_categories = _categories 	+ ["Defense"];

_headers = _headers 		+ ["B_SAM_System_02_F" call svb_getDisplayName];
_classes = _classes 		+ ["B_SAM_System_02_F"];
_prices = _prices 			+ [50000];
_placements = _placements 	+ [[10, 5]];
_categories = _categories 	+ ["Defense"];

_headers = _headers 		+ ["B_Ship_Gun_01_F" call svb_getDisplayName];
_classes = _classes 		+ ["B_Ship_Gun_01_F"];
_prices = _prices 			+ [40000];
_placements = _placements 	+ [[180, 10]];
_categories = _categories 	+ ["Defense"];

_headers = _headers 		+ ["B_Ship_MRLS_01_F" call svb_getDisplayName];
_classes = _classes 		+ ["B_Ship_MRLS_01_F"];
_prices = _prices 			+ [300000];
_placements = _placements 	+ [[180, 10]];
_categories = _categories 	+ ["Defense"];


if !(MADE_FOR_STRATIS) then {
_headers = _headers 		+ ["B_Mortar_01_F" call svb_getDisplayName];
_classes = _classes 		+ ["B_Mortar_01_F"];
_prices = _prices 		+ [10000];
_placements = _placements 	+ [[180, 5]];
_categories = _categories 	+ ["Defense"];
};

// мины
_headers = _headers 		+ ["ATMine" call svb_getDisplayName];
_classes = _classes 		+ ["ATMine"];
_prices = _prices 			+ [500];
_placements = _placements 	+ [[0, 5]];
_categories = _categories 	+ ["Fortification"];

_headers = _headers 		+ ["APERSMine" call svb_getDisplayName];
_classes = _classes 		+ ["APERSMine"];
_prices = _prices 			+ [100];
_placements = _placements 	+ [[0, 5]];
_categories = _categories 	+ ["Fortification"];

_headers = _headers 		+ ["APERSBoundingMine" call svb_getDisplayName];
_classes = _classes 		+ ["APERSBoundingMine"];
_prices = _prices 			+ [300];
_placements = _placements 	+ [[0, 5]];
_categories = _categories 	+ ["Fortification"];

_headers = _headers 		+ ["APERSTripMine" call svb_getDisplayName];
_classes = _classes 		+ ["APERSTripMine"];
_prices = _prices 			+ [200];
_placements = _placements 	+ [[0, 5]];
_categories = _categories 	+ ["Fortification"];

// Грузовые контейнеры
_headers = _headers + ["Land_Cargo40_light_blue_F" call svb_getDisplayName];
_classes = _classes + ["Land_Cargo40_light_blue_F"];
_prices = _prices + [2000];
_placements = _placements + [[0, 10]];
_categories = _categories + ["Fortification"];

_headers = _headers + ["Land_Cargo40_red_F" call svb_getDisplayName];
_classes = _classes + ["Land_Cargo40_red_F"];
_prices = _prices + [2000];
_placements = _placements + [[0, 10]];
_categories = _categories + ["Fortification"];

_headers = _headers + ["Land_Cargo40_light_green_F" call svb_getDisplayName];
_classes = _classes + ["Land_Cargo40_light_green_F"];
_prices = _prices + [3000];
_placements = _placements + [[0, 10]];
_categories = _categories + ["Fortification"];

_headers = _headers + ["Land_Cargo20_EMP_F" call svb_getDisplayName];
_classes = _classes + ["Land_Cargo20_EMP_F"];
_prices = _prices + [1000];
_placements = _placements + [[0, 10]];
_categories = _categories + ["Fortification"];

_headers = _headers + ["Land_Cargo10_light_green_F" call svb_getDisplayName];
_classes = _classes + ["Land_Cargo10_light_green_F"];
_prices = _prices + [800];
_placements = _placements + [[0, 10]];
_categories = _categories + ["Fortification"];

_headers = _headers + ["Land_Cargo20_light_green_F" call svb_getDisplayName];
_classes = _classes + ["Land_Cargo20_light_green_F"];
_prices = _prices + [1000];
_placements = _placements + [[0, 10]];
_categories = _categories + ["Fortification"];

// Барьеры и препятствия
_headers = _headers + ["Land_HBarrier_1_F" call svb_getDisplayName];
_classes = _classes + ["Land_HBarrier_1_F"];
_prices = _prices + [200];
_placements = _placements + [[0, 7]];
_categories = _categories + ["Fortification"];

_headers = _headers + ["Land_HBarrier_Big_F" call svb_getDisplayName];
_classes = _classes + ["Land_HBarrier_Big_F"];
_prices = _prices + [500];
_placements = _placements + [[0, 7]];
_categories = _categories + ["Fortification"];

_headers = _headers + ["Land_HBarrier_3_F" call svb_getDisplayName];
_classes = _classes + ["Land_HBarrier_3_F"];
_prices = _prices + [300];
_placements = _placements + [[0, 7]];
_categories = _categories + ["Fortification"];

_headers = _headers + ["Land_HBarrierTower_F" call svb_getDisplayName];
_classes = _classes + ["Land_HBarrierTower_F"];
_prices = _prices + [1500];
_placements = _placements + [[0, 7]];
_categories = _categories + ["Fortification"];

_headers = _headers + ["Land_HBarrierWall4_F" call svb_getDisplayName];
_classes = _classes + ["Land_HBarrierWall4_F"];
_prices = _prices + [300];
_placements = _placements + [[0, 7]];
_categories = _categories + ["Fortification"];

_headers = _headers + ["Land_HBarrierWall_corner_F" call svb_getDisplayName];
_classes = _classes + ["Land_HBarrierWall_corner_F"];
_prices = _prices + [400];
_placements = _placements + [[0, 7]];
_categories = _categories + ["Fortification"];

// Ежи и барьеры
_headers = _headers + ["Land_ConcreteHedgehog_01_F" call svb_getDisplayName];
_classes = _classes + ["Land_ConcreteHedgehog_01_F"];
_prices = _prices + [1000];
_placements = _placements + [[0, 7]];
_categories = _categories + ["Fortification"];

_headers = _headers + ["Land_DragonsTeeth_01_4x2_new_redwhite_F" call svb_getDisplayName];
_classes = _classes + ["Land_DragonsTeeth_01_4x2_new_redwhite_F"];
_prices = _prices + [3000];
_placements = _placements + [[0, 7]];
_categories = _categories + ["Fortification"];

_headers = _headers + ["Land_CzechHedgehog_01_new_F" call svb_getDisplayName];
_classes = _classes + ["Land_CzechHedgehog_01_new_F"];
_prices = _prices + [700];
_placements = _placements + [[0, 7]];
_categories = _categories + ["Fortification"];

// Дополнительные барьеры и препятствия
_headers = _headers + ["Land_AirstripPlatform_01_F" call svb_getDisplayName];
_classes = _classes + ["Land_AirstripPlatform_01_F"];
_prices = _prices + [30000];
_placements = _placements + [[0, 15]];
_categories = _categories + ["Fortification"];

_headers = _headers + ["Land_BasaltWall_01_gate_F" call svb_getDisplayName];
_classes = _classes + ["Land_BasaltWall_01_gate_F"];
_prices = _prices + [5000];
_placements = _placements + [[0, 10]];
_categories = _categories + ["Fortification"];

_headers = _headers + ["Land_Highway_Pillar_01_F" call svb_getDisplayName];
_classes = _classes + ["Land_Highway_Pillar_01_F"];
_prices = _prices + [15000];
_placements = _placements + [[0, 15]];
_categories = _categories + ["Fortification"];

_headers = _headers + ["Land_CastleRuins_01_wall_10m_F" call svb_getDisplayName];
_classes = _classes + ["Land_CastleRuins_01_wall_10m_F"];
_prices = _prices + [8000];
_placements = _placements + [[0, 10]];
_categories = _categories + ["Fortification"];

_headers = _headers + ["Land_Bunker_01_blocks_3_F" call svb_getDisplayName];
_classes = _classes + ["Land_Bunker_01_blocks_3_F"];
_prices = _prices + [2000];
_placements = _placements + [[0, 10]];
_categories = _categories + ["Fortification"];

_headers = _headers + ["Land_BasaltWall_01_8m_F" call svb_getDisplayName];
_classes = _classes + ["Land_BasaltWall_01_8m_F"];
_prices = _prices + [12000];
_placements = _placements + [[0, 10]];
_categories = _categories + ["Fortification"];

// Камуфляжные сети
_headers = _headers + ["CamoNet_OPFOR_big_F" call svb_getDisplayName];
_classes = _classes + ["CamoNet_OPFOR_big_F"];
_prices = _prices + [50];
_placements = _placements + [[180, 15]];
_categories = _categories + ["Fortification"];

_headers = _headers + ["CamoNet_INDP_big_F" call svb_getDisplayName];
_classes = _classes + ["CamoNet_INDP_big_F"];
_prices = _prices + [50];
_placements = _placements + [[180, 15]];
_categories = _categories + ["Fortification"];

_headers = _headers + ["CamoNet_wdl_big_F" call svb_getDisplayName];
_classes = _classes + ["CamoNet_wdl_big_F"];
_prices = _prices + [50];
_placements = _placements + [[180, 15]];
_categories = _categories + ["Fortification"];

_headers = _headers + ["CamoNet_ghex_big_F" call svb_getDisplayName];
_classes = _classes + ["CamoNet_ghex_big_F"];
_prices = _prices + [50];
_placements = _placements + [[180, 15]];
_categories = _categories + ["Fortification"];

_headers = _headers 		+ ["CamoNet_BLUFOR_big_F" call svb_getDisplayName];
_classes = _classes 		+ ["CamoNet_BLUFOR_big_F"];
_prices = _prices 			+ [50];
_placements = _placements 	+ [[180, 15]];
_categories = _categories 	+ ["Fortification"];

// ИК маскировка
_headers = _headers + ["Land_IRMaskingCover_01_F" call svb_getDisplayName];
_classes = _classes + ["Land_IRMaskingCover_01_F"];
_prices = _prices + [500];
_placements = _placements + [[0, 10]];
_categories = _categories + ["Fortification"];

_headers = _headers + ["Land_IRMaskingCover_02_F" call svb_getDisplayName];
_classes = _classes + ["Land_IRMaskingCover_02_F"];
_prices = _prices + [200];
_placements = _placements + [[0, 10]];
_categories = _categories + ["Fortification"];


// Бункеры
_headers = _headers + ["Land_Bunker_01_HQ_F" call svb_getDisplayName];
_classes = _classes + ["Land_Bunker_01_HQ_F"];
_prices = _prices + [5000];
_placements = _placements + [[0, 20]];
_categories = _categories + ["Fortification"];

_headers = _headers + ["Land_Bunker_01_tall_F" call svb_getDisplayName];
_classes = _classes + ["Land_Bunker_01_tall_F"];
_prices = _prices + [7000];
_placements = _placements + [[0, 20]];
_categories = _categories + ["Fortification"];

_headers = _headers + ["Land_Bunker_01_small_F" call svb_getDisplayName];
_classes = _classes + ["Land_Bunker_01_small_F"];
_prices = _prices + [3000];
_placements = _placements + [[0, 20]];
_categories = _categories + ["Fortification"];

_headers = _headers + ["Land_PillboxBunker_01_big_F" call svb_getDisplayName];
_classes = _classes + ["Land_PillboxBunker_01_big_F"];
_prices = _prices + [5000];
_placements = _placements + [[0, 20]];
_categories = _categories + ["Fortification"];

_headers = _headers + ["Land_PillboxBunker_01_hex_F" call svb_getDisplayName];
_classes = _classes + ["Land_PillboxBunker_01_hex_F"];
_prices = _prices + [3000];
_placements = _placements + [[0, 20]];
_categories = _categories + ["Fortification"];

_headers = _headers + ["Land_PillboxBunker_01_rectangle_F" call svb_getDisplayName];
_classes = _classes + ["Land_PillboxBunker_01_rectangle_F"];
_prices = _prices + [3000];
_placements = _placements + [[0, 20]];
_categories = _categories + ["Fortification"];

_headers = _headers 		+ ["Land_BagBunker_Small_F" call svb_getDisplayName];
_classes = _classes 		+ ["Land_BagBunker_Small_F"];
_prices = _prices 			+ [100];
_placements = _placements 	+ [[0, 10]];
_categories = _categories 	+ ["Fortification"];

_headers = _headers 		+ ["Land_BagBunker_Large_F" call svb_getDisplayName];
_classes = _classes 		+ ["Land_BagBunker_Large_F"];
_prices = _prices 			+ [500];
_placements = _placements 	+ [[0, 20]];
_categories = _categories 	+ ["Fortification"];


_headers = _headers 		+ ["Land_BagBunker_Tower_F" call svb_getDisplayName];
_classes = _classes 		+ ["Land_BagBunker_Tower_F"];
_prices = _prices 			+ [300];
_placements = _placements 	+ [[0, 20]];
_categories = _categories 	+ ["Fortification"];

// Дополнительные бункеры
_headers = _headers + ["Land_Highway_Pillar_01_garage_F" call svb_getDisplayName];
_classes = _classes + ["Land_Highway_Pillar_01_garage_F"];
_prices = _prices + [40000];
_placements = _placements + [[0, 20]];
_categories = _categories + ["Fortification"];

_headers = _headers + ["Land_Airport_01_hangar_F" call svb_getDisplayName];
_classes = _classes + ["Land_Airport_01_hangar_F"];
_prices = _prices + [18000];
_placements = _placements + [[180, 30]];
_categories = _categories + ["Fortification"];

// ангары 
_headers = _headers 		+ [["Land_i_Shed_Ind_F" call svb_getDisplayName,[["RuinOnDestroyed", "Land_Shed_Ind_ruins_F"], ["DMG_Reduce", 10]]]];
_classes = _classes 		+ ["Land_i_Shed_Ind_F"];
_prices = _prices 			+ [3000];
_placements = _placements 	+ [[90, 20]];
_categories = _categories 	+ ["Fortification"];


_headers = _headers 		+ [["Land_TentHangar_V1_F" call svb_getDisplayName,[["RuinOnDestroyed", "Land_TentHangar_V1_ruins_F"], ["DMG_Reduce", 5]]]];
_classes = _classes 		+ ["Land_TentHangar_V1_F"];
_prices = _prices 			+ [2000];
_placements = _placements 	+ [[0, 20]];
_categories = _categories 	+ ["Structures_Military"];

_headers = _headers 		+ [["Land_Shed_Big_F" call svb_getDisplayName,[["RuinOnDestroyed", "Land_Shed_Big_ruins_F"], ["DMG_Reduce", 8]]]];
_classes = _classes 		+ ["Land_Shed_Big_F"];
_prices = _prices 			+ [400];
_placements = _placements 	+ [[0, 15]];
_categories = _categories 	+ ["Fortification"];

_headers = _headers 		+ ["Land_Hangar_F" call svb_getDisplayName];
_classes = _classes 		+ ["Land_Hangar_F"];
_prices = _prices 			+ [4000];
_placements = _placements 	+ [[180, 30]];
_categories = _categories 	+ ["Fortification"];

//вышки 
_headers = _headers 		+ ["Land_Cargo_Patrol_V1_F" call svb_getDisplayName];
_classes = _classes 		+ ["Land_Cargo_Patrol_V1_F"];
_prices = _prices 			+ [500];
_placements = _placements 	+ [[0, 15]];
_categories = _categories 	+ ["Fortification"];

_headers = _headers 		+ [["Land_Cargo_Tower_V1_F" call svb_getDisplayName,[["RuinOnDestroyed", "Land_Cargo_Tower_V1_ruins_F"], ["DMG_Reduce", 8]]]];
_classes = _classes 		+ ["Land_Cargo_Tower_V1_F"];
_prices = _prices 			+ [2000];
_placements = _placements 	+ [[0, 30]];
_categories = _categories 	+ ["Fortification"];

_headers = _headers 		+ [["Land_FireEscape_01_short_F" call svb_getDisplayName,[["RuinOnDestroyed", "Land_Cargo_Tower_V1_ruins_F"], ["DMG_Reduce", 8]]]];
_classes = _classes 		+ ["Land_FireEscape_01_short_F"];
_prices = _prices 			+ [2000];
_placements = _placements 	+ [[0, 10]];
_categories = _categories 	+ ["Fortification"];

_headers = _headers 		+ [["Land_FireEscape_01_tall_F" call svb_getDisplayName,[["RuinOnDestroyed", "Land_Cargo_Tower_V1_ruins_F"], ["DMG_Reduce", 8]]]];
_classes = _classes 		+ ["Land_FireEscape_01_tall_F"];
_prices = _prices 			+ [3000];
_placements = _placements 	+ [[0, 10]];
_categories = _categories 	+ ["Fortification"];


// Освещение
_headers = _headers + ["Land_LampStadium_F" call svb_getDisplayName];
_classes = _classes + ["Land_LampStadium_F"];
_prices = _prices + [300];
_placements = _placements + [[0, 10]];
_categories = _categories + ["Fortification"];



if ((missionNamespace getVariable "CTI_RESPAWN_FOB_RANGE")> 0) then {
	_headers = _headers 		+ [["FOB",[["RuinOnDestroyed", "Land_Medevac_house_V1_ruins_F"], ["FOB"],["Condition", {_cpt = if (isNil {CTI_P_SideLogic getVariable "cti_fobs"}) then {1000} else {count (CTI_P_SideLogic getVariable "cti_fobs")}; (_cpt < CTI_BASE_FOB_MAX) && (call CTI_CL_FNC_IsPlayerCommander || (!(call CTI_CL_FNC_IsPlayerCommander) && CTI_P_TeamsRequests_FOB > 0)|| ( missionNamespace getVariable 'CTI_BASE_FOB_PERMISSION' ) == 0 )}]]]];
	_classes = _classes 		+ ["Land_Medevac_house_V1_F"];
	_prices = _prices 			+ [10000];
	_placements = _placements 	+ [[180, 10]];
	_categories = _categories 	+ ["Fortification"];
};

//- SVB Spawn Points START

// Точка появления пехоты / казармы
if !("VR_Area_01_square_2x2_grey_F" in _classes) then {
    _categories = _categories + ["Defense"];
    _headers = _headers + [localize "STR_SVB_Spawn_Barracks"];
    _classes = _classes + ["VR_Area_01_square_2x2_grey_F"];
    _prices = _prices + [50];
    _placements = _placements + [[0, 5]];
};

// Точка появления лёгкой техники
if !("Land_HelipadCircle_F" in _classes) then {
    _categories = _categories + ["Defense"];
    _headers = _headers + [localize "STR_SVB_Spawn_Light"];
    _classes = _classes + ["Land_HelipadCircle_F"];
    _prices = _prices + [200];
    _placements = _placements + [[0, 7]];
};

// Точка появления тяжёлой техники
if !("Land_HelipadSquare_F" in _classes) then {
    _categories = _categories + ["Defense"];
    _headers = _headers + [localize "STR_SVB_Spawn_Heavy"];
    _classes = _classes + ["Land_HelipadSquare_F"];
    _prices = _prices + [500];
    _placements = _placements + [[0, 7]];
};

// Точка появления боеприпасов
if !("Land_JumpTarget_F" in _classes) then {
    _categories = _categories + ["Defense"];
    _headers = _headers + [localize "STR_SVB_Spawn_Ammo"];
    _classes = _classes + ["Land_JumpTarget_F"];
    _prices = _prices + [50];
    _placements = _placements + [[0, 5]];
};

// Точка появления запчастей / ремонта
if !("Land_HelipadRescue_F" in _classes) then {
    _categories = _categories + ["Defense"];
    _headers = _headers + [localize "STR_SVB_Spawn_Repair"];
    _classes = _classes + ["Land_HelipadRescue_F"];
    _prices = _prices + [100];
    _placements = _placements + [[0, 7]];
};

// Точка появления авиации
if !("Land_HelipadCivil_F" in _classes) then {
    _categories = _categories + ["Defense"];
    _headers = _headers + [localize "STR_SVB_Spawn_Air"];
    _classes = _classes + ["Land_HelipadCivil_F"];
    _prices = _prices + [1500];
    _placements = _placements + [[0, 10]];
};

// Морская точка появления
if !("VR_Area_01_circle_4_grey_F" in _classes) then {
    _categories = _categories + ["Defense"];
    _headers = _headers + [localize "STR_SVB_Spawn_Naval"];
    _classes = _classes + ["VR_Area_01_circle_4_grey_F"];
    _prices = _prices + [150];
    _placements = _placements + [[0, 10]];
};

//- SVB Spawn Points END



[_side, _headers, _classes, _prices, _placements, _categories] call compile preprocessFileLineNumbers "Common\Config\Base\Set_Defenses.sqf";               