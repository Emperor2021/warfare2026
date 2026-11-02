
private ["_fuel", "_objects", "_pos"];

_pos = _this select 0;

//["DEBUG", "FILE: Addons\Nuke\Nuke_Server_EMI.sqf", str(_pos)] call CTI_CO_FNC_Log;

_objects = nearestObjects [_pos, ["Air","LandVehicle"], CTI_NUKE_DAMAGE_RADIUS * 10];
{
	_fuel = fuel _x;
	_x setFuel 0;
	sleep 0.01;
	_x setFuel _fuel;

	driver _x action ["engineOff", _x];
	_x setHit ["motor", 1];

	driver _x action ["lightOff", _x];
	_x setHit ["elektronika", 1];
} forEach _objects;
