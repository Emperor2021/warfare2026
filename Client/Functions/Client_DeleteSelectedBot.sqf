private ["_selectedUnits", "_bots", "_names"];

_selectedUnits = groupSelectedUnits player;
_bots = [];

if (count _selectedUnits == 0) exitWith {
	hint "Боты не выбраны";
};

{
	if (!isNull _x && !isPlayer _x && alive _x && _x in units group player) then {
		_bots pushBackUnique _x;
	};
} forEach _selectedUnits;

if (count _bots == 0) exitWith {
	hint "Среди выбранных нет ботов вашей группы";
};

["SERVER", "Request_DeleteSelectedBot", [_bots]] call CTI_CO_FNC_NetSend;

_names = _bots apply { name _x };
hint format ["Удаление ботов: %1", _names joinString ", "];
