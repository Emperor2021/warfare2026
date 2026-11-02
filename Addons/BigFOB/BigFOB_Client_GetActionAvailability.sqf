
private ["_action","_caller","_fob","_fobs","_logic","_return","_side_caller","_side_target","_target","_wip"];

_target = _this select 0;
_caller = _this select 1;
_action = _this select 2;

_side_target = _target getVariable "cti_tower_side";
_side_caller = side _caller;

_logic = (_side_caller) call CTI_CO_FNC_GetSideLogic;
_fobs = _logic getVariable "cti_fobs";

switch (_action) do {
	case "BuySoldier": {
		_return = if (_target in _fobs) then {true} else {false};
	};
	case "Convert": {
		_fob = if (_target in _fobs) then {true} else {false};

		_wip = _target getVariable "cti_tower_wip";
		if (isNil "_wip") then {_wip = false;};

		_return = if (!_fob && !_wip) then {true} else {false};
	};
	case "Dismantle": {
		_return = if (_target in _fobs) then {true} else {false};
	};
	case default {
		_return = true;
	};
};

if (not alive _target || _side_target != _side_caller) then {_return = false};

_return