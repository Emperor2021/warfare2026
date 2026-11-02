/*
  # HEADER #
  	Script: 		Server\Functions\Server_OnMineDestroyed.sqf
  	Alias:			CTI_SE_FNC_OnMineDestroyed
  	Description:	Triggered when a mine explodes/cleaned up
  	Author: 		SVB
  	Creation Date:	18.10.2026

  # PARAMETERS #
    0	[Object]: The killed mine
    1	[Integer]: The Side ID of the mine
    2	[String]: The mine variable name
	
  # RETURNED VALUE #
  	None
	
  # SYNTAX #
  	[KILLED, SIDE ID, DEFENSE VARIABLE] spawn CTI_SE_FNC_OnMineDestroyed
*/

private ["_killed", "_logic", "_position", "_side", "_sideID", "_var", "_varname"];

_killed = _this select 0;
_sideID = _this select 1;
_varname = _this select 2;

//--- Early exit if mine already deleted
if (isNil "_killed" || isNull _killed) exitWith {};

_position = getPos _killed;

_side = (_sideID) call CTI_CO_FNC_GetSideFromID;
_logic = (_side) call CTI_CO_FNC_GetSideLogic;

//--- Remove mine from side's defense list
_logic setVariable ["cti_defences",(_logic getVariable "cti_defences") - [objNull, _killed], true];

//--- Clean up debris after explosion
sleep 3;

if (!isNil "_killed" && !isNull _killed) then {
	deleteVehicle _killed;
};
