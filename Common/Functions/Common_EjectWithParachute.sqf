
private ["_caller", "_para"];

_caller = _this select 1;

_caller allowDamage false;

sleep 0.1;

//_caller action ["Eject", vehicle _caller];	//--- Does not work
_caller action ["getOut", vehicle _caller];	//--- Works fine
//moveOut _caller;	//--- Works fine only if caller in cargo
//doGetOut _caller;	//--- Does not work

sleep 1;

_para = "Steerable_Parachute_F" createVehicle (getPos _caller);
_para setPos (getPos _caller);
_caller moveInDriver _para;

sleep 1;

_caller allowDamage true;
