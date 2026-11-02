
waitUntil {(getPos _this) select 2 > 19.11};

hint parseText localize "STR_CTI_NUKE_DEVICE_ARMED";

//waitUntil {isTouchingGround _this};
waitUntil {(getPos _this) select 2 < 1.911};

//if (isTouchingGround _device) then {
if ((getPos _this) select 2 < 1.911) then {
	["SERVER", "Request_NukeDeviceDrop", getPos _this] call CTI_CO_FNC_NetSend;
//	["DEBUG", "FILE: Addons\Nuke\Nuke_Common_DeviceInit.sqf", str(getPos _this)] call CTI_CO_FNC_Log;
	sleep 1;
	deleteVehicle _this;
};
