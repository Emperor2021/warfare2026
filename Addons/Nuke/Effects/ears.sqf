private ["_xpos", "_ypos"];

_xpos = _this select 0;
_ypos = _this select 1;

if ( [_xpos, _ypos, 0] distance player < (CTI_NUKE_DAMAGE_RADIUS * 3) ) then {
	0 fadeRadio 0;
	0 fadeSound 0;
	0 fadeMusic 0;

	sleep 8;

	16 fadeRadio 1;
	16 fadeSound 1;
	16 fadeMusic 0.5;
};
