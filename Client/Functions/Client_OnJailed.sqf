/*
  # HEADER #
	Script: 		Client\Functions\Client_OnJailed.sqf
	Alias:			CTI_CL_FNC_OnJailed
	Description:	Sent by a server whenever the client reach a new plane of existence
					Note this function is automatically called by the server (PVF)
	Author: 		Benny
	Creation Date:	19-09-2013
	Revision Date:	19-09-2013

  # PARAMETERS #
    None

  # RETURNED VALUE #
	None

  # SYNTAX #
	0 spawn CTI_CL_FNC_OnJailed

  # DEPENDENCIES #
	Common Function: CTI_CO_FNC_NetSend

  # EXAMPLE #
	0 spawn CTI_CL_FNC_OnJailed
*/

if ((getPlayerUID player) in CTI_UIDs_VIP) exitWith {};

_skill = call CTI_CL_FNC_GetSkillAI;
_uidp = getplayeruid player;
if ((getPlayerUID player) in CTI_UIDs_BAN) then {
    player groupChat "STOP TEAM KILL!!!";
} else {
    if (_skill > 0.6) exitWith {};
};

createDialog "OnJailedDig";


CTI_P_Jailed = true;
_over = time + _this;
_song_loop = 31.55;
_last_loop = -600;


_pos = getMarkerPos "prison";
_rpos = [(_pos select 0) + random 2 - random 2, (_pos select 1) + random 2 - random 2, 0.75];
(vehicle player) lock false;
unassignVehicle player;
player action ["EJECT", (vehicle player)];
player action ["GETOUT", (vehicle player)];
waitUntil {(vehicle player) == player};
player setPos _rpos;
//player allowDammage false;

0 spawn {
	waitUntil {!(alive player) || (player distance (getMarkerPos "prison")) > 50};
	if (CTI_P_Jailed) then {
		if !(alive player) then {
			waitUntil {alive player};
			sleep CTI_RESPAWN_TIMER + 10;
		};
		hint parseText localize "STR_OnJailed_Escape";
		600 spawn CTI_CL_FNC_OnJailed;
	};
};

for '_i' from 0 to 25 do { player removeAction _i };

removeAllWeapons player;
removeAllItems player;
removeAllAssignedItems player;
removeAllContainers player;
removeHeadgear player;

while {true} do {
	if (time > _over) exitWith {};
	
    if (time - _last_loop > _song_loop) then {_last_loop = time; playSound "prison"};
    
	hint parseText format [localize "STR_OnJailed_TimeLeft", round (_over - time)];

	sleep .1;
};

closeDialog 0;
CTI_P_Jailed = false;
["SERVER", "Request_NoobLoggerEnd", player] call CTI_CO_FNC_NetSend;

hint parseText localize "STR_OnJailed_Freedom";

_hq = (CTI_P_SideJoined) call CTI_CO_FNC_GetSideHQ;
_structures = (CTI_P_SideJoined) call CTI_CO_FNC_GetSideStructures;
_spawn_at = _hq;
if (count _structures > 0) then {_spawn_at = [_hq, _structures] call CTI_CO_FNC_GetClosestEntity;if (isNull _spawn_at) then {_spawn_at = _hq;};};
_spawn_at = [_spawn_at, 8, 30] call CTI_CO_FNC_GetRandomPosition;
player setPos _spawn_at;
