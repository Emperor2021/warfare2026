_team=_this select 0;
_side=_this select 1;
while {!CTI_GameOver && local leader _team} do {
	// Wait for leader to become alive, with a timeout to avoid infinite blocking
	waitUntil {
		sleep 1;
		alive leader _team
	};
	// Перезапуск по мёртвому циклу, а не по отсутствию AN_iNet.
	// При падении цикла по ошибке хвост AN_Update_Connection не выполняется,
	// AN_iNet остаётся непустым — старый признак никогда не срабатывал.
	private _leader = leader _team;
	private _h = _leader getVariable ["AN_updHandle", scriptNull];
	if (isNull _h || {scriptDone _h}) then {
		[_leader, _side] call AN_Launch;
	};
};
