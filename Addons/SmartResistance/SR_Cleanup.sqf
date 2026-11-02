/*
    SR Cleanup
    Удаляет все SR-группы города
*/
params ["_town"];

private _groups = _town getVariable ["SR_groups", []];

{
    if (!isNull _x) then {
        {
            if (alive _x) then {deleteVehicle _x};
        } forEach (units _x);
        deleteGroup _x;
    };
} forEach _groups;

_town setVariable ["SR_groups", [], true];