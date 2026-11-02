/*
  # HEADER #
	Script: 		Common\Functions\Common_RearmVehicle.sqf
	Alias:			CTI_CO_FNC_RearmVehicle
	Description:	Rearm a vehicle and it's turrets
	Author: 		Benny
	Creation Date:	19-09-2013
	Revision Date:	14-10-2013

  # PARAMETERS #
    0	[Object]: The vehicle
    1	[Side]: The side of the vehicle

  # RETURNED VALUE #
	None

  # SYNTAX #
	[VEHICLE, SIDE] call CTI_CO_FNC_RearmVehicle

  # DEPENDENCIES #
	Common Function: CTI_CO_FNC_SanitizeAircraft
	Common Function: CTI_CO_FNC_SanitizeArtillery

  # EXAMPLE #
    [vehicle player, CTI_P_SideJoined] call CTI_CO_FNC_RearmVehicle;
	  -> Rearm the player vehicle of the player
*/

private ["_side", "_type", "_vehicle", "_sideFromID", "_upgrades", "_upgrade_level", "_weapons"];

_vehicle = _this select 0;
_side = _this select 1;
_type = typeOf _vehicle;

_t_side=if (typeName _side == "SCALAR") then {(_side call CTI_CO_FNC_GetSideFromID)} else {_side};

//_vehicle setVehicleAmmoDef 1;

// Fix for air vehicles ... uses sanatise script to clean up afterwards
if ( _vehicle isKindOf "Air" && (missionNamespace getVariable "CTI_AC_ENABLED")>0) then
{
	_vehicle call CTI_AC_PURGE_ALL_WEAPONS;
	_vehicle call CTI_AC_REFRESH_LOADOUT_ON_MOUNTED;
	if (_vehicle isKindOf "Air") then {[_vehicle, _side] call CTI_CO_FNC_SanitizeAircraft};
} else {

	//--- Driver
	{_vehicle removeMagazineTurret [_x, [-1]];} forEach (getArray(configFile >> "CfgVehicles" >> _type >> "magazines"));
	{_vehicle addMagazineTurret [_x, [-1]]} forEach (getArray(configFile >> "CfgVehicles" >> _type >> "magazines"));

	//--- Turrets
	_config = configFile >> "CfgVehicles" >> _type >> "turrets";
	for '_i' from 0 to (count _config)-1 do {
		_turret_main = _config select _i;
		_config_sub = _turret_main >> "turrets";
		{_vehicle removeMagazineTurret [_x, [_i]];} forEach (getArray(_turret_main >> "magazines"));
		{ _vehicle addMagazineTurret [_x, [_i]]} forEach (getArray(_turret_main >> "magazines"));
		for '_j' from 0 to (count _config_sub) -1 do {
			_turret_sub = _config_sub select _j;
			{_vehicle removeMagazineTurret [_x, [_i, _j]];} forEach (getArray(_turret_sub >> "magazines"));
			{_vehicle addMagazineTurret [_x, [_i, _j]];} forEach (getArray(_turret_sub >> "magazines"));
		};
	};

	//--- Authorize the air loadout depending on the parameters set
	if (_vehicle isKindOf "Air") then {[_vehicle, _side] call CTI_CO_FNC_SanitizeAircraft};

	//--- Sanitize the artillery loadout, mines may lag the server for instance
	if (CTI_ARTILLERY_FILTER == 1) then {if (typeOf _vehicle in (missionNamespace getVariable ["CTI_ARTILLERY", []])) then {(_vehicle) call CTI_CO_FNC_SanitizeArtillery}};

	// Reload the trophy system

	/*if (_vehicle isKindOf "tank" || _vehicle isKindOf "Wheeled_APC_F") then {
		_ammo=if (! (count ((_side) call CTI_CO_FNC_GetSideUpgrades) == 0)) then {2+2*(((_side) call CTI_CO_FNC_GetSideUpgrades) select CTI_UPGRADE_TRA)} else {2};
		_vehicle setVariable ["TROPHY_time_l",time-10000,true];
		_vehicle setVariable ["TROPHY_time_r",time-10000,true];
		_vehicle setVariable ["TROPHY_ammo_l",ceil(_ammo/2),true];
		_vehicle setVariable ["TROPHY_ammo_r",ceil(_ammo/2),true];

	};*/

	if (_vehicle isKindOf "Tank" || _vehicle isKindOf "Wheeled_APC_F" || _vehicle isKindOf "MRAP_03_base_F" || _vehicle isKindOf "MRAP_03_gmg_base_F" || _vehicle isKindOf "MRAP_03_hmg_base_F" || _vehicle isKindOf "MRAP_02_base_F" || _vehicle isKindOf "MRAP_02_gmg_base_F" || _vehicle isKindOf "MRAP_02_hmg_base_F") then {
		_weapons = getArray(configFile >> "CfgVehicles" >> typeOf _vehicle >> "weapons");
		if ("SmokeLauncher" in _weapons) then {
			{
				if (getText(configFile >> "CfgMagazines" >> _x >> "ammo") in ["SmokeLauncherAmmo"]) then {
					if (_vehicle isKindOf "MRAP_02_base_F" || _vehicle isKindOf "MRAP_02_gmg_base_F" || _vehicle isKindOf "MRAP_02_hmg_base_F") then {
						_vehicle removeMagazineTurret [_x, [-1]];
					} else {
						_vehicle removeMagazineTurret [_x, [0,0]];
					};
				};
			} forEach (getArray(configFile >> "CfgVehicles" >> typeOf _vehicle >> "magazines"));
		};

		_upgrades = (_side) call CTI_CO_FNC_GetSideUpgrades;
		_upgrade_level = _upgrades select CTI_UPGRADE_IRS;

		if (_vehicle isKindOf "MRAP_02_base_F" || _vehicle isKindOf "MRAP_02_gmg_base_F" || _vehicle isKindOf "MRAP_02_hmg_base_F") then {
			_vehicle addMagazineTurret ["SmokeLauncherMag",[-1],2];
			if (_upgrade_level == 1) then {_vehicle addMagazineTurret ["SmokeLauncherMag",[-1],2]};
			if (_upgrade_level == 2) then {_vehicle addMagazineTurret ["SmokeLauncherMag",[-1],2]};
		} else {
			_vehicle addMagazineTurret ["SmokeLauncherMag",[0,0],2];
			if (_upgrade_level == 1) then {_vehicle addMagazineTurret ["SmokeLauncherMag",[0,0],2]};
			if (_upgrade_level == 2) then {_vehicle addMagazineTurret ["SmokeLauncherMag",[0,0],2]};
		};
	};

if (typeOf _vehicle == "B_Plane_CAS_01_F" || 
    typeOf _vehicle == "B_UAV_05_F" ||
    typeOf _vehicle == "O_Plane_CAS_02_F" ||
    typeOf _vehicle == "O_Plane_Fighter_01_F" ||      
    typeOf _vehicle == "B_Plane_Fighter_02_F" ||  
    typeOf _vehicle == "I_Plane_Fighter_03_CAS_F" || 
    typeOf _vehicle == "I_Plane_Fighter_03_AA_F") then {
        
	_sideFromID = (_side) call CTI_CO_FNC_GetSideFromID;
    _sideText = str _sideFromID;
	if (_sideText == "WEST" || _sideText == "EAST") then {                    	
	_upgrades = (_sideFromID) call CTI_CO_FNC_GetSideUpgrades;
	_upgrade_level = _upgrades select CTI_UPGRADE_AIR_CM;
    _vehicle removeMagazineTurret ["120Rnd_CMFlare_Chaff_Magazine",[]];
    _vehicle removeMagazineTurret ["240Rnd_CMFlare_Chaff_Magazine",[]];
	if ((((_t_side) call CTI_CO_FNC_GetSideUpgrades) select CTI_UPGRADE_AIR_CM) == 1) then {
		_vehicle addWeapon "CMFlareLauncher";
        _vehicle removeMagazineTurret ["240Rnd_CMFlare_Chaff_Magazine",[-1]];
        _vehicle addMagazineTurret ["120Rnd_CMFlareMagazine",[-1]];
		};
		if ((((_t_side) call CTI_CO_FNC_GetSideUpgrades) select CTI_UPGRADE_AIR_CM) == 2) then {
		_vehicle addWeapon "CMFlareLauncher";
	};
   }; 
};

///////////////////////////////////////////////////////////////////////////////////////////////
//repear CMF
// O_Plane_CAS_02_F  east///////////
_sideFromID = (_side) call CTI_CO_FNC_GetSideFromID;
    _sideText = str _sideFromID;
	if (typeOf _vehicle == "O_Plane_CAS_02_F") then {
		for "_i" from 1 to 13 do {_vehicle setAmmoOnPylon [_i, 0]; };
				_vehicle removeWeapon "CMFlareLauncher";
if ((((_t_side) call CTI_CO_FNC_GetSideUpgrades) select CTI_UPGRADE_AIR_CM) == 1) then {
		_vehicle addWeapon "CMFlareLauncher";
        _vehicle removeMagazineTurret ["240Rnd_CMFlare_Chaff_Magazine",[-1]];
        _vehicle addMagazineTurret ["120Rnd_CMFlareMagazine",[-1]];
		};
		if ((((_t_side) call CTI_CO_FNC_GetSideUpgrades) select CTI_UPGRADE_AIR_CM) == 2) then {
		_vehicle addWeapon "CMFlareLauncher";
		}; 
}; 

///////////////////////////////////////////////////////////////////////////////////////////////
//repear CMF
// B_Plane_CAS_01_F  west///////////
_sideFromID = (_side) call CTI_CO_FNC_GetSideFromID;
    _sideText = str _sideFromID;
	if (typeOf _vehicle == "B_Plane_CAS_01_F") then {
		for "_i" from 1 to 13 do {_vehicle setAmmoOnPylon [_i, 0]; };
				_vehicle removeWeapon "CMFlareLauncher";
if ((((_t_side) call CTI_CO_FNC_GetSideUpgrades) select CTI_UPGRADE_AIR_CM) == 1) then {
		_vehicle addWeapon "CMFlareLauncher";
        _vehicle removeMagazineTurret ["240Rnd_CMFlare_Chaff_Magazine",[-1]];
        _vehicle addMagazineTurret ["120Rnd_CMFlareMagazine",[-1]];
		};
		if ((((_t_side) call CTI_CO_FNC_GetSideUpgrades) select CTI_UPGRADE_AIR_CM) == 2) then {
		_vehicle addWeapon "CMFlareLauncher";
		}; 
}; 

///////////////////////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////////////////////

 // To-201 Shikra
	 // To-201 Shikra
    	if (typeOf _vehicle == "O_Plane_Fighter_02_F") then {
    		for "_i" from 1 to 13 do {_vehicle setAmmoOnPylon [_i, 0]; };
    		_vehicle removeWeapon "weapon_R73Launcher";
    		_vehicle removeWeapon "weapon_R77Launcher";
    		_vehicle removeWeapon "weapon_KAB250Launcher";
    		_vehicle removeWeapon "CMFlareLauncher";

    		if ((((_t_side) call CTI_CO_FNC_GetSideUpgrades) select CTI_UPGRADE_AIR_AT) == 1) then {
    		_vehicle setPylonLoadOut ["pylons5", "PylonMissile_Missile_KH58_x1", false, []];
    		_vehicle setPylonLoadOut ["pylons6", "PylonMissile_Missile_KH58_x1", false, []];

    		_vehicle setPylonLoadOut ["pylons3", "PylonMissile_Missile_AGM_KH25_x1", false, []];
    		_vehicle setPylonLoadOut ["pylons4", "PylonMissile_Missile_AGM_KH25_x1", false, []];
            _vehicle setPylonLoadOut ["pylonBayCenter3", "PylonMissile_Missile_KH58_INT_x1", false, []];

        	_vehicle setAmmoOnPylon ["pylons3", 2];
            _vehicle setAmmoOnPylon ["pylons4", 2];
    		};
    		if ((((_t_side) call CTI_CO_FNC_GetSideUpgrades) select CTI_UPGRADE_AIR_AA) == 1) then {
    		_vehicle setPylonLoadOut ["pylonBayLeft1", "PylonMissile_Missile_AA_R73_x1", false, []];
    		_vehicle setPylonLoadOut ["pylonBayRight1", "PylonMissile_Missile_AA_R73_x1", false, []];
    		_vehicle setPylonLoadOut ["pylons1", "PylonMissile_Missile_AA_R77_x1", false, []];
    		_vehicle setPylonLoadOut ["pylons2", "PylonMissile_Missile_AA_R77_x1", false, []];

    		_vehicle setPylonLoadOut ["pylonBayRight2", "PylonMissile_Missile_AA_R77_x1", false, []];
    		_vehicle setPylonLoadOut ["pylonBayLeft2", "PylonMissile_Missile_AA_R77_x1", false, []];
    		_vehicle setPylonLoadOut ["pylonBayCenter1", "PylonMissile_Missile_AA_R77_x1", false, []];
    		_vehicle setPylonLoadOut ["pylonBayCenter2", "PylonMissile_Missile_AA_R77_x1", false, []];
    		};
    		if ((((_t_side) call CTI_CO_FNC_GetSideUpgrades) select CTI_UPGRADE_AIR_CM) == 1) then {
    		_vehicle addWeapon "CMFlareLauncher";
            _vehicle removeMagazineTurret ["240Rnd_CMFlare_Chaff_Magazine",[-1]];
            _vehicle addMagazineTurret ["120Rnd_CMFlareMagazine",[-1]];
    		};
    		if ((((_t_side) call CTI_CO_FNC_GetSideUpgrades) select CTI_UPGRADE_AIR_CM) == 2) then {
    		_vehicle addWeapon "CMFlareLauncher";
    		};
    	};
    
// To-201 Shikra Stealth
	if (typeOf _vehicle == "O_Plane_Fighter_02_Stealth_F") then {	   
		for "_i" from 7 to 13 do {_vehicle setAmmoOnPylon [_i, 0]; };
		_vehicle removeWeapon "weapon_R73Launcher";
		_vehicle removeWeapon "weapon_R77Launcher";
        _vehicle removeWeapon "weapon_KAB250Launcher";        
		_vehicle removeWeapon "CMFlareLauncher";
		
        _vehicle setPylonLoadOut [13, "PylonMissile_1Rnd_BombCluster_02_cap_F", false, []];                   
        _vehicle setAmmoOnPylon [13, 4];        

		if ((((_t_side) call CTI_CO_FNC_GetSideUpgrades) select CTI_UPGRADE_AIR_AA) == 1) then {
		_vehicle setPylonLoadOut [7, "PylonMissile_Missile_AA_R73_x1", false, []];
		_vehicle setPylonLoadOut [8, "PylonMissile_Missile_AA_R73_x1", false, []];
        _vehicle setAmmoOnPylon [7, 3];
        _vehicle setAmmoOnPylon [8, 3];
        
		_vehicle setPylonLoadOut [9, "PylonMissile_Missile_AA_R77_x1", false, []];
		_vehicle setPylonLoadOut [10, "PylonMissile_Missile_AA_R77_x1", false, []];
		_vehicle setPylonLoadOut [11, "PylonMissile_Missile_AA_R77_INT_x1", false, []];
		_vehicle setPylonLoadOut [12, "PylonMissile_Missile_AA_R77_INT_x1", false, []];
        _vehicle setAmmoOnPylon [9, 2];
        _vehicle setAmmoOnPylon [10, 2];                        
		};
		if ((((_t_side) call CTI_CO_FNC_GetSideUpgrades) select CTI_UPGRADE_AIR_CM) == 1) then {
		_vehicle addWeapon "CMFlareLauncher";
        _vehicle removeMagazineTurret ["240Rnd_CMFlare_Chaff_Magazine",[-1]];
        _vehicle addMagazineTurret ["120Rnd_CMFlareMagazine",[-1]];
		};
		if ((((_t_side) call CTI_CO_FNC_GetSideUpgrades) select CTI_UPGRADE_AIR_CM) == 2) then {
		_vehicle addWeapon "CMFlareLauncher";
		}; 
	};   
     
 // To-201 Shikra Cluster
	if (typeOf _vehicle == "O_Plane_Fighter_02_Cluster_F") then {
		for "_i" from 1 to 13 do {_vehicle setAmmoOnPylon [_i, 0]; };
		_vehicle removeWeapon "weapon_R73Launcher";
		_vehicle removeWeapon "weapon_R77Launcher";
		_vehicle removeWeapon "CMFlareLauncher";
		       
		_vehicle setPylonLoadOut [5, "PylonMissile_1Rnd_BombCluster_02_cap_F", false, []];
        _vehicle setPylonLoadOut [6, "PylonMissile_1Rnd_BombCluster_02_cap_F", false, []];
        _vehicle setPylonLoadOut [13, "PylonMissile_Bomb_KAB250_x1", false, []];
        _vehicle setPylonLoadOut [3, "PylonMissile_Bomb_KAB250_x1", false, []];
        _vehicle setPylonLoadOut [4, "PylonMissile_Bomb_KAB250_x1", false, []];
        
        _vehicle setAmmoOnPylon [5, 3];
        _vehicle setAmmoOnPylon [6, 3];                         
        _vehicle setAmmoOnPylon [13, 2];        
             		
		if ((((_t_side) call CTI_CO_FNC_GetSideUpgrades) select CTI_UPGRADE_AIR_AA) == 1) then {
		_vehicle setPylonLoadOut [1, "PylonMissile_Missile_AA_R77_x1", false, []];
		_vehicle setPylonLoadOut [2, "PylonMissile_Missile_AA_R77_x1", false, []];
		_vehicle setPylonLoadOut [7, "PylonMissile_Missile_AA_R73_x1", false, []];
		_vehicle setPylonLoadOut [8, "PylonMissile_Missile_AA_R73_x1", false, []];                          
		};
		if ((((_t_side) call CTI_CO_FNC_GetSideUpgrades) select CTI_UPGRADE_AIR_CM) == 1) then {
		_vehicle addWeapon "CMFlareLauncher";
        _vehicle removeMagazineTurret ["240Rnd_CMFlare_Chaff_Magazine",[-1]];
        _vehicle addMagazineTurret ["120Rnd_CMFlareMagazine",[-1]];
		};
		if ((((_t_side) call CTI_CO_FNC_GetSideUpgrades) select CTI_UPGRADE_AIR_CM) == 2) then {
		_vehicle addWeapon "CMFlareLauncher";
		};        
	};    

   // F/A-181 Black Wasp II
    if (typeOf _vehicle == "B_Plane_Fighter_01_F") then {
		for "_i" from 1 to 12 do {_vehicle setAmmoOnPylon [_i, 0]; };
		_vehicle removeWeapon "weapon_AMRAAMLauncher";
		_vehicle removeWeapon "weapon_AGM_65Launcher";
		_vehicle removeWeapon "weapon_BIM9xLauncher";
		_vehicle removeWeapon "weapon_GBU12Launcher";
		_vehicle removeWeapon "CMFlareLauncher_Singles";
		
		_vehicle setPylonLoadOut [11, "PylonMissile_Bomb_GBU12_x1", false, []];
		_vehicle setPylonLoadOut [12, "PylonMissile_Bomb_GBU12_x1", false, []];

		if ((((_t_side) call CTI_CO_FNC_GetSideUpgrades) select CTI_UPGRADE_AIR_AT) == 1) then {
		_vehicle setPylonLoadOut [1, "PylonRack_Missile_AGM_02_x1", false, []];
		_vehicle setPylonLoadOut [2, "PylonRack_Missile_AGM_02_x1", false, []];
        _vehicle setPylonLoadOut [3, "PylonRack_Missile_HARM_x1", false, []];
        _vehicle setPylonLoadOut [4, "PylonRack_Missile_HARM_x1", false, []];
		};
		if ((((_t_side) call CTI_CO_FNC_GetSideUpgrades) select CTI_UPGRADE_AIR_AA) == 1) then {
		_vehicle setPylonLoadOut [5, "PylonMissile_Missile_BIM9X_x1", false, []];
		_vehicle setPylonLoadOut [6, "PylonMissile_Missile_BIM9X_x1", false, []];
		_vehicle setPylonLoadOut [7, "PylonMissile_Missile_AMRAAM_D_INT_x1", false, []];
		_vehicle setPylonLoadOut [8, "PylonMissile_Missile_AMRAAM_D_INT_x1", false, []];
		_vehicle setPylonLoadOut [9, "PylonMissile_Missile_AMRAAM_D_INT_x1", false, []];
		_vehicle setPylonLoadOut [10, "PylonMissile_Missile_AMRAAM_D_INT_x1", false, []];        
		};
		if ((((_t_side) call CTI_CO_FNC_GetSideUpgrades) select CTI_UPGRADE_AIR_CM) == 1) then {
		_vehicle addWeapon "CMFlareLauncher_Singles";
        _vehicle removeMagazineTurret ["240Rnd_CMFlare_Chaff_Magazine",[-1]];
        _vehicle addMagazineTurret ["120Rnd_CMFlare_Chaff_Magazine",[-1]];
		};
		if ((((_t_side) call CTI_CO_FNC_GetSideUpgrades) select CTI_UPGRADE_AIR_CM) == 2) then {
		_vehicle addWeapon "CMFlareLauncher_Singles";
		}; 
	};

    
    // F/A-181 Black Wasp II Stealth
    if (typeOf _vehicle == "B_Plane_Fighter_01_Stealth_F") then {
		for "_i" from 5 to 12 do {_vehicle setAmmoOnPylon [_i, 0]; };
		_vehicle removeWeapon "weapon_AMRAAMLauncher";
		_vehicle removeWeapon "weapon_AGM_65Launcher";
		_vehicle removeWeapon "weapon_BIM9xLauncher";
		_vehicle removeWeapon "weapon_GBU12Launcher";
		_vehicle removeWeapon "CMFlareLauncher_Singles";
		
		_vehicle setPylonLoadOut [11, "PylonMissile_1Rnd_BombCluster_03_F", false, []];
		_vehicle setPylonLoadOut [12, "PylonMissile_1Rnd_BombCluster_03_F", false, []];
        _vehicle setAmmoOnPylon [11, 2];
        _vehicle setAmmoOnPylon [12, 2];
		
		if ((((_t_side) call CTI_CO_FNC_GetSideUpgrades) select CTI_UPGRADE_AIR_AA) == 1) then {
		_vehicle setPylonLoadOut [5, "PylonMissile_Missile_BIM9X_x1", false, []];
		_vehicle setPylonLoadOut [6, "PylonMissile_Missile_BIM9X_x1", false, []];
        _vehicle setAmmoOnPylon [5, 3]; 
        _vehicle setAmmoOnPylon [6, 3]; 
		_vehicle setPylonLoadOut [7, "PylonMissile_Missile_AMRAAM_D_INT_x1", false, []];
		_vehicle setPylonLoadOut [8, "PylonMissile_Missile_AMRAAM_D_INT_x1", false, []];
		_vehicle setPylonLoadOut [9, "PylonMissile_Missile_AMRAAM_D_INT_x1", false, []];
		_vehicle setPylonLoadOut [10, "PylonMissile_Missile_AMRAAM_D_INT_x1", false, []]; 
        _vehicle setAmmoOnPylon [7, 2]; 
        _vehicle setAmmoOnPylon [8, 2]; 
        _vehicle setAmmoOnPylon [9, 1]; 
        _vehicle setAmmoOnPylon [10, 1];        
		};
		if ((((_t_side) call CTI_CO_FNC_GetSideUpgrades) select CTI_UPGRADE_AIR_CM) == 1) then {
		_vehicle addWeapon "CMFlareLauncher_Singles";
        _vehicle removeMagazineTurret ["240Rnd_CMFlare_Chaff_Magazine",[-1]];
        _vehicle addMagazineTurret ["120Rnd_CMFlare_Chaff_Magazine",[-1]];
		};
		if ((((_t_side) call CTI_CO_FNC_GetSideUpgrades) select CTI_UPGRADE_AIR_CM) == 2) then {
		_vehicle addWeapon "CMFlareLauncher_Singles";
		};        
	};    
    
  // F/A-181 Black Wasp II Cluster
    if (typeOf _vehicle == "B_Plane_Fighter_01_Cluster_F") then {
		for "_i" from 1 to 12 do {_vehicle setAmmoOnPylon [_i, 0]; };
		_vehicle removeWeapon "weapon_AMRAAMLauncher";
		_vehicle removeWeapon "weapon_AGM_65Launcher";
		_vehicle removeWeapon "weapon_BIM9xLauncher";
		_vehicle removeWeapon "weapon_GBU12Launcher";
        _vehicle removeWeapon "weapon_KAB250Launcher";        
		_vehicle removeWeapon "CMFlareLauncher_Singles";
		
		_vehicle setPylonLoadOut [11, "PylonMissile_Bomb_GBU12_x1", false, []];
		_vehicle setPylonLoadOut [12, "PylonMissile_Bomb_GBU12_x1", false, []];      
        _vehicle setPylonLoadOut [3, "PylonRack_2Rnd_BombCluster_01_F", false, []];
		_vehicle setPylonLoadOut [4, "PylonRack_2Rnd_BombCluster_01_F", false, []];   
        _vehicle setAmmoOnPylon [11, 2];
        _vehicle setAmmoOnPylon [12, 3]; 
		
		if ((((_t_side) call CTI_CO_FNC_GetSideUpgrades) select CTI_UPGRADE_AIR_AA) == 1) then {
		_vehicle setPylonLoadOut [1, "PylonRack_Missile_AMRAAM_D_x2", false, []];
		_vehicle setPylonLoadOut [2, "PylonRack_Missile_AMRAAM_D_x2", false, []];
		_vehicle setPylonLoadOut [5, "PylonMissile_Missile_BIM9X_x1", false, []];
		_vehicle setPylonLoadOut [6, "PylonMissile_Missile_BIM9X_x1", false, []];        
		};
		if ((((_t_side) call CTI_CO_FNC_GetSideUpgrades) select CTI_UPGRADE_AIR_CM) == 1) then {
		_vehicle addWeapon "CMFlareLauncher_Singles";
        _vehicle removeMagazineTurret ["240Rnd_CMFlare_Chaff_Magazine",[-1]];        
		_vehicle addMagazineTurret ["120Rnd_CMFlare_Chaff_Magazine",[-1]];
		};
		if ((((_t_side) call CTI_CO_FNC_GetSideUpgrades) select CTI_UPGRADE_AIR_CM) == 2) then {
		_vehicle addWeapon "CMFlareLauncher_Singles";
		}; 
	};    
 
    // A-149 Gryphon
//    if (_vehicle isKindOf "I_Plane_Fighter_04_F" && _side != CTI_RESISTANCE_ID) then {
//		for "_i" from 1 to 6 do {_vehicle setAmmoOnPylon [_i, 0]; };
//		_vehicle removeWeapon "weapon_AMRAAMLauncher";
//		_vehicle removeWeapon "weapon_AGM_65Launcher";
//		_vehicle removeWeapon "weapon_BIM9xLauncher";
//		_vehicle removeWeapon "CMFlareLauncher";
//		
//		if ((((_t_side) call CTI_CO_FNC_GetSideUpgrades) select CTI_UPGRADE_AIR_AT) == 1) then {
//		_vehicle setPylonLoadOut [3, "PylonRack_Missile_AGM_02_x1", false, []];
//		_vehicle setPylonLoadOut [4, "PylonRack_Missile_AGM_02_x1", false, []];  
//        _vehicle setAmmoOnPylon [3, 6];
//        _vehicle setAmmoOnPylon [4, 6];
//		};
//		if ((((_t_side) call CTI_CO_FNC_GetSideUpgrades) select CTI_UPGRADE_AIR_AA) == 1) then {
//		_vehicle setPylonLoadOut [1, "PylonMissile_Missile_BIM9X_x1", false, []];
//		_vehicle setPylonLoadOut [2, "PylonMissile_Missile_BIM9X_x1", false, []];
//		_vehicle setPylonLoadOut [5, "PylonRack_Missile_AGM_02_x2", false, []];
//		_vehicle setPylonLoadOut [6, "PylonRack_Missile_AGM_02_x2", false, []];
//		_vehicle setAmmoOnPylon [5, 2];
//      _vehicle setAmmoOnPylon [6, 2];
//		};
//		if ((((_t_side) call CTI_CO_FNC_GetSideUpgrades) select CTI_UPGRADE_AIR_CM) >= 1) then {
//		_vehicle addWeapon "CMFlareLauncher";
//		};
//	};

    // A-149 Gryphon
    if (_vehicle isKindOf "I_Plane_Fighter_04_F") then {
		for "_i" from 1 to 6 do {_vehicle setAmmoOnPylon [_i, 0]; };
		_vehicle removeWeapon "weapon_AMRAAMLauncher";
		_vehicle removeWeapon "weapon_AGM_65Launcher";
		_vehicle removeWeapon "weapon_BIM9xLauncher";
		_vehicle removeWeapon "CMFlareLauncher";
		
		if ((((_t_side) call CTI_CO_FNC_GetSideUpgrades) select CTI_UPGRADE_AIR_AT) == 1) then {
		_vehicle setPylonLoadOut [3, "PylonRack_Missile_AGM_02_x1", false, []];
		_vehicle setPylonLoadOut [4, "PylonRack_Missile_AGM_02_x1", false, []];
		};
		if ((((_t_side) call CTI_CO_FNC_GetSideUpgrades) select CTI_UPGRADE_AIR_AA) == 1) then {
		_vehicle setPylonLoadOut [1, "PylonMissile_Missile_BIM9X_x1", false, []];
		_vehicle setPylonLoadOut [2, "PylonMissile_Missile_BIM9X_x1", false, []];
		_vehicle setPylonLoadOut [5, "PylonRack_Missile_AGM_02_x2", false, []];
		_vehicle setPylonLoadOut [6, "PylonRack_Missile_AGM_02_x2", false, []];
		};
		if ((((_t_side) call CTI_CO_FNC_GetSideUpgrades) select CTI_UPGRADE_AIR_CM) >= 1) then {
		_vehicle addWeapon "CMFlareLauncher";
		};
	};


	
//    // A-149 Gryphon
//    if (_vehicle isKindOf "I_Plane_Fighter_04_F") then {
//		for "_i" from 1 to 6 do {_vehicle setAmmoOnPylon [_i, 0]; };
//		_vehicle removeWeapon "weapon_AMRAAMLauncher";
//		_vehicle removeWeapon "weapon_AGM_65Launcher";
//		_vehicle removeWeapon "weapon_BIM9xLauncher";
//		_vehicle removeWeapon "CMFlareLauncher";
//		
//		if ((((_t_side) call CTI_CO_FNC_GetSideUpgrades) select CTI_UPGRADE_AIR_AT) == 1) then {
//		_vehicle setPylonLoadOut [3, "PylonRack_Missile_AGM_02_x1", false, []];
//		_vehicle setPylonLoadOut [4, "PylonRack_Missile_AGM_02_x1", false, []];
//		};
//		if ((((_t_side) call CTI_CO_FNC_GetSideUpgrades) select CTI_UPGRADE_AIR_AA) == 1) then {
//		_vehicle setPylonLoadOut [1, "PylonMissile_Missile_BIM9X_x1", false, []];
//		_vehicle setPylonLoadOut [2, "PylonMissile_Missile_BIM9X_x1", false, []];
//		_vehicle setPylonLoadOut [5, "PylonRack_Missile_AMRAAM_C_x1", false, []];
//		_vehicle setPylonLoadOut [6, "PylonRack_Missile_AMRAAM_C_x1", false, []];
//		};
//		if ((((_t_side) call CTI_CO_FNC_GetSideUpgrades) select CTI_UPGRADE_AIR_CM) >= 1) then {
//		_vehicle addWeapon "CMFlareLauncher";
//		};
//	};


////////////////////////////////////////////////////////////////////////////////////////////////


	if (_vehicle isKindOf "Heli_Attack_02_base_F" || _vehicle isKindOf "VTOL_02_base_F") then {
		_vehicle removeMagazinesTurret ["2Rnd_Missile_AA_03_F",[0]];
		_upgrades = (_side) call CTI_CO_FNC_GetSideUpgrades;
		_upgrade_level = _upgrades select CTI_UPGRADE_AIR_AA;
		if (_upgrade_level == 1) then {
			_vehicle addMagazineTurret ["2Rnd_Missile_AA_03_F",[0]];
			_vehicle addMagazineTurret ["2Rnd_Missile_AA_03_F",[0]];
		};
	};
    
    
 
        if (_vehicle isKindOf "C_IDAP_UAV_06_antimine_F") then {
        _vehicle setVehicleAmmo 1;
        };
    
        	if (_vehicle isKindOf "B_UAV_05_F") then {
     	    _vehicle addMagazineTurret ["PylonRack_Bomb_GBU12_x2",[0]];
            _vehicle addMagazineTurret ["PylonRack_Bomb_GBU12_x2",[0]];
			_vehicle setVehicleAmmo 1;  
	    };

	reload vehicle _vehicle;
};