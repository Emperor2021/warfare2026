if (isNil "CTI_AC_Init_Started") then {
	CTI_AC_Init_Started = true;

	CTI_AC_REFRESH_LOADOUT_ON_MOUNTED = compileFinal preprocessFileLineNumbers "Addons\Henroth_AirLoadout\Common_ACRefreshLoadoutMounted.sqf";
	CTI_AC_GET_STANDARD_EMPTY_LOADOUT = compileFinal preprocessFileLineNumbers "Addons\Henroth_AirLoadout\Common_ACGetStandardEmptyLoadout.sqf";
	CTI_AC_GET_STANDARD_VANILLA_LOADOUT = compileFinal preprocessFileLineNumbers "Addons\Henroth_AirLoadout\Common_ACGetStandardVanillaLoadout.sqf";
	CTI_AC_GET_VEHICLE_LOADOUT_OPTIONS = compileFinal preprocessFileLineNumbers "Addons\Henroth_AirLoadout\Common_ACGetVehicleLoadoutOptions.sqf";
	CTI_AC_GET_VEHCICLE_LOADOUT_COST = compileFinal preprocessFileLineNumbers "Addons\Henroth_AirLoadout\Common_ACGetVehicleLoadoutCost.sqf";

	call compile preprocessFileLineNumbers "Addons\Henroth_AirLoadout\Set_WeaponLoadouts.sqf";
};