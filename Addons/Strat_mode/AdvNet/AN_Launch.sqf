private ["_vehicle","_side_id"];
_vehicle = _this select 0;
_side_id= _this select 1;
if (NET_LOG) then {diag_log format [":: NET :: Trying to launch for %1 with sideid %2",_vehicle,_side_id]};
// Guard по живости циклов, а не по наличию AN_iNet:
// мёртвый цикл оставляет AN_iNet непустым, и старый guard блокировал перезапуск навсегда
private _upd = _vehicle getVariable ["AN_updHandle", scriptNull];
private _rec = _vehicle getVariable ["AN_recHandle", scriptNull];
if (!isNull _upd && {!scriptDone _upd} && !isNull _rec && {!scriptDone _rec}) exitWith {false};
//diag_log format ["Starting networking for %1 side %2", _this select 0 , _this	 select 1];
if (isNil {_vehicle getVariable "CTI_Net"}) then {_vehicle setVariable ["CTI_Net",_side_id,true];};
// AN_Conn networked для всех (игроки и техника), false для пехоты (боты)
private _net_global = if (_vehicle isKindOf "Man" && !isPlayer _vehicle) then {false} else {true};
if (isNil {_vehicle getVariable "AN_Conn"}) then {_vehicle setVariable ["AN_Conn",objNull,_net_global];};
if (isNil {_vehicle getVariable "AN_iNet"}) then {_vehicle setVariable ["AN_iNet",-1,true];};
if (isNil {_vehicle getVariable "AN_Parrents"}) then {_vehicle setVariable ["AN_Parrents",[],false];};

if (NET_LOG) then {diag_log format [":: NET :: Launching for %1 with sideid %2",_vehicle,_side_id]};
// Храним handle локально (false): script handle имеет смысл только на своей машине
if (isNull _upd || {scriptDone _upd}) then {
	_vehicle setVariable ["AN_updHandle", _vehicle spawn AN_Update_Connection, false];
};
if (isNull _rec || {scriptDone _rec}) then {
	_vehicle setVariable ["AN_recHandle", _vehicle spawn AN_Reconfigure_loop, false];
};