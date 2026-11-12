private ["_vehicle"];
_vehicle=_this;

// Клиент считает сеть ТОЛЬКО для своей локальной пехоты (боты в группе игрока).
// Игрока, технику и города считает сервер — иначе два писателя AN_iNet.
if (!CTI_isServer && {!(_vehicle isKindOf "Man") || {!local _vehicle} || {isPlayer _vehicle}}) exitWith {false};

while {! CTI_GameOver && alive  _vehicle} do {
	if ((_vehicle) call AN_Check_Connection) then {
		if !((_vehicle getVariable "AN_iNet") == (_vehicle getVariable "AN_Conn") getVariable "AN_iNet") then {
			_vehicle setVariable ["AN_iNet",(_vehicle getVariable "AN_Conn") getVariable "AN_iNet" ,true];
		};
	} else {
		if !((_vehicle getVariable "AN_iNet") == -1) then {
			_vehicle setVariable ["AN_iNet",-1,true];
		};
	};
	sleep 3;
};
_vehicle setVariable ["AN_iNet",nil,true];