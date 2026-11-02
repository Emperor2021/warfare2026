/*
    SR Минное поле на дороге
*/
params ["_town"];
if (!isServer) exitWith {false};

private _roads = _town nearRoads 350;
if (count _roads == 0) exitWith {false};

private _townPos = getPos _town;
private _bestRoad = objNull;
private _bestDist = 0;

{
    private _dist = (getPos _x) distance _townPos;
    if (_dist > 100 && _dist > _bestDist) then {
        _bestDist = _dist;
        _bestRoad = _x;
    };
} forEach _roads;

if (isNull _bestRoad) exitWith {false};

private _minePos = getPos _bestRoad;
private _roadDir = getDir _bestRoad;

// Группа наблюдателя
private _group = createGroup resistance;
private _observer = _group createUnit ["I_soldier_F", _minePos, [], 0, "NONE"];

// Мины поперёк дороги
private _mineCount = 5 + floor(random 4);
_minesCreated = [];
for "_i" from 0 to (_mineCount - 1) do {
    private _offset = (_i - (_mineCount / 2)) * 2.5;
    private _mPos = _minePos getPos [abs _offset, _roadDir + 90];
    private _mineType = selectRandom ["ATMine", "ATMine", "SLAMDirectionalMine"];
    
    //--- Use createMine + addOwnedMine for active mines
    _mine = createMine [_mineType, _mPos, [], 0];
    //--- Register mine with observer unit to activate it
    if (!isNull _observer) then {
        _observer addOwnedMine _mine;
    };
    _minesCreated pushBack _mine;
    
    //--- Monitor each mine for enemy proximity
    [_mine, resistance] spawn {
        params ["_mine", "_mineSide"];
        while {alive _mine && !isNull _mine} do {
            _enemies = nearestObjects [_mine, ["Man", "Car", "Tank", "Helicopter", "Plane", "Ship", "Wheeled_APC_F", "APC_F", "Tank_F"], 20];
            _enemies = _enemies select {side _x isNotEqualTo _mineSide && alive _x};
            if (count _enemies > 0) then {
                //--- Damage all enemies in radius
                {
                    _x setDamage 1;
                } forEach _enemies;
                //--- Remove the mine
                if (!isNull _mine) then { deleteVehicle _mine };
                break;
            };
            sleep 0.5;
        };
    };
};

//--- Setup observer
if (!isNull _observer) then {
    _observer setUnitPos "MIDDLE";
    _observer setDir _roadDir;
    _observer setSkill 0.7;
    _observer setSkill ["spotDistance", 0.9];
    
    private _observerPos = getPos _observer;
    private _wp = _group addWaypoint [_observerPos, 10];
    _wp setWaypointType "SENTRY";
    _wp setWaypointBehaviour "AWARE";
};

// Регистрируем
private _town_groups = _town getVariable ["SR_groups", []];
_town_groups pushBack _group;
_town setVariable ["SR_groups", _town_groups, true];

diag_log format ["[SR] :: Minefield created at %1 (%2 mines)", _minePos, count _minesCreated];
true
