/*
    Общие функции авто-перезарядки техники у источников БК.
    Компилируются на ВСЕХ машинах (сервер + клиенты + ХС).
*/
//- Время перезарядки (сек). Определяется на ВСЕХ машинах (сервер + клиенты)
CTI_AUTO_REARM_TIME = 30;

//- Локальная перезарядка техники (выполняется на владельце техники)
//- Вызов: [_техника] spawn CTI_CO_FNC_RearmVehicleLocal;  (именно spawn, не call!)
CTI_CO_FNC_RearmVehicleLocal = {
    params ["_veh"];
    if (isNull _veh || !alive _veh) exitWith {};
    if (!local _veh) exitWith {};

    //- Блокировка от повторной перезарядки
    if (_veh getVariable ["cti_autorearm_busy", false]) exitWith {};
    _veh setVariable ["cti_autorearm_busy", true, true];

    //- Показываем игроку что перезарядка началась
    if (player in _veh) then {
        systemChat (localize "STR_CTI_AUTO_REARM_START");
    };

    //- Ждём указанное время (перезарядка не мгновенная)
    sleep CTI_AUTO_REARM_TIME;

    //- Проверяем что техника всё ещё жива и локальна после ожидания
    if (!alive _veh || !local _veh) exitWith {
        _veh setVariable ["cti_autorearm_busy", false, true];
    };

    //- 1. Перезаряжаем основное оружие и все турели (включая дымы и тепловые ловушки)
    _veh setVehicleAmmo 1;

    //- 2. Перезаряжаем пилоны (для авиации с динамическим лоадаутом / Henroth)
    private _pylons = getPylonMagazines _veh;
    if (count _pylons > 0) then {
        {
            private _magClass = _x;
            if (_magClass != "") then {
                private _maxAmmo = getNumber (configFile >> "CfgMagazines" >> _magClass >> "count");
                if (_maxAmmo > 0) then {
                    _veh setAmmoOnPylon [_forEachIndex + 1, _maxAmmo];
                };
            };
        } forEach _pylons;
    };

    //- 3. Обновляем состояние оружия (движок подхватит новый БК)
    reload _veh;

    //- Снимаем блокировку
    _veh setVariable ["cti_autorearm_busy", false, true];
      if (player in _veh) then {
        systemChat (localize "STR_CTI_AUTO_REARM_DONE");
    };
};