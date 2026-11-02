
/*
	Original File: fn_keyHandler.sqf
	Author: Bryan "Tonic" Boardwine

	File: Client_KeyHandler.sqf
	Author: 1911

	Description:
	Main key handler for event 'keyDown'
*/

private ["_alt","_ctrl","_dir","_disp","_dist","_key","_locked","_ret","_shift","_tmp","_type","_veh","_vehicles"];

//--- Обработка отображения боекомплекта на карте
if (visibleMap) then {
    if (_key == 50) exitWith {  // DIK_M
        //--- Принудительно обновить информацию при нажатии M
        [] call CTI_CL_FNC_ShowAmmoInfo;
        false
    };
};



_disp = _this select 0;
_key = _this select 1;
_shift = _this select 2;
_ctrl = _this select 3;
_alt = _this select 4;

_ret = false;

if ( _key in ([(profilenamespace getVariable ['CTI_TABLET_KEY',41])] + (actionKeys "User5")) ) then {_key = 41};

switch (_key) do {

//--- Vehicle lock keys
	case 22: {
		if (time - CTI_CL_V_PreviousLockUsage < 1) exitWith {true}; //Prevent spammage
		CTI_CL_V_PreviousLockUsage = time;

		_vehicles = call CTI_CL_FNC_GetPlayerVehicles;

		if (!_ctrl) then {
			if (count _vehicles < 1) exitWith {systemChat localize "STR_CTI_KeyHandler_ToggleLock_1";};

			if (!_alt) then {
//--- U
				if (vehicle player == player) then {
					if (cursorTarget in _vehicles) then {
						_veh = cursorTarget;
					} else {
						_veh = [player, _vehicles] call CTI_CO_FNC_GetClosestEntity;
					};
				} else {
					if ((vehicle player) in _vehicles) then {
						_veh = vehicle player;
					} else {
						_type = getText (configFile >> "CfgVehicles" >> typeOf (vehicle player) >> "displayName");
						systemChat format [localize "STR_CTI_KeyHandler_ToggleLock_2", _type];
						_veh = [player, _vehicles] call CTI_CO_FNC_GetClosestEntity;
					};
				};

				_type = getText (configFile >> "CfgVehicles" >> typeOf _veh >> "displayName");
				_dist = round (player distance _veh);
				_dir = round (player getDir _veh);

				_locked = locked _veh;
				if (_locked != 0) then {
					if (local _veh) then {
						_veh lock 0;
						systemChat format [localize "STR_CTI_KeyHandler_ToggleLock_Unlocked", _type, _dist, _dir];
					} else {
						systemChat format [localize "STR_CTI_KeyHandler_ToggleLock_3", _type, _dist, _dir];
					};
				} else {
					if (count (crew _veh) > 0) then {
						{
							if (side _x == side player && group _x != group player) then {
								_x action ["getOut", _veh];
								moveOut _x;
								systemChat format [localize "STR_CTI_KeyHandler_ToggleLock_4", getText (configFile >> "CfgVehicles" >> typeOf _x >> "displayName"), _type, _dist, _dir];
							};
						} forEach (crew _veh);
					};
					if (local _veh) then {
						_veh lock 2;
						systemChat format [localize "STR_CTI_KeyHandler_ToggleLock_Locked", _type, _dist, _dir];
					} else {
						systemChat format [localize "STR_CTI_KeyHandler_ToggleLock_3", _type, _dist, _dir];
					};
				};
			} else {
//--- Alt+U
				(_vehicles) spawn {
					_vehicles = _this;
					openMap true;
					CTI_mapclick = false;
					systemChat localize "STR_CTI_KeyHandler_ToggleLock_5";
					onMapSingleClick "CTI_mapclick_pos = _pos;CTI_mapclick = true;onMapSingleClick '';true";
					waitUntil {CTI_mapclick or not visibleMap};
					if (!CTI_mapclick && !visibleMap) exitWith {systemChat localize "STR_CTI_KeyHandler_ToggleLock_Canceled";};
					if (CTI_mapclick) then {
						openMap false;
						_veh = [CTI_mapclick_pos, _vehicles] call CTI_CO_FNC_GetClosestEntity;

						_type = getText (configFile >> "CfgVehicles" >> typeOf _veh >> "displayName");
						_dist = round (player distance _veh);
						_dir = round (player getDir _veh);

						_locked = locked _veh;
						if (_locked != 0) then {
							if (local _veh) then {
								_veh lock 0;
								systemChat format [localize "STR_CTI_KeyHandler_ToggleLock_Unlocked", _type, _dist, _dir];
							} else {
								systemChat format [localize "STR_CTI_KeyHandler_ToggleLock_3", _type, _dist, _dir];
							};
						} else {
							if (count (crew _veh) > 0) then {
								{
									if (side _x == side player && group _x != group player) then {
										_x action ["getOut", _veh];
										moveOut _x;
										systemChat format [localize "STR_CTI_KeyHandler_ToggleLock_4", getText (configFile >> "CfgVehicles" >> typeOf _x >> "displayName"), _type, _dist, _dir];
									};
								} forEach (crew _veh);
							};
							if (local _veh) then {
								_veh lock 2;
								systemChat format [localize "STR_CTI_KeyHandler_ToggleLock_Locked", _type, _dist, _dir];
							} else {
								systemChat format [localize "STR_CTI_KeyHandler_ToggleLock_3", _type, _dist, _dir];
							};
						};
					};
				};
			};
		} else {
//--- Ctrl+U
			if ( (({_x == "Toolkit"} count (backpackItems player)) + ({_x == "Toolkit"} count (vestItems player))) < 1 ) exitWith {systemChat localize "STR_CTI_KeyHandler_ForceLock_1";};

			_tmp = vehicles - [_vehicles];
			_vehicles = _tmp;
			{
				if (not isNil {_x getVariable "CTI_Net"}) then {
					if (_x getVariable "CTI_Net" == CTI_P_SideID) then {_tmp = _tmp - [_x];};
				};
				if (_x distance player > 10) then {_tmp = _tmp - [_x];};
			} forEach _vehicles;
			_vehicles = _tmp;

			//if (count _vehicles < 1) exitWith {systemChat localize "STR_CTI_KeyHandler_ForceLock_2";};
			if (count _vehicles < 100) exitWith {systemChat localize "STR_CTI_KeyHandler_ForceLock_2";};

			_veh = [player, _vehicles] call CTI_CO_FNC_GetClosestEntity;

			[_veh, player] spawn SM_Force_entry;

			_type = getText (configFile >> "CfgVehicles" >> typeOf _veh >> "displayName");
			_dist = round (player distance _veh);
			_dir = round (player getDir _veh);
			systemChat format [localize "STR_CTI_KeyHandler_ForceLock_3", _type, _dist, _dir];
		};
	};



//--- Interaction (~) Key
	case 41: {
		disableSerialization;

		if ( !_alt && !_ctrl && !_shift && !visibleMap && isNull (findDisplay 60490) && !CTI_P_PreBuilding && !CTI_P_Repairing && isNull (uiNamespace getVariable ['cti_dialog_ui_interractions',objNull]) && isNull (uiNamespace getVariable ['cti_dialog_ui_tabletmain',objNull]) && isNull (uiNamespace getVariable ['cti_dialog_ui_buildmenu',objNull]) && isNull (uiNamespace getVariable ['cti_dialog_ui_videosettingsmenu',objNull]) && isNull (uiNamespace getVariable ['cti_dialog_ui_transferresourcesmenu',objNull]) && isNull (uiNamespace getVariable ['cti_dialog_ui_servicemenu',objNull]) && isNull (uiNamespace getVariable ['cti_dialog_ui_purchasemenu',objNull]) && isNull (uiNamespace getVariable ['cti_dialog_ui_upgrademenu',objNull]) && isNull (uiNamespace getVariable ['cti_dialog_ui_workersmenu',objNull]) && isNull (uiNamespace getVariable ['cti_dialog_ui_defensemenu',objNull]) && isNull (uiNamespace getVariable ['cti_dialog_ui_requestmenu',objNull]) && isNull (uiNamespace getVariable ['cti_dialog_ui_onlinehelpmenu',objNull]) && isNull (uiNamespace getVariable ['cti_dialog_ui_gear',objNull]) && isNull (uiNamespace getVariable ['cti_dialog_ui_respawnmenu',objNull]) && isNull (uiNamespace getVariable ['cti_dialog_ui_satcam',objNull]) && isNull (uiNamespace getVariable ['cti_dialog_ui_unitscam',objNull]) && isNull (uiNamespace getVariable ['cti_dialog_ui_teamsmenu',objNull]) && isNull (uiNamespace getVariable ['cti_dialog_ui_mapcommandmenu',objNull]) && isNull (uiNamespace getVariable ['cti_dialog_ui_hookmenu',objNull]) && isNull (uiNamespace getVariable ['cti_dialog_ui_aimicromenu',objNull]) && isNull (uiNamespace getVariable ['cti_dialog_ui_artillerymenu',objNull]) && isNull (uiNamespace getVariable ['cti_dialog_ui_aircraftloadoutmenu',objNull]) ) then {
			uiNamespace setVariable ["INT_TARG", call TABLET_GET_TARGET];
			createdialog "CTI_RscInteraction";
			_ret = true;
		};

	};

};

_ret
