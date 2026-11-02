
if (CTI_PLAYERS_GROUPSIZE > 100) then {
	(CTI_PLAYERS_GROUPSIZE - 100) + (floor ((score player) / 100))
} else {
	CTI_PLAYERS_GROUPSIZE
}