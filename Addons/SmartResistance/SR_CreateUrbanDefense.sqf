/*
    SR Оборона зданий
*/
params ["_town"];
if (!isServer) exitWith {false};

// Находим здания с позициями
private _buildings = nearestObjects [_town, ["House", "Building"], 400];
private _validBuildings = [];

{
    private _positions = _x buildingPos -1;
    if (count _positions > 2) then {
        _validBuildings pushBack _x;
    };
} forEach _buildings;

if (count _validBuildings == 0) exitWith {
    diag_log "[SR] :: Urban: No valid buildings found";
    false
};

// Берём до 5 зданий
private _selectedBuildings = _validBuildings;
if (count _selectedBuildings > 5) then {
    _selectedBuildings = _selectedBuildings select [0, 5];
};

private _group = createGroup resistance;
private _totalUnits = 0;

{
    private _building = _x;
    private _positions = _building buildingPos -1;
    
    if (count _positions == 0) then {continue};
    
    // Количество юнитов на здание (2-4)
    private _unitsPerBuilding = 2 + floor(random 3);
    if (_unitsPerBuilding > count _positions) then {
        _unitsPerBuilding = count _positions;
    };
    
    for "_i" from 0 to (_unitsPerBuilding - 1) do {
        private _pos = _positions select _i;
        
        // Разнообразие юнитов
        private _unitType = selectRandom [
            "I_soldier_F",
            "I_soldier_F",
            "I_soldier_GL_F",
            "I_soldier_AR_F",
            "I_soldier_LAT_F",
            "I_soldier_M_F"
        ];
        
        private _unit = _group createUnit [_unitType, _pos, [], 2, "FORM"];
        
        if (isNull _unit) then {continue};
        
        _unit setPos _pos;
        _unit setUnitPos "UP";
        _unit setDir (random 360);
        
        // Хороший скилл для городских боёв
        _unit setSkill 0.75;
        _unit setSkill ["courage", 0.85];
        _unit setSkill ["spotDistance", 0.7];
        
        _totalUnits = _totalUnits + 1;
    };
} forEach _selectedBuildings;

if (count (units _group) == 0) then {
    deleteGroup _group;
    false
} else {
    private _wp = _group addWaypoint [getPos _town, 100];
    _wp setWaypointType "HOLD";
    _wp setWaypointBehaviour "AWARE";
    _wp setWaypointCombatMode "RED";
    
    // Регистрируем группу
    private _town_groups = _town getVariable ["SR_groups", []];
    _town_groups pushBack _group;
    _town setVariable ["SR_groups", _town_groups, true];
    
    diag_log format ["[SR] :: Urban defense: %1 units in %2 buildings", _totalUnits, count _selectedBuildings];
    true
};