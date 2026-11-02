
private ["_target","_caller","_side_target","_side_caller","_funds","_logic","_fobs"];

_target = _this select 0;
_caller = _this select 1;

_side_target = _target getVariable "cti_tower_side";
_side_caller = side _caller;

_logic = (_side_caller) call CTI_CO_FNC_GetSideLogic;
_fobs = _logic getVariable "cti_fobs";

if (CTI_BASE_FOB_MAX == 0 || not alive _target || _side_target != _side_caller || (_target in _fobs)) exitWith {};

_cost = 50000;

_funds = [group _caller, _side_caller] call CTI_CO_FNC_GetFunds;

if (_funds >= _cost) then {
	_logic = (_side_caller) call CTI_CO_FNC_GetSideLogic;
	_fobs = _logic getVariable "cti_fobs";

	if (count _fobs < CTI_BASE_FOB_MAX) then {
		["SERVER", "Request_ConvertToBigFOB", _target] call CTI_CO_FNC_NetSend;
		[group _caller, _side_caller, -_cost] call CTI_CO_FNC_ChangeFunds;
		_target setVariable ["cti_tower_wip", true, true];
	} else {
		hint parseText localize "STR_CTI_Limit_Reached";
	};
} else {
	hint parseText localize "STR_BuildMenu_Info";
};
