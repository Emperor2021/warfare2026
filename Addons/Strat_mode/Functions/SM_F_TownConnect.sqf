/* SM_F_TownConnect.sqf
    Считывает связи города из Eden Editor (F5) и сохраняет их в переменную.
*/
private ["_ct", "_synced", "_neighs"];

_ct = _this select 0; // Объект города

// Считываем связи, проставленные в редакторе (Sync)
_synced = synchronizedObjects _ct;

_neighs = [];
{
    // CTI_Towns - массив всех объектов городов, определенных в миссии
    if (_x in CTI_Towns) then {
        _neighs pushBack _x;
    };
} forEach _synced;

// Записываем соседей в переменную города, доступную всем (public)
_ct setVariable ["CTI_Neigh", _neighs, true];