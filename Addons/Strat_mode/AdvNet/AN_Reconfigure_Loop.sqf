/// Клиент перестраивает маршруты только для своей локальной пехоты.
if (!CTI_isServer && {!(_this isKindOf "Man") || {!local _this} || {isPlayer _this}}) exitWith {false};

while {! CTI_GameOver && alive  _this } do {
	_this call AN_Reconfigure;
	sleep 10+random(15);
};