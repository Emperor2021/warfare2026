private ["_action","_color","_groups","_sideLetter","_text","_units","_who","_who_vehicle"];
_action = _this select 0;

switch (_action) do {
	case "onLoad": {
		_groups = allGroups;

		_track = player;
		showCinemaBorder false;

		// _ep = _track weaponDirection currentWeapon _track;
		// _pitch = (_ep) call CTI_UI_UnitsCamera_GetPitchFromDirectionVector;
		_pitch = 0;
		_dir = 180;
		_distance = 2.5;
		_pos = [(sin _dir)*(cos _pitch * _distance),(cos _pitch) * (cos _dir * _distance),1.5-(sin _pitch * _distance)];

		CTI_UnitsCamera = "camera" camCreate getPos _track;
		CTI_UnitsCamera camSetTarget _track;
		CTI_UnitsCamera camSetRelPos _pos;
		CTI_UnitsCamera camCommit 0;

		if (difficultyOption "thirdPersonView" == 1) then {
			uiNamespace setVariable ["cti_dialog_ui_unitscam_camview", "external"];
			CTI_UnitsCamera cameraEffect ["EXTERNAL", "BACK"];
			vehicle _track switchCamera "EXTERNAL";

			((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180021) ctrlSetPosition [SafeZoneX + (SafeZoneW * 0.01), SafeZoneY + (SafeZoneH * 0.80), SafeZoneW * 0.14, SafeZoneH * 0.04]; ((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180021) ctrlCommit 0; //--- Bring back the button!
		} else {
			uiNamespace setVariable ["cti_dialog_ui_unitscam_camview", "internal"];
			vehicle _track switchCamera "INTERNAL";
		};

		uiNamespace setVariable ["cti_dialog_ui_unitscam_anchor", nil];
		uiNamespace setVariable ["cti_dialog_ui_unitscam_camview_in", cameraView];
		uiNamespace setVariable ["cti_dialog_ui_unitscam_screenselect", objNull];
		uiNamespace setVariable ["cti_dialog_ui_unitscam_pitch", 0];
		uiNamespace setVariable ["cti_dialog_ui_unitscam_dir", 180];
		uiNamespace setVariable ["cti_dialog_ui_unitscam_focus", _track];

		((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180001) ctrlAddEventHandler ["MouseButtonDown", "nullReturn = _this call CTI_UI_KeyHandler_UnitsCam_MouseButtonDown"];
		((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180001) ctrlAddEventHandler ["MouseButtonUp", "nullReturn = _this call CTI_UI_KeyHandler_UnitsCam_MouseButtonUp"];
		// ((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl 170001) ctrlAddEventHandler ["MouseZChanged", "nullReturn = _this call CTI_UI_KeyHandler_SatelitteCamera_MouseZChanged"];
		((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180001) ctrlAddEventHandler ["MouseMoving", "nullReturn = _this call CTI_UI_KeyHandler_UnitsCam_MouseMoving"];
		((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180001) ctrlAddEventHandler ["MouseHolding", "nullReturn = _this call CTI_UI_KeyHandler_UnitsCam_MouseMoving"];

		ctrlSetFocus ((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180021);

		_groups = allGroups;
		uiNamespace setVariable ["cti_dialog_ui_unitscam_groups", _groups];
		_origin = uiNamespace getVariable "cti_dialog_ui_unitscam_origin";
		if (isNil '_origin') then { _origin = objNull };
		{
			if (side _x == west) then {_sideLetter = "B"};
			if (side _x == east) then {_sideLetter = "O"};
			if (side _x == resistance) then {_sideLetter = "R"};
			if (side _x == civilian) then {_sideLetter = "C"};
			((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180100) lbAdd format ["(%1) %2 (%3)",_sideLetter, groupID _x, if (isPlayer leader _x) then {name leader _x} else {"AI"}];

			if (isNull _origin) then {
				if (group _track == _x) then {((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180100) lbSetCurSel _forEachIndex};
			} else {
				if (group _origin == _x) then {if (_origin == leader _x) then {uiNamespace setVariable ["cti_dialog_ui_unitscam_origin", nil]}; ((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180100) lbSetCurSel _forEachIndex};
			};
		} forEach _groups;

		if (isNil {uiNamespace getVariable "cti_dialog_ui_unitscam_showgroups"}) then {uiNamespace setVariable ["cti_dialog_ui_unitscam_showgroups", true]};
		if (uiNamespace getVariable "cti_dialog_ui_unitscam_showgroups") then {
			((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180007) ctrlSetText localize "STR_AZ_GroupsHide";
		} else {
			((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180007) ctrlSetText localize "STR_AZ_GroupsShow";
			{((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl _x) ctrlShow false} forEach [9180002, 9180003, 9180004, 9180005, 9180006, 9180100, 9180101];
		};

		if (isNil {uiNamespace getVariable "cti_dialog_ui_unitscam_showmap"}) then {uiNamespace setVariable ["cti_dialog_ui_unitscam_showmap", true]};
		if (uiNamespace getVariable "cti_dialog_ui_unitscam_showmap") then {
			((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180008) ctrlSetText localize "STR_AZ_MapHide";
		} else {
			((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180008) ctrlSetText localize "STR_AZ_MapShow";
			{((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl _x) ctrlShow false} forEach [9180009, 9180010];
		};

		["cti_dialog_ui_unitscam", 9180017] call AZ_CL_FNC_ParseMatchInfo;

		if (isNil {uiNamespace getVariable "cti_dialog_ui_unitscam_showinfo"}) then {uiNamespace setVariable ["cti_dialog_ui_unitscam_showinfo", false]};
		if (uiNamespace getVariable "cti_dialog_ui_unitscam_showinfo") then {
			((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180015) ctrlSetText localize "STR_AZ_InfoHide";
		} else {
			((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180015) ctrlSetText localize "STR_AZ_InfoShow";
			{((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl _x) ctrlShow false} forEach [9180016, 9180018];
		};

		//--- Render in. Where the bloody hell is the dialog option to render thing invisible at first? visible = 0 ?!?!
		{((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl _x) ctrlSetPosition [SafeZoneX + (SafeZoneW * 0.01), SafeZoneY + (SafezoneH * 0.06), SafeZoneW * 0.31, SafeZoneH * 0.6]; ((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl _x) ctrlCommit 0} forEach [9180016, 9180018];
		((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180009) ctrlSetPosition [SafeZoneX + (SafeZoneW * 0.8), SafeZoneY + (SafezoneH * 0.62), SafeZoneW * 0.19, SafeZoneH * 0.32]; ((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180009) ctrlCommit 0;
		((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180010) ctrlSetPosition [SafeZoneX + (SafeZoneW * 0.805), SafeZoneY + (SafezoneH * 0.63), SafeZoneW * 0.18, SafeZoneH * 0.30]; ((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180010) ctrlCommit 0;
		((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180002) ctrlSetPosition [SafeZoneX + (SafeZoneW * 0.8), SafeZoneY + (SafezoneH * 0.06), SafeZoneW * 0.19, SafeZoneH * 0.55]; ((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180002) ctrlCommit 0;
		((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180003) ctrlSetPosition [SafeZoneX + (SafeZoneW * 0.805), SafeZoneY + (SafezoneH * 0.0605), SafeZoneW * 0.19, SafeZoneH * 0.03]; ((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180003) ctrlCommit 0;
		{((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl _x) ctrlSetPosition [SafeZoneX + (SafeZoneW * 0.805), SafeZoneY + (SafeZoneH * 0.10), SafeZoneW * 0.18, SafeZoneH * 0.3]; ((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl _x) ctrlCommit 0} forEach [9180004, 9180100];
		((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180005) ctrlSetPosition [SafeZoneX + (SafeZoneW * 0.805), SafeZoneY + (SafezoneH * 0.41), SafeZoneW * 0.19, SafeZoneH * 0.03]; ((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180005) ctrlCommit 0;
		{((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl _x) ctrlSetPosition [SafeZoneX + (SafeZoneW * 0.805), SafeZoneY + (SafezoneH * 0.45), SafeZoneW * 0.18, SafeZoneH * 0.15]; ((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl _x) ctrlCommit 0} forEach [9180006, 9180101];

		if (call CTI_CL_FNC_IsPlayerCommander) then {
			((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180023) ctrlSetPosition [SafeZoneX + (SafeZoneW * 0.01), SafeZoneY + (SafeZoneH * 0.70), SafeZoneW * 0.14, SafeZoneH * 0.04]; ((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180023) ctrlCommit 0; //--- Bring back the button!
		};

		if (isNil {uiNamespace getVariable "cti_dialog_ui_unitscam_viewmode"}) then {uiNamespace setVariable ["cti_dialog_ui_unitscam_viewmode", 0]};
		_mode = "Normal";
		switch (uiNamespace getVariable "cti_dialog_ui_unitscam_viewmode") do {
			case 1: {_mode = "NVG"; camUseNVG true; false setCamUseTi 1;};
			case 2: {_mode = "Thermal"; camUseNVG false; true setCamUseTi 1;};
			default {_mode = "Normal"; camUseNVG false; false setCamUseTi 1;};
		};
		((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180013) ctrlSetText _mode;

		if (AZ_CL_V_TRACK_HQ_WEST) then {_text = localize "STR_AZ_Menu_Options_TrackHQ_On"} else {_text = localize "STR_AZ_Menu_Options_TrackHQ_Off"};
		((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180106) ctrlSetText _text;

		if (AZ_CL_V_TRACK_HQ_EAST) then {_text = localize "STR_AZ_Menu_Options_TrackHQ_On"} else {_text = localize "STR_AZ_Menu_Options_TrackHQ_Off"};
		((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180107) ctrlSetText _text;

		if (AZ_CL_V_TRACK_BASES_WEST) then {_text = localize "STR_AZ_Menu_Options_TrackBases_On"} else {_text = localize "STR_AZ_Menu_Options_TrackBases_Off"};
		((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180108) ctrlSetText _text;

		if (AZ_CL_V_TRACK_BASES_EAST) then {_text = localize "STR_AZ_Menu_Options_TrackBases_On"} else {_text = localize "STR_AZ_Menu_Options_TrackBases_Off"};
		((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180109) ctrlSetText _text;

		if (AZ_CL_V_TRACK_UNITS_WEST) then {_text = localize "STR_AZ_Menu_Options_TrackUnits_On"} else {_text = localize "STR_AZ_Menu_Options_TrackUnits_Off"};
		((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180110) ctrlSetText _text;

		if (AZ_CL_V_TRACK_UNITS_EAST) then {_text = localize "STR_AZ_Menu_Options_TrackUnits_On"} else {_text = localize "STR_AZ_Menu_Options_TrackUnits_Off"};
		((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180111) ctrlSetText _text;

		execVM "Client\GUI\GUI_UnitsCamera.sqf";
	};
	case "onUnitsLBSelChanged": {
		_changeto = _this select 1;

		_group = (uiNamespace getVariable "cti_dialog_ui_unitscam_groups") select _changeto;
		lbClear ((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180101);

		_origin = uiNamespace getVariable "cti_dialog_ui_unitscam_origin";
		if (isNil '_origin') then { _origin = objNull };

		//--- Load the AI Members
		_ais = (units _group - [leader _group]) call CTI_CO_FNC_GetLiveUnits;
		uiNamespace setVariable ["cti_dialog_ui_unitscam_groups_ai", _ais];
		{
			((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180101) lbAdd format["%1", _x];
			if (alive _origin && _x == _origin) then {((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180101) lbSetCurSel _forEachIndex};
		} forEach (_ais);

		if !(isNil {uiNamespace getVariable "cti_dialog_ui_unitscam_origin"}) then {
			uiNamespace setVariable ["cti_dialog_ui_unitscam_origin", nil];
		} else {
			if !(isNull (uiNamespace getVariable "cti_dialog_ui_unitscam_screenselect")) then {
				((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180101) lbSetCurSel (_ais find (uiNamespace getVariable "cti_dialog_ui_unitscam_screenselect"));
				uiNamespace setVariable ["cti_dialog_ui_unitscam_screenselect", objNull];
			} else {
				if (alive leader _group) then {
					switch (uiNamespace getVariable "cti_dialog_ui_unitscam_camview") do {
						case "internal": {(vehicle leader _group) switchCamera "INTERNAL"};
						case "ironsight": {(vehicle leader _group) switchCamera "GUNNER"};
						case "external": {(vehicle leader _group) switchCamera "EXTERNAL"}
					};
					((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180011) ctrlSetText format["Feed: %1", leader _group];
					uiNamespace setVariable ["cti_dialog_ui_unitscam_focus", leader _group];
//					[_ai, "cti_dialog_ui_satcam", 9180017] call CTI_UI_SatelitteCamera_LoadEntityInformation;
				};
			};
		};
	};
	case "onUnitsAILBSelChanged": {
		_changeto = _this select 1;

		_ai = (uiNamespace getVariable "cti_dialog_ui_unitscam_groups_ai") select _changeto;
		if (alive _ai) then {
			uiNamespace setVariable ["cti_dialog_ui_unitscam_focus", _ai];
			switch (uiNamespace getVariable "cti_dialog_ui_unitscam_camview") do {
				case "internal": {vehicle _ai switchCamera "INTERNAL"};
				case "ironsight": {vehicle _ai switchCamera "GUNNER"};
				case "external": {vehicle _ai switchCamera "EXTERNAL"}
			};
			((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180011) ctrlSetText format["Feed: %1", _ai];
//			[_ai, "cti_dialog_ui_satcam", 9180017] call CTI_UI_SatelitteCamera_LoadEntityInformation;
		};
	};
	case "onToggleGroup": {
		_changeto = !(uiNamespace getVariable "cti_dialog_ui_unitscam_showgroups");
		uiNamespace setVariable ["cti_dialog_ui_unitscam_showgroups", _changeTo];

		if (_changeto) then {
			((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180007) ctrlSetText localize "STR_AZ_GroupsHide";
			{((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl _x) ctrlShow true} forEach [9180002, 9180003, 9180004, 9180005, 9180006, 9180100, 9180101];
		} else {
			((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180007) ctrlSetText localize "STR_AZ_GroupsShow";
			{((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl _x) ctrlShow false} forEach [9180002, 9180003, 9180004, 9180005, 9180006, 9180100, 9180101];
		};
	};
	case "onToggleMap": {
		_changeto = !(uiNamespace getVariable "cti_dialog_ui_unitscam_showmap");
		uiNamespace setVariable ["cti_dialog_ui_unitscam_showmap", _changeTo];

		if (_changeto) then {
			((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180008) ctrlSetText localize "STR_AZ_MapHide";
			{((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl _x) ctrlShow true} forEach [9180009, 9180010];
		} else {
			((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180008) ctrlSetText localize "STR_AZ_MapShow";
			{((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl _x) ctrlShow false} forEach [9180009, 9180010];
		};
	};
	case "onToggleInfo": {
		_changeto = !(uiNamespace getVariable "cti_dialog_ui_unitscam_showinfo");
		uiNamespace setVariable ["cti_dialog_ui_unitscam_showinfo", _changeTo];

		if (_changeto) then {
			((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180015) ctrlSetText localize "STR_AZ_InfoHide";
			{((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl _x) ctrlShow true} forEach [9180016, 9180018];
		} else {
			((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180015) ctrlSetText localize "STR_AZ_InfoShow";
			{((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl _x) ctrlShow false} forEach [9180016, 9180018];
		};
	};
	case "onViewModeChanged": {
		_mode = (uiNamespace getVariable "cti_dialog_ui_unitscam_viewmode") + 1;
		if (_mode > 2) then { _mode = 0 };
		uiNamespace setVariable ["cti_dialog_ui_unitscam_viewmode", _mode];
		switch (_mode) do {
			case 1: {_mode = "NVG"; camUseNVG true; false setCamUseTi 1;};
			case 2: {_mode = "Thermal"; camUseNVG false; true setCamUseTi 1;};
			default {_mode = "Normal"; camUseNVG false; false setCamUseTi 1;};
		};
		((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180013) ctrlSetText _mode;
	};
	case "onSatelliteCameraJump": {
		_track = uiNamespace getVariable "cti_dialog_ui_unitscam_focus";
		if (isNil '_track') then {_track = player};
		if !(isNil '_track') then {
			if (alive _track) then {
				titleCut["","BLACK IN",1];
				uiNamespace setVariable ["cti_dialog_ui_satcam_origin", _track];
				closeDialog 0;
				createDialog "AZ_RscSatelitteCamera";
			};
		};
	};
	case "onCamChange": {
		_changeto = _this select 1;
		_track = uiNamespace getVariable "cti_dialog_ui_unitscam_focus";

		if !(isNil '_track') then {
			switch (_changeto) do {
				case "ironsight": {
					CTI_UnitsCamera cameraEffect["TERMINATE","BACK"];
					vehicle _track switchCamera "GUNNER";
					uiNamespace setVariable ["cti_dialog_ui_unitscam_camview", "ironsight"];
				};
				case "internal": {
					CTI_UnitsCamera cameraEffect["TERMINATE","BACK"];
					vehicle _track switchCamera "INTERNAL";
					uiNamespace setVariable ["cti_dialog_ui_unitscam_camview", "internal"];
				};
				case "external": {
					if (difficultyOption "thirdPersonView" == 1) then {
						CTI_UnitsCamera cameraEffect ["TERMINATE", "BACK"];
						vehicle _track switchCamera "EXTERNAL";
						uiNamespace setVariable ["cti_dialog_ui_unitscam_camview", "external"];
					};
				};
			};
		};
	};
	case "onUnitDisband": {
		_who = uiNamespace getVariable "cti_dialog_ui_unitscam_focus";

		if (alive _who) then {
			["SERVER", "Request_Punishment", _who] call CTI_CO_FNC_NetSend;
		};
	};
	case "onRemote": {
		_who = uiNamespace getVariable "cti_dialog_ui_unitscam_focus";
		_dialog = uiNamespace getVariable 'cti_dialog_ui_unitscam';
		if (alive _who) then {
//			if !(isPlayer leader _who) then {
			if !(isPlayer _who) then {
				_who spawn {
					waitUntil {cameraOn == player};
					sleep 0.5;
					player remoteControl _this;
					_this switchCamera "Internal";
//					waitUntil {not alive _this};
//					objNull remoteControl _this;
				};
				_dialog closeDisplay 1;
			};
		};
	};
	case "onUnitUnflip": {
		_who = uiNamespace getVariable "cti_dialog_ui_unitscam_focus";
		_who_vehicle = vehicle _who;
		if (alive _who && speed _who_vehicle < 5 && (getPos _who_vehicle select 2) < 5 && !isPlayer _who) then {
			_unflip = false;
			if (call CTI_CL_FNC_IsPlayerCommander) then {
				_unflip = true
			} else {
				if (_who in units player) then {_unflip = true};
			};

			if (_unflip) then {
				_who_vehicle setPos [getPos _who_vehicle select 0, getPos _who_vehicle select 1, 1];
				_who_vehicle setVelocity [0,0,1];
			};
		};
	};
	case "onUnload": {
		CTI_UnitsCamera cameraEffect["TERMINATE","BACK"];
		camDestroy CTI_UnitsCamera;
		vehicle player switchCamera (uiNamespace getVariable "cti_dialog_ui_unitscam_camview_in");
		showCinemaBorder true;
	};

	case "onZeusDisconnect": {
		['SERVER', 'Server_Unassign_Zeus'] call CTI_CO_FNC_NetSend;
	};
	case "onZeusConnect": {
	//	['SERVER', 'Server_Assign_Zeus', player] call CTI_CO_FNC_NetSend;
        player globalChat "Zues connected fail!";
	};
	case "onNukeLaunch": {
		0 spawn AZ_CL_FNC_NukeLaunchAction;
	};

	case "onWestFixHQ": {
		["SERVER", "Request_HQRepair", west] call CTI_CO_FNC_NetSend;
	};
	case "onWestTrackHQ": {
		if (AZ_CL_V_TRACK_HQ_WEST) then {_text = localize "STR_AZ_Menu_Options_TrackHQ_Off";AZ_CL_V_TRACK_HQ_WEST = false;} else {_text = localize "STR_AZ_Menu_Options_TrackHQ_On";AZ_CL_V_TRACK_HQ_WEST = true;};
		((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180106) ctrlSetText _text;
	};
	case "onWestTrackBases": {
		if (AZ_CL_V_TRACK_BASES_WEST) then {_text = localize "STR_AZ_Menu_Options_TrackBases_Off";AZ_CL_V_TRACK_BASES_WEST = false;} else {_text = localize "STR_AZ_Menu_Options_TrackBases_On";AZ_CL_V_TRACK_BASES_WEST = true;};
		((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180108) ctrlSetText _text;
	};
	case "onWestTrackUnits": {
		if (AZ_CL_V_TRACK_UNITS_WEST) then {_text = localize "STR_AZ_Menu_Options_TrackUnits_Off";AZ_CL_V_TRACK_UNITS_WEST = false;} else {_text = localize "STR_AZ_Menu_Options_TrackUnits_On";AZ_CL_V_TRACK_UNITS_WEST = true;};
		((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180110) ctrlSetText _text;
	};

	case "onEastFixHQ": {
		["SERVER", "Request_HQRepair", east] call CTI_CO_FNC_NetSend;
	};
	case "onEastTrackHQ": {
		if (AZ_CL_V_TRACK_HQ_EAST) then {_text = localize "STR_AZ_Menu_Options_TrackHQ_Off";AZ_CL_V_TRACK_HQ_EAST = false;} else {_text = localize "STR_AZ_Menu_Options_TrackHQ_On";AZ_CL_V_TRACK_HQ_EAST = true;};
		((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180107) ctrlSetText _text;
	};
	case "onEastTrackBases": {
		if (AZ_CL_V_TRACK_BASES_EAST) then {_text = localize "STR_AZ_Menu_Options_TrackBases_Off";AZ_CL_V_TRACK_BASES_EAST = false;} else {_text = localize "STR_AZ_Menu_Options_TrackBases_On";AZ_CL_V_TRACK_BASES_EAST = true;};
		((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180109) ctrlSetText _text;
	};
	case "onEastTrackUnits": {
		if (AZ_CL_V_TRACK_UNITS_EAST) then {_text = localize "STR_AZ_Menu_Options_TrackUnits_Off";AZ_CL_V_TRACK_UNITS_EAST = false;} else {_text = localize "STR_AZ_Menu_Options_TrackUnits_On";AZ_CL_V_TRACK_UNITS_EAST = true;};
		((uiNamespace getVariable "cti_dialog_ui_unitscam") displayCtrl 9180111) ctrlSetText _text;
	};
};