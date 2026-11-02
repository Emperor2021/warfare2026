/*
    SR ПЗРК на крышах
*/
params ["_town"];
if (!isServer) exitWith {false};

// Ищем высокие здания рядом
private _buildings = nearestObjects [_town, ["House", "Building"], 500];
private _highBuildings = [];

{
    private _positions = _x buildingPos -1;
    private _height = (getPos _x) select 2;
    if (count _positions > 0 && _height > 5) then {
        _highBuildings pushBack _x;
    };
} forEach _buildings;

if (count _highBuildings == 0) exitWith {
    diag_log "[SR] :: AA: No high buildings found";
    false
};

// Берём до 3 зданий
private _selectedBuildings = _highBuildings;
if (count _selectedBuildings > 3) then {
    _selectedBuildings = _selectedBuildings select [0, 3];
};

private _group = createGroup resistance;

{
    private _building = _x;
    private _positions = _building buildingPos -1;
    
    if (count _positions == 0) then {continue};
    
    // Берём случайную позицию
    private _pos = _positions select (floor random count _positions);
    
    // Создаём бойца с ПЗРК
    private _unit = _group createUnit ["I_soldier_AA_F", _pos, [], 3, "FORM"];
    
    if (isNull _unit) then {continue};
    
    _unit setPos _pos;
    _unit setUnitPos "UP";
    _unit setDir (random 360);
    
    // Высокий скилл для ПЗРК
    _unit setSkill 0.8;
    _unit setSkill ["aimingAccuracy", 0.7];
    _unit setSkill ["spotDistance", 0.9];
    
    private _wp = _group addWaypoint [_pos, 5];
    _wp setWaypointType "SENTRY";
    _wp setWaypointBehaviour "AWARE";
    _wp setWaypointCombatMode "RED";
    
} forEach _selectedBuildings;

if (count (units _group) == 0) then {
    deleteGroup _group;
    false
} else {
    // Регистрируем группу в SR
    private _town_groups = _town getVariable ["SR_groups", []];
    _town_groups pushBack _group;
    _town setVariable ["SR_groups", _town_groups, true];
    
    diag_log format ["[SR] :: AA group created with %1 units", count (units _group)];
    true
};