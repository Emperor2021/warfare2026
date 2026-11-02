
private ["_caller","_target"];

_target = _this select 0;
_caller = _this select 1;

if (isNil {_target getVariable "v_keys"}) exitWith {};
if !((getPlayerUID (leader (group _caller))) in (_target getVariable "v_keys")) exitWith {};

_target lock 0;

{
	if (isPlayer _x && _x != _caller && _x != player) then {
		_x action ["getOut", vehicle _target];
	};
} forEach (crew _target);
