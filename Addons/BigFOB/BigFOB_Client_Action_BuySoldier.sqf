
private ["_caller","_caller_group","_caller_side","_caller_sideID","_cost","_dir","_fobs","_funds","_logic","_name","_pos","_target","_type","_unit"];

_target = _this select 0;
_caller = _this select 1;

_caller_group = group _caller;
_caller_side = side _caller;
_caller_sideID = (_caller_side) call CTI_CO_FNC_GetSideID;

_logic = (_side_caller) call CTI_CO_FNC_GetSideLogic;
_fobs = _logic getVariable "cti_fobs";

if (not alive _target || _side_target != _side_caller || !(_target in _fobs)) exitWith {};

if (_caller_side == west) then {_type = "B_Soldier_F";};
if (_caller_side == east) then {_type = "O_Soldier_F";};

_cost = 500;

_funds = [_caller_group, _caller_side] call CTI_CO_FNC_GetFunds;
if (_funds < _cost) exitWith {
	_name = getText (configFile >> "CfgVehicles" >> _type >> "displayName");
	hint parseText format [localize "STR_OnPurchase_NotFunds", _name, ""];
};

_pos = [_target, 15, 20] call CTI_CO_FNC_GetRandomPosition;
_pos set [2,0];

if ( (count units _caller_group) < ((call CTI_CL_FNC_GetGroupSize) + ({isPlayer _x} count (units _caller_group))) ) then {
	[_caller_group, _caller_side, - _cost] call CTI_CO_FNC_ChangeFunds;
//	sleep 5;
	_unit = [_type, _caller_group, _pos, _caller_sideID, true, "NONE"] call CTI_CO_FNC_CreateUnit;
} else {
	hint parseText localize "STR_Purchase_Limit";
};