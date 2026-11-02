_c = _this select 0;
_m = _this select 1;
_b = _this select 2;
_r = _this select 3;
_d = _this select 4;

// --- ПРОВЕРКА ЦЕЛОСТНОСТИ ---
if (count _c != count _m || count _c != count _b || count _c != count _r || count _c != count _d) exitWith {
    diag_log format ["[ARTILLERY ERROR] Set_Artillery.sqf - Arrays mismatch! C:%1, M:%2, B:%3, R:%4, D:%5", count _c, count _m, count _b, count _r, count _d];
};

_artillery = [];
for '_i' from 0 to (count _c - 1) do {
    _classname = _c select _i;

    if (isClass (configFile >> 'CfgVehicles' >> _classname)) then {
        _label = getText(configFile >> "CfgVehicles" >> _classname >> "displayName");
        
        // Получаем названия снарядов и их данные
        _mags_labels = [];
        _mags_data = [];
        _magazines = _m select _i;
        _data = _d select _i;
        
        // Проверяем, что данных достаточно
        if (count _magazines != count _data) then {
            diag_log format ["[ARTILLERY WARNING] Data mismatch for %1: mags=%2, data=%3", _classname, count _magazines, count _data];
        };
        
        {
            _mags_labels pushBack (getText(configFile >> "CfgMagazines" >> _x >> "displayName"));
            
            // Сохраняем данные для каждого снаряда
            if (_forEachIndex < count _data) then {
                _mags_data pushBack (_data select _forEachIndex);
            } else {
                _mags_data pushBack [0, 0, 0]; // fallback
            };
        } forEach _magazines;

        // Упаковываем данные
        _array = [_label, _mags_labels, _m select _i, _b select _i, _r select _i, _mags_data];
        
        missionNamespace setVariable [format ["CTI_ARTILLERY_%1", _classname], _array];
        _artillery pushBack _classname;

        diag_log format ["[ARTILLERY] Configured: %1 with %2 magazines", _classname, count _magazines];
    } else {
        diag_log format ["[ARTILLERY ERROR] Unit [%1] invalid.", _classname];
    };
};

missionNamespace setVariable ["CTI_ARTILLERY", _artillery];
diag_log format ["[ARTILLERY] Total configured: %1 types", count _artillery];