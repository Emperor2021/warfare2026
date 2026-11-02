/*
    SM_F_TownDrawConnect.sqf
    Рисует линии связей между городами на карте.
    Вызывается только на клиенте из Addons\Strat_mode\init.sqf
*/

// [Стр. 1] Resistance не видит стратегические линии
if (CTI_P_SideJoined == resistance) exitWith {};

// [Стр. 2] Ждём пока список городов будет готов (CTI_InitTowns = true)
// CTI_InitTowns ставится сервером и передаётся через JIP - надёжнее чем SM_MAP_READY
waitUntil {!isNil "CTI_InitTowns" && CTI_InitTowns};

// [Стр. 3] Дополнительная пауза - даём время Init_Location.sqf прочитать
// synchronizedObjects и заполнить CTI_Neigh для каждого города
sleep 5;

// [Стр. 4] Лог - сколько городов готово к отрисовке
private _ready = {count (_x getVariable ["CTI_Neigh", []]) > 0} count CTI_Towns;
diag_log format ["[CTI_LINK] Drawing connections, towns ready: %1/%2",
    _ready, count CTI_Towns
];

// [Стр. 5] Высота линий над землёй (500м для Altis, 0 для Stratis)
// Высота нужна чтобы линия была видна на карте а не под землёй
private _o = if !(MADE_FOR_STRATIS) then {500} else {0};

// [Стр. 6] Главный цикл - рисуем линии для каждого города
{
    private _ct = _x;
    // [Стр. 7] Получаем список соседей этого города
    private _neigh = _ct getVariable ["CTI_Neigh", []];
    // [Стр. 8] Для каждого соседа рисуем линию через CTI_SM_Connect
    {
        [getPos _ct, getPos _x, "ColorBlack", _o] call CTI_SM_Connect;
    } forEach _neigh;
} forEach CTI_Towns;

// [Стр. 9] Готово
diag_log "[CTI_LINK] Draw complete";