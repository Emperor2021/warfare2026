
Private ["_ammo","_magazine","_mode","_muzzle","_unit","_weapon"];

_unit = _this select 0;
_weapon = _this select 1;
_muzzle = _this select 2;
_mode = _this select 3;
_ammo = _this select 4;
_magazine = _this select 5;

if (_unit isKindOf "Man") then {
	if (_magazine in ["NLAW_F","RPG32_F","RPG32_HE_F","RPG7_F","Titan_AA","Titan_AP","Titan_AT"]) then {
		if (_unit canAddItemToBackpack _magazine) then {_unit addItemToBackpack _magazine;};
	} else {
		if !(_magazine in (magazines _unit)) then {
			if (_unit canAddItemToVest _magazine) then {
				_unit addItemToVest _magazine;
			} else {
				if (_unit canAddItemToUniform _magazine) then {
					_unit addItemToUniform _magazine;
				} else {
					if (_unit canAddItemToBackpack _magazine) then {
						_unit addItemToBackpack _magazine;
					};
				};
			};
		};
	};
} else {
	if (_unit ammo _muzzle < 1) then {_unit setVehicleAmmo 1;};
};
