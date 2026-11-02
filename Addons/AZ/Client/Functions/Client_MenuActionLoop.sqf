
while {TRUE} do {
	player addAction ["<t color='#00C900'>AZ</t>", "createDialog 'AZ_RscUnitsCamera';", "", -1911, false, true, "", "alive player"];
	waitUntil {not alive player};
	waitUntil {alive player};
};
