private ["_unit", "_ammo", "_source", "_missile", "_irLock"];
_unit = _this select 0;
_ammo = _this select 1;
_source = _this select 2;

_missile = nearestObject [_source,_ammo];
if (isNull _missile) exitWith {};
_irLock = getNumber(configFile >> "CfgAmmo" >> _ammo >> "irLock"); //--- Get the ammo type.

if (_irLock == 1) then { //--- IR Lock is affected
//	_unit fire ["SmokeLauncher", "SmokeLauncher", "SmokeLauncherMag"];

	_delay = 15;
	if (isNil {_unit getVariable "cti_irs_last_time_used"}) then {
		_unit fire ["SmokeLauncher", "SmokeLauncher", "SmokeLauncherMag"];
		_unit setVariable ["cti_irs_last_time_used", time, false];
	} else {
		if (time >= ((_unit getVariable "cti_irs_last_time_used") + _delay)) then {
			_unit fire ["SmokeLauncher", "SmokeLauncher", "SmokeLauncherMag"];
			_unit setVariable ["cti_irs_last_time_used", time, false];
		};
	};
};
