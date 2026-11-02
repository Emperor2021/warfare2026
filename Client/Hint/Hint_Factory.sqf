/*
    Client\Hint\Hint_Factory.sqf
    Подсказка при наведении на завод
*/

//--- Получаем все структуры стороны
private ["_structures", "_factory", "_factoryType", "_st", "_found"];

//--- Безопасное получение структур
if (isNil "CTI_P_SideJoined") exitWith { [] };
_structures = CTI_P_SideJoined call CTI_CO_FNC_GetSideStructures;

//--- Если нет структур
if (count _structures == 0) exitWith { [] };

//--- Ищем завод под курсором
_factory = objNull;
_factoryType = nil;
_found = false;
{
    //--- Пропускаем null
    if (isNull _x) exitWith {};
    
    //--- Получаем тип структуры
    _st = _x getVariable "cti_structure_type";
    if (isNil "_st") exitWith {};
    
    //--- Пропускаем города
    if (_st isEqualTo CTI_FTOWN) exitWith {};
    
    //--- Проверяем cursorTarget
    if (!_found && cursorTarget == _x && alive _x) then {
        _factory = _x;
        _factoryType = _st;
        _found = true;
    };
} forEach _structures;

//--- Если завод не найден
if (!_found) exitWith { [] };

//--- Завод должен быть близко (< 200м)
if (player distance _factory > 200) exitWith { [] };

//--- Получаем текст из локализации
private ["_text"];
_text = [_factoryType, CTI_P_SideJoined] call compile preprocessFileLineNumbers "Client\Hint\Hint_Loc.sqf";

[_text, _factory, CTI_P_SideJoined];
