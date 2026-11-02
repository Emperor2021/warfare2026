
private ["_damage", "_marker", "_markerName", "_objects", "_pos", "_radius", "_radzonesmarkers"];

_pos = _this select 0;

//["DEBUG", "FILE: Addons\Nuke\Nuke_Server_Radiation.sqf", str(_pos)] call CTI_CO_FNC_Log;

_radzonesmarkers = [];
_radius = CTI_NUKE_DAMAGE_RADIUS;

for [{_i = 0},{_i < 3},{_i = _i + 1}] do {
	_markerName = format ["nuke_radiation_marker_%1_%2", str(_pos), _i];
	_marker = createMarker [_markerName, _pos];
	_marker setMarkerShape "ELLIPSE";
	_marker setMarkerColor "ColorRed";
	_marker setMarkerSize [_radius, _radius];
	_marker setMarkerBrush "SolidFull";
	_marker setMarkerAlpha 0.25;
	_radius = _radius + CTI_NUKE_DAMAGE_RADIUS;
	_radzonesmarkers set [count _radzonesmarkers, _markerName];
};

for [{_i = 0},{_i < CTI_NUKE_RADIATION_LIFETIME / 6 / 2},{_i = _i + 1}] do {
	_objects = nearestObjects [_pos, ["Man","Air","LandVehicle","Ship","Slingload_base_F"], CTI_NUKE_DAMAGE_RADIUS * 3];
	{
		_damage = 0.01;
		if (_x distance _pos < CTI_NUKE_DAMAGE_RADIUS * 2) then {_damage = _damage + 0.02};
		if (_x distance _pos < CTI_NUKE_DAMAGE_RADIUS) then {_damage = _damage + 0.04};

		if (_x isKindOf "Man") then {
			_x setDamage (getDammage _x + _damage);
		};
		if (_x isKindOf "Air" || _x isKindOf "Tank") then {
			_damage = _damage * 0.5;
			{_x setDamage (getDammage _x + _damage)} forEach crew _x;
		};
		if (_x isKindOf "Ship" && surfaceIsWater position _x) then {
			_damage = _damage * 0.75;
			{_x setDamage (getDammage _x + _damage)} forEach crew _x;
		};
		if (_x isKindOf "Car" || _x isKindOf "Slingload_base_F") then {
			_damage = _damage * 0.75;
			{_x setDamage (getDammage _x + _damage)} forEach crew _x;
		};
	} forEach _objects;
	sleep 6;
};

{deleteMarker _x} forEach _radzonesmarkers;

//--- Second round: less damage, less radius

_radzonesmarkers = [];
_radius = CTI_NUKE_DAMAGE_RADIUS / 2;

for [{_i = 0},{_i < 3},{_i = _i + 1}] do {
	_markerName = format ["nuke_radiation_marker_%1_%2", str(_pos), _i];
	_marker = createMarker [_markerName, _pos];
	_marker setMarkerShape "ELLIPSE";
	_marker setMarkerColor "ColorRed";
	_marker setMarkerSize [_radius, _radius];
	_marker setMarkerBrush "SolidFull";
	_marker setMarkerAlpha 0.25;
	_radius = _radius + (CTI_NUKE_DAMAGE_RADIUS / 2);
	_radzonesmarkers set [count _radzonesmarkers, _markerName];
};

for [{_i = 0},{_i < CTI_NUKE_RADIATION_LIFETIME / 6 / 2},{_i = _i + 1}] do {
	_objects = nearestObjects [_pos, ["Man","Air","LandVehicle","Ship","Slingload_base_F"], CTI_NUKE_DAMAGE_RADIUS * 3 / 2];
	{
		_damage = 0.005;
		if (_x distance _pos < CTI_NUKE_DAMAGE_RADIUS / 2 * 2) then {_damage = _damage + 0.01};
		if (_x distance _pos < CTI_NUKE_DAMAGE_RADIUS / 2) then {_damage = _damage + 0.02};

		if (_x isKindOf "Man") then {
			_x setDamage (getDammage _x + _damage);
		};
		if (_x isKindOf "Air" || _x isKindOf "Tank") then {
			_damage = _damage * 0.5;
			{_x setDamage (getDammage _x + _damage)} forEach crew _x;
		};
		if (_x isKindOf "Ship" && surfaceIsWater position _x) then {
			_damage = _damage * 0.75;
			{_x setDamage (getDammage _x + _damage)} forEach crew _x;
		};
		if (_x isKindOf "Car" || _x isKindOf "Slingload_base_F") then {
			_damage = _damage * 0.75;
			{_x setDamage (getDammage _x + _damage)} forEach crew _x;
		};
	} forEach _objects;
	sleep 6;
};

{deleteMarker _x} forEach _radzonesmarkers;
