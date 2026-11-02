
private ["_defenses","_group","_logic","_objects","_side","_sideID","_spawn","_target","_type","_unit","_walls"];

_target = _this;

_side = _target getVariable "cti_tower_side";
_sideID = (_side) call CTI_CO_FNC_GetSideID;
_logic = (_side) call CTI_CO_FNC_GetSideLogic;
_walls = _target getVariable "cti_tower_walls";
_defenses = _target getVariable "cti_tower_defenses";
_group = _target getVariable "cti_tower_defense_group";
_spawn = _target getVariable "cti_tower_defense_spawn";

if (_side == west) then {_type = "B_soldier_AT_F";};
if (_side == east) then {_type = "O_Soldier_AT_F";};

//if (_side == west) then {_type = "B_Soldier_F";};
//if (_side == east) then {_type = "O_Soldier_F";};

while {!CTI_GameOver && alive _target} do {

	if (isNull _group) then {
		_group = createGroup _side;
		_group setGroupIDGlobal ["Defense Team FOB"];
		_target setVariable ["cti_tower_defense_group", _group, true];
		_unit = [_typeComm, _group, _target, _sideID, true, "NONE"] call CTI_CO_FNC_CreateUnit;
		//_unit setPosASL _pos;
		_unit attachTo [_target,[-2.85,-2,3.5]];
		detach _unit;
		_unit setDir (getDir _target);
		sleep 1;
		_target setVariable ["cti_tower_defense_spawn", getPosASL _unit, true];
		_unit addEventHandler ["handleDamage", {false}];
		_unit allowDamage false;
		_unit disableAI "PATH";
		_unit disableAI "MOVE";
		removeAllWeapons _unit;
	};

	_group = _target getVariable "cti_tower_defense_group";
	_spawn = _target getVariable "cti_tower_defense_spawn";

	{
		if !(alive gunner _x || alive assignedGunner _x) then {
			_pos = [_spawn, 1, 2] call CTI_CO_FNC_GetRandomPosition;
			_pos set [2, _spawn select 2];
			_unit = [_type, _group, _pos, _sideID, true] call CTI_CO_FNC_CreateUnit;
			_unit setPosASL _pos;
			[_unit] allowGetIn true;
			_unit assignAsGunner _x;
			[_unit] orderGetIn true;
//			sleep 10;
			_unit moveInGunner _x;
			_unit setSkill 1;
		};

		_x setPosASL (_x getVariable "cti_tower_defense_position");
		_x setDir (_x getVariable "cti_tower_defense_direction");
		sleep 1;
		[_x, 0, 0] call BIS_fnc_setPitchBank;
		_x setVehicleAmmo 1;

		if (isNull _target || not alive _target) exitWith {};

		sleep 1;
	} forEach _defenses;

	if (isNull _target || not alive _target) exitWith {};

	sleep 60;
};

if (isNull _target || not alive _target) then {
	_objects = _walls + _defenses;
	if (isNil "_walls" || isNil "_defenses") then {
		_objects = nearestObjects [_target, ["Land_CncWall1_F","Land_CncWall4_F","StaticDefense"], 30];
	};
	{deleteVehicle _x} forEach _objects;

	{deleteVehicle _x} forEach units _group;
	deleteGroup _group;

	_logic setVariable ["cti_fobs", (_logic getVariable "cti_fobs") - [objNull, _target], true];
};
