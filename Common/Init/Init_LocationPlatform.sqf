
private ["_marker", "_town", "_town_name"];

_town = _this select 0;
_town_name = _this select 1;

_marker = createMarkerLocal [format ["cti_town_marker_%1", _town], getPos _town];
_marker setMarkerTypeLocal "mil_flag";
_marker setMarkerTextLocal format[" %1", _town_name];
_marker setMarkerColorLocal "ColorGrey";
_marker setMarkerSizeLocal [0.5, 0.5];
_marker setMarkerAlphaLocal 0.5;
