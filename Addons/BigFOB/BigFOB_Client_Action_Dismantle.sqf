
private ["_target","_caller","_side_target","_side_caller","_logic","_fobs"];

_target = _this select 0;
_caller = _this select 1;

_side_target = _target getVariable "cti_tower_side";
_side_caller = side _caller;

_logic = (_side_caller) call CTI_CO_FNC_GetSideLogic;
_fobs = _logic getVariable "cti_fobs";

if (not alive _target || _side_target != _side_caller || !(_target in _fobs)) exitWith {};

["SERVER", "Request_DismantleBigFOB", _target] call CTI_CO_FNC_NetSend;
