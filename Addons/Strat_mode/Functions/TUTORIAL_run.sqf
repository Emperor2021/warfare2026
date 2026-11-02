private ["_pos","_spawn_at","_hq","_structures"];
player allowDamage false;
_pos=getMarkerPos "CTI_TUTORIAL";
_pos = [_pos,5,20] call CTI_CO_FNC_GetRandomPosition;
player setPos _pos;
//no escape
0 spawn {
	while {!((profileNamespace getVariable ["TUTO_COMPLETE",false]) || missionNamespace getVariable ["TUTO_COMPLETE",false])} do {
		if (([player,getMarkerPos "CTI_TUTORIAL"] call  BIS_fnc_distance2D)> 42.5) then {
			_pos=getMarkerPos "CTI_TUTORIAL";
			_pos = [_pos,5,20] call CTI_CO_FNC_GetRandomPosition;
			player setPos _pos;
		};
		sleep 5;
	};
};

waitUntil {(profileNamespace getVariable ["TUTO_COMPLETE",false]) || missionNamespace getVariable ["TUTO_COMPLETE",false]};
waitUntil {!isNil {CTI_P_SideLogic getVariable "cti_structures"} && !isNil {CTI_P_SideLogic getVariable "cti_hq"}};

12452 cutText [localize "STR_End_Tutorial", "PLAIN", 0];
sleep 1;

_spawn_at=objNull;

if (!(CTI_P_Jailed)) then {
	12452 cutText [localize "STR_End_Tutorial_1", "BLACK FADED", 50000];
	player allowDamage true;
	while {isNull _spawn_at} do {
		_hq = (CTI_P_SideJoined) call CTI_CO_FNC_GetSideHQ;
		_structures = (CTI_P_SideJoined) call CTI_CO_FNC_GetSideStructures;
		_spawn_at = _hq;
		if (count _structures > 0) then {  _spawn_at = [_hq, _structures] call CTI_CO_FNC_GetClosestEntity; if (isnull _spawn_at) then { _spawn_at=_hq;} };
		sleep 1;
	};
	_spawn_at = [_spawn_at, 8, 30] call CTI_CO_FNC_GetRandomPosition;
	player setPos _spawn_at;
	[player, missionNamespace getVariable format ["CTI_AI_%1_DEFAULT_GEAR", CTI_P_SideJoined]] call CTI_CO_FNC_EquipUnit; //--- Equip pure clients
	sleep 2;
	CTI_CL_V_TUTORIAL_ENDED = true;
	12452 cutText ["", "PLAIN", 0];
};