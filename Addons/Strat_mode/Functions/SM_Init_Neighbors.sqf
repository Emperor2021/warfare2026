/*
    SM_Init_Neighbors.sqf
    Инициализация связей для всей карты.
*/

// [Стр. 12] Проходимся по всем городам и вызываем нашу функцию связи
{
    [_x] call CTI_SM_Connect_Towns;
} forEach CTI_Towns;

// [Стр. 16] Ставим флаг готовности, чтобы клиент начал рисовать
SM_MAP_READY = true;
publicVariable "SM_MAP_READY";