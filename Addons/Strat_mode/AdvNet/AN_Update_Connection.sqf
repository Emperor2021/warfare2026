private ["_vehicle"];
_vehicle=_this;
while {! CTI_GameOver && alive  _vehicle} do {
	// На сервере все объекты local, проверка не нужна
	if (CTI_isServer) then {
		// Сервер обновляет AN_iNet для всех
	} else {
		if (! local _vehicle && _vehicle isKindOf "Man") exitWith {false};
	};
	if ((_vehicle) call AN_Check_Connection) then {
		if !((_vehicle getVariable "AN_iNet") == (_vehicle getVariable "AN_Conn") getVariable "AN_iNet") then {
			_vehicle setVariable ["AN_iNet",(_vehicle getVariable "AN_Conn") getVariable "AN_iNet" ,true];
		};
	} else {
		if !((_vehicle getVariable "AN_iNet") == -1) then {
			_vehicle setVariable ["AN_iNet",-1,true];
		};
	};
	
	// Обновляем статус связи для локального игрока
	if (!CTI_isServer && {_vehicle isKindOf "Man"} && {local _vehicle} && {isPlayer _vehicle}) then {
		private _iNet = _vehicle getVariable ["AN_iNet", -1];
		private _connected = (_iNet == CTI_P_SideID);
		
		if (isNil "Client_AN_Connected" || {Client_AN_Connected != _connected}) then {
			Client_AN_Connected = _connected;
			if (CTI_Log_Level >= CTI_Log_Information) then {
				["INFORMATION", "FILE: AN_Update_Connection.sqf", 
				format["Client network status: %1", if (_connected) then {"CONNECTED"} else {"DISCONNECTED"}]] call CTI_CO_FNC_Log;
			};
		};
	};
	
	sleep 3;
};
_vehicle setVariable ["AN_iNet",nil,true];