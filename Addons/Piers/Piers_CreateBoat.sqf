
private ["_caller","_caller_sideID","_cost","_dir","_funds","_name","_pos","_target","_type","_vehicle"];

_target = (_this select 0);
_caller = (_this select 1);
_type = (_this select 3) select 0;
_cost = (_this select 3) select 1;
_pos = (_this select 3) select 2;
_dir = (_this select 3) select 3;

_caller_sideID = (side _caller) call CTI_CO_FNC_GetSideID;

_funds = [group _caller, side _caller] call CTI_CO_FNC_GetFunds;
if (_funds < _cost) exitWith {
	_name = getText (configFile >> "CfgVehicles" >> _type >> "displayName");
	hint parseText format [localize "STR_OnPurchase_NotFunds", _name, ""];
};

_pos = [_pos, 25, _dir] call CTI_CO_FNC_GetPositionFrom;
_pos set [2,0];

[group _caller, side _caller, - _cost] call CTI_CO_FNC_ChangeFunds;
_vehicle = [_type, _pos, _dir, _caller_sideID, false, true, true] call CTI_CO_FNC_CreateVehicle;

_vehicle addAction ["<t color='#86F078'>Unlock</t>","Client\Actions\Action_ToggleLock.sqf", [], 99, false, true, '', '_this != _caller && alive _target && locked _target == 2'];
_vehicle addAction ["<t color='#86F078'>Lock</t>","Client\Actions\Action_ToggleLock.sqf", [], 99, false, true, '', '_this != _caller && alive _target && locked _target == 0'];
["SERVER", "Request_HandleAction", ["empty", [_vehicle,600]]] call CTI_CO_FNC_NetSend;
_vehicle setVariable ["v_keys",[getPlayerUID _caller,group _caller],true];
_caller moveInDriver _vehicle;
_caller reveal _vehicle;

if (_type == "B_SDV_01_F") then {
	_vehicle addWeaponCargoGlobal ["U_B_Wetsuit", 2];
	_vehicle addWeaponCargoGlobal ["V_RebreatherB", 2];
	_vehicle addItemCargoGlobal ["G_B_Diving", 2];
//	_vehicle addBackpackCargoGlobal ["B_Assault_Diver", 2];
};

if (_type == "O_SDV_01_F") then {
	_vehicle addWeaponCargoGlobal ["U_O_Wetsuit", 2];
	_vehicle addWeaponCargoGlobal ["V_RebreatherIR", 2];
	_vehicle addItemCargoGlobal ["G_O_Diving", 2];
//	_vehicle addBackpackCargoGlobal ["O_Assault_Diver", 2];
};
