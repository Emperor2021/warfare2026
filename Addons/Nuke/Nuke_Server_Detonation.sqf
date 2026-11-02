
private ["_bomb", "_pos"];

_pos = _this select 0;

//["DEBUG", "FILE: Addons\Nuke\Nuke_Server_Detonation.sqf", str(_pos)] call CTI_CO_FNC_Log;

_bomb = "Bo_GBU12_LGB" createVehicle [_pos select 0, _pos select 1, 0.1911];
_bomb setvelocity [0, 0, -100];

sleep 0.5;

[["CLIENT", east], "Client_OnNukeDetonation", _pos] call CTI_CO_FNC_NetSend;
[["CLIENT", west], "Client_OnNukeDetonation", _pos] call CTI_CO_FNC_NetSend;

[_pos] spawn CTI_SE_FNC_NukeDamage;

[_pos] spawn CTI_SE_FNC_NukeRadiation;

sleep 3;

[_pos] spawn CTI_SE_FNC_NukeEMI;
