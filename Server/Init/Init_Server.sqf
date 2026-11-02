//todo: Kerberos Tracker -> perma track main infos with clients UID (teamkills, kills, hq killed (ff/no ff)).

//--- Create a resistance center
createCenter resistance;
resistance setFriend [west, 0];
resistance setFriend [east, 0];

clearRadio; systemChat "Start load files";
CTI_SE_FNC_AddScore = compileFinal preprocessFileLineNumbers "Server\Functions\Server_AddScore.sqf"; clearRadio; systemChat "Server_AI_PurchaseSquad";
CTI_SE_FNC_AI_PurchaseSquad = compileFinal preprocessFileLineNumbers "Server\Functions\Server_AI_PurchaseSquad.sqf"; clearRadio; systemChat "Server_BuildStructure";
CTI_SE_FNC_BuildStructure = compileFinal preprocessFileLineNumbers "Server\Functions\Server_BuildStructure.sqf"; clearRadio; systemChat "Server_BuildDefense";
CTI_SE_FNC_BuildDefense = compileFinal preprocessFileLineNumbers "Server\Functions\Server_BuildDefense.sqf"; clearRadio; systemChat "Server_CreateWorker";
CTI_SE_FNC_CreateWorker = compileFinal preprocessFileLineNumbers "Server\Functions\Server_CreateWorker.sqf";  clearRadio; systemChat "Server_HandleAIPurchase";
CTI_SE_FNC_HandleAIPurchase = compileFinal preprocessFileLineNumbers "Server\Functions\Server_HandleAIPurchase.sqf"; clearRadio; systemChat "Server_HandleEmptyVehicle";
CTI_SE_FNC_HandleEmptyVehicle = compileFinal preprocessFileLineNumbers "Server\Functions\Server_HandleEmptyVehicle.sqf"; clearRadio; systemChat "Server_HandleStaticDefenses";
CTI_SE_FNC_HandleStaticDefenses = compileFinal preprocessFileLineNumbers "Server\Functions\Server_HandleStaticDefenses.sqf"; clearRadio; systemChat "Server_HandleStructureConstruction";
CTI_SE_FNC_HandleStructureConstruction = compileFinal preprocessFileLineNumbers "Server\Functions\Server_HandleStructureConstruction.sqf"; clearRadio; systemChat "Server_InitializeGroup";
CTI_SE_FNC_InitializeGroup = compileFinal preprocessFileLineNumbers "Server\Functions\Server_InitializeGroup.sqf"; clearRadio; systemChat "Server_InitializeStructure";
CTI_SE_FNC_InitializeStructure = compileFinal preprocessFileLineNumbers "Server\Functions\Server_InitializeStructure.sqf"; clearRadio; systemChat "Server_NoobLogger";
CTI_SE_FNC_NoobLogger = compileFinal preprocessFileLineNumbers "Server\Functions\Server_NoobLogger.sqf"; clearRadio; systemChat "Server_NoobLoggerEnd";
CTI_SE_FNC_NoobLoggerEnd = compileFinal preprocessFileLineNumbers "Server\Functions\Server_NoobLoggerEnd.sqf"; clearRadio; systemChat "Server_ObservateEnvironment";
CTI_SE_FNC_ObservateEnvironment = compileFinal preprocessFileLineNumbers "Server\Functions\Server_ObservateEnvironment.sqf"; clearRadio; systemChat "Server_OnBuildingDestroyed";
CTI_SE_FNC_OnBuildingDestroyed = compileFinal preprocessFileLineNumbers "Server\Functions\Server_OnBuildingDestroyed.sqf"; clearRadio; systemChat "Server_OnBuildingHandleDamage";
CTI_SE_FNC_OnBuildingHandleDamage = compileFinal preprocessFileLineNumbers "Server\Functions\Server_OnBuildingHandleDamage.sqf"; clearRadio; systemChat "Server_OnBuildingHandleVirtualDamage";
CTI_SE_FNC_OnBuildingHandleVirtualDamage = compileFinal preprocessFileLineNumbers "Server\Functions\Server_OnBuildingHandleVirtualDamage.sqf"; clearRadio; systemChat "Server_OnBuildingHit";
CTI_SE_FNC_OnBuildingHit = compileFinal preprocessFileLineNumbers "Server\Functions\Server_OnBuildingHit.sqf"; clearRadio; systemChat "Server_OnClientPurchase";
CTI_SE_FNC_OnClientPurchase = compileFinal preprocessFileLineNumbers "Server\Functions\Server_OnClientPurchase.sqf"; clearRadio; systemChat "Server_OnClientPurchaseCancelled";
CTI_SE_FNC_OnClientPurchaseCancelled = compileFinal preprocessFileLineNumbers "Server\Functions\Server_OnClientPurchaseCancelled.sqf"; clearRadio; systemChat "Server_OnClientPurchaseComplete";
CTI_SE_FNC_OnClientPurchaseComplete = compileFinal preprocessFileLineNumbers "Server\Functions\Server_OnClientPurchaseComplete.sqf"; clearRadio; systemChat "Server_OnDefenseDestroyed";
CTI_SE_FNC_OnDefenseDestroyed = compileFinal preprocessFileLineNumbers "Server\Functions\Server_OnDefenseDestroyed.sqf"; clearRadio; systemChat "Server_OnHQDestroyed";
CTI_SE_FNC_OnHQDestroyed = compileFinal preprocessFileLineNumbers "Server\Functions\Server_OnHQDestroyed.sqf"; clearRadio; systemChat "Server_OnTownCaptured";
CTI_SE_FNC_OnTownCaptured = compileFinal preprocessFileLineNumbers "Server\Functions\Server_OnTownCaptured.sqf"; systemChat "Server_RepairHQ";
CTI_SE_FNC_RepairHQ = compileFinal preprocessFileLineNumbers "Server\Functions\Server_RepairHQ.sqf"; clearRadio; clearRadio; systemChat "Server_SpawnTownOccupation";
CTI_SE_FNC_SpawnTownOccupation = compileFinal preprocessFileLineNumbers "Server\Functions\Server_SpawnTownOccupation.sqf"; clearRadio; systemChat "Server_SpawnTownResistance";
CTI_SE_FNC_SpawnTownResistance = compileFinal preprocessFileLineNumbers "Server\Functions\Server_SpawnTownResistance.sqf"; clearRadio; systemChat "Server_StartFactoryQueue";
CTI_SE_FNC_StartFactoryQueue = compileFinal preprocessFileLineNumbers "Server\Functions\Server_StartFactoryQueue.sqf"; clearRadio; systemChat "Server_StartUpgrade";
CTI_SE_FNC_StartUpgrade = compileFinal preprocessFileLineNumbers "Server\Functions\Server_StartUpgrade.sqf"; clearRadio; systemChat "Server_TrashObject";
CTI_SE_FNC_TrashObject = compileFinal preprocessFileLineNumbers "Server\Functions\Server_TrashObject.sqf"; clearRadio; systemChat "Server_CacheVehicle";
CTI_SE_FNC_Cache = compileFinal preprocessFileLineNumbers "Server\Functions\Server_CacheVehicle.sqf"; clearRadio; systemChat "Server_UpdateBaseAreas";
CTI_SE_FNC_UpdateBaseAreas = compileFinal preprocessFileLineNumbers "Server\Functions\Server_UpdateBaseAreas.sqf";
CTI_SE_FNC_DeleteSelectedBot = compileFinal preprocessFileLineNumbers "Server\Functions\Server_DeleteSelectedBot.sqf";

clearRadio; systemChat "Load fVectors files";
funcCalcAlignPosDir = compileFinal preprocessFileLineNumbers "Server\Functions\Externals\fCalcAlignPosDir.sqf";
funcVectorAdd = compileFinal preprocessFileLineNumbers "Server\Functions\Externals\fVectorAdd.sqf";
funcVectorCross = compileFinal preprocessFileLineNumbers "Server\Functions\Externals\fVectorCross.sqf";
funcVectorDot = compileFinal preprocessFileLineNumbers "Server\Functions\Externals\fVectorDot.sqf";
funcVectorScale = compileFinal preprocessFileLineNumbers "Server\Functions\Externals\fVectorScale.sqf";
funcVectorSub = compileFinal preprocessFileLineNumbers "Server\Functions\Externals\fVectorSub.sqf";

//--- Load Structures
clearRadio; systemChat "Load Structures...";
call compile preprocessFileLineNumbers "Addons\map_structures\initMapStructures.sqf";
call compile preprocessFileLineNumbers "Addons\map_structures\initTownStructures.sqf";

clearRadio; systemChat "Load FSM files...";

call compile preprocessFileLineNumbers "Server\Init\Init_PublicVariables.sqf";
call compile preprocessFileLineNumbers "Server\Functions\FSM\Functions_FSM_RepairTruck.sqf";
call compile preprocessFileLineNumbers "Server\Functions\FSM\Functions_FSM_UpdateAI.sqf";
call compile preprocessFileLineNumbers "Server\Functions\FSM\Functions_FSM_UpdateCommander.sqf";

/*
clearRadio; systemChat "Load TUTORIAL files...";

execVM "Server\Init\Init_Prison.sqf";
execVM "Addons\Strat_mode\Functions\TUTORIAL_Init.sqf";
*/
clearRadio; systemChat "Load settings...";

CTI_Structure_Lock=False;
CTI_Worker_Lock=False;


_rand = random(1);
if (_rand >0.1) then { 0 setOvercast 0; 0 setFog 0; forceWeatherChange; };
if (_rand >0.75) then { 0 setOvercast random(1); forceWeatherChange; };
setWind [floor random[1,3,5], floor random[0,2,5], true];
diag_log"start weather change";


CENTER_POS=getMarkerPos "CENTER_POS";
"CENTER_POS" setmarkeralpha 0;
CENTER_RADIUS=(getMarkerSize "CENTER_POS")select 0;
_locations= CENTER_POS nearroads CENTER_RADIUS;
_attempts = 0;
_real_attempts = 0;
// дистанция между hq при начале игрый
_asked = round(random[15000,18000,20000]);

waitUntil {CTI_InitTowns};
_eastLocation=CENTER_POS;
_westLocation=CENTER_POS;
while {(_eastLocation distance _westLocation) <(_asked)*0.95 ||(_eastLocation distance _westLocation) >( _asked)*1.25 || {(_x distance _eastLocation)<600} count CTI_Towns>0 || {(_x distance _westLocation)<600} count CTI_Towns>0 ||(_eastLocation distance CENTER_POS) > ( _asked)*1.2 ||(_westLocation distance CENTER_POS) > ( _asked)*1.2 } do {
	while {random(1)>0.2}do {
		_a="BiS pseudo-random number Generator is crappy";
	};
	_eastLocation=_locations call BIS_fnc_selectRandom;
	_westLocation=_locations call BIS_fnc_selectRandom;
	_attempts =_attempts +1;
	_real_attempts =_real_attempts +1;
	if (_attempts >40000) Then {
		_asked = _asked*0.9;
		_attempts=0;
		diag_log format ["Procedural starting point failed reducing distance to distance %1",_asked];
	};

};
diag_log format ["Procedural starting point took %1 distance %2",_real_attempts,(_eastLocation distance _westLocation)];

_group = createGroup resistance;
_unit = _group createUnit ["I_Survivor_F", [0,0,0], [], 0, "NONE"];
CTI_AI_Skill = skill _unit;
CTI_AI_Skill_Array = [
	_unit skill "aimingAccuracy",
	_unit skill "aimingShake",
	_unit skill "aimingSpeed",
	_unit skill "endurance",
	_unit skill "spotDistance",
	_unit skill "spotTime",
	_unit skill "courage",
	_unit skill "reloadSpeed",
	_unit skill "commanding",
	_unit skill "general"
];
deleteVehicle _unit;
deleteGroup _group;

HELO_STARTUP=[];
_i=0;
while {! (((getMarkerPos format ["HELO_START_%1", _i])select 0) == 0)} do
{
    if (((getMarkerPos format ["HELO_START_%1", _i]) distance CENTER_POS)<CENTER_RADIUS) then { HELO_STARTUP set [count HELO_STARTUP,getMarkerPos format ["HELO_START_%1", _i]]};
    _i=_i+1;
};


{
	_side = _x select 0;
	_logic = _x select 1;
	_startPos = _x select 2;
	_sideID = _side call CTI_CO_FNC_GetSideID;

	_hq = [missionNamespace getVariable Format["CTI_%1_HQ", _side], _startPos, 0, _side, true, true] call CTI_CO_FNC_CreateVehicle;
//////////////////////////////////////////////////////////////////////////////////////////////           
    if (typeOf _hq == "O_APC_Wheeled_02_rcws_F") then {        
        _hq animate ["HideTurret",1];
        _hq removeWeapon"HMG_127_APC";
        _hq removeWeapon"GMG_40mm";
        [_hq,["Hex",1],["showBags",0,"showCanisters",1,"showTools",0,"showCamonetHull",1,"showSLATHull",0]] call BIS_fnc_initVehicle;        
    };
    
    if (typeOf _hq == "B_APC_Wheeled_01_cannon_F") then {        
        _hq animate ["HideTurret",1];
        _hq removeWeapon"LMG_M200_body";
        _hq removeWeapon"autocannon_40mm_CTWS";
        [_hq,["Sand",1],["showBags",0,"showCamonetHull",1,"showCamonetTurret",0,"showSLATHull",0,"showSLATTurret",0]] call BIS_fnc_initVehicle; 
    };              
//////////////////////////////////////////////////////////////////////////////////////////////     
	_hq setVariable ["cti_gc_noremove", true]; //--- HQ wreck cannot be removed nor salvaged
	_hq setVariable ["cti_ai_prohib", true]; //--- HQ may not be used by AI as a commandable vehicle
	//_hq addEventHandler ["getIn", {_this spawn CTI_CO_FNC_OnUnitGetOut}];
	//_hq addEventHandler ["getOut", {_this spawn CTI_CO_FNC_OnUnitGetOut}];
	_hq setVariable ["cti_occupant", _side,true];
	// ИСПРАВЛЕНИЕ БАГА #4: format заменён на anonymous handler (безопасно и правильно)
	_hq addEventHandler ["killed", {
		[_this select 0, _this select 1, CTI_P_SideID] spawn CTI_SE_FNC_OnHQDestroyed
	}];
	if (CTI_BASE_NOOBPROTECTION == 1) then {
		_hq addEventHandler ["handleDamage", {
			[_this select 2, _this select 3, CTI_P_SideID] call CTI_CO_FNC_OnHQHandleDamage
		}]; //--- You want that on public
	};



	//--- Generic per-logic variables
	_logic setVariable ["cti_hq", _hq, true];
	_logic setVariable ["cti_structures_wip", [],true];
	_logic setVariable ["cti_structures", [], true];
	_logic setVariable ["cti_structures_areas", [], true];
	_logic setVariable ["cti_structures_lasthit", -600];
	_logic setVariable ["cti_workers", [], true];
	_logic setVariable ["cti_commander", grpNull, true];
	_logic setVariable ["cti_commander_funds", missionNamespace getVariable format ["CTI_ECONOMY_STARTUP_FUNDS_%1_COMMANDER", _side], true];
	_logic setVariable ["cti_pool_award", missionNamespace getVariable format ["CTI_ECONOMY_POOL_AWARD_PERCENTAGE_%1", _side], true];
	_logic setVariable ["cti_pool_resources", missionNamespace getVariable format ["CTI_ECONOMY_POOL_RESOURCES_PERCENTAGE_%1", _side], true];
	_logic setVariable ["cti_salvagers", [], true];
	_logic setVariable ["cti_spotted_units", []];
	_logic setVariable ["cti_spotted_structures", []];
	_logic setVariable ["cti_defences", [],true];
	_logic setVariable ["cti_service", [],true];
	_upgrades = [];
	_maxUpgradesConfig = missionNamespace getVariable format["CTI_%1_UPGRADES_LEVELS", _side];
	_startMaxUpgrades = (missionNamespace getVariable ["CTI_UPGRADES_START_LEVEL", 0]) == 1;

	if (_startMaxUpgrades) then {
		// Если выбран быстрый старт на максимум — клонируем лимиты уровней напрямую
		{ _upgrades pushBack _x } forEach _maxUpgradesConfig;
	} else {
		// Классический старт — забиваем массив нулями
		for '_i' from 1 to count(_maxUpgradesConfig) do { _upgrades pushBack 0 };
	};

	if ((missionNamespace getvariable "CTI_VEHICLES_AIR_FFAR")==2) then {_upgrades set [CTI_UPGRADE_AIR_FFAR,1]};
	if ((missionNamespace getvariable "CTI_VEHICLES_AIR_AT") ==2)then {_upgrades set [CTI_UPGRADE_AIR_AT,1]};
	if( (missionNamespace getvariable "CTI_VEHICLES_AIR_AA")==2 ) then {_upgrades set [CTI_UPGRADE_AIR_AA,1]};
	if ((missionNamespace getvariable "CTI_VEHICLES_AIR_CM")==2) then {_upgrades set [CTI_UPGRADE_AIR_CM,1]};
	if ((missionNamespace getvariable "CTI_TOWNS_OCCUPATION")==0) then {_upgrades set [CTI_UPGRADE_TOWNS,10]};
	// for '_i' from 1 to count(missionNamespace getVariable format["CTI_%1_UPGRADES_LEVELS", _side]) do { _upgrades pushback 1 };
	_logic setVariable ["cti_upgrades", _upgrades, true];
	_logic setVariable ["cti_upgrade", -1, true];
	_logic setVariable ["cti_upgrade_lt", -1, true];

	_logic setVariable ["cti_ai_skill", CTI_AI_Skill, true];
	_logic setVariable ["cti_ai_skill_array", CTI_AI_Skill_Array, true];


	//--- Create the defensive teams if needed
if (CTI_BASE_DEFENSES_AUTO_LIMIT > 0) then {
    _defense_team = createGroup _side;
    _defense_team setGroupIDGlobal ["Defense Team"];

    // Помечаем группу как оборонительную, чтобы чистки её не трогали
    _defense_team setVariable ["cti_defense_team", true, true];
    _defense_team setVariable ["cti_gc_noremove", true, true];

    // Запрещаем движку удалять пустую группу
    _defense_team deleteGroupWhenEmpty false;

    _logic setVariable ["cti_defensive_team", _defense_team, true];
};

	//--- Add FOB if needed
	if (CTI_BASE_FOB_MAX > 0) then {_logic setVariable ["cti_fobs", [], true]};

	//--- Startup vehicles
	{
		_model = _x select 0;
		_equipment = _x select 1;
		_roads=_startPos nearroads 75;
		_no_roads=_startPos nearroads 25;
		_position= (_roads-_no_roads) call BIS_fnc_selectRandom;
		_vehicle = [_model, _position, 0, _side, false, true, true] call CTI_CO_FNC_CreateVehicle;                      
		//[_vehicle, getPos _hq, 45, 60, true, false, true] call CTI_CO_FNC_PlaceNear;
		[_vehicle] spawn CTI_SE_FNC_HandleEmptyVehicle;          
		if (count _equipment > 0) then {[_vehicle, _equipment] call CTI_CO_FNC_EquipVehicleCargoSpace};
		if ((missionNamespace getVariable [format ["%1", _model],["","","","","","","",""]]) select 7 != "") then {[_vehicle, _side, ((missionNamespace getVariable [format ["%1", _model],["","","","","","","",""]]) select 7)] call CTI_CO_FNC_InitializeCustomVehicle;};
	} forEach (missionNamespace getVariable format["CTI_%1_Vehicles_Startup", _side]);


	

	0 spawn {
		waitUntil {CTI_Init_Server};
		while {! CTi_GameOver} do {
			{
				_unit=_x;
				_group=group _x;
				_side=side _group;
				_side_logic=(_side) call CTI_CO_FNC_GetSideLogic;
				_sideID=_side call CTI_CO_FNC_GetSideID;
				if (!(isPlayer _unit) && (_side in [east,west]) && ((_side == west && CTI_AI_TEAMS_ENABLED == 1) || (_side == east && CTI_AI_TEAMS_ENABLED == 2) || CTI_AI_TEAMS_ENABLED == 3)) then {
					if ({!(isPlayer leader _x)} count (_side_logic getVariable "CTI_TEAMS") < CTI_AI_TEAMS_NB) then {
						_new_group=grpNull;
						_new_group =createGroup _side;
						[_unit] joinSilent _new_group;
						[_unit, missionNamespace getVariable format ["CTI_AI_%1_DEFAULT_GEAR", _side]] call CTI_CO_FNC_EquipUnit;

						waitUntil {!isNull _new_group};
						[_unit] joinSilent _new_group;
						waitUntil {group _unit == _new_group};
						diag_log format ["%1- %2", units _new_group,_new_group];
						_unit enableFatigue false;
						_new_group selectLeader  _unit;
						[_new_group,_side ] call CTI_SE_FNC_InitializeGroup;
						_new_group allowFleeing 0;
						if (isNil {_new_group getVariable "cti_aifsm_handled"}) then {
							[_new_group, _side] execFSM "Server\FSM\update_ai.fsm";
						};
						_unit addEventHandler ["killed", format["[_this select 0, _this select 1, %1] spawn CTI_CO_FNC_OnUnitKilled", _sideID]];

						if (isMultiplayer) then { sleep 10 }else {sleep 2};

						_unit setDamage 1; //force respawn
					};


				};
			}count (playableUnits+switchableUnits);
			sleep 10;
		};
	};
    _teams = [];
	_logic setVariable ["cti_teams", _teams, true];


	if ((missionNamespace getVariable "CTI_AI_TEAMS_ENABLED") == 3 || _side == west && (missionNamespace getVariable "CTI_AI_TEAMS_ENABLED") == 1 || _side == east && (missionNamespace getVariable "CTI_AI_TEAMS_ENABLED") == 2 ) then {
		[_side, _logic] spawn {
			private ["_side","_logic","_teams","_possible","_next_commander"];
			_side =_this select 0;
			_logic=_this select 1;
			_logic setVariable ["cti_ai_commander", false,true];
			_logic setVariable ["cti_ai_commander_group", grpNull,true];
			sleep 60;
			//if (isMultiplayer) then { sleep 60 };
			while {!CTi_GameOver} do {
				if (isMultiplayer) then { sleep 20 };
				if ((isnull (_logic getVariable "cti_commander")&& ! (_logic getVariable ["cti_ai_commander",true])) || isplayer leader (_logic getVariable ["cti_ai_commander_group",grpNull]) )then {
					_teams =_logic getVariable ["cti_teams",[]];
					_possible=[];
					{
						if (
							!isPlayer leader _x &&
							!(_x getVariable ["cti_player_disconnected", false])
						) then {
							_possible set [count _possible, _x];
						};
						true
					} count _teams;
					if (count _possible > 0) then {
						_next_commander= _possible select floor random (count _possible);
						_logic setVariable ["cti_ai_commander", true,true];
					_logic setVariable ["cti_ai_commander_group", _next_commander,true];
					(leader _next_commander) setpos( [(_logic getVariable "cti_hq"), 8, 30] call CTI_CO_FNC_GetRandomPosition);
					[["CLIENT", _side], "Client_OnMessageReceived", ["take_com",[format ["%1 (AI)",(name leader _next_commander)]]],true] call CTI_CO_FNC_NetSend;
					_seed = time + random 10000 - random 500 + diag_frameno;
					{deleteWaypoint _x} foreach (waypoints _next_commander);
					_next_commander setVariable ["cti_order_seed", _seed];
					_next_commander setVariable ["cti_team_reload",true];
					_next_commander setVariable ["cti_order",-1];
					_next_commander setVariable ["cti_order_pos",[0,0,0]];
					//waitUntil {isNil {_next_commander getVariable "cti_aifsm_handled"}};
					[_side,_next_commander] execFSM "Server\FSM\update_commander.fsm";
					};
				};
			    sleep 5;
			};
		};

	};

} forEach [[west, CTI_WEST, _westLocation], [east, CTI_EAST, _eastLocation]];

//--- Towns init thread
0 spawn {
	waitUntil {!isNil 'CTI_InitTowns'};

	execFSM "Server\FSM\update_garbage_collector.fsm";
	execFSM "Server\FSM\update_resources.fsm";
	execFSM "Server\FSM\update_victory.fsm";
};
call compile preprocessFileLineNumbers "Common\Functions\Common_AutoRearmFunctions.sqf";
[] execVM "Server\Functions\Server_AmbientJet.sqf";
[] execVM "Server\Functions\Server_AutoRearmCombatVehicles.sqf";
CTI_Init_Server=True;
clearRadio; systemChat "Mission loading complete";
execVM "Addons\SmartResistance\SR_Init.sqf";