
private ["_bases","_coloration","_logic","_marker","_markers"];

while {!CTI_GameOver} do {
	_markers = [];

	{
		if ((_x == west && AZ_CL_V_TRACK_BASES_WEST) || (_x == east && AZ_CL_V_TRACK_BASES_EAST)) then {
			_logic = (_x) call CTI_CO_FNC_GetSideLogic;
			_bases = _logic getVariable "cti_structures_areas";
			_coloration = (_x) call CTI_CO_FNC_GetSideColoration;

			if (count _bases > 0) then {
				{
					_marker = createMarkerLocal [format ["AZ_Marker_Base_%1", str (_x)], _x];
					_marker setMarkerShapeLocal "ELLIPSE";
					_marker setMarkerBrushLocal "SolidBorder";
					_marker setMarkerSizeLocal [CTI_BASE_AREA_RANGE,CTI_BASE_AREA_RANGE];
					_marker setMarkerColorLocal _coloration;
					_marker setMarkerAlphaLocal 0.5;
					_markers = _markers + [_marker];
				} forEach _bases;
			};
		};
	} forEach [west,east];

	sleep 60;

	if (count _markers > 0) then {{deleteMarkerLocal _x} forEach _markers};
};
