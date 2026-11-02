/*
    Smart Resistance Init v2.0
    Интеграция с FSM town_resistance.fsm
*/
if (!isServer) exitWith {};

// Компиляция функций
SR_fnc_createAmbush = compileFinal preprocessFileLineNumbers "Addons\SmartResistance\SR_CreateAmbush.sqf";
SR_fnc_createAAGroup = compileFinal preprocessFileLineNumbers "Addons\SmartResistance\SR_CreateAAGroup.sqf";
SR_fnc_createMinefield = compileFinal preprocessFileLineNumbers "Addons\SmartResistance\SR_CreateMinefield.sqf";
SR_fnc_createUrbanDefense = compileFinal preprocessFileLineNumbers "Addons\SmartResistance\SR_CreateUrbanDefense.sqf";
SR_fnc_controller = compileFinal preprocessFileLineNumbers "Addons\SmartResistance\SR_Controller.sqf";
SR_fnc_cleanupGroups = compileFinal preprocessFileLineNumbers "Addons\SmartResistance\SR_Cleanup.sqf";

diag_log "[SmartResistance] :: All functions compiled (v2.0 integrated)";

// Запуск контроллера для каждого города
{
    [_x] spawn SR_fnc_controller;
} forEach CTI_Towns;

diag_log format ["[SmartResistance] :: Controllers started for %1 towns", count CTI_Towns];