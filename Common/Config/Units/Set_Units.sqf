private ["_c", "_cpt", "_custom", "_f", "_faction", "_label", "_n", "_o", "_p", "_picture", "_s", "_scripts", "_stored", "_t", "_turrets", "_u", "_var_name", "_getTurretsFunc", "_cfgVehicles", "_cfgClass"];

_side = _this select 0;
_faction = _this select 1;
_c = _this select 2;
_p = _this select 3;
_n = _this select 4;
_o = _this select 5;
_t = _this select 6;
_u = _this select 7;
_f = _this select 8;
_s = _this select 9;

_cpt = 0;

// --- Выносим компиляцию и кэшируем корень конфига. 
// Теперь диск и парсер не насилуются на каждом юните.
_getTurretsFunc = compile preprocessFileLineNumbers "Common\Config\Units\Get_DetailedTurrets.sqf";
_cfgVehicles = configFile >> "CfgVehicles";

//--- Safety: get min count (Защита от кривых массивов. Оставляем, это полезно)
_minCount = count _c;
{ if (count _x < _minCount) then { _minCount = count _x }; } forEach [_n, _o, _t, _u, _f, _s, _p];

for "_i" from 0 to (_minCount - 1) do {
    _classname = _c select _i;
    _var_name = _classname;

    _custom = false;
    _scripts = _s select _i;

    //--- Проверяем тип быстрее и без генерации строк
    if (_scripts isEqualType []) then { 
        _classname = _scripts select 0; 
        _custom = true; 
    };

    _cfgClass = _cfgVehicles >> _classname;

    if (isClass _cfgClass) then {
        //--- Проверка на существование переменной (isNil с кодом безопаснее и быстрее)
        if (isNil {missionNamespace getVariable _var_name}) then {
            
            _picture = _p select _i;
            if (_picture == "") then {
                _picture = if (_classname isKindOf "Man") then { getText(_cfgClass >> "portrait") } else { getText(_cfgClass >> "picture") };
                if (_picture == "pictureThing") then { _picture = "" };
            };

            _label = _n select _i;
            if (_label == "") then { _label = getText(_cfgClass >> "displayName") };

            _turrets = if !(_classname isKindOf "Man") then { _classname call _getTurretsFunc } else { "" };

            if (_custom) then {
                //--- Делаем копию массива (+), чтобы не менять оригинальные данные конфига в памяти
                _scripts = +_scripts; 
                _scripts set [2, CTI_CO_CustomIterator];
                missionNamespace setVariable [format["CTI_CUSTOM_ENTITY_%1", CTI_CO_CustomIterator], _var_name];
                CTI_CO_CustomIterator = CTI_CO_CustomIterator + 1;
            };

            _stored = [_label, _picture, _o select _i, _t select _i, _u select _i, _f select _i, _turrets, _scripts];
            
            //--- BECTI-паттерн: пихаем инфу в глобальную переменную по имени класснейма.
            //--- Выглядит как говно, но UI и заводы ищут юниты именно так. Не трогаем.
            missionNamespace setVariable [_var_name, _stored];
            _cpt = _cpt + 1;

            if (CTI_Log_Level >= CTI_Log_Debug) then { 
                ["DEBUG", "FILE: Common\Config\Units\Set_Units.sqf", format ["[%1] Set unit [%2] using classname [%3]", _side, _var_name, _classname]] call CTI_CO_FNC_Log 
            };
        } else {
            if (CTI_Log_Level >= CTI_Log_Warning) then { 
                ["WARNING", "FILE: Common\Config\Units\Set_Units.sqf", format ["[%1] unit [%2] was skipped since it is already defined", _side, _var_name]] call CTI_CO_FNC_Log 
            };
        };
    } else {
        if (CTI_Log_Level >= CTI_Log_Error) then { 
            ["ERROR", "FILE: Common\Config\Units\Set_Units.sqf", format ["[%1] unit [%2] is not using a valid CfgVehicles classname [%3]. If it belong to an Addons, make sure that it is loaded.", _side, _var_name, _classname]] call CTI_CO_FNC_Log 
        };
    };
};

//--- Логи, если массивы были кривыми
if (count _c > _minCount) then {
    if (CTI_Log_Level >= CTI_Log_Warning) then { 
        ["WARNING", "FILE: Common\Config\Units\Set_Units.sqf", format ["[%1] _c has %2 elements but min array has %3 — %4 units will be skipped", _side, count _c, _minCount, (count _c) - _minCount]] call CTI_CO_FNC_Log 
    };
};

if (CTI_Log_Level >= CTI_Log_Information) then { 
    ["INFORMATION", "FILE: Common\Config\Units\Set_Units.sqf", format ["[%1] [%2/%3] units were defined", _side, _cpt, _minCount]] call CTI_CO_FNC_Log 
};