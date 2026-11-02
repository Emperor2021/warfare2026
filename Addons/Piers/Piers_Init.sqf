
CTI_CO_FNC_Piers_ClosestTownIsFriendlyFor = compileFinal preprocessFileLineNumbers "Addons\Piers\Piers_ClosestTownIsFriendlyFor.sqf";

private ["_cost","_dir","_marker","_markerName","_markerNumber","_name","_object","_piers","_pos"];

_piers = [[[13480,12150,-0.5],300],[[12700,14200,-0.5],120],[[16615,12365,-0.5],225],[[17790,18133,-0.5],320]];

if (isServer) then {

	_markerNumber = 0;

	{
		_pos = _x select 0;
		_dir = _x select 1;

		_object = createVehicle ["Land_BuoyBig_F", _pos, [], 0, "CAN_COLLIDE"];
		_object addEventHandler ["handleDamage", {false}];
		_object allowDamage false;
		_object setDir _dir;
		_object enableSimulationGlobal false;

		_markerName = format ["MarkerPier%1", _markerNumber];
		_marker = createMarker [_markerName, _x select 0];
		_marker setMarkerType "respawn_naval";
		_marker setMarkerAlpha 0.5;
		_markerNumber = _markerNumber + 1;
	} forEach _piers;

} else {

	{
		_pos = _x select 0;
		_dir = _x select 1;

		_object = nearestObject [_pos, "Land_BuoyBig_F"];

		_type = "C_Scooter_Transport_01_F";
		_cost = 500;
		_name = getText (configFile >> "CfgVehicles" >> _type >> "displayName");
		_object addAction [format [localize "STR_Pier_Buy_Boat", _name, _cost], "Addons\Piers\Piers_CreateBoat.sqf", [_type, _cost, _pos, _dir], -100, false, true];

		_type = "B_Boat_Transport_01_F";
		_cost = 550;
		_name = getText (configFile >> "CfgVehicles" >> _type >> "displayName");
		_object addAction [format [localize "STR_Pier_Buy_Boat", _name, _cost], "Addons\Piers\Piers_CreateBoat.sqf", [_type, _cost, _pos, _dir], -100, false, true, "", "(_this) call CTI_CO_FNC_Piers_ClosestTownIsFriendlyFor && side _this == west"];

		_type = "O_Boat_Transport_01_F";
		_cost = 550;
		_name = getText (configFile >> "CfgVehicles" >> _type >> "displayName");
		_object addAction [format [localize "STR_Pier_Buy_Boat", _name, _cost], "Addons\Piers\Piers_CreateBoat.sqf", [_type, _cost, _pos, _dir], -100, false, true, "", "(_this) call CTI_CO_FNC_Piers_ClosestTownIsFriendlyFor && side _this == east"];

		_type = "B_Boat_Armed_01_minigun_F";
		_cost = 1500;
		_name = getText (configFile >> "CfgVehicles" >> _type >> "displayName");
		_object addAction [format [localize "STR_Pier_Buy_Boat", _name, _cost], "Addons\Piers\Piers_CreateBoat.sqf", [_type, _cost, _pos, _dir], -100, false, true, "", "(_this) call CTI_CO_FNC_Piers_ClosestTownIsFriendlyFor && side _this == west"];

		_type = "O_Boat_Armed_01_hmg_F";
		_cost = 1500;
		_name = getText (configFile >> "CfgVehicles" >> _type >> "displayName");
		_object addAction [format [localize "STR_Pier_Buy_Boat", _name, _cost], "Addons\Piers\Piers_CreateBoat.sqf", [_type, _cost, _pos, _dir], -100, false, true, "", "(_this) call CTI_CO_FNC_Piers_ClosestTownIsFriendlyFor && side _this == east"];

		_type = "B_SDV_01_F";
		_cost = 800;
		_name = getText (configFile >> "CfgVehicles" >> _type >> "displayName");
		_object addAction [format [localize "STR_Pier_Buy_Boat", _name, _cost], "Addons\Piers\Piers_CreateBoat.sqf", [_type, _cost, _pos, _dir], -100, false, true, "", "(_this) call CTI_CO_FNC_Piers_ClosestTownIsFriendlyFor && side _this == west"];

		_type = "O_SDV_01_F";
		_cost = 800;
		_name = getText (configFile >> "CfgVehicles" >> _type >> "displayName");
		_object addAction [format [localize "STR_Pier_Buy_Boat", _name, _cost], "Addons\Piers\Piers_CreateBoat.sqf", [_type, _cost, _pos, _dir], -100, false, true, "", "(_this) call CTI_CO_FNC_Piers_ClosestTownIsFriendlyFor && side _this == east"];
	} forEach _piers;

};
