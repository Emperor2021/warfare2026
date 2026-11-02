/*
Автор: Emperor
Дата: 2026-06-22
Время: 17:20
Описание
Измеряет расстояние между штабами (HQ), считает текущее время работы миссии и выводит объединенный доклад разведки.
*/

// Скрипт работает только на клиентах с интерфейсом (игроках)
if (!hasInterface) exitWith {};

// 1. Ожидаем полной инициализации игрока и сторонних логик
waitUntil { sleep 1; !isNil "CTI_Init_Client" && CTI_Init_Client };

private ["_mySide", "_enemySide", "_myHQ", "_enemyHQ", "_distanceMeters", "_distanceKm", "_missionTime", "_hours", "_minutes", "_timeText", "_msg"];

_mySide = CTI_P_SideJoined; // Сторона игрока (West / East)

// Выход, если игрок зашёл за гражданских или независимых (на всякий случай)
if !(_mySide in [west, east]) exitWith {};

// Определяем сторону противника
_enemySide = if (_mySide == west) then {east} else {west};

// 2. Ждем, пока оба штаба физически появятся на карте
_myHQ = objNull;
_enemyHQ = objNull;

while {isNull _myHQ || isNull _enemyHQ} do {
    _myHQ = _mySide call CTI_CO_FNC_GetSideHQ;
    _enemyHQ = _enemySide call CTI_CO_FNC_GetSideHQ;
    if (isNull _myHQ || isNull _enemyHQ) then { sleep 2; };
};

// 3. Сразу фиксируем расстояние на момент захода (в км)
_distanceMeters = _myHQ distance _enemyHQ;
_distanceKm = round(_distanceMeters / 1000); 

// 4. Фиксируем точное время миссии (в секундах)
_missionTime = round time;

// Рассчитываем часы и минуты
_hours = floor (_missionTime / 3600);
_minutes = floor ((_missionTime % 3600) / 60);

// Формируем текст времени на основе stringtable.xml
_timeText = "";
if (_hours > 0) then {
    if (_minutes > 0) then {
        // "X hours Y minutes ago" / "X ч. Y мин. назад"
        _timeText = format [localize "STR_CTI_Intel_Time_Hours_Mins", _hours, _minutes];
    } else {
        // "X hours ago" / "X ч. назад"
        _timeText = format [localize "STR_CTI_Intel_Time_Hours", _hours];
    };
} else {
    if (_minutes > 0) then {
        // "Y minutes ago" / "Y мин. назад"
        _timeText = format [localize "STR_CTI_Intel_Time_Mins", _minutes];
    } else {
        // "about an hour ago" / "около часа назад"
        _timeText = localize "STR_CTI_Intel_Time_Default";
    };
};

// 5. Ждем 1 минуту (60 секунд) перед выводом доклада
sleep 120;

// 6. Формируем единый локализованный текст доклада
// В шаблоне STR_CTI_Intel_Report: %1 - время, %2 - расстояние
_msg = format [localize "STR_CTI_Intel_Report", _timeText, _distanceKm];

// 7. Отправляем сообщение от лица штаба в радиоканал стороны
[_mySide, "HQ"] sideChat _msg;