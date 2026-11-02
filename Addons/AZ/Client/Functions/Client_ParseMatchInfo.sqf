
private ["_namespace","_idc","_html","_tmp","_tmpEast","_tmpWest","_uptime"];

_namespace = _this select 0;
_idc = _this select 1;



_html = "<br />" + localize "STR_AZ_MatchInfo_Header" + "<br />";

_html = _html + format [localize "STR_AZ_MatchInfo_ConnectedToZeus",name (getAssignedCuratorUnit ADMIN_ZEUS)];

_uptime = call CTI_CL_FNC_GetMissionTime;
_html = _html + format [localize "STR_MAX_MISSION_TIME", _uptime select 0, _uptime select 1, _uptime select 2, _uptime select 3, missionNamespace getVariable "CTI_MAX_MISSION_TIME"];

_html = _html + format [localize "STR_AZ_MatchInfo_PlayersNumber", west countSide allPlayers, east countSide allPlayers];

_tmpEast = "";
_tmpWest = "";
{
	_tmp = "";

	if !(isNull (((_x) call CTI_CO_FNC_GetSideLogic) getVariable ["cti_commander",grpNull])) then {
		_tmp = name (leader (((_x) call CTI_CO_FNC_GetSideLogic) getVariable ["cti_commander",grpNull]));
		if (!isPlayer (leader (((_x) call CTI_CO_FNC_GetSideLogic) getVariable ["cti_commander",grpNull]))) then {_tmp = _tmp + " (AI)"};
	};
	if (_tmp == "") then {_tmp = "NONE"};

	if (_x == west) then {_tmpWest = _tmp};
	if (_x == east) then {_tmpEast = _tmp};
} forEach [west,east];
_html = _html + format [localize "STR_AZ_MatchInfo_Commanders", _tmpWest, _tmpEast];

_html = _html + format [localize "STR_AZ_MatchInfo_CommandersFunds", (west) call CTI_CO_FNC_GetFundsCommander, (east) call CTI_CO_FNC_GetFundsCommander];

_tmpEast = 0;
_tmpWest = 0;
{
	if (side _x == west) then {_tmpWest = _tmpWest + ((group _x) call CTI_CO_FNC_GetFundsTeam);};
	if (side _x == east) then {_tmpEast = _tmpEast + ((group _x) call CTI_CO_FNC_GetFundsTeam);};
} forEach allPlayers;
_html = _html + format [localize "STR_AZ_MatchInfo_PlayersFunds", _tmpWest, _tmpEast];

_tmpEast = "";
_tmpWest = "";
{
	_hq = nil;
	_tmp = "";

	_hq = (_x) call CTI_CO_FNC_GetSideHQ;
	if (alive _hq) then {
		_tmp = localize "STR_AZ_MatchInfo_HQ_Condition_Alive";
//		if !(_hq isKindOf "Wheeled_APC_F") then {_tmp = _tmp + ", Packed"};
		if (_hq isKindOf "Slingload_base_F") then {_tmp = _tmp + localize "STR_AZ_MatchInfo_HQ_Condition_Packed"};
	} else {
		_tmp = localize "STR_AZ_MatchInfo_HQ_Condition_Dead";
	};
	if (_tmp == "") then {_tmp = "Undefined"};

	if (_x == west) then {_tmpWest = _tmp};
	if (_x == east) then {_tmpEast = _tmp};
} forEach [west,east];
_html = _html + format [localize "STR_AZ_MatchInfo_HQ_Condition", _tmpWest, _tmpEast];

_tmpEast = [];
_tmpWest = [];
{
	_hq = nil;
	_tmp = [];

	_hq = (_x) call CTI_CO_FNC_GetSideHQ;
	_tmp = getPos _hq;
	if (count _tmp >= 2) then {
		_tmp = [round (_tmp select 0),round (_tmp select 1)];
	} else {
		_tmp = ["n/a","n/a"];
	};

	if (_x == west) then {_tmpWest = _tmp};
	if (_x == east) then {_tmpEast = _tmp};
} forEach [west,east];
_html = _html + format [localize "STR_AZ_MatchInfo_HQ_Position", _tmpWest select 0, _tmpWest select 1, _tmpEast select 0, _tmpEast select 1];

_tmpEast = 0;
_tmpWest = 0;
{
	_tmp = (_x) call CTI_CO_FNC_GetSideLogic;
	_tmp = _tmp getVariable "cti_structures_areas";

	if (_x == west) then {_tmpWest = count _tmp};
	if (_x == east) then {_tmpEast = count _tmp};
} forEach [west,east];
_html = _html + format [localize "STR_AZ_MatchInfo_BasesNumber", _tmpWest, _tmpEast];





((uiNamespace getVariable _namespace) displayCtrl _idc) ctrlSetStructuredText parseText _html;
