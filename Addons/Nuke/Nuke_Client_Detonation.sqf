private ["_pos", "_xpos", "_ypos"];

_pos = _this select 0;
_xpos = _pos select 0;
_ypos = _pos select 1;

//["DEBUG", "FILE: Addons\Nuke\Nuke_Client_Detonation.sqf", str(_pos)] call CTI_CO_FNC_Log;

[] spawn {
	sleep 3;
	//enableCamShake true;
	addCamShake [5, 7, 10];
};

//[] execVM "Addons\Nuke\Effects\athmo.sqf";

sleep 2;

[_xpos, _ypos] execVM "Addons\Nuke\Effects\glare.sqf";
[_xpos, _ypos] execVM "Addons\Nuke\Effects\light.sqf";
[_xpos, _ypos] exec "Addons\Nuke\Effects\blast_1.sqs";
[_xpos, _ypos] exec "Addons\Nuke\Effects\blast1.sqs";
[_xpos, _ypos] exec "Addons\Nuke\Effects\hat.sqs";
[_xpos, _ypos] execVM "Addons\Nuke\Effects\ears.sqf";
[_xpos, _ypos] execVM "Addons\Nuke\Effects\aperture.sqf";

sleep 0.5;
[_xpos, _ypos] exec "Addons\Nuke\Effects\hatnod.sqs";
[_xpos, _ypos] exec "Addons\Nuke\Effects\blast1.sqs";

[_xpos, _ypos] exec "Addons\Nuke\Effects\ring1.sqs";
sleep 0.5;
[_xpos, _ypos] exec "Addons\Nuke\Effects\ring2.sqs";

[_xpos, _ypos] exec "Addons\Nuke\Effects\blast2.sqs";
sleep 0.4;
[_xpos, _ypos] exec "Addons\Nuke\Effects\blast3.sqs";

sleep 60;

[_xpos, _ypos] execVM "Addons\Nuke\Effects\dust.sqf";
[_xpos, _ypos] execVM "Addons\Nuke\Effects\snow.sqf";
