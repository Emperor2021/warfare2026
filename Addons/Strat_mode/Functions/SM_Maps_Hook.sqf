// [Стр. 1] Создаем глобальный массив для хранения статических линий связей городов
if (isNil "CTI_SM_StaticLines") then { CTI_SM_StaticLines = []; };

// [Стр. 4] Вспомогательная функция для безопасного добавления линий городов в обход финальной cti_sm_connect
CTI_SM_RegisterStaticLine = {
	private _line = [objNull, _this select 0, _this select 1, _this select 2];
	if !(_line in CTI_SM_StaticLines) then {
		CTI_SM_StaticLines pushBack _line;
	};
};

private ["_map1","_map2"];
// [Стр. 13] Проверка: включен ли Advanced Network (EW ANET)
if (missionNamespace getVariable ["CTI_EW_ANET", 0] == 1) then {
	MAP_GetItems = compile preprocessFileLineNumbers "Addons\Strat_mode\Functions\SM_MapEntities.sqf";
	MAP_DrawItems = compile preprocessFileLineNumbers "Addons\Strat_mode\Functions\SM_Draw_Map_Icons.sqf";
	MAP_DrawLines = compile preprocessFileLineNumbers "Addons\Strat_mode\Functions\SM_Draw_Map_Lines.sqf";
	SHOWTOMAP = [[], [], []];

	// [Стр. 20] Навешиваем обработчик рисования на основную карту (Display 12)
	0 spawn {
		disableSerialization;
		_map1 = controlNull;
		while {isNull _map1} do {
			_map1 = findDisplay 12 displayCtrl 51;
			sleep 0.1;
		};
		_map1 ctrlAddEventHandler ["Draw", "_this call MAP_DrawItems; _this call MAP_DrawLines;"];
	};

	// [Стр. 31] Навешиваем обработчик на GPS / Миникарту
	0 spawn {
		disableSerialization;
		_map2 = controlNull;
		while {isNull _map2} do {
			_frames = [];
			{_frames set [count _frames, _x select 0]; true} count (missionNamespace getVariable ["BIS_stackedEventHandlers_onEachFrame", []]);
			{if !(isNil {_x displayCtrl 101}) then {_map2 = _x displayCtrl 101};} count (uiNamespace getVariable "IGUI_Displays");
			sleep 0.1;
		};
		_map2 ctrlAddEventHandler ["Draw", "
			private ['_frames'];
			_frames = [];
			{_frames set [count _frames, _x select 0]; true} count (missionNamespace getVariable ['BIS_stackedEventHandlers_onEachFrame', []]);
			if !('hudFrame' in _frames) then {_this call MAP_DrawItems;}
		"];
	};

	// [Стр. 46] Навешиваем обработчик на тактический планшет (Display 220000)
	0 spawn {
		disableSerialization;
		_map1 = controlNull;
		while {isNull _map1} do {
			_map1 = findDisplay 220000 displayCtrl 220001;
			sleep 0.2;
		};
		_map1 ctrlAddEventHandler ["Draw", "_this call MAP_DrawItems; _this call MAP_DrawLines;"];
	};

	// [Стр. 57] Цикл обновления динамических объектов с внедрением статических линий городов
	0 spawn {
		while {!CTI_GameOver} do {
			private _items = 0 call MAP_GetItems;
			
			// Подмешиваем сохраненные линии городов в массив отрисовщика SHOWTOMAP
			private _currentLines = _items select 2;
			{
				if !(_x in _currentLines) then { _currentLines pushBack _x };
			} forEach CTI_SM_StaticLines;
			
			_items set [2, _currentLines];
			SHOWTOMAP = _items;
			sleep 1;
		};
	};
} else {
	// [Стр. 74] Если Advanced Network ОТКЛЮЧЕН — рисуем линии городов стандартным Draw-обработчиком
	0 spawn {
		disableSerialization;
		_map1 = controlNull;
		while {isNull _map1} do {
			_map1 = findDisplay 12 displayCtrl 51;
			sleep 0.1;
		};
		_map1 ctrlAddEventHandler ["Draw", {
			_map = _this select 0;
			{
				_map drawLine [_x select 1, _x select 2, [0, 0, 0, 0.6]]; // Черные линии связей городов
			} forEach CTI_SM_StaticLines;
		}];
	};

	// Инициализация маркеров групп
	0 spawn {
		waitUntil {!isNil {CTI_P_SideLogic getVariable "cti_teams"}};
		if (CTI_SM_FAR == 1) then {
			execFSM "Addons\Strat_mode\FSM\update_markers_team.fsm";
		};
	};
};