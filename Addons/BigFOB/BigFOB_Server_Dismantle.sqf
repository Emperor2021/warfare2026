
private ["_defenses","_fobs","_group","_logic","_objects","_side","_target","_walls"];

_target = _this;

_side = _target getVariable "cti_tower_side";
_logic = (_side) call CTI_CO_FNC_GetSideLogic;
_fobs = _logic getVariable "cti_fobs";
_walls = _target getVariable "cti_tower_walls";
_defenses = _target getVariable "cti_tower_defenses";
_group = _target getVariable "cti_tower_defense_group";

if (not alive _target || !(_target in _fobs)) exitWith {};

_objects = _walls + _defenses;
if (isNil "_walls" || isNil "_defenses") then {
	_objects = nearestObjects [_target, ["Land_CncWall1_F","Land_CncWall4_F","StaticDefense"], 30];
};
{deleteVehicle _x} forEach _objects;

{deleteVehicle _x} forEach units _group;
deleteGroup _group;

sleep 30;

_target setDamage 1;
_logic setVariable ["cti_fobs", (_logic getVariable "cti_fobs") - [objNull, _target], true];

sleep 30;

deleteVehicle _target;
