
private ["_pos", "_SatLevel", "_upgrades"];

_pos = _this select 0;

//["DEBUG", "FILE: Addons\Nuke\Nuke_Server_Launch.sqf", str(_pos)] call CTI_CO_FNC_Log;

_upgrades = (east) call CTI_CO_FNC_GetSideUpgrades;
_SatLevel = _upgrades select CTI_UPGRADE_SATELLITE;
if (_SatLevel == 1) then {
	[["CLIENT", east], "Client_OnMessageReceived", ["nuke-launch-detected"]] call CTI_CO_FNC_NetSend;    
};

_upgrades = (west) call CTI_CO_FNC_GetSideUpgrades;
_SatLevel = _upgrades select CTI_UPGRADE_SATELLITE;
if (_SatLevel == 1) then {
	[["CLIENT", west], "Client_OnMessageReceived", ["nuke-launch-detected"]] call CTI_CO_FNC_NetSend;
};

sleep CTI_NUKE_FLIGHT_TIME;

[_pos] spawn CTI_SE_FNC_NukeDetonation;
