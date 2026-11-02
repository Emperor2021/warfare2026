waitUntil {!isNil "CTI_P_SideJoined" && !isNil "CTI_CO_FNC_GetSideUpgrades"};
disableSerialization;

	private ["_action","_target","_nextHaloJumpIn","_nextHaloJumpInMin","_nextHaloJumpInSec"];
	_action = _this select 0;
	_target = uiNamespace getVariable ['INT_TARG', objNull];

// НАСТРОЙКИ РАДИАЛЬНОГО МЕНЮ (Battlefield Style)
// Геометрический центр экрана Arma 3
private _base_x = SafeZoneX + (SafeZoneW * 0.5);
private _base_y = SafeZoneY + (SafeZoneH * 0.5);

// Размер кнопок (ширина и высота)
private _btn_w = SafeZoneH * 0.10;
private _btn_h = SafeZoneH * 0.10;

// Радиус круга (расстояние от центра экрана до кнопок)
private _radius_y = SafeZoneH * 0.30;

// КОРРЕКЦИЯ ШИРОКОФОРМАТНОГО ЭКРАНА (Aspect Ratio Correction)
// Без этого круг будет растянут по горизонтали в овал на мониторах 16:9 / 21:9
private _radius_x = _radius_y * (safezoneH / safezoneW);

private _max_ctrl = 40;
private _up_hen = "";

// Сюда будем собирать только те кнопки, условия которых прошли проверку
private _active_controls = [];
private _active_controls_interact = [];

switch (_action) do {
	case "onLoad": {
		private _display = uiNamespace getVariable ["cti_dialog_ui_interractions", displayNull];
		if (isNull _display) exitWith {};

		// 1. Установка названия цели в текстовую панель над меню
		if (_target isKindOf "Man") then {
			(_display displayCtrl (510103)) ctrlSetText (format ["%1", name _target]);
		} else {
			(_display displayCtrl (510103)) ctrlSetText (getText (configFile >> "CfgVehicles" >> typeOf _target >> "displayname"));
		};

		// 2. Логическая фильтрация и первоначальная настройка иконок
		private _ctrl = controlNull;
		for "_i" from 1 to _max_ctrl do {
			_ctrl = _display displayCtrl (511000 + _i);
			if (!isNull _ctrl) then {
				private _show = false;
				
				// Выполняем оригинальные проверки BECTI для отображения иконок
				switch (_i) do {
					case 1: { // CTI_Icon_tablet
						_ctrl ctrlSetTextColor [1,1,0,1];
						_show = true;
					};
					case 2: { // CTI_Icon_units
						if (!CTI_P_PreBuilding && (Client_AN_Connected && (CTI_Base_BarracksInRange || CTI_Base_LightInRange || CTI_Base_HeavyInRange || CTI_Base_AirInRange || CTI_Base_AmmoInRange || CTI_Base_RepairInRange || CTI_Base_NavalInRange)) || CTI_Town_InRange) then {
							_ctrl ctrlSetTextColor [0.2588, 1, 0.7137, 1];
							_show = true;
						} else {
							_ctrl ctrlSetTextColor [0.4, 0.4, 0.4, 0.25]; // Выключена
						};
					};
					case 3: { // CTI_Icon_Gear
						if (Client_AN_Connected && CTI_Base_GearInRange) then {
							_ctrl ctrlSetTextColor [0.2588, 1, 0.7137, 1];
							_show = true;
						} else {
							_ctrl ctrlSetTextColor [0.4, 0.4, 0.4, 0.25];
						};
					};
					case 4: { // CTI_Icon_fact
						if ((CTI_P_SideLogic getVariable "cti_commander") == group player && (leader group player) == player && !CTI_P_PreBuilding && CTI_Base_HQInRange) then {
							_ctrl ctrlSetTextColor [0.2588, 1, 0.7137, 1];
							_show = true;
						} else {
							_ctrl ctrlSetTextColor [0.4, 0.4, 0.4, 0.25];
						};
					};
					case 5: { // CTI_Icon_halo
						if (vehicle player == player && !CTI_P_PreBuilding && CTI_Base_HaloInRange && [CTI_P_SideJoined, CTI_UPGRADE_HALO, 1] call CTI_CO_FNC_HasUpgrade && ((missionNamespace getVariable 'CTI_SM_HALO') == 1)) then {
							_show = true;
							if (time - CTI_HALO_LASTTIME >= CTI_HALO_COOLDOWN) then {
								_ctrl ctrlSetTextColor [0.2588, 1, 0.7137, 1];
								_ctrl ctrlSetTooltip (localize "STR_Icon_Halo");
							} else {
								_ctrl ctrlSetTextColor [0.9, 0.4, 0.1, 0.5]; // Кулдаун
								_nextHaloJumpIn = CTI_HALO_COOLDOWN - (time - CTI_HALO_LASTTIME);
								if (_nextHaloJumpIn >= 60) then {
									_nextHaloJumpInMin = floor (_nextHaloJumpIn / 60);
									_nextHaloJumpInSec = ceil (_nextHaloJumpIn - (_nextHaloJumpInMin * 60));
								} else {
									_nextHaloJumpInMin = 0;
									_nextHaloJumpInSec = ceil _nextHaloJumpIn;
								};
								_ctrl ctrlSetTooltip (format [localize "STR_Tooltip_HALO_Jump", _nextHaloJumpInMin, _nextHaloJumpInSec]);
							};
						} else {
							_ctrl ctrlSetTextColor [0.4, 0.4, 0.4, 0.25];
							_ctrl ctrlSetTooltip (localize "STR_Tooltip_HALO_Jump_NA");
						};
					};
					case 6: { // CTI_Icon_GROUP
						_ctrl ctrlSetTextColor [0.2588, 1, 0.7137, 1];
						_show = true;
					};
					case 7: { // CTI_Icon_Netp
						if (alive player && (missionNamespace getVariable "CTI_EW_ANET" == 1)) then {
							_show = true;
							if (((player) getVariable ['CTI_Net', -1]) == CTI_P_SideID) then {
								_ctrl ctrlSetTextColor [0.2588, 1, 0.7137, 1];
							} else {
								_ctrl ctrlSetTextColor [1, 0.2, 0.2, 0.8];
							};
						};
					};
					case 8: { // CTI_Icon_Thud
						_show = true;
						if (profileNamespace getVariable ["HUD_Tactical", true]) then {
							_ctrl ctrlSetTextColor [0.2588, 1, 0.7137, 1];
						} else {
							_ctrl ctrlSetTextColor [1, 0.2, 0.2, 0.8];
						};
					};
					case 9: { // CTI_Icon_earp
						_show = true;
						if (soundVolume < 1) then {
							_ctrl ctrlSetTextColor [0.2588, 1, 0.7137, 1];
						} else {
							_ctrl ctrlSetTextColor [1, 0.2, 0.2, 0.8];
						};
					};
					case 10: { // CTI_Icon_Lock
						if (!isNull _target && ((getPlayerUID player) in (_target getVariable ["v_keys", ["", grpNull]]) || (group player) in (_target getVariable ["v_keys", ["", grpNull]]) && alive _target)) then {
							_show = true;
							if (locked _target > 0) then {
								_ctrl ctrlSetTextColor [1, 0.2, 0.2, 0.9];
							} else {
								_ctrl ctrlSetTextColor [0.2588, 1, 0.7137, 1];
							};
						};
					};
					case 11: { // CTI_Icon_Net
						private _sideText = str CTI_P_SideJoined;
						private _enemySide = if (_sideText == "WEST") then {east} else {west};
						private _upgrades = (_enemySide) call CTI_CO_FNC_GetSideUpgrades;
						_up_hen = _upgrades select CTI_UPGRADE_HEN;

						if (alive _target && (missionNamespace getVariable "CTI_EW_ANET" == 1) && (_target isKindOf "Car" || _target isKindOf "Tank" || _target isKindOf "Truck" || _target isKindOf "Air" || _target isKindOf "Ship") && !(_target isKindOf "I_G_Offroad_01_F")) then {
							_show = true;
							if ((_target == (CTI_P_SideJoined call CTI_CO_FNC_GetSideHQ)) && _up_hen == 1) then {
								_ctrl ctrlSetTextColor [0.4, 0.4, 0.4, 0.5];
								_ctrl ctrlSetTooltip (localize "STR_Network_Lock_en");
							} else {
								if (locked _target > 0) then {
									_ctrl ctrlSetTextColor [0.4, 0.4, 0.4, 0.5];
									_ctrl ctrlSetTooltip (localize "STR_Network_Lock");
								} else {
									if (((_target) getVariable ['CTI_Net', -1]) == CTI_P_SideID) then {
										_ctrl ctrlSetTextColor [0.2588, 1, 0.7137, 1];
									} else {
										_ctrl ctrlSetTextColor [1, 0.2, 0.2, 0.8];
									};
									_ctrl ctrlSetTooltip (localize "STR_Icon_Net");
								};
							};
						};
					};
					case 12: { // CTI_Icon_Def
						if (vehicle player == player && alive _target) then {
							private _ok = false;
							if (_target == ((CTI_P_SideJoined) call CTI_CO_FNC_GetSideHQ)) then {_ok = true};
							if (_target in (CTI_P_SideLogic getVariable ["cti_structures", []])) then {
								if ((((missionNamespace getVariable [format ["CTI_%1_%2", CTI_P_SideJoined, typeOf _target], [[""]]]) select 0) select 0 == CTI_REPAIR)) then {_ok = true};
							};
							if (_target in ((CTI_WEST getVariable ["cti_service", []]) + (CTI_EAST getVariable ["cti_service", []]))) then {
								if ((missionNamespace getVariable [format ["%1", typeOf _target], ["","","","","","","",""]]) select 7 == "service-repairtruck") then {_ok = true};
							};
							if (_ok) then {
								_ctrl ctrlSetTextColor [0.2, 0.6, 1, 1];
								_show = true;
							};
						};
					};
					case 13: { // CTI_Icon_Rep
						if (vehicle player == player && (_target isKindOf "Car" || _target isKindOf "Tank" || _target isKindOf "Air" || _target isKindOf "Ship" || _target isKindOf "Wheeled_APC_F" || _target isKindOf "Truck_F") && alive _target) then {
							_show = true;
							if ((({_x == "Toolkit"} count (backpackItems player)) + ({_x == "Toolkit"} count (vestItems player))) > 0) then {
								_ctrl ctrlSetTextColor [0.2, 0.6, 1, 1];
								_ctrl ctrlSetTooltip (localize "STR_Icon_Rep");
							} else {
								_ctrl ctrlSetTextColor [0.4, 0.4, 0.4, 0.5];
								_ctrl ctrlSetTooltip (localize "STR_Repair_No_Toolkit");
							};
						};
					};
					case 14: { // CTI_Icon_fl
						private _hqs = [];
						{_hqs pushBack (_x call CTI_CO_FNC_GetSideHQ); true} count [east, west];
						if (vehicle player == player && (_target isKindOf "Car" || _target isKindOf "Tank" || _target isKindOf "Air" || _target isKindOf "Ship" || _target isKindOf "Wheeled_APC_F" || _target isKindOf "Truck_F") && alive _target && !(getPlayerUID player in (_target getVariable ["v_keys", []])) && !(_target getVariable ["cti_occupant", civilian] == CTI_P_SideJoined) && !(_target in _hqs)) then {
							_show = true;
							if ((({_x == "Toolkit"} count (backpackItems player)) + ({_x == "Toolkit"} count (vestItems player))) > 0) then {
								_ctrl ctrlSetTextColor [0.2, 0.6, 1, 1];
								_ctrl ctrlSetTooltip (localize "STR_Icon_FL");
							} else {
								_ctrl ctrlSetTextColor [0.4, 0.4, 0.4, 0.5];
								_ctrl ctrlSetTooltip (localize "STR_Force_Lock_No_ToolKit");
							};
						};
					};
					case 15: { // CTI_Icon_rev
						if (_target isKindOf "Man" && _target getVariable ['REV_UNC', false] && !(player getVariable ['REV_UNC', true]) && isNull (player getVariable ['REV_DRAGGING', objNull]) && (side group player) == (side group _target)) then {
							_ctrl ctrlSetTextColor [1, 0.2, 0.2, 1];
							_show = true;
						};
					};
					case 16: { // CTI_Icon_drag (Отключено по умолчанию в оригинале BECTI)
						if (false) then { _show = false; };
					};
					case 17: { // CTI_Icon_fpk
						if (vehicle player != player && (_target getVariable ['CTI_Net', -10]) >= 0 && !(_target getVariable ['CTI_Net', -11] == CTI_P_SideID) && (speed _target) < 1 && (speed _target) > -1 && ((CTI_P_SideLogic getVariable 'cti_upgrades') select CTI_UPGRADE_EXPI) > 0 && !AN_E_INTRU) then {
							_ctrl ctrlSetTextColor [0.2, 0.6, 1, 1];
							_show = true;
						};
					};
					case 18: { // CTI_Icon_intru
						if (vehicle player != player && (_target getVariable ['CTI_Net', -10]) >= 0 && !(_target getVariable ['CTI_Net', -11] == CTI_P_SideID) && ((CTI_P_SideLogic getVariable 'cti_upgrades') select CTI_UPGRADE_EXPI) > 0 && (_target getVariable ['CTI_Net', -10]) == (_target getVariable ['AN_inet', -11]) && (_target getVariable ['AN_Hacked', 0]) > 0 && !(_target getVariable ['AN_Hack_started', false])) then {
							_ctrl ctrlSetTextColor [0.2, 0.6, 1, 1];
							_show = true;
						};
					};
					case 19: { // CTI_Icon_load
						if (vehicle player != player && driver vehicle player == player && (_target isKindOf "I_G_Offroad_01_F" || typeOf _target == "B_Truck_01_mover_F") && speed _target < 1 && speed _target > -1 && alive _target && !STATIC_TRY) then {
							_ctrl ctrlSetTextColor [0.2, 0.6, 1, 1];
							_show = true;
						};
					};
					case 20: { // CTI_Icon_fact
						if (_target in (CTI_P_SideJoined call CTI_CO_FNC_GetSideStructures) && alive _target && !isNil {missionNamespace getVariable format ["CTI_%1_%2", CTI_P_SideJoined, typeOf _target]}) then {
							private _var = missionNamespace getVariable format ["CTI_%1_%2", CTI_P_SideJoined, typeOf _target];
							((uiNamespace getVariable "cti_dialog_ui_interractions") displayCtrl (510103)) ctrlSetText (format ["%1", ((_var select 0) select 2)]);
							_ctrl ctrlSetTextColor [0.2, 0.6, 1, 1];
							_show = true;
						};
					};
					case 21: { // CTI_Icon_del
						if ((_target in (CTI_P_SideLogic getVariable ["cti_defences", []]) || _target in (CTI_P_SideJoined call CTI_CO_FNC_GetSideStructures) || _target in (CTI_P_SideLogic getVariable ["cti_workers", []])) && !(_target in (CTI_P_SideLogic getVariable ["cti_fobs", []])) && alive _target && (0 call CTI_CL_FNC_IsPlayerCommander)) then {
							_ctrl ctrlSetTextColor [1, 0.2, 0.2, 1];
							_show = true;
						};
					};
					case 22: { // CTI_Icon_repHQ
						if ((missionNamespace getVariable "CTI_BASE_HQ_REPAIR") > 0 && (missionNamespace getVariable [format ["%1", typeOf _target], ["","","","","","","",""]]) select 7 == "service-repairtruck" && !alive(CTI_P_SideJoined call CTI_CO_FNC_GetSideHQ)) then {
							_show = true;
							if ((CTI_P_SideJoined call CTI_CO_FNC_GetSideHQ) distance _target <= CTI_BASE_HQ_REPAIR_RANGE && (0 call CTI_CL_FNC_GetPlayerFunds) >= (round (CTI_BASE_HQ_REPAIR_PRICE * (time / 60 / 60)))) then {
								_ctrl ctrlSetTextColor [0.2, 0.6, 1, 1];
							} else {
								_ctrl ctrlSetTextColor [0.4, 0.4, 0.4, 0.5];
							};
						};
					};
					case 23: { // CTI_Icon_push
						if (!(_target isKindOf "Man" || _target isKindOf "Static") && local _target && simulationEnabled _target && speed _target < 1 && speed _target > -1 && alive _target && locked _target < 2) then {
							_ctrl ctrlSetTextColor [0.2, 0.6, 1, 1];
							_show = true;
						};
					};
					case 24: { // CTI_Icon_pull
						if (!(_target isKindOf "Man" || _target isKindOf "Static") && local _target && simulationEnabled _target && speed _target < 1 && speed _target > -1 && alive _target && locked _target < 2) then {
							_ctrl ctrlSetTextColor [0.2, 0.6, 1, 1];
							_show = true;
						};
					};
					case 25: { // CTI_Icon_pack
						if (vehicle player == player && (_target isKindOf "Tank" || _target isKindOf "Wheeled_APC_F" || _target isKindOf "Truck_F" || (typeOf _target) in ["Land_Pod_Heli_Transport_04_box_F","B_Slingload_01_Cargo_F"]) && alive _target) then {
							_show = true;
							if ((count (crew _target) == 0) && abs (speed _target) < 1 && locked _target < 2) then {
								_ctrl ctrlSetTextColor [0.2, 0.6, 1, 1];
							} else {
								_ctrl ctrlSetTextColor [0.4, 0.4, 0.4, 0.5];
							};
						};
					};
					case 26: { // CTI_Icon_att
						if (vehicle player != player && driver vehicle player == player && (typeOf _target) == "O_Heli_Transport_04_F") then {
							_show = true;
							if (isNull (getSlingLoad _target) || !((typeOf (getSlingLoad _target)) in ["Land_Pod_Heli_Transport_04_fuel_F","Land_Pod_Heli_Transport_04_ammo_F","Land_Pod_Heli_Transport_04_bench_F","Land_Pod_Heli_Transport_04_covered_F","Land_Pod_Heli_Transport_04_box_F","Land_Pod_Heli_Transport_04_repair_F"])) then {
								_ctrl ctrlSetTextColor [0.4, 0.4, 0.4, 0.5];
							} else {
								_ctrl ctrlSetTextColor [0.2, 0.6, 1, 1];
							};
						};
					};
					case 27: { // CTI_Icon_para
						if (vehicle player != player && driver vehicle player == player && (typeOf _target) == "O_Heli_Transport_04_F") then {
							_show = true;
							if (isNull (getSlingLoad _target) && count (attachedObjects _target) == 0) then {
								_ctrl ctrlSetTextColor [0.4, 0.4, 0.4, 0.5];
							} else {
								_ctrl ctrlSetTextColor [0.2, 0.6, 1, 1];
							};
						};
					};
					case 28: { // CTI_Icon_build
						if (vehicle player == player && _target in (CTI_P_SideLogic getVariable ["cti_structures_wip", []]) && (missionNamespace getVariable "CTI_BASEBUILDING") > 0 && alive (CTI_P_SideJoined call CTI_CO_FNC_GetSideHQ)) then {
							_ctrl ctrlSetTextColor [0.2, 0.6, 1, 1];
							_show = true;
						};
					};
					case 29: { // CTI_Icon_srep
						if (vehicle player == player && _target in (CTI_P_SideLogic getVariable ["cti_structures", []]) && (getDammage _target > 0 || _target getVariable ["cti_altdmg", -1] > 0) && (missionNamespace getVariable "CTI_BASEBUILDING") > 0 && alive (CTI_P_SideJoined call CTI_CO_FNC_GetSideHQ)) then {
							_ctrl ctrlSetTextColor [0.2, 0.6, 1, 1];
							_show = true;
						};
					};
					case 30: { // CTI_Icon_AC - Aircraft Loadout
    // Проверяем, включена ли авиазагрузка в параметрах миссии
    if ((missionNamespace getVariable ["CTI_AC_ENABLED", 0]) > 0) then {
        // Игрок должен быть снаружи техники
        if (vehicle player == player) then {
            // Цель должна быть воздушной техникой и живой
            if (!isNull _target && {_target isKindOf "Air"} && {alive _target}) then {
                // Проверяем, что переменная загрузки существует (если нет - создаем)
                if (isNil {_target getVariable "CTI_AC_AIRCRAFT_LOADOUT_MOUNTED"}) then {
                    // Инициализируем загрузку по умолчанию
                    private _emptyLoadout = [_target] call CTI_AC_GET_STANDARD_VANILLA_LOADOUT;
                    _target setVariable ["CTI_AC_AIRCRAFT_LOADOUT_MOUNTED", _emptyLoadout, true];
                    _target setVariable ["CTI_AC_AIRCRAFT_LOADOUT_COST", 0, true];
                };
                
                // Проверяем доступ к складу боеприпасов
                private _structures = (CTI_P_SideJoined) call CTI_CO_FNC_GetSideStructures;
                private _ammo_depots = [CTI_AMMO, _structures, player] call CTI_CO_FNC_GetSideStructuresByType;
                private _available_ammo_depots = [_target, _ammo_depots, CTI_SERVICE_AMMO_DEPOT_RANGE] call CTI_UI_Service_GetBaseDepots;
                
                // Упрощаем: показываем иконку всегда, если есть доступ к аммо-складу
                if (count _available_ammo_depots > 0) then {
                    _ctrl ctrlSetTextColor [0.2, 0.6, 1, 1];
                    _show = true;
                } else {
                    _ctrl ctrlSetTextColor [0.4, 0.4, 0.4, 0.25];
                    _ctrl ctrlSetTooltip "Нет доступа к складу боеприпасов";
                };
            };
        };
    };
};
					case 31: { // CTI_Icon_Com
						if (!isNull _target && alive _target && (_target == (CTI_P_SideJoined call CTI_CO_FNC_GetSideHQ) || _target in (CTI_P_SideJoined call CTI_CO_FNC_GetSideStructures))) then {
							if (isNull (CTI_P_SideJoined call CTI_CO_FNC_GetSideCommander) && !((getPlayerUID player) in (CTI_P_SideLogic getVariable ["CTI_COM_BLACKLIST", []]))) then {
								_ctrl ctrlSetTextColor [1, 1, 0, 1];
								_show = true;
							} else {
								_ctrl ctrlSetTextColor [0.4, 0.4, 0.4, 0.5];
							};
						};
					};
					case 32: { // CTI_Icon_Pilot
						if (!isNull _target && alive _target && vehicle player == player && (_target isKindOf "B_Heli_Transport_03_unarmed_F" || _target isKindOf "O_Heli_Transport_04_F" || _target isKindOf "B_Heli_Transport_01_F")) then {
							_show = true;
							if (isNull (driver _target)) then {
								_ctrl ctrlSetTextColor [0.2, 0.6, 1, 1];
							} else {
								_ctrl ctrlSetTextColor [0.4, 0.4, 0.4, 0.5];
							};
						};
					};
					case 33: { // CTI_Icon_ExitT
						if (player getVariable ["cti_jail_time", 0] > 0) then {
							_ctrl ctrlSetTextColor [1, 0.2, 0.2, 1];
							_show = true;
						};
					};



					case 34: { // Mobile gear access
    // Получаем текущие апгрейды стороны
    private _upgrades = (CTI_P_SideJoined) call CTI_CO_FNC_GetSideUpgrades;
    
    // Условие появления: 3-й апгрейд (индекс 3) И техника имеет метки (Ammo/Gear/Medical)
    if ((_upgrades select CTI_UPGRADE_REST >= 3) && 
       (CTI_SPECIAL_AMMOTRUCK in (_target getVariable ["cti_spec",[]]) || 
        CTI_SPECIAL_GEAR in (_target getVariable ["cti_spec",[]]) || 
        (CTI_SPECIAL_MEDICALVEHICLE in (_target getVariable ["cti_spec",[]]) && (_upgrades select CTI_UPGRADE_REST >= CTI_GAMEPLAY_REARM_MED)))) 
    then {
        _ctrl ctrlSetTextColor [0, 0, 1, 1]; // Синий цвет кнопки
        _show = true;
    } else {
        _show = false; // Кнопка скрыта, если условия не соблюдены
    };
};
	


					case 35: { // CTI_Icon_DisDef
						private _dismantle_ok = false;
						if (vehicle player == player && (missionNamespace getVariable "CTI_BASEBUILDING") > 0) then {
							// 1. Standard check: target is directly recognized (3D objects like Fence, turrets, etc.)
							if (_target in (CTI_WEST getVariable ["cti_defences", []]) + (CTI_EAST getVariable ["cti_defences", []]) + (CTI_P_SideLogic getVariable ["cti_defences", []])) then {
								_dismantle_ok = true;
							} else {
								// 2. Fallback for flat spawn point objects (helipads, jump targets)
								// These are thin planes that lineintersectsobjs cannot detect reliably
								private _spawn_classes = [
									"VR_Area_01_square_2x2_grey_F",
									"Land_HelipadCircle_F",
									"Land_HelipadSquare_F",
									"Land_JumpTarget_F",
									"Land_HelipadRescue_F",
									"Land_HelipadCivil_F",
									"VR_Area_01_circle_4_grey_F"
								];
								private _near_spawns = nearestObjects [player, _spawn_classes, 5];
								{
									if ((_x in (CTI_P_SideLogic getVariable ["cti_defences", []])) && alive _x) exitWith {
										_dismantle_ok = true;
										// Store the fallback target so OnDisDef can use it
										uiNamespace setVariable ["svb_disdef_target", _x];
									};
								} forEach _near_spawns;
							};
						};
						
						if (!_dismantle_ok) then {
							// Clear fallback target when icon is not shown
							uiNamespace setVariable ["svb_disdef_target", objNull];
						};
						
						if (_dismantle_ok) then {
							_ctrl ctrlSetTextColor [1, 0.2, 0.2, 1];
							_show = true;
						};
					};
				};

				// Если кнопка подходит под условия, заносим ее в радиальный пул, иначе — полностью прячем
				// НОВЫЙ КОД — сортируем в два массива по номеру иконки
if (_show) then {
    // Иконки 1–9: основные — идут в круговое меню
    // Иконки 10–35: взаимодействие — идут в нижнюю панель
    if (_i <= 9) then {
        _active_controls pushBack _ctrl;
    } else {
        _active_controls_interact pushBack _ctrl;
    };
} else {
    _ctrl ctrlSetPosition [-1, -1, 0, 0];
    _ctrl ctrlCommit 0;
};
			};
		};

		// 3. МАТЕМАТИЧЕСКИЙ РАСЧЕТ РАДИАЛЬНЫХ ПОЗИЦИЙ НА ОСНОВЕ ГРАДУСОВ
		// ================================================
// БЛОК А: ОСНОВНОЕ РАДИАЛЬНОЕ МЕНЮ (круг, как было)
// ================================================
private _total_count = count _active_controls;
if (_total_count > 0) then {
    // ШАГ А: собираем все иконки в центр экрана
    {
        _x ctrlSetPosition [_base_x - (_btn_w * 0.5), _base_y - (_btn_h * 0.5), _btn_w, _btn_h];
        _x ctrlCommit 0;
    } forEach _active_controls;

    // Угол между иконками
    private _angle_step = 360 / _total_count;

    // ШАГ Б: раздвигаем по кругу с анимацией
    {
        private _index = _forEachIndex;
        private _angle = (_index * _angle_step) - 90;
        private _pos_x = _base_x + (_radius_x * (cos _angle)) - (_btn_w * 0.5);
        private _pos_y = _base_y + (_radius_y * (sin _angle)) - (_btn_h * 0.5);
        _x ctrlSetPosition [_pos_x, _pos_y, _btn_w, _btn_h];
        _x ctrlCommit 0.15;
    } forEach _active_controls;
};

// ================================================
// БЛОК Б: ВЕРХНЯЯ ПАНЕЛЬ ВЗАИМОДЕЙСТВИЯ (горизонталь)
// ================================================
private _inter_count = count _active_controls_interact;
if (_inter_count > 0) then {
    // Строка 1 — размер иконок панели (чуть меньше основных)
    private _ibtn_w = SafeZoneH * 0.085;
    private _ibtn_h = SafeZoneH * 0.085;

    // Строка 2 — Y-позиция панели: выше верхней точки радиального круга
    // _base_y - _radius_y = верхний край круга
    // ещё минус размер иконки и зазор 2% высоты экрана
    private _panel_y = _base_y - _radius_y - _ibtn_h - (SafeZoneH * 0.06);

    // Строка 3 — зазор между иконками панели
    private _gap = SafeZoneH * 0.012;

    // Строка 4 — суммарная ширина панели
    private _panel_total_w = (_inter_count * _ibtn_w) + ((_inter_count - 1) * _gap);

    // Строка 5 — X стартовой иконки: центрируем панель по горизонтали
    private _panel_start_x = _base_x - (_panel_total_w * 0.5);

    // Строка 6 — ШАГ А: телепортируем иконки ЗА верхний край экрана (невидимо)
    {
        private _pos_x = _panel_start_x + (_forEachIndex * (_ibtn_w + _gap));
        _x ctrlSetPosition [_pos_x, SafeZoneY - _ibtn_h, _ibtn_w, _ibtn_h];
        _x ctrlCommit 0;
    } forEach _active_controls_interact;

    // Строка 7 — ШАГ Б: анимируем приезд сверху вниз на финальную позицию
    {
        private _pos_x = _panel_start_x + (_forEachIndex * (_ibtn_w + _gap));
        _x ctrlSetPosition [_pos_x, _panel_y, _ibtn_w, _ibtn_h];
        _x ctrlCommit 0.20;
    } forEach _active_controls_interact;
};

		// Кормим пустые оригинальные фреймы нулевыми размерами (профилактика ошибок BECTI)
		((uiNamespace getVariable "cti_dialog_ui_interractions") displayCtrl (510100)) ctrlSetPosition [0, 0, 0, 0];
		((uiNamespace getVariable "cti_dialog_ui_interractions") displayCtrl (510101)) ctrlSetPosition [0, 0, 0, 0];
		((uiNamespace getVariable "cti_dialog_ui_interractions") displayCtrl (510100)) ctrlCommit 0;
		((uiNamespace getVariable "cti_dialog_ui_interractions") displayCtrl (510101)) ctrlCommit 0;
		((uiNamespace getVariable "cti_dialog_ui_interractions") displayCtrl (510103)) ctrlCommit 0;
	};

	case "OnLock": {
		if (locked _target > 0) then {_target lock 0;} else {_target lock 2};
		['onLoad'] call compile preprocessFileLineNumbers 'Addons\Strat_mode\Tablet\Events_UI_Interact.sqf'
	};
	case "OnNet": {
		if (locked _target > 0) exitWith {false};
		if ((_target getVariable ['CTI_Net', -1]) != -1) then {
			_target setVariable ['CTI_Net', -1, true];
			_target setVariable ['AN_iNet', CTI_P_SideID, true];
		} else {
			_target setVariable ['CTI_Net', CTI_P_SideID, true];
			["SERVER", "Server_Run_Net", [_target, CTI_P_SideID]] call CTI_CO_FNC_NetSend;
		};
		['onLoad'] call compile preprocessFileLineNumbers 'Addons\Strat_mode\Tablet\Events_UI_Interact.sqf'
	};
	case "OnNetp": {
		if ((player getVariable ['CTI_Net', -1]) != -1) then {
			player setVariable ['CTI_Net', -1, true];
			player setVariable ['AN_iNet', CTI_P_SideID, true];
		} else {
			player setVariable ['CTI_Net', CTI_P_SideID, true];
		};
		['onLoad'] call compile preprocessFileLineNumbers 'Addons\Strat_mode\Tablet\Events_UI_Interact.sqf'
	};
	case "OnDef": {
		uiNamespace setVariable ['cti_dialog_ui_defensemenu', objNull];
		closedialog 0;
		[_target] execVM "Client\Actions\Action_DefenseMenu.sqf";
	};
	case "OnRepair": {
		closedialog 0;
		[_target, player] spawn SM_repair_vehicle;
	};
	case "OnForce": {
		closedialog 0;
		[_target, player] spawn SM_Force_entry;
	};
	case "OnRev": {
		closedialog 0;
		[_target, player] spawn REV_ACT_REV;
	};
	case "OnDrag": {
		closedialog 0;
		if (isNull (player getVariable ['REV_DRAGGING', objNull])) then {
			if (_target isKindOf "Man") then {[_target, player] spawn REV_ACT_DRAG;};
		} else {
			if (_target isKindOf "Man") then {[player] spawn REV_ACT_REL;};
		};
	};
	case "OnFact": {
		if ((getPlayerUID player) in CTI_UIDs_BAN) then {
			0.5 fadeSound 0.1;
		} else {
			closedialog 0;
			[_target] execVM "Client\Actions\Action_UseNearestFactory.sqf";
		};
	};
	case "OnDel": {
		if (_target in (CTI_P_SideLogic getVariable ["cti_defences", []])) then {
			deleteVehicle _target;
		};

		if (_target in (CTI_P_SideJoined call CTI_CO_FNC_GetSideStructures)) then {
			_xxbase = 0;	
			_xmp = (CTI_P_SideJoined) call CTI_CO_FNC_GetSideLogic;
			_xmp = _xmp getVariable "cti_structures_areas";
			_xxbase = count _xmp;

			if (_xxbase > 1) then {
				if (CTI_BASE_AREA_SALE > 0) then {
					if (CTI_BASE_AREA_SALE == 1) then {
						_target setVariable ["cti_sell", true, true];
						_target setDammage 1;
						["SERVER", "Request_UpdateBaseAreas", CTI_P_SideJoined] call CTI_CO_FNC_NetSend;
					};
					if (CTI_BASE_AREA_SALE == 2) then {
						private ["_area", "_areas", "_areas_found", "_enemy", "_enemylogic"];
						_areas = CTI_P_SideLogic getVariable "cti_structures_areas";
						_enemy = if (CTI_P_SideJoined == west) then {east} else {west};
						_enemylogic = (_enemy) call CTI_CO_FNC_GetSideLogic;
						_areas_found = _enemylogic getVariable "CTI_BASES_FOUND_AREAS";
						_area = [_target, _areas] call CTI_CO_FNC_GetClosestEntity;

						if !(_area in _areas_found) then {
							_target setVariable ["cti_sell", true, true];
							_target setDammage 1;
							["SERVER", "Request_UpdateBaseAreas", CTI_P_SideJoined] call CTI_CO_FNC_NetSend;
						} else {
							hint parseText localize "STR_CTI_Base_Sale_Discovered";
						};
					};
				} else {
					hint parseText localize "STR_CTI_Base_Sale_Disabled";
				};
			} else {
				hint parseText localize "STR_CTI_Base_Sale_Disabled";
			};
		};

		if (_target in (CTI_P_SideLogic getVariable ["cti_workers", []])) then {
			_target setVariable ["cti_sell", true, true];
			_target setDammage 1;
		};
		closedialog 0;
	};
	case "OnFpk": {
		[_target, player] spawn AN_E_Intrusion_Start;
		AN_E_INTRU = true;
		['onLoad'] call compile preprocessFileLineNumbers 'Addons\Strat_mode\Tablet\Events_UI_Interact.sqf';
	};
	case "OnIntru": {
		(_target) setVariable ['AN_Hack_started', true, true];
		['onLoad'] call compile preprocessFileLineNumbers 'Addons\Strat_mode\Tablet\Events_UI_Interact.sqf';
	};
	case "OnLoad": {
		CTI_P_ChatID commandChat 'ST LOAD :: Trying to load a static, please wait';
		STATIC_TRY = true;
		['SERVER', 'Request_load', [_target, player]] call CTI_CO_FNC_NetSend;
		['onLoad'] call compile preprocessFileLineNumbers 'Addons\Strat_mode\Tablet\Events_UI_Interact.sqf';
	};
	case "OnPull": {
		if (speed _target < 2 && speed _target > -2) then {[_target, player] execVM "Client\Actions\Action_TaxiReverse.sqf"};
		['onLoad'] call compile preprocessFileLineNumbers 'Addons\Strat_mode\Tablet\Events_UI_Interact.sqf';
	};
	case "OnPush": {
		if (speed _target < 2 && speed _target > -2) then {[_target, player] execVM "Client\Actions\Action_Push.sqf"};
		['onLoad'] call compile preprocessFileLineNumbers 'Addons\Strat_mode\Tablet\Events_UI_Interact.sqf';
	};
	case "OnRepHQ": {
		CTI_P_LastRepairTime = time;
		[_target, player] execVM "Client\Actions\Action_RepairHQ.sqf";
		['onLoad'] call compile preprocessFileLineNumbers 'Addons\Strat_mode\Tablet\Events_UI_Interact.sqf';
	};
	case "OnUnits": {
		if ((getPlayerUID player) in CTI_UIDs_BAN) then {
			0.5 fadeSound 0.1;
		} else {
			closedialog 0;
			if (!CTI_P_PreBuilding && (Client_AN_Connected && (CTI_Base_BarracksInRange || CTI_Base_LightInRange || CTI_Base_HeavyInRange || CTI_Base_AirInRange || CTI_Base_AmmoInRange || CTI_Base_RepairInRange || CTI_Base_NavalInRange)) || CTI_Town_InRange) then {
				[_target] execVM "Client\Actions\Action_UseNearestFactory.sqf";
			};
		};
	};
	case "OnPara": {
		closedialog 0;
		(_target) spawn SA_TODROP;
	};
	case "OnAtt": {
		closedialog 0;
		(_target) spawn SA_TOATTACH;
	};
	case "OnPack": {
		closedialog 0;
		CTI_P_Repairing = true;
		[player, _target] spawn SA_ACTION_PACK;
	};
	case "OnGear": {
		if ((getPlayerUID player) in CTI_UIDs_BAN) then {
			0.5 fadeSound 0.1;
		} else {
			if (!Client_AN_Connected) exitWith {
            hint "Нет подключения к сети";
        };
			_possible = call CTI_UI_Gear_LoadAvailableUnits;
			if ((count _possible) == 0) exitWith {false};
			closedialog 0;
			disableserialization;
			uiNamespace setVariable ['GEAR_TARG_F', false];
			createDialog "CTI_RscGearMenu";
		};
	};
	case "OnGearM": {
		if ((time - (_target getVariable ["CTI_last_purchase_time", -10000])) < CTI_GEAR_MOBILE_COOLOFF) exitWith {false};
		closedialog 0;
		disableserialization;
		uiNamespace setVariable ['GEAR_TARG', _target];
		uiNamespace setVariable ['GEAR_TARG_F', true];
		createDialog "CTI_RscGearMenu";
	};
	case "OnBuild": {
		closedialog 0;
		[player, _target] spawn SM_ACTION_BUILD;
	};
	case "OnSRep": {
		closedialog 0;
		[player, _target] spawn SM_ACTION_REPAIR;
	};
   	case "OnDisDef": {
		closedialog 0;
		// Use fallback target if set (flat spawn points), otherwise use INT_TARG
		private _dismantle_target = uiNamespace getVariable ["svb_disdef_target", objNull];
		if (isNull _dismantle_target) then {_dismantle_target = _target};
		[player, _dismantle_target] spawn SM_ACTION_DISMANTLE;
		// Clear fallback after use
		uiNamespace setVariable ["svb_disdef_target", objNull];
	};
	case "OnAircraftCust": {
		_structures = (CTI_P_SideJoined) call CTI_CO_FNC_GetSideStructures;
		_ammo_depots = [CTI_AMMO, _structures, player] call CTI_CO_FNC_GetSideStructuresByType;
		_available_ammo_depots = [_target, _ammo_depots, CTI_SERVICE_AMMO_DEPOT_RANGE] call CTI_UI_Service_GetBaseDepots;
		_available_ammo_trucks = [_target, CTI_SPECIAL_AMMOTRUCK, CTI_SERVICE_AMMO_TRUCK_RANGE] call CTI_CO_FNC_GetNearestSpecialVehicles;
		if (!(_target getVariable ["CTI_AC_AIRCRAFT_LOADOUT_IS_BUSY", true]) && count (_available_ammo_depots + _available_ammo_trucks) > 0 && local _target) then {
			uiNamespace setVariable ['HAL_TARG', _target];
			closedialog 0;
			createDialog "CTI_RscTabletAircraftLoadoutMenu";
		};
	};
	case "OnCom": {
		if (isNull (CTI_P_SideJoined call CTI_CO_FNC_GetSideCommander) && !((getPlayerUID player) in (CTI_P_SideLogic getVariable ["CTI_COM_BLACKLIST", []]))) then {
			closedialog 0;
			_uidp = getPlayerUID player;
			if ((getPlayerUID player) in CTI_UIDs_BAN) then {
				player groupChat "Вы не можете быть коммандиром!";
			} else {
				0 call CTI_COM_SET_CLIENT;
			};
		};
	};
	case "OnTablet": {
		closedialog 0;
		if ((getPlayerUID player) in CTI_UIDs_BAN) then {
			player switchMove "ainvpknlmstpsnonwrfldnon_medic0s";
			0.5 fadeSound 0.1;
		} else {
			createdialog "CTI_RscTablet_main";
		};
	};
	case "OnBFact": {
		if !((CTI_P_SideLogic getVariable "cti_commander") == group player && (leader group player) == player && !CTI_P_PreBuilding && CTI_Base_HQInRange) exitWith {false};
		closedialog 0;
		createDialog "CTI_RscBuildMenu_Tablet";
	};
	case "OnPilot": {
		closedialog 0;
		if (isNull (driver _target)) then {player moveInDriver _target} else {0 spawn {hint "There is already a pilot"; sleep 3; hintSilent "";}};
	};
	case "OnHalo": {
		if !(vehicle player == player && !CTI_P_PreBuilding && CTI_Base_HaloInRange && [CTI_P_SideJoined, CTI_UPGRADE_HALO, 1] call CTI_CO_FNC_HasUpgrade && ((missionNamespace getVariable 'CTI_SM_HALO') == 1) && (time - CTI_HALO_LASTTIME >= CTI_HALO_COOLDOWN)) exitWith {false};
		closedialog 0;
		0 execVM "Addons\ATM_airdrop\atm_airdrop.sqf"
	};
	case "OnEarp": {
		if (soundVolume < 1) then {
			0.5 fadeSound 1;
		} else {
			0.5 fadeSound 0.25;
		};
		['onLoad'] call compile preprocessFileLineNumbers 'Addons\Strat_mode\Tablet\Events_UI_Interact.sqf';
	};
	case "OnGroup": {
		closedialog 0;
		createDialog "RscDisplayDynamicGroups";
	};
	case "OnThud": {
		profileNamespace setVariable ["HUD_Tactical", !((profileNamespace getVariable ["HUD_Tactical", true]))];
		saveProfileNamespace;
		['onLoad'] call compile preprocessFileLineNumbers 'Addons\Strat_mode\Tablet\Events_UI_Interact.sqf'
	};
	case "OnExitT": {
		TUTO_COMPLETE = true;
	};
};