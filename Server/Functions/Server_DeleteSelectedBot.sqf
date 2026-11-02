private ["_units", "_unit"];

if (_this isEqualType objNull) then {
	_units = [_this];
} else {
	if (_this isEqualType []) then {
		if ((count _this) == 1 && ((_this select 0) isEqualType [])) then {
			_units = _this select 0;
		} else {
			_units = _this;
		};
	} else {
		_units = [];
	};
};

if ((count _units) == 0) exitWith {};

{
	_unit = _x;

	if (!isNull _unit && !isPlayer _unit && (_unit isKindOf "CAManBase") && alive _unit) then {
		if (vehicle _unit != _unit) then {
			unassignVehicle _unit;
			moveOut _unit;
		};

		deleteVehicle _unit;
	};
} forEach _units;
