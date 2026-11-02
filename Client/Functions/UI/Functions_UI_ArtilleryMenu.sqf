CTI_UI_Artillery_GetTeamArtillery = {
	private ["_available", "_types", "_vehicles"];
	_available = [];

	_types = missionNamespace getVariable ["CTI_ARTILLERY", []];
	_vehicles = [group player, true] call CTI_CO_FNC_GetTeamVehicles;

	{if (typeOf _x in _types) then {_available pushBack _x}} forEach _vehicles;

	_available
};

CTI_UI_Artillery_GetText = {
	private ["_artillery", "_get", "_kind", "_processed", "_texts"];

	_artillery = _this;

	_processed = [];
	_texts = [];

	{
		_kind = typeOf _x;
		if !(_kind in _processed) then {
			_get = missionNamespace getVariable format ["CTI_ARTILLERY_%1", _kind];

			if !(isNil '_get') then {
				_texts pushBack [_get select 0, _kind];
			};

			_processed pushBack _kind;
		};
	} forEach _artillery;

	_texts
};

CTI_UI_Artillery_GetGivenTeamArtillery = {
	private ["_artillery", "_available", "_type"];
	_type = _this;

	_available = [];
	_artillery = call CTI_UI_Artillery_GetTeamArtillery;

	{if (typeOf _x == _type) then {_available pushBack _x}} forEach _artillery;
	_available
};

CTI_UI_Artillery_CanFire = {
	private ["_artillery", "_magazine", "_range_min", "_range_max", "_target"];
	_artillery = _this select 0;
	_magazine = _this select 1;
	_target = _this select 2;
	_range_min = _this select 3;
	_range_max = _this select 4;

	if (_target inRangeOfArtillery [[_artillery], _magazine] && _target distance _artillery >= _range_min && _target distance _artillery <= _range_max) then {true} else {false}
};

CTI_UI_Artillery_GetArtilleryRange = {
    params ["_ranges"];

    if (isNil "_ranges") exitWith {
        diag_log "ARTY ERROR: _ranges = NIL";
        [0,0]
    };

    if ((count _ranges) == 0) exitWith {
        diag_log "ARTY ERROR: empty range array";
        [0,0]
    };

    private _setup = missionNamespace getVariable ["CTI_ARTILLERY_SETUP",0];

    if (_setup < 0) then {_setup = 0};

    if (_setup >= count _ranges) then {
        diag_log format [
            "ARTY ERROR: setup=%1 count=%2",
            _setup,
            count _ranges
        ];

        _setup = (count _ranges) - 1;
    };

    _ranges select _setup
};

CTI_UI_Artillery_CreateArtilleryTargetMarker = {
	private ["_marker", "_position"];
	_position = _this;

	_marker = createMarkerLocal ["CTI_MarkerArtillery", _position];
	_marker setMarkerTypeLocal "mil_destroy";
	_marker setMarkerColorLocal "ColorBlack";
	_marker setMarkerSizeLocal [0.75, 0.75];
	uiNamespace setVariable ["cti_dialog_ui_artillerymenu_marker", _marker];
};

CTI_UI_Artillery_CreateArtilleryMarker = {
	private ["_artillery", "_marker_max", "_marker_min", "_range_max", "_range_min"];

	_artillery = _this select 0;
	_range_min = _this select 1;
	_range_max = _this select 2;

	_marker_min = createMarkerLocal [Format ["cti_artillery_%1", CTI_P_MarkerIterator], getPos _artillery];CTI_P_MarkerIterator = CTI_P_MarkerIterator + 1;
	_marker_min setMarkerAlphaLocal 0;
	_marker_min setMarkerColorLocal "ColorBlack";
	_marker_min setMarkerShapeLocal "ELLIPSE";
	_marker_min setMarkerBrushLocal "SOLID";
	_marker_min setMarkerSizeLocal [_range_min, _range_min];

	_marker_max = createMarkerLocal [Format ["cti_artillery_%1", CTI_P_MarkerIterator], getPos _artillery];CTI_P_MarkerIterator = CTI_P_MarkerIterator + 1;
	_marker_max setMarkerAlphaLocal 0;
	_marker_max setMarkerColorLocal "ColorBlack";
	_marker_max setMarkerShapeLocal "ELLIPSE";
	_marker_max setMarkerBrushLocal "BORDER";
	_marker_max setMarkerSizeLocal [_range_max, _range_max];

	[_marker_min, _marker_max]
};

CTI_UI_Artillery_UpdateArtilleryMarker = {
	private ["_artillery", "_marker_max", "_marker_min", "_markers"];

	_artillery = _this select 0;
	_markers = _this select 1;

	_marker_min = _markers select 0;
	_marker_max = _markers select 1;

	while {alive _artillery} do {
		{_x setMarkerPosLocal getPos _artillery} forEach [_marker_min, _marker_max];
	};

	{deleteMarkerLocal _x} forEach [_marker_min, _marker_max];
};

CTI_UI_Artillery_GetSelectedArtilleryArray = {
	private ["_artillery_array", "_return"];
	_artillery_array = _this;

	_return = [];
	{_return pushBack  (_artillery_array select _x)} forEach (lbSelection ((uiNamespace getVariable "cti_dialog_ui_artillerymenu") displayCtrl 290014));

	_return
};

// ============================================
// ОБНОВЛЕНИЕ GUI (ТОЛЬКО БОЕПРИПАСЫ В СПИСКЕ)
// ============================================
CTI_UI_Artillery_UpdateInfoDisplay = {
    params ["_display", "_magInfo"];
    
    if (isNull _display) exitWith {};
    
    if (typeName _magInfo != "ARRAY") then {
        diag_log format ["[ARTILLERY ERROR] _magInfo is not array: %1", _magInfo];
        _magInfo = [0, 0, 0, 0, 0];
    };
    
    private _current = 0;
    private _total = 0;
    private _flightTime = 0;
    private _dispersion = 0;
    private _reloadTime = 0;
    
    if (count _magInfo >= 5) then {
        _current = _magInfo select 0;
        _total = _magInfo select 1;
        _flightTime = _magInfo select 2;
        _dispersion = _magInfo select 3;
        _reloadTime = _magInfo select 4;
    };
    
    // Отдельный блок боеприпасов УДАЛЕН — информация только в списке орудий
};

// ============================================
// ФУНКЦИЯ ОБНОВЛЕНИЯ ВРЕМЕНИ ПОЛЕТА И РАЗБРОСА
// ============================================
CTI_UI_Artillery_UpdateFlightInfo = {
    params ["_targetPos"];
    
    private _display = uiNamespace getVariable ["cti_dialog_ui_artillerymenu", displayNull];
    if (isNull _display) exitWith {};
    
    private _magazine = uiNamespace getVariable ["cti_dialog_ui_artillerymenu_artillery_magazine", ""];
    if (_magazine == "") exitWith {};
    
    private _artilleryArray = uiNamespace getVariable ["cti_dialog_ui_artillerymenu_artillery", []];
    if (count _artilleryArray == 0) exitWith {};
    
    private _piece = (_artilleryArray select 0) select 0;
    if (isNull _piece) exitWith {};
    
    private _pos = getPos _piece;
    private _distance = _pos distance _targetPos;
    private _dir = _pos getDir _targetPos;
    
    private _magInfo = uiNamespace getVariable ["cti_dialog_ui_artillerymenu_artillery_info", []];
    private _flightTime = 0;
    private _dispersion = 0;
    
    if (count _magInfo >= 5) then {
        _flightTime = _magInfo select 2;
        _dispersion = _magInfo select 3;
    };
    
    private _realFlightTime = _flightTime * (_distance / 10000);
    if (_realFlightTime < 1) then { _realFlightTime = 1 };
    
    // Расчет разброса
    private _weapons = getArray (configFile >> "CfgVehicles" >> typeOf _piece >> "weapons");
    private _dispersionWeapon = 0.001;
    if (count _weapons > 0) then {
        _dispersionWeapon = getNumber (configFile >> "CfgWeapons" >> (_weapons select 0) >> "dispersion");
    };
    if (_dispersionWeapon == 0) then { _dispersionWeapon = 0.001 };
    
    private _ammoClass = getText (configFile >> "CfgMagazines" >> _magazine >> "ammo");
    private _dispersionAmmo = 0.001;
    if (_ammoClass != "") then {
        _dispersionAmmo = getNumber (configFile >> "CfgAmmo" >> _ammoClass >> "dispersion");
    };
    if (_dispersionAmmo == 0) then { _dispersionAmmo = 0.001 };
    
    private _totalDispersion = _dispersionWeapon + _dispersionAmmo;
    
    private _baseFactor = 1.5;
    private _vehicleType = typeOf _piece;
    if (_vehicleType find "Mortar" != -1) then { _baseFactor = 3.0 };
    if (_vehicleType find "MLRS" != -1) then { _baseFactor = 4.0 };
    if (_vehicleType find "MBT_01_arty" != -1) then { _baseFactor = 2.5 };
    if (_vehicleType find "MBT_02_arty" != -1) then { _baseFactor = 2.5 };
    
    private _cep = (_totalDispersion * _distance) * _baseFactor;
    
    private _ammoFactor = 1.0;
    if (_ammoClass find "guided" != -1) then { _ammoFactor = 0.4 };
    if (_ammoClass find "Cluster" != -1) then { _ammoFactor = 2.0 };
    if (_ammoClass find "AT_mine" != -1) then { _ammoFactor = 1.8 };
    if (_ammoClass find "smoke" != -1) then { _ammoFactor = 1.3 };
    if (_ammoClass find "Flare" != -1) then { _ammoFactor = 1.5 };
    if (_ammoClass find "LG" != -1) then { _ammoFactor = 0.8 };
    
    private _distanceFactor = 1 + (_distance / 8000);
    private _finalDispersion = _cep * _ammoFactor * _distanceFactor;
    
    private _minDispersion = 15;
    private _maxDispersion = 600;
    if (_ammoClass find "guided" != -1) then { _minDispersion = 8 };
    if (_ammoClass find "LG" != -1) then { _minDispersion = 8 };
    if (_vehicleType find "Mortar" != -1) then { _minDispersion = 20 };
    if (_vehicleType find "MLRS" != -1) then { _minDispersion = 30 };
    
    private _baseDispersion = round _finalDispersion;
    if (_baseDispersion < _minDispersion) then { _baseDispersion = _minDispersion };
    if (_baseDispersion > _maxDispersion) then { _baseDispersion = _maxDispersion };
    
    private _dispersionLong = _baseDispersion * 1.3;
    private _dispersionShort = _baseDispersion * 0.7;
    
    private _ctrlFlight = _display displayCtrl 290103;
    if (!isNull _ctrlFlight) then {
        _ctrlFlight ctrlSetText format ["Время полета: %1 сек", round _realFlightTime];
    };
    
    private _ctrlDispersion = _display displayCtrl 290105;
    if (!isNull _ctrlDispersion) then {
        private _avgDispersion = round ((_dispersionLong + _dispersionShort) / 2);
        _ctrlDispersion ctrlSetText format ["Разброс: %1 м", _avgDispersion];
    };
    
    private _dispersionMarker = uiNamespace getVariable ["cti_dialog_ui_artillerymenu_dispersion_marker", ""];
    if (_dispersionMarker == "") then {
        _dispersionMarker = createMarkerLocal ["CTI_MarkerDispersion", _targetPos];
        _dispersionMarker setMarkerShapeLocal "ELLIPSE";
        _dispersionMarker setMarkerBrushLocal "BORDER";
        _dispersionMarker setMarkerColorLocal "ColorRed";
        _dispersionMarker setMarkerAlphaLocal 0.6;
        _dispersionMarker setMarkerSizeLocal [_dispersionLong, _dispersionShort];
        _dispersionMarker setMarkerDirLocal _dir;
        uiNamespace setVariable ["cti_dialog_ui_artillerymenu_dispersion_marker", _dispersionMarker];
    } else {
        _dispersionMarker setMarkerPosLocal _targetPos;
        _dispersionMarker setMarkerSizeLocal [_dispersionLong, _dispersionShort];
        _dispersionMarker setMarkerDirLocal _dir;
    };
    
    diag_log format ["[ARTILLERY] Flight info: distance=%1, flightTime=%2, dispersion=%3/%4 (dir=%5)", 
        round _distance, round _realFlightTime, round _dispersionLong, round _dispersionShort, round _dir];
};

// ============================================
// ФУНКЦИЯ ВЫБОРА СНАРЯДА
// ============================================
CTI_UI_Artillery_SelectMagazine = {
    params ["_magazineClass", "_magIndex"];
    
    if (_magazineClass == "") exitWith {};
    
    uiNamespace setVariable ["cti_dialog_ui_artillerymenu_artillery_magazine", _magazineClass];
    
    private _display = uiNamespace getVariable ["cti_dialog_ui_artillerymenu", displayNull];
    if (isNull _display) exitWith {};
    
    private _ranges = uiNamespace getVariable ["cti_dialog_ui_artillerymenu_artillery_ranges", []];
    private _dataArray = uiNamespace getVariable ["cti_dialog_ui_artillerymenu_artillery_data", []];
    
    if (count _ranges > _magIndex) then {
        uiNamespace setVariable ["cti_dialog_ui_artillerymenu_artillery_range", _ranges select _magIndex];
    };
    
    private _magData = [];
    if (count _dataArray > _magIndex) then {
        _magData = _dataArray select _magIndex;
    };
    
    private _magInfo = [_magazineClass, _magData] call CTI_CO_FNC_GetMagazineInfo;
    uiNamespace setVariable ["cti_dialog_ui_artillerymenu_artillery_info", _magInfo];
    
    [] call CTI_UI_Artillery_RefreshInfo;
};

// ============================================
// ОБНОВЛЕНИЕ ИНФОРМАЦИИ (БОЕПРИПАСЫ)
// ============================================
CTI_UI_Artillery_RefreshInfo = {
    private _display = uiNamespace getVariable ["cti_dialog_ui_artillerymenu", displayNull];
    if (isNull _display) exitWith {
        diag_log "[ARTILLERY] RefreshInfo: display is null";
    };
    
    private _magazine = uiNamespace getVariable ["cti_dialog_ui_artillerymenu_artillery_magazine", ""];
    if (_magazine == "") exitWith {
        diag_log "[ARTILLERY] RefreshInfo: magazine is empty";
    };
    
    private _dataArray = uiNamespace getVariable ["cti_dialog_ui_artillerymenu_artillery_data", []];
    private _magIndex = lbCurSel 290009;
    if (_magIndex < 0) then { _magIndex = 0 };
    
    private _magData = [];
    if (count _dataArray > _magIndex) then {
        _magData = _dataArray select _magIndex;
    };
    
    diag_log format ["[ARTILLERY] RefreshInfo: magazine=%1, index=%2", _magazine, _magIndex];
    
    private _maxCount = getNumber(configFile >> "CfgMagazines" >> _magazine >> "count");
    if (_maxCount == 0) then { _maxCount = 32 };
    
    private _current = 0;
    private _found = false;
    
    private _artilleryArray = uiNamespace getVariable ["cti_dialog_ui_artillerymenu_artillery", []];
    diag_log format ["[ARTILLERY] Artillery array count: %1", count _artilleryArray];
    
    {
        private _piece = _x select 0;
        if (!isNull _piece && alive _piece) then {
            private _mags = magazinesAmmo _piece;
            diag_log format ["[ARTILLERY] Checking %1, magazines: %2", typeOf _piece, count _mags];
            {
                if ((_x select 0) == _magazine) then {
                    _current = _current + (_x select 1);
                    _found = true;
                    diag_log format ["[ARTILLERY] Found %1 in artillery %2: %3/%4", 
                        _magazine, typeOf _piece, _current, _maxCount];
                };
            } forEach _mags;
        };
    } forEach _artilleryArray;
    
    if (!_found) then {
        diag_log format ["[ARTILLERY] Magazine %1 not found, ammo = 0", _magazine];
        _current = 0;
    };
    
    private _flightTime = 0;
    private _dispersion = 0;
    private _reloadTime = 0;
    
    if (count _magData >= 3) then {
        _flightTime = _magData select 0;
        _dispersion = _magData select 1;
        _reloadTime = _magData select 2;
    } else {
        if (_magazine find "155mm" != -1) then {
            _flightTime = 30; _dispersion = 25; _reloadTime = 10;
        } else {
            if (_magazine find "82mm" != -1) then {
                _flightTime = 12; _dispersion = 15; _reloadTime = 8;
            } else {
                if (_magazine find "230mm" != -1) then {
                    _flightTime = 20; _dispersion = 35; _reloadTime = 15;
                } else {
                    _flightTime = 20; _dispersion = 20; _reloadTime = 10;
                };
            };
        };
    };
    
    private _magInfo = [_current, _maxCount, _flightTime, _dispersion, _reloadTime];
    uiNamespace setVariable ["cti_dialog_ui_artillerymenu_artillery_info", _magInfo];
    
    diag_log format ["[ARTILLERY] RefreshInfo: magInfo=[%1,%2] (found: %3)", _current, _maxCount, _found];
    
    // ============================================
    // ОБНОВЛЯЕМ СПИСОК ОРУДИЙ С БОЕПРИПАСАМИ
    // ============================================
    if (count _artilleryArray > 0) then {
        private _ctrlList = _display displayCtrl 290014;
        if (!isNull _ctrlList) then {
            private _magazineLocal = _magazine;
            
            for "_i" from 0 to (lbSize _ctrlList - 1) do {
                private _piece = _artilleryArray select _i select 0;
                private _ammoCount = 0;
                private _maxCountLocal = 0;
                
                if (!isNull _piece && alive _piece && _magazineLocal != "") then {
                    private _mags = magazinesAmmo _piece;
                    {
                        if ((_x select 0) == _magazineLocal) then {
                            _ammoCount = _ammoCount + (_x select 1);
                            _maxCountLocal = getNumber(configFile >> "CfgMagazines" >> _magazineLocal >> "count");
                            if (_maxCountLocal == 0) then { _maxCountLocal = 32 };
                        };
                    } forEach _mags;
                    
                    if (_ammoCount == 0 && {count _mags == 0}) then {
                        _maxCountLocal = getNumber(configFile >> "CfgMagazines" >> _magazineLocal >> "count");
                        if (_maxCountLocal == 0) then { _maxCountLocal = 32 };
                    };
                };
                
                private _displayName = getText(configFile >> "CfgVehicles" >> typeOf _piece >> "displayName");
                private _newText = format ["[%1] - %2 (%3/%4)", 
                    _piece call CTI_CL_FNC_GetAIDigit,
                    _displayName,
                    _ammoCount,
                    _maxCountLocal
                ];
                
                _ctrlList lbSetText [_i, _newText];
                
                if (_ammoCount <= 0) then {
                    _ctrlList lbSetColor [_i, [0.5, 0.5, 0.5, 1]];
                } else {
                    _ctrlList lbSetColor [_i, [1, 1, 1, 1]];
                };
            };
        };
    };
};

// ============================================
// ЦИКЛ ОБНОВЛЕНИЯ
// ============================================
CTI_UI_Artillery_UpdateLoop = {
    private _display = uiNamespace getVariable ["cti_dialog_ui_artillerymenu", displayNull];
    if (isNull _display) exitWith {};
    
    diag_log "[ARTILLERY] UpdateLoop started";
    
    while {!isNull _display} do {
        sleep 2;
        [] call CTI_UI_Artillery_RefreshInfo;
    };
    
    diag_log "[ARTILLERY] UpdateLoop ended";
};

// ============================================
// ФОРСИРОВАННОЕ ОБНОВЛЕНИЕ
// ============================================
CTI_UI_Artillery_ForceRefreshAmmo = {
    private _display = uiNamespace getVariable ["cti_dialog_ui_artillerymenu", displayNull];
    if (isNull _display) exitWith {};
    
    private _magazine = uiNamespace getVariable ["cti_dialog_ui_artillerymenu_artillery_magazine", ""];
    if (_magazine == "") exitWith {};
    
    [] call CTI_UI_Artillery_RefreshInfo;
    
    diag_log "[ARTILLERY] Force refresh ammo called";
};