/*
    Серверный цикл авто-перезарядки боевой техники у источников БК.
    Источники: стационарные склады БК + грузовики/контейнеры с БК.
*/
if (!isServer) exitWith {};
waitUntil {!isNil "CTI_Init_Server" && {CTI_Init_Server}};

//-------- НАСТРОЙКИ --------
CTI_AUTO_REARM_RANGE              = 25;    //- Радиус для техники и для статики от грузовиков (м)
CTI_AUTO_REARM_RANGE_STATIC_DEPOT = 500;   //- Радиус для статики от склада БК на базе (м)
CTI_AUTO_REARM_CYCLE              = 15;    //- Период проверки (сек)
CTI_AUTO_REARM_THRESHOLD          = 0.05;  //- Заряжать если БК ниже этой доли (0..1)
CTI_AUTO_REARM_NEED_STOP          = false; //- true = только остановившаяся техника
//- CTI_AUTO_REARM_TIME определена в Common\Functions\Common_AutoRearmFunctions.sqf

//-------- СЕРВЕРНЫЕ ФУНКЦИИ --------

//- Расчёт доли боекомплекта техники (0..1)
CTI_SE_FNC_GetVehicleAmmoRatio = {
    params ["_veh"];
    private _minRatio = 1;
    private _count = 0;

    private _mags = magazinesAmmo _veh;
    {
        private _cls  = _x select 0;
        private _ammo = _x select 1;
        if (_ammo isEqualType []) then { _ammo = count _ammo };
        private _max  = getNumber (configFile >> "CfgMagazines" >> _cls >> "count");
        if (_max > 0 && {_ammo isEqualType 0}) then {
            _count = _count + 1;
            private _ratio = _ammo / _max;
            if (_ratio < _minRatio) then { _minRatio = _ratio };
        };
    } forEach _mags;

    {
        private _turret = _x;
        private _turretMags = _veh magazinesTurret _turret;
        {
            private _cls  = _x;
            private _ammo = _veh magazineTurretAmmo [_cls, _turret];
            if (_ammo isEqualType []) then { _ammo = count _ammo };
            private _max  = getNumber (configFile >> "CfgMagazines" >> _cls >> "count");
            if (_max > 0 && {_ammo isEqualType 0}) then {
                _count = _count + 1;
                private _ratio = _ammo / _max;
                if (_ratio < _minRatio) then { _minRatio = _ratio };
            };
        } forEach _turretMags;
    } forEach (allTurrets _veh + [[-1]]);

    if (_count == 0) exitWith { 1 };
    _minRatio
};

//- Определение стороны объекта
CTI_SE_FNC_GetEntitySide = {
    params ["_obj"];
    private _side = sideUnknown;
    private _occ = _obj getVariable ["cti_occupant", objNull];

    if (_occ isEqualType west) then {
        _side = _occ;
        if (_side != civilian) exitWith { _side };
    } else {
        if (!isNull _occ) then {
            _side = side _occ;
            if (_side != sideUnknown && _side != civilian) exitWith { _side };
        };
    };

    _side = side _obj;
    if (_side != sideUnknown && _side != civilian) exitWith { _side };

    sideUnknown
};

//- Проверка: является ли объект источником БК по типу
CTI_SE_FNC_IsAmmoSourceByType = {
    params ["_obj"];
    private _type = typeOf _obj;
    private _ammoSourceTypes = [
        "B_Truck_01_ammo_F",
        "O_Truck_03_ammo_F",
        "I_Truck_02_ammo_F",
        "B_T_Truck_01_ammo_F",
        "O_T_Truck_03_ammo_F",
        "I_E_Truck_02_ammo_F",
        "B_Slingload_01_Ammo_F",
        "O_Heli_Transport_04_ammo_F",
        "B_Heli_Transport_03_ammo_F",
        "Land_Pod_Heli_Transport_04_ammo_F",
        "O_Truck_02_Ammo_F"
    ];
    _type in _ammoSourceTypes
};

//- Поиск источников БК рядом с позицией
CTI_SE_FNC_FindAmmoSourcesNear = {
    params ["_pos", "_side", "_range"];
    private _sources = [];
    private _nearObjects = _pos nearEntities [["LandVehicle", "Air", "Ship", "Slingload_base_F", "ReammoBox_F"], _range];
    {
        if (alive _x) then {
            private _isSource = _x call CTI_SE_FNC_IsAmmoSourceByType;
            if (!_isSource) then {
                _isSource = CTI_SPECIAL_AMMOTRUCK in (_x getVariable ["cti_spec", []]);
            };
            if (_isSource) then {
                private _srcSide = _x call CTI_SE_FNC_GetEntitySide;
                if (_srcSide == _side || _srcSide == sideUnknown) then {
                    _sources pushBack _x;
                };
            };
        };
    } forEach _nearObjects;
    _sources
};

//-------- ОСНОВНОЙ ЦИКЛ --------
diag_log format ["[AutoRearm] Серверный цикл запущен. Радиус: %1м, радиус статики от склада: %2м, порог: %3", 
    CTI_AUTO_REARM_RANGE, CTI_AUTO_REARM_RANGE_STATIC_DEPOT, CTI_AUTO_REARM_THRESHOLD];

while {!CTI_GameOver} do {
    sleep CTI_AUTO_REARM_CYCLE;

    {
        private _veh = _x;

        if (alive _veh && {!(_veh isKindOf "Man")}) then {
            if (_veh getVariable ["cti_autorearm_busy", false]) then { continue };

            private _isCombat = _veh isKindOf "Tank"
                || _veh isKindOf "Air"
                || _veh isKindOf "StaticWeapon"
                || _veh isKindOf "Ship"
                || (_veh isKindOf "Car" && {count (weapons _veh) > 0})
                || (count (weapons _veh) > 0);

            if (_isCombat) then {
                private _ratio = _veh call CTI_SE_FNC_GetVehicleAmmoRatio;

                if (_ratio <= CTI_AUTO_REARM_THRESHOLD) then {
                    private _canRearm = if (CTI_AUTO_REARM_NEED_STOP) then {abs (speed _veh) < 2} else {true};

                    if (_canRearm) then {
                        private _sideVeh = _veh call CTI_SE_FNC_GetEntitySide;

                        if (_sideVeh != sideUnknown && _sideVeh != civilian) then {

                            //- Радиус для грузовиков/контейнеров — всегда 25м
                            private _truckRange = CTI_AUTO_REARM_RANGE;

                            //- Радиус для склада БК — 500м для статики, 25м для техники
                            private _depotRange = if (_veh isKindOf "StaticWeapon") then {
                                CTI_AUTO_REARM_RANGE_STATIC_DEPOT
                            } else {
                                CTI_AUTO_REARM_RANGE
                            };

                            //- 1) Грузовики БК / контейнеры рядом (радиус 25м для всех)
                            private _trucks = [_veh, CTI_SPECIAL_AMMOTRUCK, _truckRange]
                                call CTI_CO_FNC_GetNearestSpecialVehicles;
                            private _friendlyTruck = {
                                (_x call CTI_SE_FNC_GetEntitySide) == _sideVeh
                            } count _trucks > 0;

                            //- Фолбэк: поиск по типу объекта (радиус 25м для всех)
                            if (!_friendlyTruck) then {
                                private _fallbackSources = [getPos _veh, _sideVeh, _truckRange]
                                    call CTI_SE_FNC_FindAmmoSourcesNear;
                                _friendlyTruck = count _fallbackSources > 0;
                            };

                            //- 2) Стационарный склад БК своей стороны рядом
                            private _depot = [CTI_AMMO, _veh, (_sideVeh) call CTI_CO_FNC_GetSideStructures, _depotRange]
                                call CTI_CO_FNC_GetClosestStructure;

                            if (_friendlyTruck || {!isNull _depot}) then {
                                diag_log format ["[AutoRearm] Заряжаю: %1 | сторона: %2 | БК: %3%4 | источник: %5",
                                    typeOf _veh, _sideVeh, round(_ratio * 100), "%",
                                    if (_friendlyTruck) then {"грузовик/контейнер"} else {"склад БК"}];

                                if (local _veh) then {
                                    [_veh] spawn CTI_CO_FNC_RearmVehicleLocal;
                                } else {
                                    [_veh] remoteExec ["CTI_CO_FNC_RearmVehicleLocal", _veh];
                                };
                            };
                        };
                    };
                };
            };
        };
    } forEach vehicles;
};

diag_log "[AutoRearm] Серверный цикл завершён (игра окончена)";
