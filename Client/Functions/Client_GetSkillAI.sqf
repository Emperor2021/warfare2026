
private ["_logic","_skill"];

_logic = (CTI_P_Sidejoined) call CTI_CO_FNC_GetSideLogic;
_skill = _logic getVariable "cti_ai_skill";

_skill = _skill + ((1 - _skill) * ((score player) / 300));

if (_skill > 1) then {_skill = 1};

_skill