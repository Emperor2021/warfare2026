/*
 * Name: CTI_AC_GET_VEHICLE_LOADOUT_OPTIONS (compileFinal)
 * Input: vehicle object (_this)
 * Return: CTI_LOADOUT_<classname>_MNT_OPTIONS array or nil
 */
missionNamespace getVariable [ format [ "CTI_LOADOUT_%1_MNT_OPTIONS" , ( typeOf _this ) ] , nil ];
