
private ["_arg","_group","_units","_vehicles"];

_arg = _this;	//--- Group or unit

if (typeName _arg == "GROUP") then {_group = _arg;};
if (typeName _arg == "OBJECT") then {_group = group _arg;};

_units = units _group;

_vehicles = [];
{
	if ( vehicle _x != _x && !((vehicle _x) in _vehicles) ) then {_vehicles = _vehicles + [vehicle _x];};
} forEach _units;

_vehicles
