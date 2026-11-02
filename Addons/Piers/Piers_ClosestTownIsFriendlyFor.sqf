
private ["_caller","_caller_sideID","_town","_town_sideID"];

_caller = _this;
_caller_sideID = (side _caller) call CTI_CO_FNC_GetSideID;

_town = (_caller) call CTI_CO_FNC_GetClosestTown;
_town_sideID = _town getVariable "cti_town_sideID";

if (_town_sideID == _caller_sideID) then {true} else {false}