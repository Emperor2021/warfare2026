/*
    Функция: CTI_CO_FNC_GetMagazineInfo
    Описание: Возвращает информацию о боеприпасе из выбранной артиллерии
    Параметры: 
        0: STRING - класс магазина
        1: ARRAY - данные о снаряде [flightTime, dispersion, reloadTime]
    Возвращает: ARRAY - [остаток, максимум, время_полета, разброс, время_перезарядки]
*/
params ["_magazineClass", "_data"];

// Проверка входящих параметров
if (isNil "_magazineClass" || {_magazineClass == ""}) exitWith {
    diag_log "[ARTILLERY ERROR] CTI_CO_FNC_GetMagazineInfo: _magazineClass is nil or empty";
    [0, 0, 0, 0, 0]
};

if (isNil "_data") then { _data = [] };

private _total = 0;
private _current = 0;
private _found = false;

diag_log format ["[ARTILLERY] CTI_CO_FNC_GetMagazineInfo: Searching for %1", _magazineClass];

// ============================================
// 1. Ищем в технике артиллерии из меню
// ============================================
private _artilleryArray = uiNamespace getVariable ["cti_dialog_ui_artillerymenu_artillery", []];
diag_log format ["[ARTILLERY] Artillery array count: %1", count _artilleryArray];

{
    private _piece = _x select 0;
    if (!isNull _piece && alive _piece) then {
        private _mags = magazinesAmmo _piece;
        diag_log format ["[ARTILLERY] Checking %1, magazines: %2", typeOf _piece, count _mags];
        {
            private _magClass = _x select 0;
            private _ammoCount = _x select 1;
            
            if (_magClass == _magazineClass) then {
                private _maxCount = getNumber(configFile >> "CfgMagazines" >> _magazineClass >> "count");
                if (_maxCount == 0) then { _maxCount = 1 };
                
                _current = _current + _ammoCount;
                _total = _total + _maxCount;
                _found = true;
                
                diag_log format ["[ARTILLERY] Found %1 in artillery %2: %3/%4 (total: %5)", 
                    _magazineClass, typeOf _piece, _ammoCount, _maxCount, _current];
            };
        } forEach _mags;
    };
} forEach _artilleryArray;

// ============================================
// 2. Если не нашли - ищем во всех vehicles
// ============================================
if (!_found) then {
    diag_log "[ARTILLERY] Not found in artillery array, searching all vehicles";
    {
        if (alive _x) then {
            private _mags = magazinesAmmo _x;
            {
                private _magClass = _x select 0;
                private _ammoCount = _x select 1;
                
                if (_magClass == _magazineClass) then {
                    private _maxCount = getNumber(configFile >> "CfgMagazines" >> _magazineClass >> "count");
                    if (_maxCount == 0) then { _maxCount = 1 };
                    
                    _current = _current + _ammoCount;
                    _total = _total + _maxCount;
                    _found = true;
                    
                    diag_log format ["[ARTILLERY] Found %1 in vehicle %2: %3/%4", 
                        _magazineClass, typeOf _x, _ammoCount, _maxCount];
                };
            } forEach _mags;
        };
    } forEach vehicles;
};

// ============================================
// 3. Если все еще не нашли - проверяем игроков
// ============================================
if (!_found) then {
    diag_log format ["[ARTILLERY] No ammo found for %1, checking players", _magazineClass];
    {
        if (alive _x) then {
            private _mags = magazinesAmmo _x;
            {
                private _magClass = _x select 0;
                private _ammoCount = _x select 1;
                
                if (_magClass == _magazineClass) then {
                    private _maxCount = getNumber(configFile >> "CfgMagazines" >> _magazineClass >> "count");
                    if (_maxCount == 0) then { _maxCount = 1 };
                    
                    _current = _current + _ammoCount;
                    _total = _total + _maxCount;
                    _found = true;
                };
            } forEach _mags;
        };
    } forEach playableUnits;
};

// ============================================
// 4. Если все еще 0 - используем стандартные значения
// ============================================
if (!_found || _total == 0) then {
    diag_log format ["[ARTILLERY] No ammo found for %1, using defaults", _magazineClass];
    _total = getNumber(configFile >> "CfgMagazines" >> _magazineClass >> "count");
    if (_total == 0) then { _total = 32 };
    _current = _total;
};

// Получаем данные о снаряде
private _flightTime = 0;
private _dispersion = 0;
private _reloadTime = 0;

if (count _data >= 3) then {
    _flightTime = _data select 0;
    _dispersion = _data select 1;
    _reloadTime = _data select 2;
} else {
    // Значения по умолчанию
    if (_magazineClass find "155mm" != -1) then {
        _flightTime = 30; _dispersion = 25; _reloadTime = 10;
    } else {
        if (_magazineClass find "82mm" != -1) then {
            _flightTime = 12; _dispersion = 15; _reloadTime = 8;
        } else {
            if (_magazineClass find "230mm" != -1) then {
                _flightTime = 20; _dispersion = 35; _reloadTime = 15;
            } else {
                _flightTime = 20; _dispersion = 20; _reloadTime = 10;
            };
        };
    };
};

private _result = [_current, _total, _flightTime, _dispersion, _reloadTime];
diag_log format ["[ARTILLERY] CTI_CO_FNC_GetMagazineInfo result for %1: %2 (found: %3)", 
    _magazineClass, _result, _found];

_result