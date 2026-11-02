
private ["_target","_marker","_marker_color","_marker_name","_marker_text","_marker_text_orig","_side","_sideID"];

_target = _this select 0;
_marker = _this select 1;
_marker_name = _this select 2;
_marker_text = _this select 3;
_marker_text_orig = _marker_text;

while {alive _target && (AZ_CL_V_TRACK_UNITS_WEST || AZ_CL_V_TRACK_UNITS_EAST)} do {
	_marker_name setMarkerPosLocal (getPos _target);

	if !(_target isKindOf "Man") then {
		_sideID = _target getVariable "cti_net";
		if !(isNil "_sideID") then {
			_side = (_sideID) call CTI_CO_FNC_GetSideFromID;
		} else {
			_side = switch (getNumber (configFile >> "CfgVehicles" >> typeOf _target >> "side")) do {case 0: {east}; case 1: {west}; case 2: {resistance}; default {civilian}};
		};
		_marker_color = (_side) call CTI_CO_FNC_GetSideColoration;
		_marker_name setMarkerColorLocal _marker_color;

		_players = {isPlayer _x} count (crew _target);
		if (_players > 0) then {
			_marker_text = _marker_text_orig + ": ";
			{if (isPlayer _x) then {_marker_text = _marker_text + format ["[%1]%2 ", (groupId (group _x)), (name _x)];};} forEach (crew _target);
			_marker_name setMarkerTextLocal _marker_text;
		} else {
			_marker_name setMarkerTextLocal _marker_text_orig;
		};
	};

//	if (vehicle _target == _target || (vehicle _target) isKindOf "StaticWeapon") then {
	if ( vehicle _target == _target || ((vehicle _target) isKindOf "StaticWeapon" && !(isPlayer _target)) ) then {
		_marker_name setMarkerAlphaLocal 0.75;
	} else {
		_marker_name setMarkerAlphaLocal 0;
	};

	sleep 1;
};

if (not alive _target) then {
	_marker_name setMarkerColorLocal "ColorBlack";
	sleep 10;
	deleteMarkerLocal _marker_name;
};
