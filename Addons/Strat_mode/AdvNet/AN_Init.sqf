AN_Check_Connection = compile preprocessFileLineNumbers "Addons\Strat_mode\AdvNet\AN_CheckConn.sqf";
AN_Reconfigure = compile preprocessFileLineNumbers "Addons\Strat_mode\AdvNet\AN_Reconfigure.sqf";
AN_Launch = compile preprocessFileLineNumbers "Addons\Strat_mode\AdvNet\AN_Launch.sqf";
AN_Update_Connection = compile preprocessFileLineNumbers "Addons\Strat_mode\AdvNet\AN_Update_Connection.sqf";
AN_Handle_Team = compile preprocessFileLineNumbers "Addons\Strat_mode\AdvNet\AN_Handle_Team.sqf";

AN_Switchable = compile preprocessFileLineNumbers "Addons\Strat_mode\AdvNet\AN_Switchable.sqf";
AN_Reconfigure_loop = compile preprocessFileLineNumbers "Addons\Strat_mode\AdvNet\AN_Reconfigure_Loop.sqf";

with missionNamespace do {
    CTI_PVF_Server_Run_Net = {
        _this spawn AN_Launch;
    };
};

0 execVM "Addons\Strat_mode\AdvNet\AN_Ex_Intrusion.sqf";

waitUntil {
    sleep 0.1;
    CTI_Init_Strat && CTI_InitTowns
};

if (CTI_IsClient && hasInterface) then {

    0 spawn {
        while {!CTI_GameOver} do {

            waitUntil {
                sleep 0.5;
                !isNull player && alive player
            };

            
            waitUntil {
                sleep 0.1;
                !isNull player &&
                !isNil {player getVariable "CTI_Net"} &&
                !isNil {player getVariable "AN_iNet"} &&
                !isNil {player getVariable "AN_Conn"}
            };

            if (NET_LOG) then {
                diag_log format [
                    ":: NET :: Starting Client_AN_Connected loop for player %1",
                    player
                ];
            };

            while {alive player && !CTI_GameOver} do {

                private _net = player getVariable ["CTI_Net", -1];
                private _inet = player getVariable ["AN_iNet", -1];
                private _conn = player getVariable ["AN_Conn", objNull];

                private _isConnected =
                    (_net > -1) &&
                    (_net isEqualTo _inet) &&
                    {!isNull _conn} &&
                    {alive _conn};

                // Client_AN_Connected — производное состояние для UI, только чтение реплики
                if (isNil "Client_AN_Connected" || {Client_AN_Connected != _isConnected}) then {
                    Client_AN_Connected = _isConnected;
                };
                sleep 0.2;
            };
        };
    };
};

if (CTI_IsServer) then {

    waitUntil {
        sleep 0.1;
        CTI_Init_Server
    };

    {
        [_x] spawn AN_Switchable;
        true
    } count switchableUnits;

        0 spawn {
        while {!CTI_GameOver} do {
            {
                                private _h = _x getVariable ["AN_updHandle", scriptNull];
                if (alive _x && {isNull _h || {scriptDone _h}}) then {
                    [_x, (side _x) call CTI_CO_FNC_GetSideID] spawn AN_Launch;
                };
            } forEach allPlayers;
            sleep 2;
        };
    };

    {
        [_x, -1] spawn AN_Launch;
        true
    } count CTI_Towns;
};