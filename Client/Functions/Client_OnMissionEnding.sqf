/*
# HEADER #
Script: 		Client\Functions\Client_OnMissionEnding.sqf
Alias:			CTI_CL_FNC_OnMissionEnding
Description:	Triggered upon the mission ending. Auto-spectator enabled.
Note this function is automatically called by the server (PVF)
Author: 		Benny, Emperor
*/
private ["_result", "_side", "_win"];
_side = _this select 0;
_result = _this select 1;
CTI_GameOver = true;

// ==========================================
// РЕЖИМ АНАЛИЗА ПОСЛЕ ИГРЫ (АВТО-НАБЛЮДАТЕЛЬ)
// ==========================================

// 1. Делаем игрока бессмертным (страховка)
player allowDamage false;

// 2. Раскрываем ВСЕ юниты на карте
{
    player reveal [_x, 4];
} forEach allUnits;

// 3. Включаем режим наблюдателя (ПРАВИЛЬНЫЙ СИНТАКСИС!)
// "Initialize" - команда старта, player - от кого, [] - кого можно смотреть (все), true - включить UI
["Initialize", [player, [], true]] call BIS_fnc_EGSpectator;

// 4. Показываем локализованное сообщение
// Если строка вдруг не найдена, выведем хардкод, чтобы не было пустоты
private _hintText = localize "STR_EndGame_SpectatorHint";
if (_hintText == "STR_EndGame_SpectatorHint" || _hintText == "") then {
    _hintText = "<t size='1.5' color='#00FF00' align='center'>ИГРА ЗАВЕРШЕНА</t><br/><br/>Вы переведены в режим Наблюдателя.<br/>Все юниты раскрыты на карте.<br/><br/>Экран результатов через 3 минуты.";
};
hint parseText _hintText;

// 5. Врубаем музычку
playMusic "LeadTrack01_F";

// 6. Даём 180 секунд (3 минуты) на полёты и анализ
sleep 180; 

// Затухание музыки
5 fadeMusic 0;
sleep 5;
playMusic "";

// Отключаем наблюдателя перед дебрифингом, чтобы не было багов интерфейса
["Terminate"] call BIS_fnc_EGSpectator;

// ==========================================
// ЗАВЕРШЕНИЕ МИССИИ
// ==========================================
_win = false;
switch (_result) do {
    case "win": {if (CTI_P_SideJoined == _side) then {_win = true}};
    case "loose": {if (CTI_P_SideJoined != _side) then {_win = true}};
};

if (_win) then {
    ["END1", true, 0] call BIS_fnc_endMission;
} else {
    ["END2", false, 0] call BIS_fnc_endMission;
};