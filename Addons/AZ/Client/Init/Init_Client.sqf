


AZ_CL_V_MarkerIterator = 0;
AZ_CL_V_Markers_Units = [];
AZ_CL_V_Tracked_Units = [];

AZ_CL_V_TRACK_BASES_EAST = false;
AZ_CL_V_TRACK_BASES_WEST = false;
AZ_CL_V_TRACK_HQ_EAST = false;
AZ_CL_V_TRACK_HQ_WEST = false;
AZ_CL_V_TRACK_UNITS_EAST = false;
AZ_CL_V_TRACK_UNITS_WEST = false;



AZ_CL_FNC_GetGroupVehicles = compileFinal preprocessFileLineNumbers "Addons\AZ\Client\Functions\Client_GetGroupVehicles.sqf";
AZ_CL_FNC_NukeLaunchAction = compileFinal preprocessFileLineNumbers "Addons\AZ\Client\Functions\Client_NukeLaunchAction.sqf";
AZ_CL_FNC_MenuActionLoop = compileFinal preprocessFileLineNumbers "Addons\AZ\Client\Functions\Client_MenuActionLoop.sqf";
AZ_CL_FNC_ParseMatchInfo = compileFinal preprocessFileLineNumbers "Addons\AZ\Client\Functions\Client_ParseMatchInfo.sqf";
AZ_CL_FNC_TrackBases = compileFinal preprocessFileLineNumbers "Addons\AZ\Client\Functions\Client_TrackBases.sqf";
AZ_CL_FNC_TrackHQ = compileFinal preprocessFileLineNumbers "Addons\AZ\Client\Functions\Client_TrackHQ.sqf";
AZ_CL_FNC_TrackUnits = compileFinal preprocessFileLineNumbers "Addons\AZ\Client\Functions\Client_TrackUnits.sqf";
AZ_CL_FNC_TrackMarker = compileFinal preprocessFileLineNumbers "Addons\AZ\Client\Functions\Client_TrackMarker.sqf";

/*
AZ_UI_SatelitteCamera_MapClicked = {
	private ["_button", "_control", "_mx", "_my", "_position"];
	_control = _this select 0;
	_button = _this select 1;
	_mx = _this select 2;
	_my = _this select 3;

	if (_button == 0) then {
		_position = _control ctrlMapScreenToWorld [_mx, _my];
		_position set [2, getPos CTI_SatelitteCamera select 2];
		CTI_SatelitteCamera setPos _position;
	};
};
*/



AZ_Init_Client_Complete = true;



//--- Waiting until that the game is launched.
waitUntil {time > 0};



0 spawn AZ_CL_FNC_MenuActionLoop;
0 spawn AZ_CL_FNC_TrackUnits;
0 spawn AZ_CL_FNC_TrackBases;
0 spawn AZ_CL_FNC_TrackHQ;
