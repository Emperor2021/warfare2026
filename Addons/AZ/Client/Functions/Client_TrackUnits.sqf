
private ["_marker","_marker_color","_marker_name","_marker_side","_marker_size","_marker_text","_marker_type","_side","_sideID","_special"];

while {!CTI_GameOver} do {

	if (AZ_CL_V_TRACK_UNITS_WEST || AZ_CL_V_TRACK_UNITS_EAST) then {
		{
			if !(_x in AZ_CL_V_Tracked_Units) then {
				_marker_size = [1,1];
				_marker_text = " ";
				_marker_type = "";
				_special = nil;
				_sideID = nil;
				_side = nil;

				if (_x isKindOf "Man") then {
					_side = side _x;
					if (isPlayer _x) then {_marker_text = format ["[%1]%2", (groupId (group _x)), (name _x)];};
				} else {
					_sideID = _x getVariable "cti_net";
					if !(isNil "_sideID") then {
						_side = (_sideID) call CTI_CO_FNC_GetSideFromID;
					} else {
						_side = switch (getNumber (configFile >> "CfgVehicles" >> typeOf _x >> "side")) do {case 0: {east}; case 1: {west}; case 2: {resistance}; default {civilian}};
					};
					_marker_text = _marker_text + (getText (configFile >> "CfgVehicles" >> typeOf _x >> "displayName"));
					if ( _x == ((_side) call CTI_CO_FNC_GetSideHQ) ) then {_marker_text = "HQ: " + (getText (configFile >> "CfgVehicles" >> typeOf _x >> "displayName"));};
					if (_x isKindOf "Slingload_base_F") then { _marker_type = _marker_side+"inf" };
					_special = _x getVariable "cti_spec";
				};

				if ( (_side == west && AZ_CL_V_TRACK_UNITS_WEST) || (_side == east && AZ_CL_V_TRACK_UNITS_EAST) || _side == resistance) then {
					_marker_side = switch (_side) do { case west: {"b_"}; case east: {"o_"}; case resistance: {"n_"}; default {"n_"} };
					_marker_color = (_side) call CTI_CO_FNC_GetSideColoration;

					if !(isNil "_special") then {
						if (CTI_SPECIAL_REPAIRTRUCK in _special) then { //--- Repair truck.
							_marker_type = _marker_side+"maint"; //type is ok? b_support ?
						};
						if (CTI_SPECIAL_AMMOTRUCK in _special) then { //--- Ammo truck.
							_marker_type = _marker_side+"support";
						};
						if (CTI_SPECIAL_MEDICALVEHICLE in _special) then { //--- Medical vehicle.
							_marker_type = _marker_side+"med";
						};
					};

					if (_marker_type == "") then {
						switch (true) do {
							case (_x isKindOf "Man"): { _marker_type = _marker_side+"inf"; _marker_size = [0.75, 0.75]; };
							case (_x isKindOf "ReammoBox_F" || _x isKindOf "StaticWeapon"): { _marker_type = _marker_side+"unknown"; _marker_size = [0.75, 0.75]; };
							case ((_x isKindOf "Car" || _x isKindOf "Motorcycle") && !(_x isKindOf "Wheeled_APC_F")): { _marker_type = _marker_side+"motor_inf" };
							case (_x isKindOf "Wheeled_APC_F"): { _marker_type = _marker_side+"mech_inf" };
							case (_x isKindOf "Ship"): { _marker_type = _marker_side+"naval" };
							case (_x isKindOf "Tank"): { _marker_type = _marker_side+"armor" };
							case (_x isKindOf "Helicopter"): { _marker_type = _marker_side+"air" };
							case (_x isKindOf "Plane"): { _marker_type = _marker_side+"plane" };
							default { _marker_type = _marker_side+"unknown" };
						};
					};

					_marker_name = format ["AZ_Marker_Unit_%1", AZ_CL_V_MarkerIterator];
					_marker = createMarkerLocal [_marker_name, getPos _x];
					_marker setMarkerTypeLocal _marker_type;
					_marker setMarkerTextLocal _marker_text;
					_marker setMarkerColorLocal _marker_color;
					_marker setMarkerSizeLocal _marker_size;
					_marker setMarkerAlphaLocal 0.75;
					AZ_CL_V_Markers_Units = AZ_CL_V_Markers_Units + [_marker_name];
					AZ_CL_V_Tracked_Units = AZ_CL_V_Tracked_Units + [_x];
					AZ_CL_V_MarkerIterator = AZ_CL_V_MarkerIterator + 1;

					[_x,_marker,_marker_name,_marker_text] spawn AZ_CL_FNC_TrackMarker;
				};
			};
		} forEach (allUnits + vehicles);
	} else {
		{deleteMarkerLocal _x} forEach AZ_CL_V_Markers_Units;
		AZ_CL_V_Markers_Units = [];
		AZ_CL_V_Tracked_Units = [];
	};

	sleep 5;
};
