private ["_sideID", "_town", "_town_name", "_town_side", "_town_value"];
waitUntil {! isnil "CTI_InitTowns"};
waitUntil {CTI_InitTowns};
_town = _this select 0;
_town_name = _this select 1;
_town_side = _this select 2;
_town_value = if (count _this > 3) then {_this select 3} else {100};

// ============================================================
// АВТОИМЯ: если имя не передано или пустое — берём из карты
// Работает для новых городов: nullReturn = [this] execVM "..."
// или: nullReturn = [this, "", resistance, 200] execVM "..."
// ============================================================
if (_town_name == "" || isNil "_town_name") then {
    // Перебираем все типы локаций от крупных к мелким
    private _loc = objNull;
    private _locTypes = ["nameCityCapital", "nameCity", "nameVillage", "nameLocal"];
    private _bestDist = 1000;  // ищем в радиусе 1000м

    {
        private _candidate = nearestLocation [getPos _town, _x];
        if (!isNull _candidate) then {
            private _dist = (getPos _town) distance (locationPosition _candidate);
            if (_dist < _bestDist) then {
                _bestDist = _dist;
                _loc = _candidate;
            };
        };
    } forEach _locTypes;

    // Если нашли локацию — берём её имя
    if (!isNull _loc) then {
        _town_name = name _loc;
    } else {
        // Ничего не нашли в радиусе — используем координаты
        private _pos = getPos _town;
        _town_name = format ["[%1, %2]", round (_pos select 0), round (_pos select 1)];
    };

    diag_log format ["[CTI_LINK] Autoname: %1 (dist: %2m)", _town_name, round _bestDist];
};

_CENTER_POS=getMarkerPos "CENTER_POS";
_CENTER_RADIUS=(getMarkerSize "CENTER_POS")select 0;

if ((_town distance _CENTER_POS)>_CENTER_RADIUS) exitwith {true};

if (count _this > 4) then {
	_forced_neigh= _this select 4;
	_town setVariable ["cti_town_fneigh", _forced_neigh];
};
_town setVariable ["cti_town_name", _town_name];

waitUntil {!isNil 'CTI_Init_JIP' && !isNil 'CTI_Init_Common'};

_sideID = _town_side call CTI_CO_FNC_GetSideID;
if (CTI_IsServer || CTI_IsHeadless) then {
	if CTI_IsServer then {
		_town setVariable ["cti_town_owner", "0", true];
		_town setVariable ["cti_town_sideID", _sideID, true];
		_town setVariable ["cti_town_lastSideID", _sideID, true];
		_town setVariable ["cti_town_value", _town_value, true];
		_town setVariable ["cti_structure_type",CTI_FTOWN,true];

		// Создаём флагшток если объект Logic (новые города)
		// Для FlagPole_F используем сам объект
		if !((typeOf _town) == "FlagPole_F") then {
			private _flag = createVehicle ["FlagPole_F", getPosATL _town, [], 0, "CAN_COLLIDE"];
			_flag setPosATL [getPosATL _flag select 0, getPosATL _flag select 1, 0];
			_flag allowDamage false;
			_town setVariable ["cti_town_flag", _flag, true];
		} else {
			_town setVariable ["cti_town_flag", _town, true];
		};

		_current_side = _sideID call CTI_CO_FNC_GetSideFromID;
		(_town getVariable ["cti_town_flag", _town]) setFlagTexture (_current_side call CTI_CO_FNC_GetSideFlag);

		// ============================================================
		// СОСЕДИ ИЗ РЕДАКТОРА
		// Читаем synchronizedObjects для ВСЕХ городов.
		// Если в редакторе есть линия — добавляем к существующим соседям.
		// Работает и для старых FlagPole городов и для новых Logic городов.
		// ============================================================
		[_town] spawn {
			private _t = _this select 0;

			// Ждём SM_MAP_READY (таймаут 30 сек на случай если стратрежим выключен)
			private _t0 = time;
			waitUntil {
				missionNamespace getVariable ["SM_MAP_READY", false] || (time - _t0 > 30)
			};
			sleep 1;

				// [Стр. 94] Самодобавление в CTI_Towns
				// Если этот город не попал в список при старте — добавляем себя
				if !(_t in CTI_Towns) then {
					CTI_Towns pushBack _t;
					diag_log format ["[CTI] %1 самодобавился в CTI_Towns",
						_t getVariable ["cti_town_name", str _t]
					];
				};

			// Читаем линии синхронизации из Eden Editor
			private _synced = synchronizedObjects _t;

			// Фильтр: только города и не сам себя
			private _fromEditor = _synced select {
				!isNil {_x getVariable "cti_town_name"} && _x != _t
			};

			// Если линии есть — дополняем список соседей без дублей
			if (count _fromEditor > 0) then {
				private _existing = _t getVariable ["CTI_Neigh", []];
				{
					if !(_x in _existing) then { _existing pushBack _x };
				} forEach _fromEditor;
				_t setVariable ["CTI_Neigh", _existing, true];

				diag_log format ["[CTI_LINK] %1 +editor-> [%2]",
					_t getVariable ["cti_town_name", str _t],
					(_fromEditor apply {_x getVariable ["cti_town_name","?"]}) joinString ", "
				];
			};
		};

		(_town) execFSM "Addons\Strat_mode\FSM\town_capture.fsm";
	};
	(_town) execFSM "Addons\Strat_mode\FSM\town_resistance.fsm";
	if (missionNamespace getVariable "CTI_TOWNS_OCCUPATION" > 0) then {
		(_town) execFSM "Addons\Strat_mode\FSM\town_occupation.fsm";
	};
};

if (CTI_IsClient) then {
	waitUntil {CTI_Init_Client};
	waitUntil {!(isNil {_town getVariable "cti_town_sideID"}) && !(isNil {_town getVariable "cti_town_lastSideID"})};

	_current_side = (_town getVariable "cti_town_sideID") call CTI_CO_FNC_GetSideFromID;
	_coloration = CTI_RESISTANCE_COLOR;

	if (CTI_P_SideID in [_town getVariable "cti_town_lastSideID", _town getVariable "cti_town_sideID"]
		&& !(CTI_P_SideJoined == resistance)) then {
		_coloration = _current_side call CTI_CO_FNC_GetSideColoration;
	};

	_marker = createMarkerLocal [format ["cti_town_areaMarker_%1", _town], getPos _town];
	_marker setMarkerShapeLocal "ELLIPSE";
	_marker setMarkerBrushLocal "SolidBorder";
	_marker setMarkerSizeLocal [CTI_MARKERS_TOWN_AREA_RANGE, CTI_MARKERS_TOWN_AREA_RANGE];
	_marker setMarkerColorLocal _coloration;
	_marker setMarkerAlphaLocal 0;

	_marker = createMarkerLocal [format ["cti_town_capareaMarker_%1", _town], getPos _town];
	_marker setMarkerShapeLocal "ELLIPSE";
	_marker setMarkerBrushLocal "Border";
	_marker setMarkerSizeLocal [CTI_TOWNS_CAPTURE_RANGE, CTI_TOWNS_CAPTURE_RANGE];
	_marker setMarkerColorLocal "ColorBlack";
	_marker setMarkerAlphaLocal 1;

	_marker = createMarkerLocal [format ["cti_town_marker_%1", _town], getPos _town];
	_marker setMarkerTypeLocal "mil_flag";
	_marker setMarkerTextLocal format["%1 :: %2",_town_name, _town_value];
	_marker setMarkerColorLocal _coloration;
	_marker setMarkerSizeLocal [0.3, 0.3];

	_marker = createMarkerLocal [format ["cti_town_HALLOMarker_%1", _town], getPos _town];
	_marker setMarkerShapeLocal "ELLIPSE";
	_marker setMarkerBrushLocal "Border";
	_marker setMarkerSizeLocal [CTI_MARKERS_TOWN_AREA_RANGE*CTI_HALO_RATIO, CTI_MARKERS_TOWN_AREA_RANGE*CTI_HALO_RATIO];
	_marker setMarkerColorLocal "ColorYellow";
	_marker setMarkerAlphaLocal 0;
};
