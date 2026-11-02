#define DIK_TAB             0x0F
#define DIK_U               0x16
#define DIK_TILDE             0x29

NET_LOG=false;

CTI_P_SideJoined = side player;

CTI_P_SideID = CTI_P_SideJoined call CTI_CO_FNC_GetSideID;
CTI_P_SideLogic = CTI_P_SideJoined call CTI_CO_FNC_GetSideLogic;

if (isNil "SM_Last_dis") then {SM_Last_dis = 0};
if (isNil "SM_TO_dis") then {SM_TO_dis = 0};

player setPos ([getMarkerPos format["CTI_%1Respawn", CTI_P_SideJoined], 3, 15] call CTI_CO_FNC_GetRandomPosition); //--- Preplace

CTI_CL_FNC_AddMissionActions = compileFinal preprocessFile "Client\Functions\Client_AddMissionActions.sqf";
CTI_CL_FNC_ChangePlayerFunds = compileFinal preprocessFile "Client\Functions\Client_ChangePlayerFunds.sqf";
CTI_CL_FNC_DisplayMessage = compileFinal preprocessFile "Client\Functions\Client_DisplayMessage.sqf";
CTI_CL_FNC_GetAIDigit = compileFinal preprocessFile "Client\Functions\Client_GetAIDigit.sqf";
CTI_CL_FNC_GetAIOrderLabel = compileFinal preprocessFile "Client\Functions\Client_GetAIOrderLabel.sqf";
CTI_CL_FNC_GetIncomes = compileFinal preprocessFile "Client\Functions\Client_GetIncomes.sqf";
CTI_CL_FNC_GetOrderLabel = compileFinal preprocessFile "Client\Functions\Client_GetOrderLabel.sqf";
CTI_CL_FNC_GetPlayerFunds = compileFinal preprocessFile "Client\Functions\Client_GetPlayerFunds.sqf";
CTI_CL_FNC_GetPlayerIncome = compileFinal preprocessFile "Client\Functions\Client_GetPlayerIncome.sqf";
CTI_CL_FNC_GetPlayerVehicles = compileFinal preprocessFileLineNumbers "Client\Functions\Client_GetPlayerVehicles.sqf";
CTI_CL_FNC_GetMissionTime = compileFinal preprocessFile "Client\Functions\Client_GetMissionTime.sqf";
CTI_CL_FNC_HasAIOrderChanged = compileFinal preprocessFile "Client\Functions\Client_HasAIOrderChanged.sqf";
CTI_CL_FNC_HookVehicle = compileFinal preprocessFile "Client\Functions\Client_HookVehicle.sqf";
CTI_CL_FNC_IsPlayerCommander = compileFinal preprocessFile "Client\Functions\Client_IsPlayerCommander.sqf";
CTI_CL_FNC_InitializeStructure = compileFinal preprocessFile "Client\Functions\Client_InitializeStructure.sqf";
CTI_CL_FNC_JoinRequestAnswer = compileFinal preprocessFile "Client\Functions\Client_JoinRequestAnswer.sqf";
CTI_CL_FNC_KeyHandler = compileFinal preprocessFileLineNumbers "Client\Functions\Client_KeyHandler.sqf";
CTI_CL_FNC_KeyHandlerUp = compileFinal preprocessFileLineNumbers "Client\Functions\Client_KeyHandlerUp.sqf";
CTI_CL_FNC_PlacingBuilding = compileFinal preprocessFile "Client\Functions\Client_PlacingBuilding.sqf";
CTI_CL_FNC_PlacingDefense = compileFinal preprocessFile "Client\Functions\Client_PlacingDefense.sqf";
CTI_CL_FNC_OnExplosivePlaced = compileFinal preprocessFile "Client\Functions\Client_OnExplosivePlaced.sqf";
CTI_CL_FNC_OnHQDestroyed = compileFinal preprocessFile "Client\Functions\Client_OnHQDestroyed.sqf";
CTI_CL_FNC_OnFriendlyStructureDestroyed = compileFinal preprocessFile "Client\Functions\Client_OnFriendlyStructureDestroyed.sqf";
CTI_CL_FNC_OnJailed = compileFinal preprocessFile "Client\Functions\Client_OnJailed.sqf";
CTI_CL_FNC_OnMissionEnding = compileFinal preprocessFile "Client\Functions\Client_OnMissionEnding.sqf";
CTI_CL_FNC_OnPlayerFired = compileFinal preprocessFile "Client\Functions\Client_OnPlayerFired.sqf";
CTI_CL_FNC_OnPlayerKilled = compileFinal preprocessFile "Client\Functions\Client_OnPlayerKilled.sqf";
CTI_CL_FNC_OnPurchaseDelegationReceived = compileFinal preprocessFile "Client\Functions\Client_OnPurchaseDelegationReceived.sqf";
CTI_CL_FNC_OnPurchaseOrderReceived = compileFinal preprocessFile "Client\Functions\Client_OnPurchaseOrderReceived.sqf";
CTI_CL_FNC_OnStructureConstructed = compileFinal preprocessFile "Client\Functions\Client_OnStructureConstructed.sqf";
CTI_CL_FNC_OnTownCaptured = compileFinal preprocessFile "Client\Functions\Client_OnTownCaptured.sqf";
CTI_CL_FNC_PurchaseUnit = compileFinal preprocessFile "Client\Functions\Client_PurchaseUnit.sqf";
CTI_CL_FNC_RemoveRuins = compileFinal preprocessFile "Client\Functions\Client_RemoveRuins.sqf";

CTI_CL_FNC_GetGroupSize = compileFinal preprocessFile "Client\Functions\Client_GetGroupSize.sqf";
CTI_CL_FNC_GetSkillAI = compileFinal preprocessFile "Client\Functions\Client_GetSkillAI.sqf";
CTI_CL_FNC_SetSkillAI = compileFinal preprocessFile "Client\Functions\Client_SetSkillAI.sqf";

TUTORIAL_RUN = compileFinal preprocessFile "Addons\Strat_mode\Functions\TUTORIAL_run.sqf";

call compile preprocessFileLineNumbers "Common\Functions\Common_AutoRearmFunctions.sqf";
call compile preprocessFileLineNumbers "Client\Functions\FSM\Functions_FSM_UpdateClientAI.sqf";
call compile preprocessFileLineNumbers "Client\Functions\FSM\Functions_FSM_UpdateOrders.sqf";

CTI_CL_FNC_ShowAmmoInfo = compileFinal preprocessFile "Client\Functions\Client_ShowAmmoInfo.sqf";
CTI_UI_Artillery_BurstFire = compileFinal preprocessFileLineNumbers "Client\Functions\UI\Functions_UI_ArtilleryBurstFire.sqf";
CTI_CL_FNC_DeleteSelectedBot = compileFinal preprocessFileLineNumbers "Client\Functions\Client_DeleteSelectedBot.sqf";

CTI_P_SideColor = switch (CTI_P_SideJoined) do { case west: {CTI_WEST_COLOR}; case east: {CTI_EAST_COLOR}; case resistance: {CTI_RESISTANCE_COLOR}; default {"ColorBlack"} };
CTI_P_MarkerPrefix = switch (CTI_P_SideJoined) do { case west: {"b_"}; case east: {"o_"}; case resistance: {"n_"}; default {""} };
CTI_P_ChatID = [CTI_P_SideJoined,"HQ"];
CTI_P_MarkerIterator = 0;
CTI_P_PurchaseRequests = [];
CTI_P_TeamsRequests = [];
CTI_P_TeamsRequests_FOB = 0;
CTI_P_TeamsRequests_FOB_Dismantle = 0;
CTI_P_TeamsRequests_Last = -5000;
CTI_P_PreBuilding = false;
CTI_P_LastDefenseBuilt = objNull;
CTI_P_LastStructurePreBuilt = objNull;
CTI_P_Respawning = false;
CTI_P_LastRespawnTime= -2000;
CTI_P_LastDeathTime= -2000;
CTI_P_CurrentTasks = [];
CTI_P_CanJoin = false;
CTI_P_Jailed = false;
CTI_P_LastTeamkill = time;
CTI_P_LastFireMission = -1200;
CTI_P_HookVehicle = objNull;
CTI_P_LastRootMenu = "";
CTI_P_LastRepairTime = -600;
CTI_P_WallsAutoAlign = true;
CTI_P_DefensesAutoManning = true;
CTI_P_RapidDefence_Actions=[];
CTI_P_RapidDefence=-1;
CTI_P_Coloration_Money = "#BAFF81";
CTI_P_Locks=[];
CTI_P_Interaction = false;
CTI_DIALOGS = ["cti_dialog_ui_interractions","cti_dialog_ui_tabletmain","cti_dialog_ui_buildmenu","cti_dialog_ui_videosettingsmenu","cti_dialog_ui_transferresourcesmenu","cti_dialog_ui_servicemenu","cti_dialog_ui_purchasemenu","cti_dialog_ui_upgrademenu","cti_dialog_ui_workersmenu","cti_dialog_ui_defensemenu","cti_dialog_ui_requestmenu","cti_dialog_ui_onlinehelpmenu","cti_dialog_ui_gear","cti_dialog_ui_satcam","cti_dialog_ui_unitscam","cti_dialog_ui_teamsmenu","cti_dialog_ui_mapcommandmenu","cti_dialog_ui_aimicromenu","cti_dialog_ui_artillerymenu","cti_dialog_ui_aircraftloadoutmenu","cti_dialog_ui_respawnmenu","cti_dialog_ui_hookmenu"];
CTI_TABLET_DIALOG="cti_dialog_ui_tabletmain";
HUD_NOTIFICATIONS=[];

//--- Artillery Computer is only enabled on demand
enableEngineArtillery true;
if ((missionNamespace getVariable "CTI_ARTILLERY_SETUP") == -2) then {enableEngineArtillery false} else {enableEngineArtillery true};

12452 cutText [localize "STR_Begin_Tut", "BLACK FADED", 50000];
if (isMultiplayer) then {
12452 cutText [localize "STR_Begin_Tut_1", "BLACK FADED", 50000];

//--- Can I join?
missionNamespace setVariable ["CTI_PVF_Client_JoinRequestAnswer", {_this spawn CTI_CL_FNC_JoinRequestAnswer}]; //--- Early PVF, do not spoil the game with the others.

_last_req = -100;
while {!CTI_P_CanJoin} do {
	if (time - _last_req > 15) then {_last_req = time; ["SERVER", "Request_Join", [player, CTI_P_SideJoined]] call CTI_CO_FNC_NetSend};
	sleep 1;
};

["SERVER", "First_Time", [player, CTI_P_SideJoined]] call CTI_CO_FNC_NetSend; //--- Tell server that the player has successfully loaded in.
["SERVER", "Request_Date", [player]] call CTI_CO_FNC_NetSend; //--- Request server date to sync.

12452 cutText [localize "STR_Begin_Tut_2", "BLACK FADED", 50000];

if (CTI_P_Jailed) then {
	hint parseText localize "STR_OnJailed_EndlessRide";
	600 spawn CTI_CL_FNC_OnJailed;
};


};

removeAllWeapons player;
removeAllItems player;
removeAllAssignedItems player;
removeAllContainers player;
removeHeadgear player;

//--- Initialize the client PV
call compile preprocessFile "Client\Init\Init_PublicVariables.sqf";
call compile preprocessFileLineNumbers "Common\Functions\Common_AutoRearmFunctions.sqf";
//--- Call the UI Functions

call compile preprocessFile "Client\Functions\UI\Functions_UI_AIMicromanagementMenu.sqf";
call compile preprocessFile "Client\Functions\UI\Functions_UI_ArtilleryMenu.sqf";
call compile preprocessFile "Client\Functions\UI\Functions_UI_GearMenu.sqf";
call compile preprocessFile "Client\Functions\UI\Functions_UI_KeyHandlers.sqf";
call compile preprocessFile "Client\Functions\UI\Functions_UI_MapCommanding.sqf";
call compile preprocessFile "Client\Functions\UI\Functions_UI_PurchaseMenu.sqf";
call compile preprocessFile "Client\Functions\UI\Functions_UI_RequestMenu.sqf";
call compile preprocessFile "Client\Functions\UI\Functions_UI_RespawnMenu.sqf";
call compile preprocessFile "Client\Functions\UI\Functions_UI_SatelliteCamera.sqf";
call compile preprocessFile "Client\Functions\UI\Functions_UI_ServiceMenu.sqf";
call compile preprocessFile "Client\Functions\UI\Functions_UI_UnitsCamera.sqf";
call compile preprocessFile "Client\Functions\UI\Functions_UI_UpgradeMenu.sqf";

if ((missionNamespace getVariable ["CTI_AC_ENABLED", 0]) > 0) then {
if (isNil "CTI_AC_Init_Started") then {
call compile preprocessFileLineNumbers "Addons\Henroth_AirLoadout\init.sqf";
};
call compile preprocessFile "Addons\Henroth_AirLoadout\Functions_UI_AircraftLoadoutMenu.sqf";
};

if (CTI_P_SideJoined == west) then {(west) call compile preprocessFileLineNumbers "Common\Config\Gear\Gear_West.sqf"};
if (CTI_P_SideJoined == east) then {(east) call compile preprocessFileLineNumbers "Common\Config\Gear\Gear_East.sqf"};

CTI_InitClient = true;

//--- Wait for a proper overall init (disabled slot?)
//waitUntil {!isNil {(group player) getVariable "cti_funds"} || (CTI_P_SideJoined == resistance)} ;

player addEventHandler ["killed", {_this spawn CTI_CL_FNC_OnPlayerKilled}];

//if !(CTI_IsServer) then {[player, missionNamespace getVariable format ["CTI_AI_%1_DEFAULT_GEAR", CTI_P_SideJoined]] call CTI_CO_FNC_EquipUnit}; //--- Equip pure clients

if (isNil {profileNamespace getVariable "CTI_PERSISTENT_HINTS"}) then { profileNamespace setVariable ["CTI_PERSISTENT_HINTS", true]; saveProfileNamespace };

//--- Marker init thread
0 spawn {
if (CTI_P_SideJoined == resistance) exitWith {false};
waitUntil {!isNil {CTI_P_SideLogic getVariable "cti_teams"}};

execFSM "Client\FSM\update_netunits_team.fsm";


};

//--- HQ / Base markers thread
0 spawn {

waitUntil {!isNil 'CTI_Init_CommanderClient'};
waitUntil {!isNil {CTI_P_SideLogic getVariable "cti_structures"} && !isNil {CTI_P_SideLogic getVariable "cti_hq"}};
//--- Initialize the structures (JIP or prefab) along with HQ.
execVM "Client\Init\Init_JIP.sqf";
execFSM "Client\FSM\update_actions.fsm";


};

//--- Commander thread
0 spawn {
//if (CTI_P_SideJoined == resistance) exitWith {call CTI_CL_FNC_AddMissionActions; CTI_Init_CommanderClient = true; false};
waitUntil {!isNil {CTI_P_SideLogic getVariable "cti_commander"} && !isNil {CTI_P_SideLogic getVariable "cti_hq"} && !isNil {CTI_P_SideLogic getVariable "cti_salvagers"}};

_hq = (CTI_P_SideJoined) call CTI_CO_FNC_GetSideHQ;

CTI_Init_CommanderClient = true;


call CTI_CL_FNC_AddMissionActions;

//if (alive _hq) then {
	//--- Pure clients
	if (CTI_IsClient && !CTI_IsServer) then {
		// ИСПРАВЛЕНИЕ БАГА #4: format заменён на anonymous handler
		_hq addEventHandler ["killed", {
			[_this select 0, _this select 1, CTI_P_SideID] spawn CTI_CL_FNC_OnHQDestroyed
		}];

		if (CTI_BASE_NOOBPROTECTION == 1) then {
			_hq addEventHandler ["handleDamage", format["[_this select 2, _this select 3, %1] call CTI_CO_FNC_OnHQHandleDamage", CTI_P_SideID]]; //--- You want that on public
		};
	};
//};


};

//--- Gear templates (persitent)
if !(CTI_P_SideJoined == resistance) then {if (isNil {profileNamespace getVariable format["CTI_PERSISTENT_GEAR_TEMPLATE_%1", CTI_P_SideJoined]}) then {call CTI_UI_Gear_InitializeProfileTemplates};

if !(isNil {profileNamespace getVariable format["CTI_PERSISTENT_GEAR_TEMPLATE_%1", CTI_P_SideJoined]}) then {execVM "Client\Init\Init_Persistent_Gear.sqf"};};

//--- Graphics/video thread (persistent)
0 spawn {
//--- View Distance
_distance = profileNamespace getVariable "CTI_PERSISTENT_VIEW_DISTANCE";
_distance_max = missionNamespace getVariable "CTI_GRAPHICS_VD_MAX";

if (isNil "_distance") then { _distance = viewDistance };
if (typeName _distance != "SCALAR") then { _distance = viewDistance };
if (_distance < 1) then { _distance = 500 };
if (_distance > _distance_max) then { _distance = _distance_max };
setViewDistance _distance;

//--- Object Distance (scales to View Distance)
_distance = profileNamespace getVariable "CTI_PERSISTENT_OBJECT_DISTANCE";
if (isNil "_distance") then { _distance = viewDistance };
if (_distance < 1) then { _distance = 500 };
if (_distance > viewDistance) then { _distance = viewDistance };
setObjectViewDistance _distance;

//--- Shadows Distance.
_distance = profileNamespace getVariable "CTI_PERSISTENT_SHADOWS_DISTANCE";
if !(isNil "_distance") then {
	if (typeName _distance == "SCALAR") then {
		if (_distance < 50) then { _distance = 50 };
		if (_distance > 200) then { _distance = 200 };
		setShadowDistance _distance;
	};
};

//--- Terrain Grid
_grid = profileNamespace getVariable "CTI_PERSISTENT_TG";
_grid_max = missionNamespace getVariable "CTI_GRAPHICS_TG_MAX";

if (isNil "_grid") then { _grid = 25 };
if (typeName _grid != "SCALAR") then {
	_grid = 0;
} else {
	if (_grid < 0) then { _grid = 0 };
};
if (_grid > _grid_max) then { _grid = _grid_max };
setTerrainGrid _grid;


};

TABLET_KEY_DOWN={
_return=false;
disableSerialization;

if (! (_this select 2) && ! (_this select 3) && ! (_this select 4) &&(_this select 1) in ([(profilenamespace getvariable ['CTI_TABLET_KEY',41])]+(actionKeys "User5"))  && !visibleMap && !CTI_P_PreBuilding &&!CTI_P_Repairing && isNull (uiNamespace getVariable ['cti_dialog_ui_interractions',objNull]) && isNull (uiNamespace getVariable ['cti_dialog_ui_defensemenu',objnull]) && isNull (uiNamespace getVariable ['cti_dialog_ui_purchasemenu',objnull]) && isnull (uiNamespace getVariable ["cti_dialog_ui_tabletmain",objnull]) && (isnull (findDisplay 60490))) then {
		uiNamespace setVariable ["INT_TARG", call TABLET_GET_TARGET];
		createdialog "CTI_RscInteraction";
		_return=true;
};
_return


};
TABLET_KEY_UP={
_return=false;
disableSerialization;
if (! (_this select 2) && ! (_this select 3) && ! (_this select 4) && (_this select 1) in [(profilenamespace getvariable ['CTI_TABLET_KEY',41])]  && !isNil {uiNamespace getVariable 'cti_dialog_ui_interractions'}&& isNil {uiNamespace getVariable 'cti_dialog_ui_purchasemenu'} && isNil {uiNamespace getVariable 'cti_dialog_ui_buildmenu'} && isNil {uiNamespace getVariable 'cti_dialog_ui_defensemenu'}&& isNil {uiNamespace getVariable 'cti_dialog_ui_gear'}&& isNil {uiNamespace getVariable 'cti_dialog_ui_aircraftloadoutmenu'} && isnil {uiNamespace getVariable "cti_dialog_ui_tabletmain"} && (isnull (findDisplay 60490)) ) then {
closeDialog 0;
};
_return
};

TABLET_GET_TARGET={
private ["_target"];
_target=objnull;
if (cursortarget iskindof "CAManBase" && ([player,cursortarget] call BIS_fnc_distance2D) <3 ) exitWith {cursortarget};
if (cursortarget == (CTI_P_SideLogic getvariable "cti_hq") && ([player,cursortarget] call BIS_fnc_distance2D) <10 && (isnull attachedTo (CTI_P_SideLogic getvariable "cti_hq") ) ) exitWith {cursortarget};
if (vehicle player != player) exitWith {vehicle player};
_target = lineintersectsobjs [(eyepos player),(atltoasl screentoworld [0.5,0.5]),objnull,objnull,false,16];
if (count _target == 0 && !(cursortarget iskindof "CAManBase") && ( [player,cursortarget] call BIS_fnc_distance2D) <8) exitWith {cursortarget};
if ((count _target) == 0) exitWith {player};
if (( [player,(_target select 0)] call BIS_fnc_distance2D) > 8) exitWith {player};
_target select 0;
};

0 spawn {
disableSerialization;
/*
waitUntil {!isNil {findDisplay 46} && !isNull (findDisplay 46) && !isnil "TABLET_KEY_DOWN" && !isNil "TABLET_KEY_UP"};
_maindisplay=findDisplay 46;
//_maindisplay displayRemoveAllEventHandlers  "KeyDown";
//_maindisplay displayRemoveAllEventHandlers  "KeyUp";
sleep 0.5;
KD_BECTI=_maindisplay  displayAddEventHandler ["KeyDown", TABLET_KEY_DOWN];
KU_BECTI=_maindisplay  displayAddEventHandler ["KeyUp", TABLET_KEY_UP];
*/
waitUntil {!isNil {findDisplay 46} && !isNull (findDisplay 46) && !isNil "CTI_CL_FNC_KeyHandler" && !isNil "CTI_CL_FNC_KeyHandlerUp"};
( findDisplay 46 ) displayAddEventHandler [ "KeyDown", "_this call CTI_CL_FNC_KeyHandler" ];
( findDisplay 46 ) displayAddEventHandler [ "KeyUp", "_this call CTI_CL_FNC_KeyHandlerUp" ];
};

if (CTI_BASE_NOOBPROTECTION == 1) then {player addEventHandler ["fired", {_this spawn CTI_CL_FNC_OnPlayerFired}]}; //--- Trust me, you want that

if ((missionNamespace getVariable "CTI_UNITS_FATIGUE") == 0) then {player enableFatigue false} else  {player enableFatigue true}; //--- Disable the unit's fatigue

["SERVER", "Request_NoobLogger", [player,0]] call CTI_CO_FNC_NetSend;

0 execVM "Addons\MapMarkersTitling.sqf";

if ((getPlayerUID player) in CTI_UIDs_ADMINS) then {
AZ_Init_Client_Complete = false;
execVM "Addons\AZ\Client\Init\Init_Client.sqf";
waitUntil {AZ_Init_Client_Complete};
};

//--- Set AI skill depending on the player's score
_logic = (CTI_P_Sidejoined) call CTI_CO_FNC_GetSideLogic;
_skill = _logic getVariable "cti_ai_skill";
if (_skill < 1) then {
0 spawn CTI_CL_FNC_SetSkillAI;
};

//--- Запуск отслеживания боекомплекта на карте
call compile preprocessFile "Client\Events\Events_MapAmmoInfo.sqf";
[] call CTI_StartMapAmmoTracking;

//--- Объявляем туториал завершенным СРАЗУ, чтобы не ломать Strat Mode HUD и сеть связи
TUTO_COMPLETE = true;
CTI_CL_V_TUTORIAL_ENDED = true;

//--- Безопасный асинхронный запуск спавна у базы и выдачи экипировки
0 spawn {
    // Ждем, пока на стороне зарегистрируются структуры и штаб (HQ)
    waitUntil {  sleep 0.5; !isNil {CTI_P_SideLogic getVariable "cti_structures"} && !isNil {CTI_P_SideLogic getVariable "cti_hq"} };
    
    private _spawn_at = objNull;
    while {isNull _spawn_at} do {
        private _hq = (CTI_P_SideJoined) call CTI_CO_FNC_GetSideHQ;
        private _structures = (CTI_P_SideJoined) call CTI_CO_FNC_GetSideStructures;
        _spawn_at = _hq;
        if (count _structures > 0) then {
            _spawn_at = [_hq, _structures] call CTI_CO_FNC_GetClosestEntity;
            if (isNull _spawn_at) then { _spawn_at = _hq; };
        };
        sleep 1;
    };

    // Случайная позиция около базы
    _spawn_at = [_spawn_at, 8, 15] call CTI_CO_FNC_GetRandomPosition;
    player setPos _spawn_at;

    // Выдача экипировки
    if ((getPlayerUID player) in CTI_UIDs_ADMINS) then {
        [player, missionNamespace getVariable format ["CTI_%1_DEFAULT_GEAR_ADMINS", CTI_P_SideJoined]] call CTI_CO_FNC_EquipUnit;
        player groupChat "ADMIN GEAR LOAD...";
    } else {
        [player, missionNamespace getVariable format ["CTI_AI_%1_DEFAULT_GEAR", CTI_P_SideJoined]] call CTI_CO_FNC_EquipUnit;
        player groupChat (localize "CTI_GEAR_LOADED");
    };

    sleep 1;
    12452 cutText ["", "PLAIN", 0]; // Убираем черный экран

    // Запускаем защиту колес
    waitUntil {(! isNil "CTI_PVF_Protect_Wheels") && (! isNil "H_PROTECT_WHEELS")};
    {if (_x getvariable ["wheel_prot",false]) then {_x call CTI_PVF_Protect_WheELS }; true} count vehicles;
};

// Запуск фоновой обработки стационарных защит
{_x spawn CTI_PVF_Client_HandleDefense} forEach (CTI_P_SideLogic getVariable ["cti_defences", []]);


// Запуск системы подсказок
[] execVM "Client\Hint\Hint_StartAll.sqf";

// Подключаем наш скрипт на спавн 6 ботов-подчинённых
[] execVM "Client\Functions\Client_InitPlayerBots.sqf";
//Измеряет расстояние между штабами (HQ), считает текущее время работы миссии и выводит объединенный доклад разведки.
[] execVM "Client\Functions\Client_IntelReport.sqf";

// СИГНАЛИЗИРУЕМ О ТОМ, ЧТО КЛИЕНТ И ВСЯ ЕГО ЛОГИКА ПОЛНОСТЬЮ ГОТОВЫ К СТАРТУ СЕТИ
CTI_Init_Client = true;
