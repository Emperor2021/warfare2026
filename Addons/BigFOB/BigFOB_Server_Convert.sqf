
private ["_defenses","_dir","_group","_logic","_object","_objects","_pos","_side","_sideID","_target","_type","_typeAA","_typeAT","_typeGL","_typeMG","_typeM","_typeComm","_unit","_walls"];

_target = _this;

_side = _target getVariable "cti_tower_side";
_sideID = (_side) call CTI_CO_FNC_GetSideID;
_logic = (_side) call CTI_CO_FNC_GetSideLogic;
_fobs = _logic getVariable "cti_fobs";

if (not alive _target || (_target in _fobs)) exitWith {};

_pos = getPosASL _target;
_dir = getDir _target;



_target addEventHandler ["handleDamage",{getDammage (_this select 0) + (_this select 2) / 10}];



BuildWalls = {
	_objects = [];
	{
		_object = createVehicle [_x select 0, _target, [], 0, "CAN_COLLIDE"];
		_object attachTo [_target,_x select 1];
		detach _object;
		_object setDir ((getDir _target) + (_x select 2));
		if ((count _x) > 3) then {[_object, _x select 3, _x select 4] call BIS_fnc_setPitchBank};
		_object enableSimulationGlobal false;
		_objects = _objects + [_object];
	} forEach _this;
	_objects
};

_walls = [
["Land_CncWall4_F",[-6.3,-3.3,-18.05],270],
["Land_CncWall4_F",[-3.3,-6.3,-18.05],180],
["Land_CncWall4_F",[-6.3,3.3,-18.05],270],
["Land_CncWall4_F",[-3.3,6.3,-18.05],0],
["Land_CncWall4_F",[3.3,-6.3,-18.05],180],
["Land_CncWall4_F",[6.3,-3.3,-18.05],90],
["Land_CncWall4_F",[3.3,6.3,-18.05],0],
["Land_CncWall4_F",[6.3,3.3,-18.05],90],

["Land_CncWall4_F",[-6.3,-3.3,-14.55],270],
["Land_CncWall4_F",[-3.3,-6.3,-14.55],180],
["Land_CncWall4_F",[-6.3,3.3,-14.55],270],
["Land_CncWall4_F",[-3.3,6.3,-14.55],0],
["Land_CncWall4_F",[3.3,-6.3,-14.55],180],
["Land_CncWall4_F",[6.3,-3.3,-14.55],90],
["Land_CncWall4_F",[3.3,6.3,-14.55],0],
["Land_CncWall4_F",[6.3,3.3,-14.55],90],


["Land_CncWall4_F",[-6.3,-3.3,-11.05],270],
["Land_CncWall4_F",[-3.3,-6.3,-11.05],180],
["Land_CncWall4_F",[-6.3,3.3,-11.05],270],
["Land_CncWall4_F",[-3.3,6.3,-11.05],0],
["Land_CncWall4_F",[3.3,-6.3,-11.05],180],
["Land_CncWall4_F",[6.3,-3.3,-11.05],90],
["Land_CncWall4_F",[3.3,6.3,-11.05],0],
["Land_CncWall4_F",[6.3,3.3,-11.05],90],

["Land_CncWall1_F",[-6.3,0,-7.55],270],
["Land_CncWall4_F",[-6.3,-3.3,-7.55],270],
["Land_CncWall4_F",[-3.3,-6.3,-7.55],180],
["Land_CncWall4_F",[-6.3,3.3,-7.55],270],
["Land_CncWall1_F",[0,-6.3,-7.55],180],
["Land_CncWall4_F",[-3.3,6.3,-7.55],0],
["Land_CncWall1_F",[0,6.3,-7.55],0],
["Land_CncWall4_F",[3.3,-6.3,-7.55],180],
["Land_CncWall1_F",[6.3,0,-7.55],90],
["Land_CncWall4_F",[6.3,-3.3,-7.55],90],
["Land_CncWall4_F",[3.3,6.3,-7.55],0],
["Land_CncWall4_F",[6.3,3.3,-7.55],90],

["Land_CncWall1_F",[-6.3,0,-4.05],270],
["Land_CncWall4_F",[-6.3,-3.3,-4.05],270],
["Land_CncWall4_F",[-3.3,-6.3,-4.05],180],
["Land_CncWall4_F",[-6.3,3.3,-4.05],270],
["Land_CncWall1_F",[0,-6.3,-4.05],180],
["Land_CncWall4_F",[-3.3,6.3,-4.05],0],
["Land_CncWall1_F",[0,6.3,-4.05],0],
["Land_CncWall4_F",[3.3,-6.3,-4.05],180],
["Land_CncWall1_F",[6.3,0,-4.05],90],
["Land_CncWall4_F",[6.3,-3.3,-4.05],90],
["Land_CncWall4_F",[3.3,6.3,-4.05],0],
["Land_CncWall4_F",[6.3,3.3,-4.05],90],

["Land_CncWall1_F",[-6.3,0,-0.55],270],
["Land_CncWall4_F",[-6.3,-3.3,-0.55],270],
["Land_CncWall4_F",[-3.3,-6.3,-0.55],180],
["Land_CncWall4_F",[-6.3,3.3,-0.55],270],
["Land_CncWall1_F",[0,-6.3,-0.55],180],
["Land_CncWall4_F",[-3.3,6.3,-0.55],0],
["Land_CncWall1_F",[0,6.3,-0.55],0],
["Land_CncWall4_F",[3.3,-6.3,-0.55],180],
["Land_CncWall1_F",[6.3,0,-0.55],90],
["Land_CncWall4_F",[6.3,-3.3,-0.55],90],
["Land_CncWall4_F",[3.3,6.3,-0.55],0],
["Land_CncWall4_F",[6.3,3.3,-0.55],90]
];

_walls = (_walls) call BuildWalls;
_target setVariable ["cti_tower_walls", _walls, true];



if (_side == west) then {_typeAA = "B_static_AA_F";_typeAT = "B_static_AT_F";_typeGL = "B_GMG_01_high_F";_typeMG = "B_HMG_01_high_F";_typeM = "B_Mortar_01_F";_typeComm = "B_officer_F";};
if (_side == east) then {_typeAA = "O_static_AA_F";_typeAT = "O_static_AT_F";_typeGL = "O_GMG_01_high_F";_typeMG = "O_HMG_01_high_F";_typeM = "O_Mortar_01_F";_typeComm = "O_officer_F";};

BuildDefenses = {
	_objects = [];
	{
		_type = _x select 0;
		_type = switch (_type) do { 
			case "AA": {_typeAA};
			case "AT": {_typeAT};
			case "GL": {_typeGL};
			case "MG": {_typeMG};
			case "M": {_typeM};
			default {_typeGL};
		};
		_object = createVehicle [_type, _target, [], 0, "CAN_COLLIDE"];
		_object attachTo [_target,_x select 1];
		detach _object;
		_object setDir ((getDir _target) + (_x select 2));
		_object setVariable ["cti_tower_defense_position", getPosASL _object, true];
		_object setVariable ["cti_tower_defense_direction", getDir _object, true];
		sleep 1;
		[_object, 0, 0] call BIS_fnc_setPitchBank;
		_object addEventHandler ["handleDamage", {false}];
		_object allowDamage false;
		_object lock 3; //---  Locked for players
		_objects = _objects + [_object];
	} forEach _this;
	_objects
};

_defenses = [
["AA",[-4.25,4.25,6],315],
["AA",[-2,4.25,6],45],
["AA",[4.71,4,6],45],
["AA",[4.75,-3,6],135],
["AA",[-1.65,-5.25,5.9],135],
["AA",[-4.2,-5.3,5.9],225],
["AA",[-4.5,-2,6],270],

["MG",[5,4.5,1.55],225],
["GL",[-4.5,-4.5,1.65],180],
["GL",[5,-1,1.65],90],
["GL",[-2.75,4.25,1.65],0],
//["GL",[6.15,4,4.2],90],
//["GL",[-5.9,1.95,4.2],270],
//["GL",[-5.9,4.45,4.2],270],

["MG",[0,0,-11.05],0]
];

_defenses = (_defenses) call BuildDefenses;
_target setVariable ["cti_tower_defenses", _defenses, true];



_group = createGroup _side;
_group setGroupIDGlobal ["Defense Team FOB"];
_target setVariable ["cti_tower_defense_group", _group, true];
_unit = [_typeComm, _group, _target, _sideID, true, "NONE"] call CTI_CO_FNC_CreateUnit;
//_unit setPosASL _pos;
_unit attachTo [_target,[-2.85,-2,3.5]];
detach _unit;
_unit setDir _dir;
sleep 1;
_target setVariable ["cti_tower_defense_spawn", getPosASL _unit, true];
_unit addEventHandler ["handleDamage", {false}];
_unit allowDamage false;
_unit disableAI "PATH";
_unit disableAI "MOVE";
removeAllWeapons _unit;



(_target) spawn CTI_SE_FNC_BigFOB_Loop;



[["CLIENT", _side], "Client_OnSpecialConstructed", [_target, "FOB"]] call CTI_CO_FNC_NetSend;
_logic setVariable ["cti_fobs", (_logic getVariable "cti_fobs") + [_target], true];
_logic setVariable ["cti_defences", (_logic getVariable "cti_defences") - [objNull, _target], true];
