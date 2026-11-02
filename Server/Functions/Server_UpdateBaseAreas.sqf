
private ["_area", "_areas", "_areas_found", "_closest", "_enemy", "_enemylogic", "_logic", "_need_update", "_neigh", "_side", "_structures_positions"];

_side = _this;
_logic= (_side) call CTI_CO_FNC_GetSideLogic;
_areas = _logic getVariable "cti_structures_areas";
_neigh = _logic getVariable "CTI_BASES_NEIGH";

sleep 10;

//--- We update the base area array to remove potential empty areas. First we get the 2D positions of our structures
_structures_positions = [];
{
	_pos = getPos _x;
	_pos = [_pos select 0, _pos select 1];
	_structures_positions pushBack _pos;
} forEach ((_side call CTI_CO_FNC_GetSideStructures) + (_logic getVariable "cti_structures_wip"));

//--- Check for empty areas now
if (CTI_BASE_AREA_SALE > 0) then {

	_need_update = false;
	{
		_closest = [_x, _structures_positions] call CTI_CO_FNC_GetClosestEntity;
		if (CTI_BASE_AREA_SALE == 1) then {
			if (_closest distance _x > CTI_BASE_AREA_RANGE) then {
				_need_update = true;
				_areas set [_forEachIndex, "empty"];
				_neigh set [_forEachIndex, "empty"];
			};
		};
		if (CTI_BASE_AREA_SALE == 2) then {
			_enemy = switch (_side) do
				{
				    case west: {east};
				    case east: {west};
				};
			_enemylogic= (_enemy) call CTI_CO_FNC_GetSideLogic;
			_areas_found = _enemylogic getVariable "CTI_BASES_FOUND_AREAS";
			if !(_x in _areas_found) then {
				if (_closest distance _x > CTI_BASE_AREA_RANGE) then {
					_need_update = true;
					_areas set [_forEachIndex, "empty"];
					_neigh set [_forEachIndex, "empty"];
				};
			};
		};
	} forEach + _areas;

	//--- Only update if we have to
	if (_need_update) then {
		_areas = _areas - ["empty"];
		_logic setVariable ["cti_structures_areas", _areas, true];
		_neigh = _neigh - ["empty"];
		_logic setVariable ["CTI_BASES_NEIGH", _neigh, true];
	};
};
