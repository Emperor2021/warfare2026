/*
    Server\Functions\Server_DisconnectedDefense.sqf

    Individual defensive position controller for a disconnected
    player's group.

    Rules:
    - Every unit keeps its own position from disconnect time.
    - Maximum normal displacement: 25 metres from that position.
    - The leader is NOT used as a common destination.
    - Units keep TARGET / AUTOTARGET enabled and can fight.
    - No group waypoint is created.
    - When a unit leaves its 25m zone, it is sent to a safe point
      inside its own zone.
    - Vehicles are treated as one object: all crew share the
      vehicle's anchor position.
*/

params [
    [
        "_team",
        grpNull,
        [grpNull]
    ],
    [
        "_side",
        west,
        [west]
    ]
];


if (
    isNull _team
) exitWith {};


private _defenseRadius = 25;
private _checkInterval = 2;
private _safePositionRadius = 20;


private _units = _team getVariable [
    "cti_disconnect_units",
    []
];


if (
    count _units == 0
) exitWith {};


while {
    !isNull _team &&
    {
        _team getVariable [
            "cti_player_disconnected",
            false
        ]
    }
} do {

    {
        _x params [
            "_unit",
            "_vehicle",
            "_anchorPosition"
        ];


        if (
            !isNull _unit &&
            alive _unit
        ) then {

            /*
                If the unit entered another vehicle after disconnect,
                follow that vehicle only if it is still inside the
                original 25m defensive area.
            */
            private _currentVehicle = vehicle _unit;
            private _currentPosition = getPosATL _currentVehicle;
            private _distanceFromAnchor = _currentPosition distance2D _anchorPosition;


            /*
                Keep combat functions available.
            */
            _unit enableAI "TARGET";
            _unit enableAI "AUTOTARGET";
            _unit enableAI "ANIM";
            _unit enableAI "MOVE";
            _unit allowFleeing 0;


            /*
                Look for enemies close to this unit.

                This is deliberately local to the unit's own area.
                We do NOT use the leader as a common center point.
            */
            private _enemies = _unit nearEntities [
                [
                    "Man",
                    "Car",
                    "Tank",
                    "Air"
                ],
                150
            ];

            _enemies = _enemies select {
                alive _x &&
                {
                    side _x != _side
                } &&
                {
                    side _x in [
                        east,
                        west,
                        resistance
                    ]
                }
            };


            if (
                count _enemies > 0
            ) then {

                /*
                    Enemy is nearby.
                    Let the AI fight and move locally.
                */
                _unit setBehaviour "COMBAT";
                _unit setCombatMode "YELLOW";


                private _enemy = _enemies select 0;

                _unit reveal [
                    _enemy,
                    4
                ];

                _unit doTarget _enemy;


                /*
                    Give the unit an occasional new safe position
                    inside its own 25m zone.

                    This is what gives infantry a chance to change
                    position / find cover without running away.
                */
                private _lastCoverMove = _unit getVariable [
                    "cti_disconnect_last_cover_move",
                    -1000
                ];

                if (
                    time - _lastCoverMove >= 8 ||
                    _distanceFromAnchor > _defenseRadius
                ) then {

                    private _safePosition = [
                        _anchorPosition,
                        3,
                        _safePositionRadius,
                        2,
                        0,
                        0.5,
                        0
                    ] call BIS_fnc_findSafePos;


                    if (
                        count _safePosition >= 2
                    ) then {

                        if (
                            _currentVehicle == _vehicle
                        ) then {

                            _currentVehicle doMove _safePosition;

                        } else {

                            _unit doMove _safePosition;
                        };


                        _unit setVariable [
                            "cti_disconnect_last_cover_move",
                            time,
                            false
                        ];
                    };
                };

            } else {

                /*
                    No enemy nearby.

                    Cancel old movement orders and keep the unit
                    close to its own original position.
                */
                if (
                    _distanceFromAnchor > _defenseRadius
                ) then {

                    private _safePosition = [
                        _anchorPosition,
                        3,
                        _safePositionRadius,
                        2,
                        0,
                        0.5,
                        0
                    ] call BIS_fnc_findSafePos;


                    if (
                        count _safePosition >= 2
                    ) then {

                        if (
                            _currentVehicle == _vehicle
                        ) then {

                            _currentVehicle doMove _safePosition;

                        } else {

                            _unit doMove _safePosition;
                        };

                    } else {

                        _unit doMove _anchorPosition;
                    };

                } else {

                    doStop _unit;
                    _unit setBehaviour "AWARE";
                    _unit setCombatMode "YELLOW";
                };
            };
        };
    } forEach _units;


    /*
        Rebuild the list so killed units do not stay in memory forever.
    */
    _units = _units select {
        !isNull (_x select 0)
    };


    _team setVariable [
        "cti_disconnect_units",
        _units,
        false
    ];


    sleep _checkInterval;
};


/*
    Player returned or the group was removed.

    Restore normal movement/combat settings for surviving units.
*/
{
    _x params [
        "_unit",
        "_vehicle"
    ];


    if (
        !isNull _unit &&
        alive _unit
    ) then {

        _unit enableAI "MOVE";
        _unit enableAI "TARGET";
        _unit enableAI "AUTOTARGET";
        _unit enableAI "ANIM";

        _unit setBehaviour "AWARE";
        _unit setCombatMode "YELLOW";
    };

} forEach _units;


true
