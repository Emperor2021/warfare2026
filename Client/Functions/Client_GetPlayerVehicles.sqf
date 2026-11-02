
private ["_vehicles"];

_vehicles = [];

{
	if (not isNil {_x getVariable "v_keys"}) then {
		if ((getPlayerUID player) in (_x getVariable ["v_keys",["",grpNull]]) || (group player) in (_x getVariable ["v_keys",["",grpNull]]) && alive _x && !(_x in _vehicles)) then {_vehicles = _vehicles + [vehicle _x];};
	};
} forEach vehicles;

_vehicles
