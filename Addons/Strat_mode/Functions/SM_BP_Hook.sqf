private ["_bases", "_bases_old", "_side", "_sidelogic"];
_side = _this;
_sidelogic = (_side) call CTI_CO_FNC_GetSideLogic;
_bases = (_sidelogic getVariable "cti_structures_areas");
_bases_old = _bases;

while {!CTI_GameOver} do {
	_bases = (_sidelogic getVariable "cti_structures_areas");

	{
		if !(_x in _bases_old) then {
			if ((missionNamespace getVariable 'CTI_SM_BASEP_M') != 0) then {[_bases select ((count _bases) -1),_side, ((count _bases) -1)] spawn SM_BP_Init};
			[["CLIENT",_side], "Client_Base_Zone",[_side,((count _bases) -1),_bases select ((count _bases) -1)]] call CTI_CO_FNC_NetSend;
		};
	} forEach _bases;

	_bases_old = _bases;

	sleep 1;
};
