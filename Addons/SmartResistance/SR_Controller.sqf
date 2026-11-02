/*
    Smart Resistance Controller v2.0
    Интеграция с FSM town_resistance.fsm
    Работает синхронно: FSM спавнит базу, SR добавляет умные тактики
*/
params ["_town"];
if (!isServer) exitWith {};

// Защита от повторного запуска
if (!isNil {_town getVariable "SR_controllerActive"}) exitWith {};
_town setVariable ["SR_controllerActive", true, true];

// SR хранит свои группы отдельно от FSM
_town setVariable ["SR_groups", [], true];

// Кулдаун между спавном тактик (сек)
private _cooldown = 120;
private _lastSpawn = -9999;

// Макс SR-активаций за одну "волну" сопротивления FSM
private _maxPerWave = 2;

// Ждём инициализации города
waitUntil {sleep 1; !isNil {_town getVariable "cti_town_sideID"}};

private _waveActive = false;
private _waveSpawns = 0;

// Главный цикл
while {!CTI_GameOver} do {
    sleep 5;
    
    private _isActive = _town getVariable ["cti_town_resistance_active", false];
    private _sideID = _town getVariable ["cti_town_sideID", -1];
    
    // Город должен принадлежать resistance
    if (_sideID != CTI_RESISTANCE_ID) then {
        // Деактивация — чистим свои группы
        if (_waveActive) then {
            [_town] call SR_fnc_cleanupGroups;
            _waveActive = false;
            _waveSpawns = 0;
        };
        continue;
    };
    
    // FSM активировал сопротивление
    if (_isActive) then {
        if (!_waveActive) then {
            // Новая волна!
            _waveActive = true;
            _waveSpawns = 0;
            _lastSpawn = -9999;
            diag_log format ["[SR] :: New resistance wave at %1", _town getVariable ["cti_town_name", "Unknown"]];
        };
        
        // Проверяем кулдаун и лимит спавнов
        if (time - _lastSpawn < _cooldown) then {continue};
        if (_waveSpawns >= _maxPerWave) then {continue};
        
        // === АНАЛИЗ УГРОЗЫ ===
        private _enemies = _town nearEntities [["Man", "Car", "Tank", "Air"], 800];
        private _hostiles = _enemies select {side _x in [west, east]};
        
        if (count _hostiles < 1) then {continue};
        
        // Анализ состава
        private _hasInfantry = false;
        private _hasVehicles = false;
        private _hasArmor = false;
        private _hasAir = false;
        
        {
            if (_x isKindOf "Man") then {_hasInfantry = true};
            if (_x isKindOf "Car" || _x isKindOf "Truck_F") then {_hasVehicles = true};
            if (_x isKindOf "Tank" || _x isKindOf "Wheeled_APC_F") then {_hasArmor = true};
            if (_x isKindOf "Air") then {_hasAir = true};
        } forEach _hostiles;
        
        // === ВЫБОР ТАКТИКИ ===
        private _tactics = [];
        
        if (_hasInfantry || _hasVehicles) then {_tactics pushBack "AMBUSH"};
        if (_hasVehicles || _hasArmor) then {_tactics pushBack "MINEFIELD"};
        if (_hasAir) then {_tactics pushBack "AA"};
        if (_hasInfantry && count _hostiles > 5) then {_tactics pushBack "URBAN"};
        
        if (count _tactics == 0) then {continue};
        
        // Применяем случайную тактику
        private _selectedTactic = selectRandom _tactics;
        private _result = false;
        
        switch (_selectedTactic) do {
            case "AMBUSH": {
                _result = [_town, _hostiles] call SR_fnc_createAmbush;
            };
            case "MINEFIELD": {
                _result = [_town] call SR_fnc_createMinefield;
            };
            case "AA": {
                _result = [_town] call SR_fnc_createAAGroup;
            };
            case "URBAN": {
                _result = [_town] call SR_fnc_createUrbanDefense;
            };
        };
        
        if (_result) then {
            _lastSpawn = time;
            _waveSpawns = _waveSpawns + 1;
            diag_log format ["[SR] :: %1 tactic spawned at %2 (wave %3/%4)", 
                _selectedTactic, _town getVariable ["cti_town_name", "Unknown"], _waveSpawns, _maxPerWave];
        };
        
    } else {
        // FSM деактивировал — чистимся
        if (_waveActive) then {
            [_town] call SR_fnc_cleanupGroups;
            _waveActive = false;
            _waveSpawns = 0;
            diag_log format ["[SR] :: Wave ended at %1, cleaned up", _town getVariable ["cti_town_name", "Unknown"]];
        };
    };
};