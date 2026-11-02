
private ["_side", "_sideGroups"];

_side = _this;

_sideGroups = [];

{
	if (side _x == _side) then {_sideGroups pushBack _x};
} forEach allGroups;

_sideGroups