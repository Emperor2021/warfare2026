_team=_this select 0;
_side=_this select 1;
while {!CTI_GameOver && local leader _team} do {
	// Wait for leader to become alive, with a timeout to avoid infinite blocking
	waitUntil {
		sleep 1;
		alive leader _team
	};
	// Only launch if network is not yet initialized
	if (isNil {(leader _team) getVariable "AN_iNet"}) then {
		[leader _team, _side] call AN_Launch;
	};
};
