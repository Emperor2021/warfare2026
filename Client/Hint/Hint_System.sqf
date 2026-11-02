/*
    Client\Hint\Hint_System.sqf
    Модульная система подсказок
*/

//--- Глобальные переменные
if (isNil "CTI_Hint_LastText") then { CTI_Hint_LastText = "" };
if (isNil "CTI_Hint_LastTarget") then { CTI_Hint_LastTarget = objNull };

//--- Ждём инициализации
waitUntil {!isNil "CTI_P_SideJoined" && !isNull (findDisplay 46)};

diag_log "Hint System: Started";

//--- Запускаем Welcome подсказку с задержкой 12 сек
0 spawn {
    waitUntil {!isNil "CTI_P_SideJoined"};
    sleep 12;
    
    //--- Проверяем настройку подсказок
    if !(profileNamespace getVariable ["CTI_PERSISTENT_HINTS", true]) exitWith {};
    
    //--- Получаем текст из локализации
    private ["_hintText"];
    _hintText = ["Welcome", CTI_P_SideJoined] call compile preprocessFileLineNumbers "Client\Hint\Hint_Loc.sqf";
    
    //--- Показываем через BIS_fnc_dynamicText
    [_hintText, safeZoneX, safeZoneY + safeZoneH * 0.15, 120, 1, 0] spawn BIS_fnc_dynamicText;
};

while {true} do {
    //--- Подсказки включаются/выключаются кнопкой Hints в настройках видео
    if (profileNamespace getVariable ["CTI_PERSISTENT_HINTS", true]) then {
        private _hintData = [] call CTI_Hint_GetActiveHint;

        //--- Фильтр по стороне (если подсказка имеет тег стороны)
        if (count _hintData > 2) then {
            private _hintSide = _hintData select 2;
            if (_hintSide != CTI_P_SideJoined) then {
                //--- Сторода не совпадает — пропускаем, но НЕ выходим из цикла!
                _hintData = [];
            };
        };

        if (count _hintData > 0) then {
            private _text = _hintData select 0;
            private _target = _hintData select 1;

            //--- Показываем только если текст изменился
            if (_text != CTI_Hint_LastText) then {
                hintSilent parseText _text;
                CTI_Hint_LastText = _text;
                CTI_Hint_LastTarget = _target;
            };
        } else {
            if (CTI_Hint_LastText != "") then {
                hintSilent "";
                CTI_Hint_LastText = "";
                CTI_Hint_LastTarget = objNull;
            };
        };
    } else {
        if (CTI_Hint_LastText != "") then {
            hintSilent "";
            CTI_Hint_LastText = "";
            CTI_Hint_LastTarget = objNull;
        };
    };

    sleep 0.2;
};
