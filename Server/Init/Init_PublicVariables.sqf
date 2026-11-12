//--- PVF Are store within the mission namespace
with missionNamespace do {
	CTI_PVF_First_Time = {
		private ["_client","_get", "_uid"];
		
		_client = _this select 0;
		_side = _this select 1;
		_uid = getPlayerUID _client;
		_get = missionNamespace getVariable Format["CTI_SERVER_CLIENT_%1",_uid];
		
		if !(isNil '_get') then {
			if (_get select 4) then {
				_get set [2, _side];
				_get set [4, false];
				missionNamespace setVariable [Format["CTI_SERVER_CLIENT_%1",_uid],_get];
			};
		};
	};
	
	//--- Forward a PVF to a client (client to client communication)
	CTI_PVF_Server_Forwarder = {
		private ["_pv_who"];

		_pv_who = (_this select 0) select 1;
		if (typeName _pv_who == "OBJECT") then { _pv_who = owner _pv_who };

		if (typeName _pv_who != "SCALAR") exitWith {
			if (CTI_Log_Level >= CTI_Log_Error) then { //--- Error
				["ERROR", "FUNCTION: CTI_PVF_Server_Forwarder", format ["PVF [%1] could not be forwarded to the desired client since it isn't an OBJECT (Target: [%2], Type [%3])", _this select 1, _pv_who, typeName _pv_who]] call CTI_CO_FNC_Log
			};
		};

		CTI_NetCom = _this; //--- Compose the net message (again)
		_pv_who publicVariableClient "CTI_NetCom";
	};

	CTI_PVF_Request_HQLocality = {
		private ["_hq", "_side", "_target"];
		_side = _this select 0;
		_target = _this select 1;

		_hq = (_side) call CTI_CO_FNC_GetSideHQ;
		if (isnull _target) then {_hq setOwner 0} else {_hq setOwner (owner _target)};
	};

	CTI_PVF_Request_Locality = {
		private ["_hq", "_side", "_target"];
		_obj = _this select 0;
		_target = _this select 1;

		_obj setOwner (owner _target);
	};

	CTI_PVF_Request_AddScore = { _this spawn CTI_SE_FNC_AddScore };

	CTI_PVF_Request_Building = { _this spawn CTI_SE_FNC_BuildStructure };
	CTI_PVF_Request_Defense = { _this spawn CTI_SE_FNC_BuildDefense };

	CTI_PVF_Request_Purchase = { _this spawn CTI_SE_FNC_OnClientPurchase };
	CTI_PVF_Request_PurchaseCancel = { _this spawn CTI_SE_FNC_OnClientPurchaseCancelled };
	CTI_PVF_Answer_Purchase = { _this spawn CTI_SE_FNC_OnClientPurchaseComplete };

	CTI_PVF_Request_Worker = { _this spawn CTI_SE_FNC_CreateWorker };

	CTI_PVF_Request_HandleAction = {
		private ["_action", "_param"];
		_action = _this select 0;
		_param = _this select 1;

		switch (_action) do {
			case "empty": {_param spawn CTI_SE_FNC_HandleEmptyVehicle};
			case "repair": {_param execFSM "Server\FSM\update_repairtruck.fsm"};
			case "salvager": {_param execFSM "Server\FSM\update_salvager.fsm"};
		};
	};

	CTI_PVF_Request_AIOrderAction = {
		private ["_groups", "_order", "_side"];
		_groups = _this select 0;
		_order = _this select 1;
		_side = _this select 2;

		if (typeName _groups != "ARRAY") then {_groups = [_groups]};

		{
			switch (_order) do {
				case CTI_ORDER_EMBARKCOMMANDVEH: {[["CLIENT", _side], "Client_OnMessageReceived", ["order-getin", leader _x]] call CTI_CO_FNC_NetSend; (_x) call CTI_FSM_UpdateAI_EmbarkCommandableVehicles};
				case CTI_ORDER_DISEMBARKCOMMANDVEH: {[["CLIENT", _side], "Client_OnMessageReceived", ["order-getout", leader _x]] call CTI_CO_FNC_NetSend; (_x) call CTI_FSM_UpdateAI_DisembarkCommandableVehicles};
				case CTI_ORDER_EMBARKCARGOVEH: {[["CLIENT", _side], "Client_OnMessageReceived", ["order-getinc", leader _x]] call CTI_CO_FNC_NetSend; (_x) call CTI_FSM_UpdateAI_EmbarkCargoVehicles};
				case CTI_ORDER_DISEMBARKCARGOVEH: {[["CLIENT", _side], "Client_OnMessageReceived", ["order-getoutc", leader _x]] call CTI_CO_FNC_NetSend; (_x) call CTI_FSM_UpdateAI_DisembarkCargoVehicles};
			};
		} forEach _groups;
	};

	CTI_PVF_Request_Join = {
		private ["_client","_east","_end","_first_time","_join","_players","_side","_uid","_west"];
		_client = _this select 0;
		_side = _this select 1;

		_name = name _client;
		_uid = getPlayerUID _client;
		_join = true;
		_was_jailed = false;
		_end = 0;
		_get = missionNamespace getVariable Format["CTI_SERVER_CLIENT_%1",_uid];

		//--- Teamswap check
		If (CTI_TEAMSWAP == 1 && _join) then {
			if !(isNil '_get') then { //--- Retrieve JIP Information if there's any.
				_side_origin = _get select 2; //--- Get the original side.
				_first_time = _get select 4; //--- Get any previous successful join attempts.
				if !(isNil '_first_time') then { //--- Bypass if no previous successful join detected (ie kicked for stacking on first join).
					if (_side_origin != _side) then { //--- The joined side differs from the original one. 
						_join = false;
//						["CLIENT", "Client_OnMessageReceived", ["teamswap", _name]] call CTI_CO_FNC_NetSend;
						if (CTI_Log_Level >= CTI_Log_Information) then {["INFORMATION", "FUNCTION: CTI_PVF_Request_Join", format["Player [%1] [%2] tried to teamswap from it's original side [%3] to side [%4]. The server explicitely answered that he should be sent back to the lobby.", _name, _uid, _side_origin, _side]] call CTI_CO_FNC_Log};
						_end = 6;
					};
				};
			} else {
				if (CTI_Log_Level >= CTI_Log_Warning) then {["WARNING", "FUNCTION: CTI_PVF_Request_Join", format["Player [%1] [%2] doesn't have any JIP information yet. If this is the start of the mission then this message can be safely ignored.", _name, _uid]] call CTI_CO_FNC_Log};
			};
		};

		//--- Team-stack check
		if (CTI_TEAMSTACK > 0) then {
			_imbalance = 2;
			_east = east countSide allPlayers;
			_west = west countSide allPlayers;

			//--- If a large enough imbalance is detected, name and shame the player and deny the request
			If ((_side == west && _west > _east + _imbalance) || (_side == east && _east > _west + _imbalance)) then {
				_first_time = _get select 4; //--- Get any previous successful join attempts.
				if (_first_time) then {
					_join = false;
//					["CLIENT", "Client_OnMessageReceived", ["teamstack", _name]] call CTI_CO_FNC_NetSend;
					if (CTI_Log_Level >= CTI_Log_Information) then {["INFORMATION", "FUNCTION: CTI_PVF_Request_Join", format["Player [%1] [%2] tried to teamstack on side [%3]. The server explicitely answered that he should be sent back to the lobby.", _name, _uid, _uid]] call CTI_CO_FNC_Log};
					_end = 7;
				};
				if (_uid in CTI_UIDs_VIP) then {
					_join = true;
					_end = 0;
				};
			};
		};

		if (_uid in CTI_UIDs_VIP) then {
			_was_jailed = false;
		};

		if (CTI_Log_Level >= CTI_Log_Information) then {["INFORMATION", "FUNCTION: CTI_PVF_Request_Join", format["Player [%1] [%2] can join? -> [%3].", _name, _uid, _join]] call CTI_CO_FNC_Log};
		_get = missionNamespace getVariable format ["CTI_SERVER_CLIENT_ELITE_%1", _uid];
		if !(isNil '_get') then {if (_get select 1 == 1) then {_was_jailed = true}};
		[["CLIENT", _client], "Client_JoinRequestAnswer", [_join, _was_jailed, _end]] call CTI_CO_FNC_NetSend;
	};

	CTI_PVF_Request_Date = { 
		Private ["_client","_serverdate"];
		_client = _this select 0;
		_serverdate = date;
		[["CLIENT", _client], "Client_DateRequestAnswer", [_serverdate]] call CTI_CO_FNC_NetSend;
	};

	CTI_PVF_Request_NoobLogger = { _this spawn CTI_SE_FNC_NoobLogger };
	CTI_PVF_Request_NoobLoggerEnd = { _this spawn CTI_SE_FNC_NoobLoggerEnd };
	CTI_PVF_Request_Upgrade = { _this spawn CTI_SE_FNC_StartUpgrade };
	CTI_PVF_Request_EventDestroyedHQ = { _this spawn CTI_SE_FNC_OnHQDestroyed };
	CTI_PVF_Request_HQRepair = { _this spawn CTI_SE_FNC_RepairHQ };
    CTI_PVF_Request_DeleteSelectedBot = { _this spawn CTI_SE_FNC_DeleteSelectedBot };

	CTI_PVF_Request_TownAddVehicles = {
		private ["_side", "_town", "_vehicles"];

		_town = _this select 0;
		_side = _this select 1;
		_vehicles = _this select 2;

		if (_side == resistance) then {
			_town setVariable ["cti_town_resistance_active_vehicles", (_town getVariable "cti_town_resistance_active_vehicles") + _vehicles];
		} else {
			_town setVariable ["cti_town_occupation_active_vehicles", (_town getVariable "cti_town_occupation_active_vehicles") + _vehicles];
		};
	};
	CTI_PVF_Request_Cache = { _this spawn CTI_SE_FNC_Cache };
	CTI_PVF_Uncache = {
		_this  enableSimulationGlobal true;
		diag_log format [":: Cache :: Force Uncaching %1",(_this) ];
	};

	CTI_PVF_Request_Punishment = {removeAllWeapons _this;removeAllItems _this;removeAllAssignedItems _this;removeAllContainers _this;removeHeadgear _this;sleep 3;_this setDammage 1;};

	CTI_PVF_Request_NukeStrike = { [_this] spawn CTI_SE_FNC_NukeLaunch };
	CTI_PVF_Request_NukeDeviceDrop = { [_this] spawn CTI_SE_FNC_NukeDetonation };

	CTI_PVF_Request_UpdateBaseAreas = { _this spawn CTI_SE_FNC_UpdateBaseAreas };

	CTI_PVF_Request_ConvertToBigFOB = { _this spawn CTI_SE_FNC_BigFOB_Convert };
	CTI_PVF_Request_DismantleBigFOB = { _this spawn CTI_SE_FNC_BigFOB_Dismantle };

	// === ИСПРАВЛЕНИЕ БАГА #1: Сервер принимает обновление AI Units от клиента ===
	// _this — это параметры (PVF parameters), а не весь NetCom массив
	CTI_PVF_Request_Update_AIUnits = {
		private ["_data", "_aiUnits", "_playerVehicles"];
		_data = _this;  // _this уже есть параметры (Common_OnPVFReceived передаёт select 2)
		
		if (count _data >= 1) then {
			CTI_AI_Units = _data select 0;
		};
		if (count _data >= 2) then {
			CTI_Player_Vehicles = _data select 1;
		};
		
		publicVariable "CTI_AI_Units";
		publicVariable "CTI_Player_Vehicles";
		
		if (CTI_Log_Level >= CTI_Log_Debug) then {
			["DEBUG", "FUNCTION: CTI_PVF_Request_Update_AIUnits", format ["AI Units: %1, Player Vehicles: %2", count CTI_AI_Units, count CTI_Player_Vehicles]] call CTI_CO_FNC_Log;
		};
	};

	// === СЕТЬ ДЛЯ БОТОВ ===
	// Было: свой цикл с _bot call AN_Update_Connection.
	// AN_Update_Connection — сам бесконечный while со sleep 3, спроектирован под spawn.
	// Вызов через call блокировал внешний поток: AN_Reconfigure выполнялся один раз,
	// sleep 5 недостижим, бот никогда не переподключался.
	// Плюс обход AN_Launch не писал AN_updHandle → конфликт с guard'ом по scriptDone.
	// Используем существующий AN_Launch: он спавнит оба цикла и хранит handles.
	CTI_PVF_Request_BotNetworkInit = {
		private ["_bot"];
		_bot = _this select 0;
		if (isNil "_bot" || {isNull _bot} || {!alive _bot}) exitWith {};
		[_bot, (side _bot) call CTI_CO_FNC_GetSideID] spawn AN_Launch;
	};

};