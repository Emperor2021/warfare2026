private ["_dir", "_distance", "_objects", "_pos", "_spd", "_vel", "_xpos", "_ypos"];

_pos = _this select 0;
_xpos = _pos select 0;
_ypos = _pos select 1;

_spd = CTI_NUKE_BLOW_SPEED;

// Получаем все объекты в зоне ядерного взрыва.
_objects = _pos nearObjects ["All", CTI_NUKE_DAMAGE_RADIUS * 2];

{
    // Не позволяем ядерному удару ломать служебные Logic BECTI.
    if !(_x isKindOf "Logic") then {

        if !(_x isKindOf "FlagCarrier") then {

            if (_x distance _pos >= CTI_NUKE_DAMAGE_RADIUS) then {

                if !(isNil {_x getVariable "cti_altdmg"}) then {
                    _x setVariable [
                        "cti_altdmg",
                        ((_x getVariable "cti_altdmg") + 0.5),
                        true
                    ];
                };

                if (
                    _x isKindOf "Air"
                    || _x isKindOf "LandVehicle"
                    || _x isKindOf "Slingload_base_F"
                ) then {

                    _vel = velocity _x;
                    _spd = CTI_NUKE_BLOW_SPEED;

                    _distance = [_xpos, _ypos, 0] distance _x;

                    if (_distance > 0.1) then {
                        _dir = asin (((getPos _x select 1) - _ypos) / _distance);

                        if (getPos _x select 0 < _xpos) then {
                            _dir = 180 - _dir;
                        };

                        if (_x isKindOf "Air") then {
                            _spd = _spd * 1.5;
                        };

                        if (_x isKindOf "Tank") then {
                            _spd = _spd * 0.5;
                        };

                        _x setVelocity [
                            (_vel select 0) + ((_spd / 2) * cos _dir),
                            (_vel select 1) + ((_spd / 2) * sin _dir),
                            1.911
                        ];

                        {
                            _x setDamage (getDammage _x + 0.5);
                        } forEach crew _x;

                        _x setHit ["motor", 1];
                    };
                };

                _x setDamage (getDammage _x + 0.5);

            } else {

                if !(isNil {_x getVariable "cti_altdmg"}) then {
                    _x setVariable ["cti_altdmg", 1, true];
                };

                if (
                    _x isKindOf "Air"
                    || _x isKindOf "LandVehicle"
                    || _x isKindOf "Slingload_base_F"
                ) then {

                    _vel = velocity _x;
                    _spd = CTI_NUKE_BLOW_SPEED;

                    _distance = [_xpos, _ypos, 0] distance _x;

                    if (_distance > 0.1) then {
                        _dir = asin (((getPos _x select 1) - _ypos) / _distance);

                        if (getPos _x select 0 < _xpos) then {
                            _dir = 180 - _dir;
                        };

                        if (_x isKindOf "Air") then {
                            _spd = _spd * 1.5;
                        };

                        if (_x isKindOf "Tank") then {
                            _spd = _spd * 0.5;
                        };

                        _x setVelocity [
                            (_vel select 0) + (_spd * cos _dir),
                            (_vel select 1) + (_spd * sin _dir),
                            1.911
                        ];

                        {
                            _x setDamage 1;
                        } forEach crew _x;
                    };
                };

                _x setDamage 1;
            };
        };
    };
} forEach _objects;