
closeDialog 0;
sleep 1;
openMap true;
CTI_NUKE_mapclick = false;
onMapSingleClick "CTI_NUKE_strike_pos = _pos;CTI_NUKE_mapclick = true;onMapSingleClick '';true";
waitUntil {CTI_NUKE_mapclick or !(visibleMap)};
if (!visibleMap) exitwith {hint localize "STR_CTI_NUKE_LAUNCH_CANCELED";};
if (CTI_NUKE_mapclick) then {
	openMap false;
	["SERVER", "Request_NukeStrike", CTI_NUKE_strike_pos] call CTI_CO_FNC_NetSend;
};
