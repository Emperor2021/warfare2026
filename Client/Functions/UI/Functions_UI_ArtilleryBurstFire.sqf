private ["_artillery", "_target", "_magazine", "_shots", "_rangeMin", "_rangeMax", "_burstSize", "_remainingShots", "_currentBurst", "_reloadDelay"];

_artillery = _this select 0;
_target = _this select 1;
_magazine = _this select 2;
_shots = _this select 3;
_rangeMin = _this select 4;
_rangeMax = _this select 5;

if (isNull _artillery) exitWith {};
if !(alive _artillery) exitWith {};
if (_magazine == "") exitWith {};
if (_shots <= 0) exitWith {};

// размер серии по умолчанию
_burstSize = 8;
_reloadDelay = 20;

// MK6 / mortar
if (_artillery isKindOf "StaticMortar") then {
	_burstSize = 8;
	_reloadDelay = 30;
};

// SPG
if (_artillery isKindOf "B_MBT_01_arty_base_F" || _artillery isKindOf "O_MBT_02_arty_base_F") then {
	_burstSize = 8;
	_reloadDelay = 30;
};

// MLRS
if (_artillery isKindOf "B_MBT_01_mlrs_base_F" || _artillery isKindOf "Truck_02_MRL_base_F") then {
	_burstSize = 12;
	_reloadDelay = 30;
};

_remainingShots = _shots;

while {_remainingShots > 0 && alive _artillery} do {
	if !([_artillery, _magazine, _target, _rangeMin, _rangeMax] call CTI_UI_Artillery_CanFire) exitWith {};

	_currentBurst = _remainingShots min _burstSize;

	_artillery doArtilleryFire [_target, _magazine, _currentBurst];
	_remainingShots = _remainingShots - _currentBurst;

	if (_remainingShots > 0) then {
		sleep _reloadDelay;
	};
};

// Обновление информации после выстрела
[] spawn {
	sleep 2;
	[] call CTI_UI_Artillery_RefreshInfo;
	sleep 3;
	[] call CTI_UI_Artillery_RefreshInfo;
};