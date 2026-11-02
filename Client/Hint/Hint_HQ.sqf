/*
    Client\Hint\Hint_HQ.sqf
    Подсказка при наведении на HQ (КШМ)
    Сравнивает cursorTarget с реальным объектом КШМ
*/

//--- Получаем реальный объект КШМ
private ["_hq"];
_hq = CTI_P_SideLogic getVariable "cti_hq";

//--- Если КШМ не найдена
if (isNull _hq) exitWith { [] };

//--- Проверяем что КШМ жива
if (!alive _hq) exitWith { [] };

//--- cursorTarget должен быть равен объекту КШМ
if (cursorTarget != _hq) exitWith { [] };

//--- КШМ должна быть близко (< 200м)
if (player distance _hq > 200) exitWith { [] };

//--- Получаем текст из локализации
private ["_text"];
_text = ["HQ", CTI_P_SideJoined] call compile preprocessFileLineNumbers "Client\Hint\Hint_Loc.sqf";

[_text, _hq, CTI_P_SideJoined];
