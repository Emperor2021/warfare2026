
if (([group player, CTI_P_SideJoined] call CTI_CO_FNC_GetFunds) >= CTI_NUKE_COST_LAUNCH) then {
	openMap true;
	CTI_NUKE_mapclick = false;
	onMapSingleClick "CTI_NUKE_strike_pos = _pos;CTI_NUKE_mapclick = true;onMapSingleClick '';true";
	waitUntil {CTI_NUKE_mapclick or !(visibleMap)};
	if (!visibleMap) exitwith {hint localize "STR_CTI_NUKE_LAUNCH_CANCELED";};
	if (CTI_NUKE_mapclick) then {
		openMap false;
		["SERVER", "Request_NukeStrike", CTI_NUKE_strike_pos] call CTI_CO_FNC_NetSend;
		-(CTI_NUKE_COST_LAUNCH) call CTI_CL_FNC_ChangePlayerFunds;
//		["DEBUG", "FILE: Addons\Nuke\Nuke_Client_Action.sqf", str(CTI_NUKE_strike_pos)] call CTI_CO_FNC_Log;
	};
} else {
	hint parseText (format [localize "STR_CTI_NUKE_LAUNCH_NOFUNDS", CTI_NUKE_COST_LAUNCH]);
};