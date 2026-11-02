/* STREAMING_CHUNK: Initializing main handler and display reference */
params ["_action"];
private _display = uiNamespace getVariable ["cti_dialog_ui_artillerymenu", displayNull];

switch (_action) do {
    case "onLoad": {
        /* STREAMING_CHUNK: Handling dialog initialization and safety checks */
        if (isNil "CTI_ARTILLERY_SETUP" || {CTI_ARTILLERY_SETUP < 0}) exitWith {closeDialog 0};
        if (isNull _display) exitWith {};
        
        private _ctrlFire = _display displayCtrl 290015;
        _ctrlFire ctrlSetPosition [SafeZoneX + (SafeZoneW * 0.785), SafeZoneY + (SafezoneH * 0.69), SafeZoneW * 0.2, SafeZoneH * 0.04]; 
        _ctrlFire ctrlCommit 0;
        
        private _canFire = time - CTI_P_LastFireMission > CTI_ARTILLERY_TIMEOUT;
        _ctrlFire ctrlEnable _canFire;

        private _artillery = call CTI_UI_Artillery_GetTeamArtillery;
        uiNamespace setVariable ["cti_dialog_ui_artillerymenu_marker", ""];
        uiNamespace setVariable ["cti_dialog_ui_artillerymenu_artillery", []];
        uiNamespace setVariable ["cti_dialog_ui_artillerymenu_artillery_magazine", ""];
        uiNamespace setVariable ["cti_dialog_ui_artillerymenu_artillery_range", -1];
        uiNamespace setVariable ["cti_dialog_ui_artillerymenu_artillery_ranges", []];
        uiNamespace setVariable ["cti_dialog_ui_artillerymenu_artillery_data", []];
        uiNamespace setVariable ["cti_dialog_ui_artillerymenu_artillery_info", []];
        uiNamespace setVariable ["cti_dialog_ui_artillerymenu_last_update", 0];

        private _marker_last = uiNamespace getVariable "cti_dialog_ui_artillerymenu_marker_lastcoord";
        if (!isNil '_marker_last') then {(_marker_last) call CTI_UI_Artillery_CreateArtilleryTargetMarker};

        if (count _artillery > 0) then {
            private _types = (_artillery) call CTI_UI_Artillery_GetText;
            private _ctrlCombo = _display displayCtrl 290007;
            {
                private _index = _ctrlCombo lbAdd (_x select 0);
                _ctrlCombo lbSetData [_index, _x select 1];
            } forEach _types;

            lbSort _ctrlCombo;
            if (count _types > 0) then {
                _ctrlCombo lbSetCurSel 0;
                private _firstData = _ctrlCombo lbData 0;
                if (_firstData != "") then {
                    ["onArtilleryTypeChanged", 0] call compile preprocessFileLineNumbers 'Client\Events\Events_UI_ArtilleryMenu.sqf';
                };
            };
        };
        execVM "Client\GUI\GUI_ArtilleryMenu.sqf";
        
        [] spawn CTI_UI_Artillery_UpdateLoop;
    };

    case "onArtilleryTypeChanged": {
        private _oldDispersionMarker = uiNamespace getVariable ["cti_dialog_ui_artillerymenu_dispersion_marker", ""];
        if (_oldDispersionMarker != "") then { 
            deleteMarkerLocal _oldDispersionMarker; 
            uiNamespace setVariable ["cti_dialog_ui_artillerymenu_dispersion_marker", ""];
        };
        
        private _selected = _this select 1;
        if (_selected > -1 && !isNull _display) then {
            private _selectedClass = (_display displayCtrl 290007) lbData _selected;
            lbClear (_display displayCtrl 290009);
            lbClear (_display displayCtrl 290011);

            private _get = missionNamespace getVariable [format ["CTI_ARTILLERY_%1", _selectedClass], []];
            
            {
                if !(scriptDone (_x select 2)) then {terminate (_x select 2)};
                {deleteMarkerLocal _x} forEach (_x select 1);
            } forEach (uiNamespace getVariable ["cti_dialog_ui_artillerymenu_artillery", []]);

            if (count _get >= 6) then {
                private _magazines_labels = _get select 1;
                private _magazines = _get select 2;
                private _ranges = _get select 4; 
                private _data = _get select 5;
                
                uiNamespace setVariable ["cti_dialog_ui_artillerymenu_artillery_ranges", _ranges];
                uiNamespace setVariable ["cti_dialog_ui_artillerymenu_artillery_data", _data];
                uiNamespace setVariable ["cti_dialog_ui_artillerymenu_artillery_range", _ranges select 0];
                
                private _ctrlMags = _display displayCtrl 290009;
                for '_i' from 0 to count(_magazines)-1 do {
                    private _idx = _ctrlMags lbAdd (_magazines_labels select _i);
                    _ctrlMags lbSetData [_idx, _magazines select _i];
                    _ctrlMags lbSetValue [_idx, _i]; 
                };
                if (count _magazines > 0) then {
                    _ctrlMags lbSetCurSel 0;
                    [_ctrlMags lbData 0, 0] call CTI_UI_Artillery_SelectMagazine;
                };

                private _ctrlBurst = _display displayCtrl 290011;
                {
                    private _idx = _ctrlBurst lbAdd str _x;
                    _ctrlBurst lbSetValue [_idx, _x];
                } forEach (_get select 3);
                if (count (_get select 3) > 0) then {_ctrlBurst lbSetCurSel 0};

                private _artillery = (_selectedClass) call CTI_UI_Artillery_GetGivenTeamArtillery;
                private _artillery_array = [];
                lbClear (_display displayCtrl 290014);
                
                {
                    private _piece = _x;
                    private _ammoCount = 0;
                    private _maxCount = 0;
                    
                    private _magazine = uiNamespace getVariable ["cti_dialog_ui_artillerymenu_artillery_magazine", ""];
                    if (_magazine != "") then {
                        private _mags = magazinesAmmo _piece;
                        {
                            if ((_x select 0) == _magazine) then {
                                _ammoCount = _ammoCount + (_x select 1);
                                _maxCount = getNumber(configFile >> "CfgMagazines" >> _magazine >> "count");
                                if (_maxCount == 0) then { _maxCount = 32 };
                            };
                        } forEach _mags;
                        
                        if (_ammoCount == 0 && {count _mags == 0}) then {
                            _maxCount = getNumber(configFile >> "CfgMagazines" >> _magazine >> "count");
                            if (_maxCount == 0) then { _maxCount = 32 };
                        };
                    };
                    
                    private _displayName = _get select 0;
                    private _rowText = format ["[%1] - %2 (%3/%4)", 
                        _x call CTI_CL_FNC_GetAIDigit, 
                        _displayName,
                        _ammoCount,
                        _maxCount
                    ];
                    
                    private _row = (_display displayCtrl 290014) lbAdd _rowText;
                    
                    if (_ammoCount <= 0) then {
                        (_display displayCtrl 290014) lbSetColor [_row, [0.5, 0.5, 0.5, 1]];
                    };
                    
                    private _markers = [_x, (_ranges select 0) select 0, (_ranges select 0) select 1] call CTI_UI_Artillery_CreateArtilleryMarker;
                    private _thread = [_x, _markers] spawn CTI_UI_Artillery_UpdateArtilleryMarker;
                    _artillery_array pushBack [_x, _markers, _thread];
                } forEach _artillery;
                
                uiNamespace setVariable ["cti_dialog_ui_artillerymenu_artillery", _artillery_array];
                
                // Принудительно обновляем список с боеприпасами
                [] spawn {
                    sleep 0.5;
                    [] call CTI_UI_Artillery_RefreshInfo;
                };
            };
        };
    };

    case "onArtilleryMagazineChanged": {
        private _selected = _this select 1;
        if (_selected > -1 && !isNull _display) then {
            private _ctrlMags = _display displayCtrl 290009;
            private _data = _ctrlMags lbData _selected;
            private _magIndex = _ctrlMags lbValue _selected;
            
            [_data, _magIndex] call CTI_UI_Artillery_SelectMagazine;
        };
    };

    case "onMapButtonDown": {
        private _event = _this select 1;
        if ((_event select 1) == 0 && !isNull _display) then {
            private _mappos = (_display displayCtrl 290001) ctrlMapScreenToWorld [(_event select 2), (_event select 3)];
            private _marker = uiNamespace getVariable ["cti_dialog_ui_artillerymenu_marker", ""];
            if (_marker == "") then {(_mappos) call CTI_UI_Artillery_CreateArtilleryTargetMarker};
            _marker setMarkerPosLocal _mappos;
        };
    };

    case "onFireMissionCall": {
        private _artillery = uiNamespace getVariable ["cti_dialog_ui_artillerymenu_artillery", []];
        private _artillery_marker = uiNamespace getVariable ["cti_dialog_ui_artillerymenu_marker", ""];
        private _artillery_magazine = uiNamespace getVariable ["cti_dialog_ui_artillerymenu_artillery_magazine", ""];
        private _artillery_range = uiNamespace getVariable ["cti_dialog_ui_artillerymenu_artillery_range", []];

        if (_artillery_magazine != "" && _artillery_marker != "" && time - CTI_P_LastFireMission > CTI_ARTILLERY_TIMEOUT) then {
            _artillery = (_artillery) call CTI_UI_Artillery_GetSelectedArtilleryArray;
            if (count _artillery > 0) then {
                private _artillery_burst = (_display displayCtrl 290011) lbValue (lbCurSel 290011);
                private _target = getMarkerPos _artillery_marker;
                {
                    private _piece = _x select 0;
                    if (alive _piece && ([_piece, _artillery_magazine, _target, _artillery_range select 0, _artillery_range select 1] call CTI_UI_Artillery_CanFire)) then {
                        [_piece, _target, _artillery_magazine, _artillery_burst, _artillery_range select 0, _artillery_range select 1] spawn CTI_UI_Artillery_BurstFire;
                    };
                } forEach _artillery;
                CTI_P_LastFireMission = time;
                
                [] spawn {
                    sleep 2;
                    [] call CTI_UI_Artillery_RefreshInfo;
                    sleep 3;
                    [] call CTI_UI_Artillery_RefreshInfo;
                };
            };
        };
    };

    case "onUnload": {
        {
            if !(scriptDone (_x select 2)) then {terminate (_x select 2)};
            {deleteMarkerLocal _x} forEach (_x select 1);
        } forEach (uiNamespace getVariable ["cti_dialog_ui_artillerymenu_artillery", []]);
        
        private _marker = uiNamespace getVariable ["cti_dialog_ui_artillerymenu_marker", ""];
        if (_marker != "") then { deleteMarkerLocal _marker; };
        
        private _dispersionMarker = uiNamespace getVariable ["cti_dialog_ui_artillerymenu_dispersion_marker", ""];
        if (_dispersionMarker != "") then { deleteMarkerLocal _dispersionMarker; };
    };
};