/*
  # HEADER #
	Script: 		Server\Functions\Server_OnBuildingDestroyed.sqf
	Alias:			CTI_SE_FNC_OnBuildingDestroyed
	Description:	Triggered by the Killed EH whenever a structure get destroyed
					Note this function shall be called by an Event Handler (EH) but can also be called manually
	Author: 		Benny
	Creation Date:	20-09-2013
	Revision Date:  16-10-2013

  # PARAMETERS #
    0	[Object]: The destroyed structure
    1	[Object]: The killer
    2	[String]: The structure variable name
    3	[Intenger]: The Side ID of the structure
    4	[Array]: The position of the structure
    5	[Number]: The direction
    6	[Number]: The current completion speed ratio

  # RETURNED VALUE #
	None

  # SYNTAX #
	[KILLED, KILLER, STRUCTURE VARIABLE, SIDE ID, POSITION, DIRECTION, COMPLETION RATIO] spawn CTI_SE_FNC_OnBuildingDestroyed

  # DEPENDENCIES #
	Common Function: CTI_CO_FNC_GetSideFromID
	Common Function: CTI_CO_FNC_GetSideLogic
	Common Function: CTI_CO_FNC_NetSend
	Server Function: CTI_SE_FNC_HandleStructureConstruction

  # EXAMPLE #
    [_damaged, _shooter, _variable, _sideID, _position, _direction, _completion_ratio] spawn CTI_SE_FNC_OnBuildingDestroyed
*/

private ["_classnames", "_completion_ratio", "_direction", "_killed", "_killer", "_logic", "_position", "_sell", "_side", "_sideID", "_structure", "_var", "_variable","_award","_score","_time_multiplier","_upgrades","_var_name"];

_killed = _this select 0;
_killer = _this select 1;
_variable = _this select 2;
_sideID = _this select 3;
_position = _this select 4;
_direction = _this select 5;
_completion_ratio = _this select 6;



_side = (_sideID) call CTI_CO_FNC_GetSideFromID;
_logic = (_side) call CTI_CO_FNC_GetSideLogic;
//_sell = if (isNil {_killed getVariable "cti_sell"}) then {false} else {true};
_sell = if (_killer == _killed) then {true} else {false};

diag_log format [" :: FACTORY :: %1 Killed, side %2 -- Sold: %3 -- Current Com group %4 -- %5",_killed,_side,(_killer == _killed),(_side) call CTI_CO_FNC_GetSideCommander,name leader((_side) call CTI_CO_FNC_GetSideCommander)];

sleep (random 0.5);
while{CTI_Structure_Lock} do {sleep random 0.5};
CTI_Structure_Lock=True;

// bistery: a damaged structure will not trigger the EH assigned to the original one! will it get fixed? nop!
_logic setVariable ["cti_structures", (_logic getVariable "cti_structures") - [_killed, objNull], true];
_var = missionNamespace getVariable _variable;

//--- Remove base area position if building is sold
if (_sell) then {
	private _position2D = [_position select 0, _position select 1];
	private _areas = _logic getVariable "cti_structures_areas";
	private _newAreas = [];
	{
		if ([_x select 0, _x select 1] distance _position2D >= 1) then {
			_newAreas pushBack _x;
		};
	} forEach _areas;
	_logic setVariable ["cti_structures_areas", _newAreas, true];
};

//--- Sell?
if !(_sell) then {
	//--- Replace with ruins
	_structure = ((_var select 1) select 1) createVehicle _position;
	_structure setDir _direction;
	_structure setPos _position;
	_structure setDir _direction;
	_structure setVectorUp [0,0,0];

	_structure setVariable ["cti_save", _variable,true];
	_structure setVariable ["cti_completion", 10,true];
	_structure setVariable ["cti_completion_ratio", _completion_ratio * CTI_BASE_CONSTRUCTION_RATIO_ON_DEATH,true];
	// _structure setVariable ["cti_structures_iteration", round(CTI_BASE_WORKERS_BUILD_COEFFICIENT / ((_var select 3)/100))];
	_structure setVariable ["cti_structures_iteration", (_var select 3)/100,true];
	_structure setVariable ["cti_structure_type", ((_var select 0) select 0)];

	[_side, _structure, _variable, _position, _direction] spawn CTI_SE_FNC_HandleStructureConstruction;

	_logic setVariable ["cti_structures_wip", (_logic getVariable "cti_structures_wip") + [_structure] - [objNull],true];
	[["CLIENT", _side], "Client_structurepreplaced", [_structure]] call CTI_CO_FNC_NetSend;



	if ((_killer isKindOf "UAV" || _killer isKindOf "UGV_01_base_F" || _killer isKindOf "UAV_03_base_F") && ! isNull((uavControl _killer) select 0)  ) then {_killer = ((uavControl _killer) select 0)};

	if (isPlayer (leader (group _killer))) then {
		_killer = leader (group _killer);
		_var_name = (_var select 0) select 1;
		_time_multiplier = if (time > 3600) then {floor (time / 3600)} else {1};
		_award = (_var select 2) * _time_multiplier;
		_score = if (_award > 1000) then {floor (_award / 1000)} else {1};

		[["CLIENT", _killer], "Client_AwardBounty", [_var select 0, _award]] call CTI_CO_FNC_NetSend;

		["SERVER", "Request_AddScore", [_killer, _score]] call CTI_CO_FNC_NetSend;

		_upgrades = (side _killer) call CTI_CO_FNC_GetSideUpgrades;
		if ((typeName _upgrades == "ARRAY") && {count _upgrades > CTI_UPGRADE_SATELLITE} && {(_upgrades select CTI_UPGRADE_SATELLITE) == 1}) then {
			[["CLIENT", side _killer], "Client_OnMessageReceived", ["enemy-building-destroyed", [name _killer, _var_name]]] call CTI_CO_FNC_NetSend;
		};
	};
};

sleep 1;
deleteVehicle _killed;

_classnames = _var select 1;
_classnames = if (count _classnames > 2) then {[_classnames select 1] + (_classnames select 2)} else {[_classnames select 1]};

{if (isNil {_x getVariable "cti_completion"}) then { deleteVehicle _x }} forEach (nearestObjects [_position, _classnames, 25]);

[["CLIENT", _side], "Client_OnStructureKilled", [_position, _variable, _sell]] call CTI_CO_FNC_NetSend;
["CLIENT", "Client_RemoveRuins", [_position, _variable]] call CTI_CO_FNC_NetSend;
CTI_Structure_Lock=False;
