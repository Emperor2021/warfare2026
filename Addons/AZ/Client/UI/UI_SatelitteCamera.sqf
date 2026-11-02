private ["_action","_sideLetter"];
_action = _this select 0;

switch (_action) do {
	case "onLoad": {
		_hq = (CTI_P_SideJoined) call CTI_CO_FNC_GetSideHQ;
//		if !(alive _hq) exitWith {closeDialog 0};
		
		_pos = getPos _hq;
		_pos set [2, CTI_SATCAM_ZOOM_MIN];
		
		showCinemaBorder false;
		
		CTI_SatelitteCamera = "camera" camCreate _pos;
		CTI_SatelitteCamera setVectorDirAndUp [[0, 0, -1], [0, 1, -1]];
		
		uiNamespace setVariable ["cti_dialog_ui_satcam_anchor", nil];
		uiNamespace setVariable ["cti_dialog_ui_satcam_focus", nil];
		uiNamespace setVariable ["cti_dialog_ui_satcam_mapselect", objNull];
		
		(uiNamespace getVariable "cti_dialog_ui_satcam") displayAddEventHandler ["KeyDown", "nullReturn = _this spawn CTI_UI_KeyHandler_SatelitteCamera"];
		((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl 9170001) ctrlAddEventHandler ["MouseButtonDown", "nullReturn = _this call CTI_UI_KeyHandler_SatelitteCamera_MouseButtonDown"];
		((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl 9170001) ctrlAddEventHandler ["MouseButtonUp", "nullReturn = _this call CTI_UI_KeyHandler_SatelitteCamera_MouseButtonUp"];
		((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl 9170001) ctrlAddEventHandler ["MouseZChanged", "nullReturn = _this call CTI_UI_KeyHandler_SatelitteCamera_MouseZChanged"];
		((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl 9170001) ctrlAddEventHandler ["MouseMoving", "nullReturn = _this call CTI_UI_KeyHandler_SatelitteCamera_MouseMoving"];
		((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl 9170001) ctrlAddEventHandler ["MouseHolding", "nullReturn = _this call CTI_UI_KeyHandler_SatelitteCamera_MouseMoving"];
		
		ctrlSetFocus ((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl 9170001);
		
//		_groups = (CTI_P_SideJoined) call CTI_CO_FNC_GetSideGroups;
		_groups = allGroups;
		uiNamespace setVariable ["cti_dialog_ui_satcam_groups", _groups];
		_origin = uiNamespace getVariable "cti_dialog_ui_satcam_origin";
		if (isNil '_origin') then { _origin = objNull };
		{
			if (side _x == west) then {_sideLetter = "B"};
			if (side _x == east) then {_sideLetter = "O"};
			if (side _x == resistance) then {_sideLetter = "R"};
			if (side _x == civilian) then {_sideLetter = "C"};
			((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl 9170100) lbAdd format ["(%1) %2 (%3)",_sideLetter, groupID _x, if (isPlayer leader _x) then {name leader _x} else {"AI"}];
			if (group _origin == _x) then {if (_origin == leader _x) then {uiNamespace setVariable ["cti_dialog_ui_satcam_origin", nil]}; ((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl 9170100) lbSetCurSel _forEachIndex};
		} forEach _groups;
		
		if (isNil {uiNamespace getVariable "cti_dialog_ui_satcam_showgroups"}) then {uiNamespace setVariable ["cti_dialog_ui_satcam_showgroups", true]};
		if (uiNamespace getVariable "cti_dialog_ui_satcam_showgroups") then {
			((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl 9170007) ctrlSetText localize "STR_AZ_GroupsHide";
		} else {
			((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl 9170007) ctrlSetText localize "STR_AZ_GroupsShow";
			{((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl _x) ctrlShow false} forEach [9170002, 9170003, 9170004, 9170005, 9170006, 9170100, 9170101];
		};
		
		if (isNil {uiNamespace getVariable "cti_dialog_ui_satcam_showmap"}) then {uiNamespace setVariable ["cti_dialog_ui_satcam_showmap", true]};
		if (uiNamespace getVariable "cti_dialog_ui_satcam_showmap") then {
			((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl 9170008) ctrlSetText localize "STR_AZ_MapHide";
		} else {
			((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl 9170008) ctrlSetText localize "STR_AZ_MapShow";
			{((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl _x) ctrlShow false} forEach [9170009, 9170010];
		};
		
		["cti_dialog_ui_satcam", 9170017] call AZ_CL_FNC_ParseMatchInfo;
		
		if (isNil {uiNamespace getVariable "cti_dialog_ui_satcam_showinfo"}) then {uiNamespace setVariable ["cti_dialog_ui_satcam_showinfo", false]};
		if (uiNamespace getVariable "cti_dialog_ui_satcam_showinfo") then {
			((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl 9170015) ctrlSetText localize "STR_AZ_InfoHide";
		} else {
			((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl 9170015) ctrlSetText localize "STR_AZ_InfoShow";
			{((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl _x) ctrlShow false} forEach [9170016, 9170018];
		};
		
		//--- Render in. Where the bloody hell is the dialog option to render thing invisible at first? visible = 0 ?!?!
		{((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl _x) ctrlSetPosition [SafeZoneX + (SafeZoneW * 0.01), SafeZoneY + (SafezoneH * 0.06), SafeZoneW * 0.31, SafeZoneH * 0.6]; ((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl _x) ctrlCommit 0} forEach [9170016, 9170018];
		((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl 9170009) ctrlSetPosition [SafeZoneX + (SafeZoneW * 0.8), SafeZoneY + (SafezoneH * 0.62), SafeZoneW * 0.19, SafeZoneH * 0.32]; ((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl 9170009) ctrlCommit 0;
		((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl 9170010) ctrlSetPosition [SafeZoneX + (SafeZoneW * 0.805), SafeZoneY + (SafezoneH * 0.63), SafeZoneW * 0.18, SafeZoneH * 0.30]; ((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl 9170010) ctrlCommit 0;
		((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl 9170002) ctrlSetPosition [SafeZoneX + (SafeZoneW * 0.8), SafeZoneY + (SafezoneH * 0.06), SafeZoneW * 0.19, SafeZoneH * 0.55]; ((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl 9170002) ctrlCommit 0;
		((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl 9170003) ctrlSetPosition [SafeZoneX + (SafeZoneW * 0.805), SafeZoneY + (SafezoneH * 0.0605), SafeZoneW * 0.19, SafeZoneH * 0.03]; ((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl 9170003) ctrlCommit 0;
		{((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl _x) ctrlSetPosition [SafeZoneX + (SafeZoneW * 0.805), SafeZoneY + (SafeZoneH * 0.10), SafeZoneW * 0.18, SafeZoneH * 0.3]; ((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl _x) ctrlCommit 0} forEach [9170004, 9170100];
		((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl 9170005) ctrlSetPosition [SafeZoneX + (SafeZoneW * 0.805), SafeZoneY + (SafezoneH * 0.41), SafeZoneW * 0.19, SafeZoneH * 0.03]; ((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl 9170005) ctrlCommit 0;
		{((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl _x) ctrlSetPosition [SafeZoneX + (SafeZoneW * 0.805), SafeZoneY + (SafezoneH * 0.45), SafeZoneW * 0.18, SafeZoneH * 0.15]; ((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl _x) ctrlCommit 0} forEach [9170006, 9170101];
		
		if (isNil {uiNamespace getVariable "cti_dialog_ui_satcam_viewmode"}) then {uiNamespace setVariable ["cti_dialog_ui_satcam_viewmode", 0]};
		_mode = "Normal";
		switch (uiNamespace getVariable "cti_dialog_ui_satcam_viewmode") do {
			case 1: {_mode = "NVG"; camUseNVG true; false setCamUseTi 1;};
			case 2: {_mode = "Thermal"; camUseNVG false; true setCamUseTi 1;};
			default {_mode = "Normal"; camUseNVG false; false setCamUseTi 1;};
		};
		((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl 9170013) ctrlSetText _mode;
		
		if (ctrlText ((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl 9170011) == "") then { ((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl 9170011) ctrlSetText "Feed: No Target" };
		
		CTI_SatelitteCamera cameraEffect ["Internal", "back"];
		
		execVM "Client\GUI\GUI_SatelitteCamera.sqf";
	};
	case "onUnitsLBSelChanged": {
		_changeto = _this select 1;
	
		_group = (uiNamespace getVariable "cti_dialog_ui_satcam_groups") select _changeto;
		lbClear ((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl 9170101);
		
		_origin = uiNamespace getVariable "cti_dialog_ui_satcam_origin";
		if (isNil '_origin') then { _origin = objNull };
		
		//--- Load the AI Members
		_ais = (units _group - [leader _group]) call CTI_CO_FNC_GetLiveUnits;
		uiNamespace setVariable ["cti_dialog_ui_satcam_groups_ai", _ais];
		{
			((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl 9170101) lbAdd format["%1", _x];
			if (alive _origin && _x == _origin) then {((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl 9170101) lbSetCurSel _forEachIndex};
		} forEach (_ais);
		
		if !(isNil {uiNamespace getVariable "cti_dialog_ui_satcam_origin"}) then {
			uiNamespace setVariable ["cti_dialog_ui_satcam_origin", nil];
		} else {
			if !(isNull (uiNamespace getVariable "cti_dialog_ui_satcam_mapselect")) then {
				((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl 9170101) lbSetCurSel (_ais find (uiNamespace getVariable "cti_dialog_ui_satcam_mapselect"));
				uiNamespace setVariable ["cti_dialog_ui_satcam_mapselect", objNull];
			} else {
				if (alive leader _group) then {
					((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl 9170011) ctrlSetText format["Feed: %1", leader _group];
					uiNamespace setVariable ["cti_dialog_ui_satcam_focus", leader _group];
//					[leader _group, "cti_dialog_ui_satcam", 9170017] call CTI_UI_SatelitteCamera_LoadEntityInformation;
				};
			};
		};
	};
	case "onUnitsAILBSelChanged": {
		_changeto = _this select 1;
		
		if (_changeto > -1) then {
			_ai = (uiNamespace getVariable "cti_dialog_ui_satcam_groups_ai") select _changeto;
			if (alive _ai) then {
				uiNamespace setVariable ["cti_dialog_ui_satcam_focus", _ai];
				((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl 9170011) ctrlSetText format["Feed: %1", _ai];
//				[_ai, "cti_dialog_ui_satcam", 9170017] call CTI_UI_SatelitteCamera_LoadEntityInformation;
			};
		};
	};
	case "onToggleGroup": {
		_changeto = !(uiNamespace getVariable "cti_dialog_ui_satcam_showgroups");
		uiNamespace setVariable ["cti_dialog_ui_satcam_showgroups", _changeTo];
		
		if (_changeto) then {
			((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl 9170007) ctrlSetText "Hide Teams";
			{((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl _x) ctrlShow true} forEach [9170002, 9170003, 9170004, 9170005, 9170006, 9170100, 9170101];
		} else {
			((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl 9170007) ctrlSetText "Show Teams";
			{((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl _x) ctrlShow false} forEach [9170002, 9170003, 9170004, 9170005, 9170006, 9170100, 9170101];
		};
	};
	case "onToggleMap": {
		_changeto = !(uiNamespace getVariable "cti_dialog_ui_satcam_showmap");
		uiNamespace setVariable ["cti_dialog_ui_satcam_showmap", _changeTo];
		
		if (_changeto) then {
			((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl 9170008) ctrlSetText "Hide Map";
			{((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl _x) ctrlShow true} forEach [9170009, 9170010];
		} else {
			((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl 9170008) ctrlSetText "Show Map";
			{((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl _x) ctrlShow false} forEach [9170009, 9170010];
		};
	};
	case "onToggleInfo": {
		_changeto = !(uiNamespace getVariable "cti_dialog_ui_satcam_showinfo");
		uiNamespace setVariable ["cti_dialog_ui_satcam_showinfo", _changeTo];
		
		if (_changeto) then {
			((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl 9170015) ctrlSetText localize "STR_AZ_InfoHide";
			{((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl _x) ctrlShow true} forEach [9170016, 9170018];
		} else {
			((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl 9170015) ctrlSetText localize "STR_AZ_InfoShow";
			{((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl _x) ctrlShow false} forEach [9170016, 9170018];
		};
	};
	case "onViewModeChanged": {
		_mode = (uiNamespace getVariable "cti_dialog_ui_satcam_viewmode") + 1;
		if (_mode > 2) then { _mode = 0 };
		uiNamespace setVariable ["cti_dialog_ui_satcam_viewmode", _mode];
		switch (_mode) do { 
			case 1: {_mode = "NVG"; camUseNVG true; false setCamUseTi 1;};
			case 2: {_mode = "Thermal"; camUseNVG false; true setCamUseTi 1;};
			default {_mode = "Normal"; camUseNVG false; false setCamUseTi 1;};
		};
		((uiNamespace getVariable "cti_dialog_ui_satcam") displayCtrl 9170013) ctrlSetText _mode;
	};
	case "onUnitCameraJump": {
		_track = uiNamespace getVariable "cti_dialog_ui_satcam_focus";
		if (isNil '_track') then {_track = player};
		if !(isNil '_track') then {
			if (alive _track) then {
				titleCut["","BLACK IN",1];
				uiNamespace setVariable ["cti_dialog_ui_unitscam_origin", _track];
				closeDialog 0;
				createDialog "AZ_RscUnitsCamera";
			};
		};
	};
	case "onUnload": {
		CTI_SatelitteCamera cameraEffect["TERMINATE","BACK"];
		camDestroy CTI_SatelitteCamera;
		showCinemaBorder true;
	};
};