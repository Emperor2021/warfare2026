private ["_action"];
_action = _this select 0;

switch (_action) do {
	case "onLoad": {
		_logic = (CTI_P_SideJoined) call CTI_CO_FNC_GetSideLogic;
		_workers = _logic getVariable "cti_workers";
		uiNamespace setVariable ["cti_dialog_ui_workersmenu_workers", _workers];
		uiNamespace setVariable ["cti_dialog_ui_workersmenu_sellmode", 0];
		if ((missionNamespace getVariable "CTI_BASEBUILDING") < 1) then {
			((uiNamespace getVariable "cti_dialog_ui_workersmenu") displayCtrl 260002) ctrlshow true;
			((uiNamespace getVariable "cti_dialog_ui_workersmenu") displayCtrl 260003) ctrlshow true;
		} else {
			((uiNamespace getVariable "cti_dialog_ui_workersmenu") displayCtrl 260002) ctrlshow false;
			((uiNamespace getVariable "cti_dialog_ui_workersmenu") displayCtrl 260003) ctrlshow false;

		};
		{
			if (typeName _x == "OBJECT") then {
				((uiNamespace getVariable "cti_dialog_ui_workersmenu") displayCtrl 260002) lnbAddRow [format["%1", mapGridPosition _x], format["Worker %1",_forEachIndex+1]];
				((uiNamespace getVariable "cti_dialog_ui_workersmenu") displayCtrl 260002) lnbSetValue [[_forEachIndex,0], _forEachIndex];
			};
		} forEach _workers;
	};
	case "onWorkersListLBSelChanged": {
		_selected = _this select 1;

		_selected = lnbValue [260002, [_selected, 0]];
		_worker = (uiNamespace getVariable "cti_dialog_ui_workersmenu_workers") select _selected;

		//--- Focus the minimap on the worker
		if (alive _worker) then {
			ctrlMapAnimClear ((uiNamespace getVariable "cti_dialog_ui_workersmenu") displayCtrl 260001);
			((uiNamespace getVariable "cti_dialog_ui_workersmenu") displayCtrl 260001) ctrlMapAnimAdd [.65, .2, getPos _worker];
			ctrlMapAnimCommit ((uiNamespace getVariable "cti_dialog_ui_workersmenu") displayCtrl 260001);
		};
	};
	case "onWorkerDisbandPressed": {
		_selected = _this select 1;

		if (_selected > -1) then { //--- Disband and delete the entry
			((uiNamespace getVariable "cti_dialog_ui_workersmenu") displayCtrl 260003) ctrlenable false;
			_selected = lnbValue [260002, [_selected, 0]];
			lnbClear  260002 ;
			_worker = (uiNamespace getVariable "cti_dialog_ui_workersmenu_workers") select _selected;
			_worker setDammage 1;
			_logic = (CTI_P_SideJoined) call CTI_CO_FNC_GetSideLogic;
			_workers = _logic getVariable "cti_workers";
			uiNamespace setVariable ["cti_dialog_ui_workersmenu_workers", _workers];
			{
				if (typeName _x == "OBJECT") then {
					((uiNamespace getVariable "cti_dialog_ui_workersmenu") displayCtrl 260002) lnbAddRow [format["%1", mapGridPosition _x], format["Worker %1",_forEachIndex+1]];
					((uiNamespace getVariable "cti_dialog_ui_workersmenu") displayCtrl 260002) lnbSetValue [[_forEachIndex,0], _forEachIndex];
				};
			} forEach _workers;
			((uiNamespace getVariable "cti_dialog_ui_workersmenu") displayCtrl 260003) ctrlEnable true;
			//((uiNamespace getVariable "cti_dialog_ui_workersmenu") displayCtrl 260002) lnbDeleteRow _selected;
		};
	};
	case "onStructureSellPressed": {
		uiNamespace setVariable ["cti_dialog_ui_workersmenu_sellmode", 1];
	};
	case "onMapButtonDown": {
		_event = _this select 1;
		_button = _event select 1;
		_mx = _event select 2;
		_my = _event select 3;

		if (_button == 0 && (uiNamespace getVariable "cti_dialog_ui_workersmenu_sellmode") == 1) then {
			if (CTI_BASE_AREA_SALE > 0) then {
				_structures = (CTI_P_SideJoined) call CTI_CO_FNC_GetSideStructures;
				_structures = _structures + (CTI_P_SideLogic getVariable "cti_fobs");
				_mappos = ((uiNamespace getVariable "cti_dialog_ui_workersmenu") displayCtrl 260001) ctrlMapScreenToWorld [_mx, _my];
				_nearest = [_mappos, _structures] call CTI_CO_FNC_GetClosestEntity;
				if (_nearest distance _mappos < 500) then {
					if (CTI_BASE_AREA_SALE == 1) then {
						if (isNil {_nearest getVariable "cti_sell"}) then {
							_nearest setVariable ["cti_sell", true, true];
							_nearest setDammage 1;
							["SERVER", "Request_UpdateBaseAreas", CTI_P_SideJoined] call CTI_CO_FNC_NetSend;
						};
					};

					if (CTI_BASE_AREA_SALE == 2) then {
						private ["_area", "_areas", "_areas_found", "_enemy", "_enemylogic"];
						_areas = CTI_P_SideLogic getVariable "cti_structures_areas";
						_enemy = switch (CTI_P_SideJoined) do
							{
							    case west: {east};
							    case east: {west};
							};
						_enemylogic= (_enemy) call CTI_CO_FNC_GetSideLogic;
						_areas_found = _enemylogic getVariable "CTI_BASES_FOUND_AREAS";
						_area = [_nearest, _areas] call CTI_CO_FNC_GetClosestEntity;
						if !(_area in _areas_found) then {
							if (isNil {_nearest getVariable "cti_sell"}) then {
								_nearest setVariable ["cti_sell", true, true];
								_nearest setDammage 1;
								["SERVER", "Request_UpdateBaseAreas", CTI_P_SideJoined] call CTI_CO_FNC_NetSend;
							};
						} else {
//							hint parseText localize "STR_CTI_Base_Sale_Discovered";
							if (_nearest in (CTI_P_SideLogic getVariable ["cti_fobs",[]])) then {
								_nearest setDammage 1;
								CTI_P_SideLogic setVariable ["cti_fobs", (CTI_P_SideLogic getVariable "cti_fobs") - [objNull, _nearest], true];
							} else {
								hint parseText localize "STR_CTI_Base_Sale_Discovered";
							};
						};
					};
				};
			} else {
				hint parseText localize "STR_CTI_Base_Sale_Disabled";
			};
			uiNamespace setVariable ["cti_dialog_ui_workersmenu_sellmode", 0];
		};
	};
};