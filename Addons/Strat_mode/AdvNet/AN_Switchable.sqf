private ["_unit","_side_id","_uid","_new"];
_unit = _this;

// sleep обязателен: waitUntil без задержки проверяет условие каждый кадр
waitUntil {sleep 1; !isNull _unit && alive _unit && CTI_Init_Server};

_side_id = (side _unit) call CTI_CO_FNC_GetSideID;
// UID нужен для перепривязки: после респавна объект игрока НОВЫЙ,
// старая привязка к объекту навсегда залипала на трупе
_uid = if (isPlayer _unit) then {getPlayerUID _unit} else {""};

while {!CTI_GameOver} do {
	// AN_Launch идемпотентен по живости цикла (guard по scriptDone)
	[_unit, _side_id] call AN_Launch;

	waitUntil {sleep 1; !alive _unit || CTI_GameOver};
	if (CTI_GameOver) exitWith {};

	// AI под тем же объектом не возрождается — ждать дальше нечего
	if (_uid == "") exitWith {};

	// Игрок: ищем его новый объект по UID
	_new = objNull;
	waitUntil {
		sleep 1;
		_new = objNull;
		{if (getPlayerUID _x == _uid) exitWith {_new = _x};} forEach allPlayers;
		(!isNull _new && {alive _new}) || CTI_GameOver
	};
	if (CTI_GameOver) exitWith {};
	_unit = _new;
};