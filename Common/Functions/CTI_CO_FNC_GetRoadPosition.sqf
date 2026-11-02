//--- Function: CTI_CO_FNC_GetRoadPosition
//--- Description: Returns a position on the nearest road to the given position
//--- Parameters:
//---   _this select 0: ARRAY - Position to find nearest road to (format: [x, y, z] or [x, y])
//---   _this select 1: NUMBER (Optional) - Maximum distance to search for road (default: 100)
//---   _this select 2: BOOL (Optional) - If true, return direction of road (default: false)
//--- Returns: ARRAY - Position on road [x, y, z]
//--- Example: _roadPos = [getPos player, 50] call CTI_CO_FNC_GetRoadPosition;

private ["_position", "_maxDistance", "_getDirection", "_road", "_roadPos"];

_position = _this select 0;
_maxDistance = if (count _this > 1) then {_this select 1} else {100};
_getDirection = if (count _this > 2) then {_this select 2} else {false};

// Convert position to array if needed (handle both [x,y,z] and [x,y] formats)
if (typeName _position == "OBJECT") then {
    _position = getPos _position;
};

// Ensure we have 3 coordinates
if (count _position < 3) then {
    _position = _position + [0];
};

// Find nearest road
_road = nearestRoad (_position select 0, _position select 1);

// If no road found within maxDistance, return original position
if (isNull _road) exitWith {_position};

// Check if road is within max distance
_roadPos = getPos _road;
if ((_position select 0) distance (_roadPos select 0) > _maxDistance) exitWith {_position};

// Return position on road with original Z-coordinate
if (_getDirection) then {
    // Return [position, direction]
    [_roadPos, roadDirection _road]
} else {
    // Return position with original Z-coordinate
    [(_roadPos select 0), (_roadPos select 1), (_position select 2)]
};
