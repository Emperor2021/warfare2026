// ============================================================
// SVB Spawn Points
// Инициализация конфигурации и функций
// ============================================================

if (isNil "SVB_INIT") then {
    SVB_INIT = true;

    // Конфиг точек появления:
    // [ключ фабрики, класс точки, радиус, лимит, только вода]
    // лимит -1 = без лимита
    SVB_SPAWN_POINT_CLASSES = [
        ["Barracks", "VR_Area_01_square_2x2_grey_F", 100, 6, false],
        ["Light",    "Land_HelipadCircle_F",         100, 6, false],
        ["Heavy",    "Land_HelipadSquare_F",         100, 6, false],
        ["Ammo",     "Land_JumpTarget_F",            100, 6, false],
        ["Repair",   "Land_HelipadRescue_F",         100, 6, false],
        ["Air",      "Land_HelipadCivil_F",          100, 6, false],
        ["Naval",    "VR_Area_01_circle_4_grey_F",   100, 6, true]
    ];
};

// ============================================================
// Определить тип фабрики в виде строкового ключа
// ============================================================
svb_fnc_getFactoryTypeKey = {
    params ["_factory"];

    // Если передана строка — сразу пустой ключ
    if (typeName _factory == typeName "") exitWith {""};
    if (isNull _factory) exitWith {""};

    private _type = _factory getVariable ["cti_structure_type", ""];
    private _typeStr = str(_type);

    if (_type isEqualTo (missionNamespace getVariable ["CTI_FACTORY_BARRACKS", "Barracks"]) || _type isEqualTo (missionNamespace getVariable ["CTI_BARRACKS", "Barracks"]) || {(_typeStr find "Barracks") >= 0}) exitWith {"Barracks"};
    if (_type isEqualTo (missionNamespace getVariable ["CTI_FACTORY_LIGHT", "Light"]) || _type isEqualTo (missionNamespace getVariable ["CTI_LIGHT", "Light"]) || {(_typeStr find "Light") >= 0}) exitWith {"Light"};
    if (_type isEqualTo (missionNamespace getVariable ["CTI_FACTORY_HEAVY", "Heavy"]) || _type isEqualTo (missionNamespace getVariable ["CTI_HEAVY", "Heavy"]) || {(_typeStr find "Heavy") >= 0}) exitWith {"Heavy"};
    if (_type isEqualTo (missionNamespace getVariable ["CTI_FACTORY_AMMO", "Ammo"]) || _type isEqualTo (missionNamespace getVariable ["CTI_AMMO", "Ammo"]) || {(_typeStr find "Ammo") >= 0}) exitWith {"Ammo"};
    if (_type isEqualTo (missionNamespace getVariable ["CTI_FACTORY_REPAIR", "Repair"]) || _type isEqualTo (missionNamespace getVariable ["CTI_REPAIR", "Repair"]) || {(_typeStr find "Repair") >= 0}) exitWith {"Repair"};
    if (_type isEqualTo (missionNamespace getVariable ["CTI_FACTORY_AIR", "Air"]) || _type isEqualTo (missionNamespace getVariable ["CTI_AIR", "Air"]) || {(_typeStr find "Air") >= 0}) exitWith {"Air"};
    if (_type isEqualTo (missionNamespace getVariable ["CTI_FACTORY_NAVAL", "Naval"]) || _type isEqualTo (missionNamespace getVariable ["CTI_NAVAL", "Naval"]) || {(_typeStr find "Naval") >= 0}) exitWith {"Naval"};

    ""
};

// ============================================================
// Получить конфиг точки по ключу фабрики
// ============================================================
svb_fnc_getSpawnPointConfig = {
    params ["_key"];

    private _cfg = [];

    {
        if ((_x select 0) == _key) exitWith {
            _cfg = _x;
        };
    } forEach SVB_SPAWN_POINT_CLASSES;

    _cfg
};

// ============================================================
// Получить конфиг точки по классу объекта
// ============================================================
svb_fnc_getSpawnPointConfigByClass = {
    params ["_classname"];

    private _cfg = [];

    {
        if ((_x select 1) == _classname) exitWith {
            _cfg = _x;
        };
    } forEach SVB_SPAWN_POINT_CLASSES;

    _cfg
};

// ============================================================
// Регистрация построенной точки появления
// Вызывается на сервере из Server_BuildDefense.sqf
// ============================================================
svb_fnc_registerSpawnPoint = {
    params ["_defense", "_varname", "_side", "_position", "_direction", "_center"];

    if (isNull _defense) exitWith {};

    private _class = typeOf _defense;
    private _cfg = [_class] call svb_fnc_getSpawnPointConfigByClass;

    if (_cfg isEqualTo []) exitWith {};

    private _key = _cfg select 0;
    private _range = _cfg select 2;
    private _limit = _cfg select 3;
    private _waterOnly = _cfg select 4;

    // Морская точка не должна работать на суше
    if (_waterOnly && {!surfaceIsWater _position}) exitWith {};

    private _sideStructures = _side call CTI_CO_FNC_GetSideStructures;

    private _candidates = [];

    // Spawn point привязывается ТОЛЬКО к фабрикам СВОЕГО ТИПА в радиусе
    {
        if (!isNull _x && {alive _x}) then {
            if (_defense distance _x <= _range) then {
                private _factoryKey = _x call svb_fnc_getFactoryTypeKey;
                if (_factoryKey == _key) then {
                    _candidates pushBack _x;
                };
            };
        };
    } forEach _sideStructures;

    if (count _candidates == 0) exitWith {};

    // Лимит точек на фабрику
    {
        private _point = _x getVariable ["svb_spawn_points", []];

        if (_limit >= 0 && {count _point >= _limit}) then {} else {
            private _order = _x getVariable ["svb_spawn_order_counter", 0];
            _order = _order + 1;
            _x setVariable ["svb_spawn_order_counter", _order, true];

            _defense setVariable ["svb_spawn_factory", _x, true];
            _defense setVariable ["svb_spawn_key", _key, true];
            _defense setVariable ["svb_spawn_side", _side, true];
            _defense setVariable ["svb_spawn_order", _order, true];

            _point pushBack _defense;
            _x setVariable ["svb_spawn_points", _point, true];
        };
    } forEach _candidates;
};

// ============================================================
// Отписка точки после удаления/уничтожения
// ============================================================
svb_fnc_unregisterSpawnPoint = {
    params ["_point"];

    if (isNull _point) exitWith {};

    private _factory = _point getVariable ["svb_spawn_factory", objNull];

    if (!isNull _factory) then {
        private _points = _factory getVariable ["svb_spawn_points", []];
        _points = _points - [_point];
        _factory setVariable ["svb_spawn_points", _points, true];
    };

    _point setVariable ["svb_spawn_factory", objNull, true];
    _point setVariable ["svb_spawn_key", "", true];
    _point setVariable ["svb_spawn_side", sideUnknown, true];
    _point setVariable ["svb_spawn_order", -1, true];
};

// ============================================================
// Получить все живые и валидные точки фабрики
// ============================================================
svb_fnc_getFactorySpawnPoints = {
    params ["_factory", "_side"];

    if (isNull _factory || {!alive _factory}) exitWith {[]};

    private _key = _factory call svb_fnc_getFactoryTypeKey;

    private _cfg = [_key] call svb_fnc_getSpawnPointConfig;

    if (_cfg isEqualTo []) exitWith {[]};

    private _class = _cfg select 1;
    private _range = _cfg select 2;

    // Собираем spawn points ТОЛЬКО ЭТОЙ фабрики
    private _points = [];
    private _factoryPoints = _factory getVariable ["svb_spawn_points", []];

    {
        if (
            !isNull _x &&
            alive _x &&
            typeOf _x == _class
        ) then {
            _points pushBack _x;
        };
    } forEach _factoryPoints;

    // Сортировка по порядку строительства
    private _mapped = _points apply {
        [_x getVariable ["svb_spawn_order", 0], _x]
    };

    _mapped sort true;

    _points = _mapped apply {_x select 1};

    _points
};

// ============================================================
// Проверка занятости точки
// ============================================================
svb_fnc_isSpawnPointFree = {
    params ["_point", "_key"];

    if (isNull _point || {!alive _point}) exitWith {false};

    private _occupied = false;

    // Живая пехота на точке мешает любому спавну
    private _nearMen = _point nearEntities ["Man", 3];
    private _aliveMen = {alive _x} count _nearMen;

    if (_aliveMen > 0) then {
        _occupied = true;
    };

    if (!_occupied) then {
        if (_key isEqualTo "Light" || _key isEqualTo "Heavy" || _key isEqualTo "Ammo" || _key isEqualTo "Repair") then {
            private _nearVeh = _point nearEntities ["LandVehicle", 8];
            private _aliveVeh = {alive _x} count _nearVeh;
            if (_aliveVeh > 0) then {
                _occupied = true;
            };
            // Проверяем статичное оружие и ящики
            private _nearAll = _point nearEntities ["All", 8];
            private _nearStatic = _nearAll select {alive _x && (_x isKindOf "StaticWeapon" || _x isKindOf "AmmoBox")};
            private _staticCount = count _nearStatic;
            if (_staticCount > 0) then {
                _occupied = true;
            };
        } else {
            if (_key isEqualTo "Air") then {
                private _nearAir = _point nearEntities ["Air", 12];
                private _groundAir = _nearAir select {
                    alive _x &&
                    ((getPosATL _x) select 2) < 5
                };

                if (count _groundAir > 0) then {
                    _occupied = true;
                };
            } else {
                if (_key isEqualTo "Naval") then {
                    private _nearShip = _point nearEntities ["Ship", 12];
                    if ({alive _x} count _nearShip > 0) then {
                        _occupied = true;
                    };
                };
            };
        };
    };

    !_occupied
};

// ============================================================
// Найти свободную точку для покупки
// Возвращает: [найдена ли точка, позиция, направление]
// ============================================================
svb_fnc_getFreeSpawnPoint = {
    params ["_factory", "_side", "_model"];

    private _result = [false, [0,0,0], 0];

    if (isNull _factory || {!alive _factory}) exitWith {_result};

    // Фабрика должна принадлежать стороне покупателя
    if !(_factory in (_side call CTI_CO_FNC_GetSideStructures)) exitWith {_result};

    // Пехота может использовать любую точку, техника — только своего типа
    private _modelKey = if (_model isKindOf "Man") then {"MAN"} else {_factory call svb_fnc_getFactoryTypeKey};

    private _points = [_factory, _side] call svb_fnc_getFactorySpawnPoints;

    if (_points isEqualTo []) exitWith {_result};

    {
        private _point = _x;
        private _pointSide = _point getVariable ["svb_spawn_side", sideUnknown];
        private _pointKey = _point getVariable ["svb_spawn_key", ""];
        private _pointClass = typeOf _point;

        // Пехота ТОЛЬКО Barracks, техника ТОЛЬКО своего типа
        private _modelKey = if (_model isKindOf "Man") then {"Barracks"} else {_factory call svb_fnc_getFactoryTypeKey};

        private _match = _pointKey == _modelKey;

        if (_match && {(_pointSide == _side || _pointSide == sideUnknown)}) then {
            private _isFree = [_point, _modelKey] call svb_fnc_isSpawnPointFree;
            if (_isFree) then {
                private _pos = getPosATL _point;
                _result = [true, _pos, getDir _point];
            };
        };

        if (_result select 0) exitWith {};
    } forEach _points;

    _result
};

// ============================================================
// Найти ближайшую свободную точку спавна к объекту (для городов)
// Возвращает: [найдена ли точка, позиция, направление]
// ============================================================
svb_fnc_getNearestSpawnPoint = {
    params ["_targetObj", "_side", "_model"];

    private _result = [false, [0,0,0], 0];

    // Ящики и минёты НЕ используют SVB спавн — они спавнятся в CTI default позиции
    private _isStatic = (_model find "Mortar" >= 0 || _model find "mortar" >= 0 || _model find "Box" >= 0 || _model find "box" >= 0 || _model find "SupplyCrate" >= 0 || _model find "UAV" >= 0 || _model find "uav" >= 0);
    if (_isStatic) exitWith {_result};

    // Определяем ключ спавна по classname техники
    private _modelKey = if (_model isKindOf "Man") then {"Barracks"} else {
        private _u = _model;
        if (_u find "Tank" >= 0 || _u find "tank" >= 0 || _u find "APC" >= 0 || _u find "apc" >= 0 || _u find "IFV" >= 0 || _u find "ifv" >= 0) then {"Heavy"}
        else {
            if (_u find "Plane" >= 0 || _u find "plane" >= 0 || _u find "Jet" >= 0 || _u find "jet" >= 0 || _u find "Helicopter" >= 0 || _u find "helicopter" >= 0) then {"Air"}
            else {
                if (_u find "Ship" >= 0 || _u find "ship" >= 0 || _u find "Boat" >= 0 || _u find "boat" >= 0) then {"Naval"}
                else {"Light"}
            }
        }
    };

    // Определяем класс точки спавна по ключу
    private _pointCfg = [_modelKey] call svb_fnc_getSpawnPointConfig;
    if (_pointCfg isEqualTo []) exitWith {_result};

    private _pointClass = _pointCfg select 1;
    private _pointRange = _pointCfg select 2;

    // Ищем все точки спавна этого типа в радиусе
    private _nearPoints = nearestObjects [_targetObj, [_pointClass], _pointRange];

    private _found = false;
    {
        if (_found) exitWith {};
        if (alive _x) then {
            private _pointSide = _x getVariable ["svb_spawn_side", sideUnknown];
            if ((_pointSide == _side || _pointSide == sideUnknown) && {[_x, _modelKey] call svb_fnc_isSpawnPointFree}) then {
                private _pos = getPosATL _x;
                private _dir = getDir _x;
                _result = [true, _pos, _dir];
                _found = true;
            };
        };
    } forEach _nearPoints;

    _result
};

// ============================================================
// Центрирование техники на точке спавна (вызывается через remoteExec на сервере)
// ============================================================
SVB_Fnc_CenterVehicle = {
    params ["_vehicle", "_targetPos", "_targetDir"];

    if (isNull _vehicle) exitWith {};

    sleep 0.5;

    if (alive _vehicle) then {
        // Сохраняем текущую Z (она правильная после создания)
        private _currentZ = (position _vehicle) select 2;
        _vehicle setPos [_targetPos select 0, _targetPos select 1, _currentZ];
        _vehicle setDir _targetDir;
    };
};

// ============================================================
// Записать все функции в missionNamespace для глобального доступа
// ============================================================

if (!isNil "svb_fnc_getFactoryTypeKey") then { missionNamespace setVariable ["svb_fnc_getFactoryTypeKey", svb_fnc_getFactoryTypeKey, true] };
if (!isNil "svb_fnc_getSpawnPointConfig") then { missionNamespace setVariable ["svb_fnc_getSpawnPointConfig", svb_fnc_getSpawnPointConfig, true] };
if (!isNil "svb_fnc_getSpawnPointConfigByClass") then { missionNamespace setVariable ["svb_fnc_getSpawnPointConfigByClass", svb_fnc_getSpawnPointConfigByClass, true] };
if (!isNil "svb_fnc_registerSpawnPoint") then { missionNamespace setVariable ["svb_fnc_registerSpawnPoint", svb_fnc_registerSpawnPoint, true] };
if (!isNil "svb_fnc_unregisterSpawnPoint") then { missionNamespace setVariable ["svb_fnc_unregisterSpawnPoint", svb_fnc_unregisterSpawnPoint, true] };
if (!isNil "svb_fnc_getFactorySpawnPoints") then { missionNamespace setVariable ["svb_fnc_getFactorySpawnPoints", svb_fnc_getFactorySpawnPoints, true] };
if (!isNil "svb_fnc_isSpawnPointFree") then { missionNamespace setVariable ["svb_fnc_isSpawnPointFree", svb_fnc_isSpawnPointFree, true] };
if (!isNil "svb_fnc_getFreeSpawnPoint") then { missionNamespace setVariable ["svb_fnc_getFreeSpawnPoint", svb_fnc_getFreeSpawnPoint, true] };
if (!isNil "svb_fnc_getNearestSpawnPoint") then { missionNamespace setVariable ["svb_fnc_getNearestSpawnPoint", svb_fnc_getNearestSpawnPoint, true] };
if (!isNil "SVB_Fnc_CenterVehicle") then { missionNamespace setVariable ["SVB_Fnc_CenterVehicle", SVB_Fnc_CenterVehicle, true] };