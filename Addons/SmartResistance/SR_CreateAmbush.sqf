/*
    SR Засада на дороге
    Возвращает: true/false
*/
params ["_town", "_hostiles"];
if (!isServer) exitWith {false};

private _roads = _town nearRoads 400;
if (count _roads == 0) exitWith {false};

// Находим дорогу между городом и ближайшим врагом
private _nearestEnemy = _hostiles select 0;
private _enemyPos = getPos _nearestEnemy;
private _townPos = getPos _town;

private _bestRoad = objNull;
private _bestScore = -1;

{
    private _roadPos = getPos _x;
    private _distToTown = _roadPos distance _townPos;
    private _distToEnemy = _roadPos distance _enemyPos;
    
    if (_distToTown > 80 && _distToEnemy > 100) then {
        private _score = 1000 - abs(_distToTown - _distToEnemy);
        if (_score > _bestScore) then {
            _bestScore = _score;
            _bestRoad = _x;
        };
    };
} forEach _roads;

if (isNull _bestRoad) exitWith {false};

private _ambushPos = getPos _bestRoad;
private _group = createGroup resistance;
private _roadDir = getDir _bestRoad;

// Спавним 4-6 бойцов
private _unitCount = 4 + floor(random 3);

for "_i" from 1 to _unitCount do {
    private _side_offset = if (_i <= (_unitCount / 2)) then {-1} else {1};
    private _forward_offset = ((_i - 1) % 3) * 5 - 5;
    
    private _unitPos = _ambushPos getPos [abs (_side_offset * (8 + random 5)), _roadDir + (90 * _side_offset)];
    _unitPos = _unitPos getPos [abs _forward_offset, _roadDir];
    
    private _unitType = selectRandom [
        "I_soldier_F", "I_soldier_F", "I_soldier_GL_F", 
        "I_soldier_AR_F", "I_soldier_LAT_F"
    ];
    
    private _unit = _group createUnit [_unitType, _unitPos, [], 3, "FORM"];
    _unit setUnitPos "DOWN";
    _unit setDir (_roadDir + (180 * _side_offset));
    
    // Скилл засадникам
    _unit setSkill 0.7;
    _unit setSkill ["spotDistance", 0.8];
    _unit setSkill ["spotTime", 0.8];
    _unit setSkill ["courage", 0.9];
};

_group setBehaviour "STEALTH";
_group setCombatMode "RED";
_group setSpeedMode "LIMITED";

private _wp = _group addWaypoint [_ambushPos, 20];
_wp setWaypointType "HOLD";
_wp setWaypointBehaviour "STEALTH";
_wp setWaypointCombatMode "RED";

// Активация засады при приближении врага
[_group, _ambushPos] spawn {
    params ["_group", "_ambushPos"];
    waitUntil {
        sleep 3;
        if (isNull _group || {!alive (leader _group)}) exitWith {true};
        private _nearEnemies = _ambushPos nearEntities [["Man", "Car", "Tank"], 80];
        private _hostiles = _nearEnemies select {side _x in [west, east]};
        count _hostiles > 0
    };
    
    if (isNull _group || {!alive (leader _group)}) exitWith {};
    
    {
        if (alive _x) then {
            _x setUnitPos "UP";
            _x setBehaviour "COMBAT";
            _x setCombatMode "RED";
        };
    } forEach (units _group);
    
    diag_log format ["[SR] :: Ambush ACTIVATED at %1", _ambushPos];
};

// Регистрируем группу в SR
private _town_groups = _town getVariable ["SR_groups", []];
_town_groups pushBack _group;
_town setVariable ["SR_groups", _town_groups, true];

true