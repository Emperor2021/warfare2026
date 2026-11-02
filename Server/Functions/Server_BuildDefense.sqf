/*
  # HEADER #
  	Script: 		Server\Functions\Server_BuildDefense.sqf
  	Alias:			CTI_SE_FNC_BuildDefense
  	Description:	Construct a defense at a given position
  	Author: 		Benny
  	Creation Date:	20-09-2013
  	Revision Date:	14-10-2013

  # PARAMETERS #
    0	[String]: The defense variable name
    1	[Side]: The Side which requested it
    2	[Array]: The position of the defense
    3	[Number]: The direction of the defense
    4	[Boolean]: Determine if an alignment is needed for walls
    5	{Optionnal} [Boolean]: Determine if the defense shall be manned or not

  # RETURNED VALUE #
  	[Object]: The constructed defense

  # SYNTAX #
  	[DEFENSE VARIABLE, SIDE, POSITION, DIRECTION, AUTOALIGN, MANNED] call CTI_SE_FNC_BuildDefense

  # DEPENDENCIES #
  	Common Function: CTI_CO_FNC_GetSideID
  	Common Function: CTI_CO_FNC_GetSideLogic
  	Common Function: CTI_CO_FNC_NetSend
  	Server Function: CTI_SE_FNC_HandleStaticDefenses
  	Server Function: funcCalcAlignPosDir

  # EXAMPLE #
    _defense = [_variable, CTI_P_SideJoined, [_pos select 0, _pos select 1], _dir, CTI_P_WallsAutoAlign, CTI_P_DefensesAutoManning] call CTI_SE_FNC_BuildDefense;
*/

private ["_autoalign", "_center", "_defense", "_direction", "_direction_structure", "_fob", "_isMine", "_limit", "_logic", "_manned", "_mineClassname", "_origin", "_position", "_ruins", "_side", "_stronger", "_var", "_varname"];

_varname = _this select 0;
_var = missionNamespace getVariable _varname;
_side = _this select 1;
_position = _this select 2;
_direction = _this select 3;
_origin = _this select 4;
_autoalign = _this select 5;
_manned = if (count _this > 6) then {_this select 6} else {false};
_center = if (count _this > 7) then {_this select 7} else {objNull};
_logic = (_side) call CTI_CO_FNC_GetSideLogic;

//--- Get the classname first
_mineClassname = _var select 1;

//--- Check if this is a mine
_isMine = false;
{if (_mineClassname isEqualTo _x) exitWith {_isMine = true}} forEach ["ATMine", "APERSMine", "APERSBoundingMine", "APERSTripMine"];

//--- Is it a fob?
_fob = false;
_limit = false;
{if (_x select 0 == "FOB") exitWith {_fob = true}} forEach (_var select 5);
if (_fob) then {if (count(_logic getVariable "cti_fobs") >= CTI_BASE_FOB_MAX) then {_limit = true}};
if (_limit) exitWith {};

//--- Ensure Z is preserved from client
if (count _position < 3) then { _position set [2, 0]; };
if (_fob) then {
	_position=[_position, 15] call CTI_CO_FNC_GetEmptyPosition;
};

//--- Create the defense object
if (_isMine) then {
	//--- Mines: use createMine + addOwnedMine to activate
	_defense = createMine [_mineClassname, _position, [], 0];
	//--- Register mine with a unit from the side to make it active
	_sideUnits = allUnits select {side _x == _side};
	if (count _sideUnits > 0) then {
		(_sideUnits select 0) addOwnedMine _defense;
	} else {
		//--- No units on server, create a dummy unit to own the mine
		_dummy = _side createUnit ["B_survivor_F", _position, [], 0, "NONE"];
		_dummy addOwnedMine _defense;
		deleteVehicle _dummy;
	};
	//--- Cleanup mine after explosion
	[_defense, _logic, _varname] spawn {
		params ["_mine", "_mineLogic", "_mineVarname"];
		waitUntil {isNull _mine || !alive _mine};
		sleep 1;
		_mineLogic setVariable ["cti_defences",(_mineLogic getVariable "cti_defences") - [objNull, _mine], true];
	};
} else {
	//--- Regular defense: use createVehicle
	_defense = _mineClassname createVehicle _position;
};

_logic setVariable ["cti_defences",((_logic getVariable "cti_defences")+ [_defense] - [objNull]),true];

//--- Mines are not spawn points
if !_isMine then {
	if (!isNil "svb_fnc_registerSpawnPoint") then {
		[_defense, _varname, _side, _position, _direction, _center] call svb_fnc_registerSpawnPoint;
	};
};

[["CLIENT", _side], "Client_HandleDefense", _defense] call CTI_CO_FNC_NetSend;

_direction_structure = (_var select 4) select 0;

if (_defense isKindOf "Building") then {
	if (_autoalign) then {
		private ["_autoSupport", "_correction", "_offsetZ", "_width"];
		_autoSupport = [];
		{if (_x select 0 == "CanAutoAlign") exitWith {_autoSupport = _x}} forEach (_var select 5);

		if (count _autoSupport > 0) then {
			_width = _autoSupport select 1;
			_offsetZ = _autoSupport select 2; //todo
			_correction = [_defense, _position, _direction, _width, _offsetZ, _direction_structure] call funcCalcAlignPosDir;
			_position = _correction select 0;
			_direction = _correction select 1;
		};
	};
};

if (_fob) then {
	[["CLIENT", _side], "Client_OnSpecialConstructed", [_defense, "FOB"]] call CTI_CO_FNC_NetSend;
	_logic setVariable ["cti_fobs", (_logic getVariable "cti_fobs") + [_defense], true];

};

_defense setVariable ["cti_save",[_varname,[_position,_direction],_manned],false];

if !_isMine then {
	_defense setDir _direction;
	_defense setPosATL _position;
};

if (_defense emptyPositions "gunner" < 1 && !_isMine && !_fob) then { //--- Soft defense
	_defense setDir _direction;
	// _defense setVectorUp [0,0,0];
	if !(isNull _origin) then {[["CLIENT", _origin], "Client_ReceiveDefense", _defense] call CTI_CO_FNC_NetSend};
};

//--- Make the defense stronger?
_stronger = -1;
{if (_x select 0 == "DMG_Reduce") exitWith {_stronger = _x select 1}} forEach (_var select 5);
if (_stronger != -1 && !_isMine) then {
	_defense addEventHandler ["handleDamage", format["getDammage (_this select 0)+(_this select 2)/%1",_stronger]];
};

//--- Check if the defense has a ruin model attached (we don't wana have a cemetery of wrecks)
_ruins = "";
{if (_x select 0 == "RuinOnDestroyed") exitWith {_ruins = _x select 1}} forEach (_var select 5);

//--- Mines don't have killed EH, they are cleaned up automatically
if !_isMine then {
	_defense addEventHandler ["killed", format["[_this select 0, _this select 1, %1, '%2', '%3'] spawn CTI_SE_FNC_OnDefenseDestroyed", _side call CTI_CO_FNC_GetSideID, _ruins, _varname]];
};

if (_defense emptyPositions "gunner" > 0 && !_isMine) then { //--- Hard defense
	//todo: determine if the defense is "auto" or not via config simulation
	[_defense, CTI_BASE_DEFENSES_EMPTY_TIMEOUT] spawn CTI_SE_FNC_HandleEmptyVehicle; //--- Track the defense lifespan

	//--- The defense is eligible for auto manning
	if (_manned && CTI_BASE_DEFENSES_AUTO_LIMIT > 0) then {_defense setVariable ["cti_aman_enabled", true]};



};

if (_defense isKindOf "B_supplyCrate_F") then {
	clearBackpackCargoGlobal _defense;
	clearItemCargoGlobal _defense;
	clearMagazineCargoGlobal _defense;
	clearWeaponCargoGlobal _defense;
};

if (CTI_BASE_FOB_MAX > 0 && _defense isKindOf "Land_Cargo_Tower_V1_F") then {
	_defense setVariable ["cti_tower_side", _side, true];
	[["CLIENT", _side], "Client_OnBigTowerConstructed", _defense] call CTI_CO_FNC_NetSend;
};
if (_defense isKindOf "Radar_System_01_base_F" || _defense isKindOf "Radar_System_02_base_F" || _defense isKindOf "SAM_System_01_base_F" || _defense isKindOf "SAM_System_02_base_F" || _defense isKindOf "SAM_System_03_base_F" || _defense isKindOf "SAM_System_04_base_F" || _defense isKindOf "AAA_System_01_base_F" || _defense isKindOf "B_Ship_Gun_01_base_F" || _defense isKindOf "B_Ship_MRLS_01_base_F") then {
    private _crewClass = if (_side == west) then {"B_crew_F"} else {"O_crew_F"};
    private _defGrp = createGroup _side;
    
    // Сколько всего мест экипажа нужно занять
    private _crewNeeded = (_defense emptyPositions "gunner") 
                        + (_defense emptyPositions "commander") 
                        + (_defense emptyPositions "driver");
    
    // Создаём бойцов нужной стороны и сразу сажаем в установку
    for "_i" from 1 to _crewNeeded do {
        private _crewman = _defGrp createUnit [_crewClass, getPos _defense, [], 0, "NONE"];
        _crewman moveInAny _defense;
    };
    
    _defGrp setBehaviour "COMBAT";
    _defGrp setCombatMode "RED";
    _defense setVehicleRadar 1;
    _defense setVehicleLock "UNLOCKED";
};
if (missionNamespace getVariable "CTI_TROPHY_APS" == 1) then {
	_defense addEventHandler["Fired","_this call TR_HANDLER;"];
};

//artillery radar revamp
if (missionNamespace getVariable "CTI_SM_RADAR" == 1) then {
	_defense addEventHandler["Fired","_this call ARTR_HANDLER;"];
};


if ((!isNil "ADMIN_ZEUS") && !_isMine) then { ADMIN_ZEUS addCuratorEditableObjects [[_defense],true];};

_defense
