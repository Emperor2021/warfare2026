
private ["_color","_hq","_marker","_markers","_type"];

while {!CTI_GameOver} do {
	_markers = [];

	{
		if ((_x == west && AZ_CL_V_TRACK_HQ_WEST) || (_x == east && AZ_CL_V_TRACK_HQ_EAST)) then {
			_hq = (_x) call CTI_CO_FNC_GetSideHQ;

			if (_x == west) then {_type = "b_hq";_color = "ColorBlue";};
			if (_x == east) then {_type = "o_hq";_color = "ColorRed";};
			if (not alive _hq) then {_color = "ColorBlack";};

			_marker = createMarkerLocal [format ["AZ_Marker_HQ_%1", str (_x)], getPos _hq];
			_marker setMarkerTypeLocal _type;
			_marker setMarkerTextLocal "HQ";
			_marker setMarkerColorLocal _color;
			_marker setMarkerSizeLocal [1, 1];
			_marker setMarkerAlphaLocal 0.75;
			_markers = _markers + [_marker];
		};
	} forEach [west,east];

	sleep 1;

	if (count _markers > 0) then {{deleteMarkerLocal _x} forEach _markers};
};
