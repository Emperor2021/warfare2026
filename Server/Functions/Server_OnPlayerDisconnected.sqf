/*
  # HEADER #
        Script:         Server\Functions\Server_OnPlayerDisconnected.sqf
        Alias:          CTI_SE_FNC_OnPlayerDisconnected
        Description:    Triggered when a player leave the server
                        Note this function is MP only.
                        Also note that the server (in MP) will also trigger
                        this script with a name of __SERVER__
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


if (
    CTI_Log_Level >= CTI_Log_Information
) then {

    [
        "INFORMATION",
        "FILE: Server\Functions\Server_OnPlayerDisconnected.sqf",
        format [
            "Player [%1] [%2] has left the current session",
            _name,
            _uid
        ]
    ] call CTI_CO_FNC_Log;
};


/*
    Ignore the server itself.
*/
if (
    _name == "__SERVER__" ||
    _uid == ""
) exitWith {};


waitUntil {
    !isNil "CTI_Init_Common"
};


/*
    Was it a Headless Client?
*/
_candidates = missionNamespace getVariable [
    "CTI_HEADLESS_CLIENTS",
    nil
];

if !(isNil "_candidates") then {

    _index = -1;

    {
        if ((_x select 2) == _uid) exitWith {
            _index = _forEachIndex;
        };

    } forEach _candidates;


    if (_index > -1) then {

        _candidates set [
            _index,
            "!nil!"
        ];

        _candidates = _candidates - [
            "!nil!"
        ];

        missionNamespace setVariable [
            "CTI_HEADLESS_CLIENTS",
            _candidates
        ];


        if (
            CTI_Log_Level >= CTI_Log_Information
        ) then {

            [
                "INFORMATION",
                "FILE: Server\Functions\Server_OnPlayerDisconnected.sqf",
                format [
                    "Headless Client [%1] [%2] has been disconnected and was removed from the registered clients. There is now [%3] Headless Clients.",
                    _uid,
                    _name,
                    count _candidates
                ]
            ] call CTI_CO_FNC_Log;
        };
    };
};


/*
    Get the player's stored information.
*/
_get = missionNamespace getVariable format [
    "CTI_SERVER_CLIENT_%1",
    _uid
];


if (isNil "_get") exitWith {

    if (
        CTI_Log_Level >= CTI_Log_Warning
    ) then {

        [
            "WARNING",
            "FILE: Server\Functions\Server_OnPlayerDisconnected.sqf",
            format [
                "Disconnected Player [%1] [%2] information couldn't be retrieved",
                _name,
                _uid
            ]
        ] call CTI_CO_FNC_Log;
    };
};


/*
    Find the player's original CTI group.
*/
_team = grpNull;

{
    if (
        (group _x getVariable [
            "cti_uid",
            ""
        ]) == _uid
    ) exitWith {

        _team = group _x;
    };

} forEach playableUnits;


if (isNull _team) exitWith {

    if (
        CTI_Log_Level >= CTI_Log_Error
    ) then {

        [
            "ERROR",
            "FILE: Server\Functions\Server_OnPlayerDisconnected.sqf",
            format [
                "Disconnected Player [%1] [%2] group couldn't be found among the current playable units",
                _name,
                _uid
            ]
        ] call CTI_CO_FNC_Log;
    };
};


/*
    Get side information.
*/
_side = _get select 3;

_commander = (
    _side
) call CTI_CO_FNC_GetSideCommander;


_is_commander = if (
    _commander == _team
) then {
    true
} else {
    false
};


/*
    Was it the commander?
*/
if (
    _is_commander &&
    !isNull _team
) then {

    /*
        Sanitize commander information.
    */
    _logic = (
        _side
    ) call CTI_CO_FNC_GetSideLogic;


    _logic setVariable [
        "cti_commander",
        grpNull,
        true
    ];


    /*
        Send message.
    */
    [
        ["CLIENT", _side],
        "Client_OnMessageReceived",
        ["commander-disconnected"]
    ] call CTI_CO_FNC_NetSend;


    /*
        AI commander takeover.
    */
    if (
        missionNamespace getVariable [
            "CTI_AI_COMMANDER_ENABLED",
            0
        ] == 1
    ) then {

        (
            _side
        ) execFSM "Server\FSM\update_commander.fsm";
    };
};


/*
    Get team funds and HQ.
*/
_funds = (
    _team
) call CTI_CO_FNC_GetFundsTeam;


_hq = (
    _side
) call CTI_CO_FNC_GetSideHQ;


_leader = leader _team;


/*
    Mark this group as belonging to a disconnected player.

    IMPORTANT:
    SM_CLEAN_GROUPS checks this variable.

    As long as it is TRUE, the cleanup script will NOT delete
    the player's AI units.
*/
_team setVariable [
    "cti_jip_preserve",
    true,
    true
];


/*
    Force the player leader out of his vehicle.

    The vehicle itself is NOT deleted here.
*/
if (
    !(isNull assignedVehicle _leader)
) then {

    unassignVehicle _leader;

    [
        _leader
    ] orderGetIn false;

    [
        _leader
    ] allowGetIn false;
};


if (
    vehicle _leader == _hq
) then {

    _leader action [
        "EJECT",
        vehicle _leader
    ];
};


/*
    Optional BECTI cleanup.

    If CTI_AI_TEAMS_JIP_PRESERVE is explicitly set to 0,
    the original BECTI behavior is retained.

    Otherwise the player's army is preserved.
*/
_jipPreserve = missionNamespace getVariable [
    "CTI_AI_TEAMS_JIP_PRESERVE",
    1
];


if (
    _jipPreserve == 0
) then {

    /*
        We deliberately override this old behavior for the
        disconnected player's group.

        The group is protected by cti_jip_preserve.
    */

    if (
        CTI_Log_Level >= CTI_Log_Information
    ) then {

        [
            "INFORMATION",
            "FILE: Server\Functions\Server_OnPlayerDisconnected.sqf",
            format [
                "JIP preservation active for team [%1], player [%2] [%3]. Units and vehicles will remain.",
                _team,
                _name,
                _uid
            ]
        ] call CTI_CO_FNC_Log;
    };
};


/*
    Save current funds.
*/
_get set [
    1,
    _funds
];


/*
    DISCONNECTED PLAYER DEFENSE

    IMPORTANT:
    The old BECTI code moved the leader to HQ / respawn and
    started update_ai.fsm. That behaviour is intentionally removed.

    New behaviour:
    - The leader stays exactly where he was.
    - Every AI unit gets its own anchor position.
    - Each unit may move within 25 metres of its own anchor.
    - Units can still fight enemy units.
    - No strategic AI orders are started for this group.
    - Vehicles stay with their own anchor position.
*/

_team setVariable [
    "cti_player_disconnected",
    true,
    true
];


private _disconnectUnits = [];


{
    if (
        alive _x
    ) then {

        private _unit = _x;
        private _vehicle = vehicle _unit;
        private _anchorPosition = getPosATL _vehicle;
        _disconnectUnits pushBack [
            _unit,
            _vehicle,
            _anchorPosition
        ];


        _unit setVariable [
            "cti_disconnect_anchor",
            _anchorPosition,
            false
        ];

        /*
            Cancel the previous movement command.
        */
        doStop _unit;


        /*
            Keep normal AI movement and combat enabled.
        */
        _unit enableAI "MOVE";
        _unit enableAI "TARGET";
        _unit enableAI "AUTOTARGET";
        _unit enableAI "ANIM";


        _unit setBehaviour "AWARE";
        _unit setCombatMode "YELLOW";
    };

} forEach units _team;


/*
    Save all individual positions on the group.
    The defense controller uses this snapshot and never uses
    the leader's position as a common destination.
*/
_team setVariable [
    "cti_disconnect_units",
    _disconnectUnits,
    false
];


/*
    Save the leader's exact position separately for diagnostics
    and for protection against accidental strategic movement.
*/
_team setVariable [
    "cti_disconnect_leader_position",
    getPosATL _leader,
    false
];

/*
    Mark the group as protected for JIP.
*/
_team setVariable [
    "cti_jip_preserve",
    true,
    true
];


/*
    Start the individual-position defense controller.
*/
[
    _team,
    _side
] execVM "Server\Functions\Server_DisconnectedDefense.sqf";


if (
    CTI_Log_Level >= CTI_Log_Information
) then {

    [
        "INFORMATION",
        "FILE: Server\Functions\Server_OnPlayerDisconnected.sqf",
        format [
            "Player [%1] [%2] disconnected. Group [%3] is defending individual positions. Units: [%4]. Radius: 25m.",
            _name,
            _uid,
            _team,
            count _disconnectUnits
        ]
    ] call CTI_CO_FNC_Log;
};

/*
    Save player information.
*/
missionNamespace setVariable [
    format [
        "CTI_SERVER_CLIENT_%1",
        _uid
    ],
    _get
];


/*
    Release the UID.

    IMPORTANT:
    We DO NOT remove cti_jip_preserve.

    That flag is needed by SM_CLEAN_GROUPS while the
    player is disconnected.
*/
_team setVariable [
    "cti_uid",
    nil
];


/*
    Update global teams if needed.
*/
[
    _side
] spawn {

    sleep 10;


    _logic = (
        _this
    ) call CTI_CO_FNC_GetSideLogic;


    _teams = _logic getVariable [
        "cti_teams",
        []
    ];


    if (
        {
            isNull _x
        } count _teams > 0
    ) then {

        _teams = _teams - [
            objNull
        ];


        _logic setVariable [
            "cti_teams",
            _teams
        ];


        if (
            CTI_Log_Level >= CTI_Log_Information
        ) then {

            [
                "INFORMATION",
                "FILE: Server\Functions\Server_OnPlayerDisconnected.sqf",
                format [
                    "Removed some null groups from the Global Teams for side [%1]",
                    _this
                ]
            ] call CTI_CO_FNC_Log;
        };
    };
};
