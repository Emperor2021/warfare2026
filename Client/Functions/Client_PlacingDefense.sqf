/*
  # HEADER #
	Script: 		Client\Functions\Client_PlacingDefense.sqf
	Alias:			CTI_CL_FNC_PlacingDefense
	Description:	Prepare the placement of a defense before the construction
	Author: 		Benny
	Creation Date:	20-09-2013
	Revision Date:	14-10-2013

  # PARAMETERS #
    0	[String]: The defense variable name
    1	[Object]: The center (construction center)
    2	[Number]: The construction radius

  # RETURNED VALUE #
	None

  # SYNTAX #
	[DEFENSE VARIABLE, CENTER, RADIUS] spawn CTI_CL_FNC_PlacingDefense

  # DEPENDENCIES #
	Client Function: CTI_CL_FNC_ChangePlayerFunds
	Client Function: CTI_CL_FNC_GetPlayerFunds
	Common Function: CTI_CO_FNC_GetDirTo
	Common Function: CTI_CO_FNC_NetSend

  # EXAMPLE #
    [_selected, CTI_P_SideJoined call CTI_CO_FNC_GetSideHQ, CTI_BASE_CONSTRUCTION_RANGE] spawn CTI_CL_FNC_PlacingDefense;
*/

_variable = _this select 0;
_center = _this select 1;
_center_distance = _this select 2;

if (profileNamespace getVariable ["CTI_PERSISTENT_HINTS", false]) then {
	hint parseText format["<t size='1.3' color='#2394ef'>%1</t><br /><br /><t align='justify'>%2<br /><br />
	%3<br /><br />
	%4<br /><br />
	- %5 <t align='right'><t color='#f4cb38'>%6</t></t><br />
	- %7 <t align='right'><t color='#f4cb38'>%8</t></t><br />
	- %9 <t align='right'><t color='#f4cb38'>%10</t></t><br />
	- %11 <t align='right'><t color='#f4cb38'>%12</t></t><br />
	- %13 <t align='right'><t color='#f4cb38'>%14</t></t><br /><br />
	- %15 <t align='right'><t color='#f4cb38'>%16</t></t><br />
	- %17 <t align='right'><t color='#f4cb38'>%18</t></t><br />
	- %19 <t align='right'><t color='#f4cb38'>%20</t></t><br />
	- %21 <t align='right'><t color='#f4cb38'>%22</t></t><br />
	- %23 <t align='right'><t color='#f4cb38'>%24</t></t><br /><br />
	- %25 <t align='right'><t color='#f4cb38'>%26</t></t><br /><br />
	%27<br /><br />
	%28<br /><br />
	</t>",
		localize "STR_Build_Hint_Title",
		localize "STR_Build_Hint_Intro",
		localize "STR_Def_Hint_Action_Def",
		localize "STR_Build_Hint_Keys_Title",
		localize "STR_Build_Hint_Rotate_Pos1", localize "STR_Build_Hint_Key_User1",
		localize "STR_Build_Hint_Rotate_Pos5", localize "STR_Build_Hint_Key_CtrlUser1",
		localize "STR_Build_Hint_Rotate_Pos45", localize "STR_Build_Hint_Key_ShiftUser1",
		localize "STR_Build_Hint_Dist_Pos1", localize "STR_Build_Hint_Key_AltUser1",
		localize "STR_Def_Hint_Height_Pos", localize "STR_Def_Hint_Key_CtrlAltUser1",
		localize "STR_Build_Hint_Rotate_Neg1", localize "STR_Build_Hint_Key_User2",
		localize "STR_Build_Hint_Rotate_Neg5", localize "STR_Build_Hint_Key_CtrlUser2",
		localize "STR_Build_Hint_Rotate_Neg45", localize "STR_Build_Hint_Key_ShiftUser2",
		localize "STR_Build_Hint_Dist_Neg1", localize "STR_Build_Hint_Key_AltUser2",
		localize "STR_Def_Hint_Height_Neg", localize "STR_Def_Hint_Key_CtrlAltUser2",
		localize "STR_Build_Hint_Reset", localize "STR_Build_Hint_Key_User3",
		localize "STR_Build_Hint_Note",
		localize "STR_Build_Hint_Filter"
	];
};

CTI_VAR_StructureCanceled = false;
CTI_P_PreBuilding = true;

CTI_P_KeyRotate = 0;
CTI_P_KeyDistance = 0;
CTI_P_KeyDistance_Min = -10;
CTI_P_KeyDistance_Max = 20;
CTI_P_KeyHeight = 0;
CTI_P_KeyHeight_Min = -5;
CTI_P_KeyHeight_Max = 20;

_deh = (findDisplay 46) displayAddEventHandler ["KeyDown", "nullReturn = _this spawn CTI_UI_KeyHandler_BuildMenu"];

_var = missionNamespace getVariable _variable;
_classname = _var select 1;

// SVB: морская точка появления может ставиться только на воду
_svb_is_naval_point = (_classname == "VR_Area_01_circle_4_grey_F");

_local = _classname createVehicleLocal [0,0,0];
_direction_structure = (_var select 4) select 0;
_distance_structure = (_var select 4) select 1;

{_local disableCollisionWith _x} forEach (player nearObjects 150);

_local enableSimulation false;
_local setpos (getPos player);

_last_collision_update = -600;
_condition = {true};
{if (_x select 0 == "Condition") exitWith {_condition = _x select 1}} forEach (_var select 5);

_action = player addAction ["<t color='#9CF863'>Place Defense</t>", "Client\Actions\Action_BuildingPlace.sqf","", 96, false, true, "", "CTI_P_PreBuilding_SafePlace"];
_action2 = player addAction ["<t color='#F86363'>Cancel Defense</t>", "Client\Actions\Action_BuildingPlace_Cancel.sqf"];

_dir = 0;
_pos = [];

while {!CTI_VAR_StructurePlaced && !CTI_VAR_StructureCanceled} do {
	_pos = player modelToWorld [0, _distance_structure + CTI_P_KeyDistance, CTI_P_KeyHeight];

	CTI_P_PreBuilding_SafePlace = if (
		_pos distance (((CTI_P_SideJoined) call CTI_CO_FNC_GetSideLogic) getVariable "cti_hq") > 15 &&
		_pos distance ([_pos, CTI_P_SideJoined call CTI_CO_FNC_GetSideStructures] call CTI_CO_FNC_GetClosestEntity) > 15 &&
		_pos distance ([_pos, ((CTI_P_SideJoined) call CTI_CO_FNC_GetSideLogic) getVariable "cti_structures_wip"] call CTI_CO_FNC_GetClosestEntity) > 15 &&
		_pos distance ([_pos, ((CTI_P_SideJoined) call CTI_CO_FNC_GetSideLogic) getVariable "cti_fobs"] call CTI_CO_FNC_GetClosestEntity) > 15 &&
		(if (_svb_is_naval_point) then {surfaceIsWater _pos} else {!surfaceIsWater _pos}) &&
		!(lineIntersects [
			ATLtoASL (player modelToWorld (player selectionPosition "pilot")),
			ATLtoASL (_local modelToWorld (_local selectionPosition "pilot")),
			player,
			_local
		])
	) then {true} else {false};

	if (time - _last_collision_update > 1.5) then {
		_last_collision_update = time;
		{_local disableCollisionWith _x} forEach (player nearObjects 150);
	};

	if (_center distance player > _center_distance || !alive _center) exitWith {
		CTI_VAR_StructureCanceled = true;
	};

	_dir = ([_local, player] call CTI_CO_FNC_GetDirTo) + _direction_structure + CTI_P_KeyRotate;
	_pos set [2, CTI_P_KeyHeight];

	_local setPos _pos;
	_local setDir _dir;

	sleep .01;
};

hintsilent "";

player removeAction _action;
player removeAction _action2;

CTI_P_PreBuilding = false;
deleteVehicle _local;

(findDisplay 46) displayRemoveEventHandler ["KeyDown", _deh];

if !(CTI_VAR_StructureCanceled) then {
	if (call _condition) then {
		_funds = call CTI_CL_FNC_GetPlayerFunds;

		if (_funds >= (_var select 2)) then {
			-(_var select 2) call CTI_CL_FNC_ChangePlayerFunds;

			["SERVER", "Request_Defense", [
				_variable,
				CTI_P_SideJoined,
				[_pos select 0, _pos select 1, _pos select 2],
				_dir,
				player,
				CTI_P_WallsAutoAlign,
				CTI_P_DefensesAutoManning,
				_center
			]] call CTI_CO_FNC_NetSend;
		} else {
			hint parseText "<t size='1.3' color='#2394ef'>Information</t><br /><br />You do not have enough funds to place that defense.";
		};

		_fob = false;
		{if (_x select 0 == "FOB") exitWith {_fob = true}} forEach (_var select 5);
		if (_fob) then {CTI_P_TeamsRequests_FOB = 0};
	} else {
		hint parseText "<t size='1.3' color='#2394ef'>Information</t><br /><br />Not all conditions are met to construct this defense.";
	};
};