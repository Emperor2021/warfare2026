
if (isServer) then {

	CTI_SE_FNC_BigFOB_Convert = compileFinal preprocessFileLineNumbers "Addons\BigFOB\BigFOB_Server_Convert.sqf";
	CTI_SE_FNC_BigFOB_Dismantle = compileFinal preprocessFileLineNumbers "Addons\BigFOB\BigFOB_Server_Dismantle.sqf";
	CTI_SE_FNC_BigFOB_Loop = compileFinal preprocessFileLineNumbers "Addons\BigFOB\BigFOB_Server_Loop.sqf";

};

if (hasInterface) then {

	CTI_CL_FNC_BigFOB_GetActionAvailability = compileFinal preprocessFileLineNumbers "Addons\BigFOB\BigFOB_Client_GetActionAvailability.sqf";

};
