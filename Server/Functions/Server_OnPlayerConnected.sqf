/*
  # HEADER #
        Script:         Server\Functions\Server_OnPlayerConnected.sqf
        Alias:          CTI_SE_FNC_OnPlayerConnected
        Description:    Triggered when a player joins the server
                        Note this function is MP only.
        Author:         Benny
        Modified for JIP group preservation.

  # PARAMETERS #
        0   [String]: The Player's UID
        1   [String]: The Player's name
        2   [Number]: The Player's seed ID
*/

_uid = _this select 0;
_name = _this select 1;
_id = _this select 2;

if (CTI_Log_Level >= CTI_Log_Information) then {
    [
        "INFORMATION",
        "FILE: Server\Functions\Server_OnPlayerConnected.sqf",
        format ["Player [%1] [%2] has joined the current session", _name, _uid]
    ] call CTI_CO_FNC_Log;
};

/*
    Ignore the server itself.
*/
if (_name == "__SERVER__" || _uid == "") exitWith {};

waitUntil {!isNil "CTI_Init_Common"};

/*
    Try to find the player's group.
*/
_max = 10;
_team = grpNull;

while {_max > 0 && isNull _team} do {
    {
        if ((getPlayerUID _x) == _uid) exitWith {
            _team = group _x;
        };
    } forEach playableUnits;

    if (isNull _team) then {
        sleep 0.5;
    };

    _max = _max - 1;
};

/*
    Make sure we found the player group.
*/
if (isNull _team) exitWith {
    if (CTI_Log_Level >= CTI_Log_Error) then {
        [
            "ERROR",
            "FILE: Server\Functions\Server_OnPlayerConnected.sqf",
            format ["Player [%1] [%2] couldn't be found among the current playable units", _name, _uid]
        ] call CTI_CO_FNC_Log;
    };
};

_leader = leader _team;

/*
    Determine side.
*/
_side = side _team;

if !(_side in [west, east, resistance]) then {
    _side = switch (
        getNumber (configFile >> "CfgVehicles" >> typeOf _leader >> "side")
    ) do {
        case 0: {east};
        case 1: {west};
        case 2: {resistance};
        default {civilian};
    };
};

if !(_side in [west, east, resistance]) exitWith {
    if (CTI_Log_Level >= CTI_Log_Error) then {
        [
            "ERROR",
            "FILE: Server\Functions\Server_OnPlayerConnected.sqf",
            format ["Player [%1] [%2] side couldn't be determined", _name, _uid]
        ] call CTI_CO_FNC_Log;
    };
};

/*
    Get CTI side logic.
*/
_logic = (_side) call CTI_CO_FNC_GetSideLogic;

_teams = _logic getVariable ["cti_teams", []];

if (isNil "_teams") then {
    systemChat "Mission fail, please tell the administrator to restart mission!";
};

/*
    Make sure the player's group exists in CTI teams.
*/
if !(_team in _teams) then {
    [_team, _side] call CTI_SE_FNC_InitializeGroup;

    if (CTI_Log_Level >= CTI_Log_Information) then {
        [
            "INFORMATION",
            "FILE: Server\Functions\Server_OnPlayerConnected.sqf",
            format [
                "Player [%1] [%2] does not belong to any CTI Groups on [%3]. Performed late-initialization and updated the Global Teams",
                _name, _uid, _side
            ]
        ] call CTI_CO_FNC_Log;
    };

    /*
        Update global teams.
    */
    _logic setVariable [
        "cti_teams",
        _teams - [objNull] + [_team],
        true
    ];
};

/*
    Force the player leader out of the vehicle.

    This is original BECTI behavior.
*/
if !(isNull assignedVehicle _leader) then {
    unassignVehicle _leader;
    [_leader] orderGetIn false;
    [_leader] allowGetIn false;
};

/*
    Get previous player information.
*/
_get = missionNamespace getVariable format ["CTI_SERVER_CLIENT_%1", _uid];

/*
    Heal player.
*/
_leader setDamage 0;

/*
    IMPORTANT JIP STEP

    Restore the player's UID on the group.
*/
_team setVariable ["cti_uid", _uid];

/*
    IMPORTANT JIP STEP

    The player has returned.

    The group is no longer considered a disconnected
    player group, so normal cleanup rules can apply again.
*/
_team setVariable ["cti_jip_preserve", false, true];

/*
    The player has returned.
    Stop the disconnected-position defense controller.
*/
_team setVariable ["cti_player_disconnected", false, true];
_team setVariable ["cti_disconnect_units", nil, false];
_team setVariable ["cti_disconnect_leader_position", nil, false];

/*
    First-time player.
*/
if (isNil "_get") then {
    /*
        Format:
        [
            UID,
            Funds,
            First Joined Side,
            Last Joined Side,
            First Time Join
        ]
    */
    missionNamespace setVariable [
        format ["CTI_SERVER_CLIENT_%1", _uid],
        [_uid, 0, _side, _side, true]
    ];

    if (CTI_Log_Level >= CTI_Log_Information) then {
        [
            "INFORMATION",
            "FILE: Server\Functions\Server_OnPlayerConnected.sqf",
            format [
                "Player [%1] [%2] information were stored for the first time on side [%3]",
                _name, _uid, _side
            ]
        ] call CTI_CO_FNC_Log;
    };
} else {
    /*
        Player has joined before.
    */
    if (CTI_Log_Level >= CTI_Log_Debug) then {
        [
            "DEBUG",
            "FILE: Server\Functions\Server_OnPlayerConnected.sqf",
            format [
                "Player [%1] [%2] information are [%3]",
                _name, _uid, _get
            ]
        ] call CTI_CO_FNC_Log;
    };

    _get set [3, _side];

    _funds = _get select 1;
    _sidefirst = _get select 2;

    /*
        Make sure the player didn't switch sides.
    */
    if (_sidefirst != _side) then {
        _funds = missionNamespace getVariable [
            format ["CTI_ECONOMY_STARTUP_FUNDS_%1", _side],
            0
        ];
    };

    if (isNil "_funds") then {
        _funds = missionNamespace getVariable [
            format ["CTI_ECONOMY_STARTUP_FUNDS_%1", _side],
            0
        ];
    };

    _team setVariable ["cti_funds", _funds, true];

    if (CTI_Log_Level >= CTI_Log_Information) then {
        [
            "INFORMATION",
            "FILE: Server\Functions\Server_OnPlayerConnected.sqf",
            format [
                "Player [%1] [%2] information were updated. Joined side is [%3]. Teamswap? [%4]",
                _name, _uid, _side,
                if (_sidefirst != _side) then {true} else {false}
            ]
        ] call CTI_CO_FNC_Log;
    };
};
// ==========================================
// ОБРАБОТКА JIP (Перезашедших) ВО ВРЕМЯ ДЕБРИФИНГА
// ==========================================
if (missionNamespace getVariable ["CTI_GameOver", false]) then {
    // Игра уже закончена. Передаём объект игрока (_leader) вместо _id, так надёжнее.
    [_side, _leader] spawn {
        params ["_side", "_leader"];
        
        // Ждём, пока клиент полностью прогрузится, заспавнится на карте и станет alive.
        // BECTI грузится долго, 5 секунд ему как собаке срать.
        waitUntil {sleep 2; alive _leader && {!isNull _leader} && {isPlayer _leader}};
        
        // Даём ещё 3 секунды, чтобы клиентские скрипты спавна (камера, UI) отработались и не сбросили наш наблюдатель.
        sleep 3; 
        
        // Определяем, кто побеждает по городам
        _westTowns = (west) call CTI_CO_FNC_GetSideTownCount;
        _eastTowns = (east) call CTI_CO_FNC_GetSideTownCount;
        
        _result = "loose";
        if (_side == west && _westTowns >= _eastTowns) then { _result = "win"; };
        if (_side == east && _eastTowns >= _westTowns) then { _result = "win"; };
        if (_side == resistance) then { _result = "win"; };
        
        // Принудительно запускаем скрипт конца миссии на клиенте опоздавшего
        // Юзаем _leader (объект) вместо _id, Арма так лучше понимает, кому кидать remoteExec
        [_side, _result] remoteExec ["CTI_CL_FNC_OnMissionEnding", _leader];
        
        if (CTI_Log_Level >= CTI_Log_Information) then {
            ["INFORMATION", "FILE: Server_OnPlayerConnected.sqf", format ["Player JIP'd during debriefing. Sent to spectator mode. Name: %1", name _leader]] call CTI_CO_FNC_Log;
        };
    };
};