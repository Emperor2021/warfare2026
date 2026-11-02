/*
    Client\Hint\Hint_StartAll.sqf
    Запускает все модули подсказок
*/

//--- Компилируем функции один раз при старте
CTI_Hint_Fnc_HQ = compile preprocessFileLineNumbers "Client\Hint\Hint_HQ.sqf";
CTI_Hint_Fnc_Factory = compile preprocessFileLineNumbers "Client\Hint\Hint_Factory.sqf";

//--- Функция получения активной подсказки
CTI_Hint_GetActiveHint = {
    private ["_result"];
    
    //--- Подсказка HQ
    _result = [] call CTI_Hint_Fnc_HQ;
    if (count _result > 0) exitWith { _result };
    
    //--- Подсказка Factory
    _result = [] call CTI_Hint_Fnc_Factory;
    if (count _result > 0) exitWith { _result };
    
    //--- Нет активных подсказок
    [];
};

//--- Запуск системы
[] execVM "Client\Hint\Hint_System.sqf";
