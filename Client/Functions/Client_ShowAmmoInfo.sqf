/*
    Функция отображения боекомплекта при наведении на технику/юнитов
    Показывает информацию только для своей стороны
    Не перезаписывает чужие hint
*/

private ["_target", "_text", "_sideID", "_targetSide", "_isVehicle", "_magazines", "_magData", "_existing"];

//--- Глобальная переменная для отслеживания таймера хинта
if (isNil "CTI_AmmoInfo_TimerHandle") then {
    CTI_AmmoInfo_TimerHandle = objNull;
};

_target = cursorTarget;

//--- Проверяем, открыта ли карта - работаем только на карте
if (!visibleMap) exitWith { false };

//--- Проверяем, существует ли цель
if (isNull _target) exitWith { false };

//--- Получаем сторону цели
_targetSide = side _target;

//--- Проверяем, что цель принадлежит своей стороне
if (_targetSide != side player) exitWith { false };

//--- Проверяем, что цель - юнит или техника
if !(_target isKindOf "Man" || _target isKindOf "LandVehicle" || _target isKindOf "Air" || _target isKindOf "Ship" || _target isKindOf "StaticWeapon") exitWith { false };

//--- Не показываем для самого себя
if (_target == player) exitWith { false };

_isVehicle = (_target isKindOf "AllVehicles" && !(_target isKindOf "Man"));

_text = "<t align='left' size='1.1' shadow='1'>";

//--- Добавляем название техники/юнита
if (_isVehicle) then {
    _text = _text + "<t color='#00FF00' size='1.5'>" + getText (configFile >> "CfgVehicles" >> typeOf _target >> "displayName") + "</t><br/>";
} else {
    _text = _text + "<t color='#00FF00' size='1.5'>" + getText (configFile >> "CfgVehicles" >> typeOf _target >> "displayName") + " [" + name _target + "]</t><br/>";
};

_text = _text + "────────────────────────<br/>";

//--- Для техники показываем боезапас
if (_isVehicle) then {
    _magazines = [];

    //--- Основной боезапас (magazinesAmmo) - объединяем одинаковые
    {
        _magName = _x select 0;
        _magCount = _x select 1;

        if (_magCount > 0) then {
            //--- Проверяем, есть ли уже такой магазин в списке
            _existing = false;
            {
                if (_x select 0 == _magName) exitWith {
                    _x set [1, (_x select 1) + _magCount];
                    _existing = true;
                };
            } forEach _magazines;

            //--- Если нет, добавляем новый
            if (!_existing) then {
                _magazines pushBack [_magName, _magCount];
            };
        };
    } forEach (magazinesAmmo _target);

if (count _magazines > 0) then {
        _text = _text + "<t color='#FFFF00'>" + localize "STR_CTI_AMMOINFO_AMMO" + ":</t><br/>";
        {
            _magName = _x select 0;
            _magCount = _x select 1;

            if (typeName _magCount != "SCALAR") then {_magCount = 0};

            _displayName = getText (configFile >> "CfgMagazines" >> _magName >> "displayName");
            if (_displayName == "") then {_displayName = _magName};

            _magNameLower = toLower _magName;
            _ammoColor = "#FFFFFF";

            if (_magNameLower find "missile" >= 0 || _magNameLower find "rocket" >= 0) then {
                _ammoColor = "#FF0000";
            } else {
                if (_magNameLower find "shell" >= 0 || _magNameLower find "ammo" >= 0 || _magNameLower find "apds" >= 0 || _magNameLower find "he" >= 0) then {
                    _ammoColor = "#FF8800";
                } else {
                    _ammoColor = "#00FFFF";
                };
            };

            _text = _text + "<t color='" + _ammoColor + "'>" + _displayName + "</t>: <t color='#FFFFFF'>" + str _magCount + "</t><br/>";
        } forEach _magazines;
    } else {
        _text = _text + "<t color='#FF0000'>" + localize "STR_CTI_AMMOINFO_AMMO_EMPTY" + "</t><br/>";
    };

    _text = _text + "────────────────────────<br/>";

    //--- Показываем здоровье техники
    _damage = damage _target;
    _health = round ((1 - _damage) * 100);
    _healthColor = if (_health > 70) then {"#00FF00"} else {if (_health > 40) then {"#FFFF00"} else {"#FF0000"}};
    _text = _text + "<t color='#00FF00'>" + localize "STR_CTI_AMMOINFO_STATUS" + ": </t><t color='" + _healthColor + "'>" + str _health + "%</t><br/>";
} else {
    //--- Для пехоты показываем магазины (боекомплект) - объединяем одинаковые
    _targetMagazines = magazinesAmmo _target;
    _magData = [];

    //--- Объединяем одинаковые магазины
    {
        _magName = _x select 0;
        _magCount = _x select 1;

        if (_magCount > 0) then {
            //--- Проверяем, есть ли уже такой магазин в списке
            _existing = false;
            {
                if (_x select 0 == _magName) exitWith {
                    _x set [1, (_x select 1) + _magCount];
                    _existing = true;
                };
            } forEach _magData;

            //--- Если нет, добавляем новый
            if (!_existing) then {
                _magData pushBack [_magName, _magCount];
            };
        };
    } forEach _targetMagazines;

    //--- Проверяем, есть ли боекомплект
    _hasAmmo = false;
    {
        if ((_x select 1) > 0) exitWith {_hasAmmo = true};
    } forEach _magData;

    if (_hasAmmo) then {
        _text = _text + "<t color='#FFFF00'>" + localize "STR_CTI_AMMOINFO_AMMO" + ":</t><br/>";
        {
            _magName = _x select 0;
            _magCount = _x select 1;

            //--- Проверяем, что _magCount это число
            if (typeName _magCount != "SCALAR") then {_magCount = 0};

            //--- Получаем читаемое название магазина
            _displayName = getText (configFile >> "CfgMagazines" >> _magName >> "displayName");
            if (_displayName == "") then {_displayName = _magName};

            _text = _text + _displayName + ": <t color='#FFFFFF'>" + str _magCount + "</t><br/>";
        } forEach _magData;

        _text = _text + "────────────────────────<br/>";
    };

    //--- Для пехоты показываем оружие
    _weaponsInfo = weaponsItems _target;

    if (count _weaponsInfo > 0) then {
        _text = _text + "<t color='#FFFF00'>" + localize "STR_CTI_AMMOINFO_WEAPONS" + ":</t><br/>";
        {
            _weapon = _x select 0;
            if (_weapon != "") then {
                _weaponName = getText (configFile >> "CfgWeapons" >> _weapon >> "displayName");
                if (_weaponName == "") then {_weaponName = _weapon};

                _text = _text + "  " + _weaponName + "<br/>";
            };
        } forEach _weaponsInfo;

        _text = _text + "────────────────────────<br/>";
    };

    //--- Здоровье юнита
    _damage = damage _target;
    _health = round ((1 - _damage) * 100);
    _healthColor = if (_health > 70) then {"#00FF00"} else {if (_health > 40) then {"#FFFF00"} else {"#FF0000"}};
    _text = _text + "<t color='#00FF00'>" + localize "STR_CTI_AMMOINFO_HEALTH" + ": </t><t color='" + _healthColor + "'>" + str _health + "%</t><br/>";
};

_text = _text + "</t>";

//--- Отображаем информацию
hintSilent parseText _text;

//--- Автоматически закрываем хинт через 5 секунд
if (!isNull CTI_AmmoInfo_TimerHandle) then {
    terminate CTI_AmmoInfo_TimerHandle; //--- Прерываем предыдущий таймер, если он существует
};

CTI_AmmoInfo_TimerHandle = 0 spawn {
    sleep 5;
    hintSilent "";
    CTI_AmmoInfo_TimerHandle = objNull; //--- Сбрасываем переменную таймера
};

true
