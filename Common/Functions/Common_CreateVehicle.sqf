/*
  # HEADER #
	Script: 		Common\Functions\Common_CreateVehicle.sqf
	Alias:			CTI_CO_FNC_CreateVehicle
	Description:	Create an empty vehicle
					Note that making a vehicle public with the _net variable will make it
					undergo the function CTI_CO_FNC_InitializeNetVehicle
					A public vehicle is initialized for all (+JIP) but the server
	Author: 		Benny
	Creation Date:	16-09-2013
	Revision Date:	16-09-2013

  # PARAMETERS #
    0	[String]: The type of vehicle to create
    1	[Array/Object]: The 2D/3D position where the vehicle should be created at
    2	[Integer]: The Azimuth direction (0-360?) of the vehicle
    3	[Side/Integer]: The Side or Side ID of the vehicle
    4	{Optionnal} [Boolean]: Determine if the vehicle should be created locked or not
    5	{Optionnal} [Boolean]: Determine if the vehicle should be "public" or not
    6	{Optionnal} [Boolean]: Determine if the vehicle should be handled upon destruction or not (bounty...tk...)
    7	{Optionnal} [String]: Set a special spawn mode for the vehicle

  # RETURNED VALUE #
	[Object]: The created vehicle

  # SYNTAX #
	[CLASSNAME, POSITION, DIRECTION, SIDE] call CTI_CO_FNC_CreateVehicle
	[CLASSNAME, POSITION, DIRECTION, SIDE, LOCKED] call CTI_CO_FNC_CreateVehicle
	[CLASSNAME, POSITION, DIRECTION, SIDE, LOCKED, PUBLIC] call CTI_CO_FNC_CreateVehicle
	[CLASSNAME, POSITION, DIRECTION, SIDE, LOCKED, PUBLIC, HANDLED] call CTI_CO_FNC_CreateVehicle
	[CLASSNAME, POSITION, DIRECTION, SIDE, LOCKED, PUBLIC, HANDLED, SPECIAL] call CTI_CO_FNC_CreateVehicle

  # DEPENDENCIES #
	Common Function: CTI_CO_FNC_GetSideFromID
	Common Function: CTI_CO_FNC_GetSideID
	Common Function: CTI_CO_FNC_OnUnitGetOut
	Common Function: CTI_CO_FNC_OnUnitHit
	Common Function: CTI_CO_FNC_OnUnitKilled

  # EXAMPLE #
	_vehicle = ["B_Quadbike_01_F", getPos player, 0, CTI_P_SideJoined] call CTI_CO_FNC_CreateVehicle;
	  -> Create a "B_Quadbike_01_F" at the player's position facing North on the player's initial side
	_vehicle = ["B_Quadbike_01_F", getPos player, 180, CTI_P_SideJoined, true, true] call CTI_CO_FNC_CreateVehicle;
	  -> Create a locked and handled "B_Quadbike_01_F" at the player's position facing South on the player's initial side
*/

private ["_direction", "_handle", "_locked", "_net", "_position", "_side", "_special", "_type", "_vehicle", "_sideFromID", "_sideText", "_upgrades", "_upgrade_level", "_weapons"];

_type = _this select 0;
_position = _this select 1;
_direction = _this select 2;
_side = _this select 3;

_locked = if (count _this > 4) then {_this select 4} else {false};
_net = if (count _this > 5) then {_this select 5} else {false};
_handle = if (count _this > 6) then {_this select 6} else {false};
_special = if (count _this > 7) then {_this select 7} else {"FORM"};
_created = if (count _this > 8) then {_this select 8} else {objNull};
_t_side=if (typeName _side == "SCALAR") then {(_side call CTI_CO_FNC_GetSideFromID)} else {_side};
if (typeName _position == "OBJECT") then {_position = getPos _position};
if (typeName _side == "SIDE") then {_side = (_side) call CTI_CO_FNC_GetSideID};


_vehicle = if ( isNull _created) then {createVehicle [_type, _position, [], 7, _special]} else {_created};
if (isNull _created) then {
	_vehicle setDir _direction;
	if (_special == "FORM") then {_vehicle setPos [getPos _vehicle select 0, getPos _vehicle select 1, 1];}; //--- Make the vehicle spawn above the ground level to prevent any bisteries
	// --- Zerty edit
    
//if _type isKindOf "C_IDAP_UAV_06_antimine_F" then {[_vehicle] joinSilent (createGroup _side)};
     
	if (_type isKindOf "UAV" || 
        _type isKindOf "UGV_01_base_F" || 
        _type isKindOf "UAV_03_base_F" || 
        _type isKindOf "UAV_01_base_F" ||
        _vehicle isKindOf "B_UGV_02_Demining_F" ||
        _vehicle isKindOf "B_UGV_02_Science_F" ||
        _type isKindOf "UAV_06_base_F") then {createVehicleCrew _vehicle};
        
        
   if ( _vehicle isKindOf "B_UGV_02_Demining_F" || _vehicle isKindOf "B_UGV_02_Science_F" || _vehicle isKindOf "C_IDAP_UAV_06_antimine_F") then {
        createVehicleCrew _vehicle;
        _vehicle joinAsSilent [createGroup _t_side, 99]; 
    };        

	if (_special == "FLY" && _vehicle isKindOf "Plane") then {
		_vehicle setVelocity [75 * (sin _direction), 75 * (cos _direction), 0];
	} else {
		_vehicle setVelocity [0,0,0.1];
	};
};


	if (_type isKindOf "AAA_System_01_base_F" || _type isKindOf "SAM_System_01_base_F" || _type isKindOf "SAM_System_02_base_F") then { 	
    _sideFromID = (_side) call CTI_CO_FNC_GetSideFromID;
    _sideText = str _sideFromID;    
	if (_sideText == "WEST" ) then {
     createVehicleCrew _vehicle;
	(group _vehicle) setBehaviour "COMBAT";
	(group _vehicle) setCombatMode "RED";
	_vehicle setVehicleRadar 1;
	_vehicle setVehicleLock "UNLOCKED";
    [_vehicle,["Sand",1],true] call BIS_fnc_initVehicle;
    };
    if (_sideText == "EAST" ) then {
        createVehicleCrew _vehicle;
	    (group _vehicle) setBehaviour "COMBAT";
	    (group _vehicle) setCombatMode "RED";
	    _vehicle setVehicleRadar 1;
	    _vehicle setVehicleLock "UNLOCKED";        
        _vehicle joinAsSilent [createGroup _t_side, 99];            
    [_vehicle,["Green",1],true] call BIS_fnc_initVehicle;
     };
    };
    
if (_type isKindOf "Radar_System_01_base_F" ||
    _type isKindOf "Radar_System_02_base_F" || 
	_type isKindOf "SAM_System_03_base_F" || 
	_type isKindOf "SAM_System_04_base_F" || 	
	_type isKindOf "B_Ship_Gun_01_base_F" || 
	_type isKindOf "B_Ship_MRLS_01_base_F") then { 
		createVehicleCrew _vehicle;
		(group _vehicle) setBehaviour "COMBAT";
		(group _vehicle) setCombatMode "RED";
		_vehicle setVehicleRadar 1;
		_vehicle setVehicleLock "UNLOCKED";	
	};		

//-----------------------------------------------------------------------------    
    _sideFromID = (_side) call CTI_CO_FNC_GetSideFromID;
    _sideText = str _sideFromID; 
      
 
  
  if (_vehicle isKindOf "O_Plane_Fighter_02_F") then {
    _rnd = random (1);
    if (_rnd > 0.75) then { 
     [_vehicle,["CamoAridHex",1], true] call BIS_fnc_initVehicle;     
    } else { if (_rnd > 0.5) then {
     [_vehicle,["CamoGreyHex",1], true] call BIS_fnc_initVehicle;     
        } else {
     [_vehicle,["CamoBlue",1], true] call BIS_fnc_initVehicle;      
      };      
    };             
  };  
  
  
	if (_vehicle isKindOf "B_Plane_Fighter_01_F") then {
		[_vehicle,["DarkGreyCamo",0.6],["wing_fold_l",0.3]] call BIS_fnc_initVehicle;              
	};

 // Strider
  if (_sideText == "EAST" || _sideText == "WEST") then {
    if (typeOf _vehicle == "I_MRAP_03_F" || typeOf _vehicle == "I_MRAP_03_gmg_F" || typeOf _vehicle == "I_MRAP_03_hmg_F") then {
		[_vehicle,["Blufor",1],true] call BIS_fnc_initVehicle;
    };	
  };
   
  

//-----------------------------------------------------------------------------    
    
/*
if (missionNamespace getVariable "CTI_TROPHY_APS" == 1) then {
	if (_vehicle isKindOf "tank" || _vehicle isKindOf "Wheeled_APC_F") then {

		_ammo=if (! (count ((_t_side) call CTI_CO_FNC_GetSideUpgrades) == 0) ) then {2+2*(((_t_side) call CTI_CO_FNC_GetSideUpgrades) select CTI_UPGRADE_TRA)} else {2};
		if (isNil "_ammo") then {_ammo = 2};
		_vehicle setVariable ["TROPHY_time_l",time-10000,true];
		_vehicle setVariable ["TROPHY_time_r",time-10000,true];
		_vehicle setVariable ["TROPHY_ammo_l",ceil(_ammo/2),true];
		_vehicle setVariable ["TROPHY_ammo_r",ceil(_ammo/2),true];

	};
};*/

//slingload modification
if (_type isKindOf 'Slingload_01_Base_F') then {_vehicle setmass [4000,0]};
if (_type isKindOf "Pod_Heli_Transport_04_base_F") then {_vehicle setmass [2000,0]};


// henroth air loadout
if ( _type isKindOf "Air"  && (missionNamespace getVariable "CTI_AC_ENABLED")>0 && _side != CTI_RESISTANCE_ID) then
{
	_vanilla_loadout = _vehicle call CTI_AC_GET_STANDARD_VANILLA_LOADOUT;
	_vehicle setVariable [ "CTI_AC_AIRCRAFT_LOADOUT_MOUNTED", (_vanilla_loadout) , true ];
	_vehicle setVariable [ "CTI_AC_AIRCRAFT_LOADOUT_COST", ( _vehicle call CTI_AC_GET_VEHCICLE_LOADOUT_COST ) , true ];
	_vehicle setVariable [ "CTI_AC_AIRCRAFT_LOADOUT_IS_BUSY_TIME" , 0 , true ]; // Last time locked
	_vehicle setVariable [ "CTI_AC_AIRCRAFT_LOADOUT_IS_BUSY", false , true ]; // Semaphore
};

if ((missionNamespace getVariable [format ["%1", typeOf _vehicle],["","","","","","","",""]]) select 7 != "") then {
	_side_logic=(_side call CTI_CO_FNC_GetSideFromID) call CTI_CO_FNC_GetSideLogic;
	_current=_side_logic getVariable ["cti_service", []];
	_current=_current -[objNull];
	_current set [count _current,_vehicle];
	_side_logic setVariable ["cti_service", _current,true];
};



if (_locked && !( _vehicle isKindOf "Thing") && !( _vehicle isKindOf "StaticWeapon") && !( _vehicle isKindOf "AAA_System_01_base_F") && !( _vehicle isKindOf "UAV") && !( _vehicle isKindOf "UGV_01_base_F") && !( _vehicle isKindOf "UAV_03_base_F")) then {_vehicle lock 2} else {_vehicle lock 0};
if (_net) then {_vehicle setVariable ["cti_net", _side, true]};
if (_handle) then {
	_vehicle addEventHandler ["killed", format["[_this select 0, _this select 1, %1] spawn CTI_CO_FNC_OnUnitKilled", _side]]; //--- Called on destruction
	_vehicle addEventHandler ["hit", {_this spawn CTI_CO_FNC_OnUnitHit}]; //--- Register importants hits
	//--- Track who get in or out of the vehicle so that we may determine the death more easily
	_vehicle addEventHandler ["getIn", {_this spawn CTI_CO_FNC_OnUnitGetOut}];
	_vehicle addEventHandler ["getOut", {_this spawn CTI_CO_FNC_OnUnitGetOut}];
	_vehicle setVariable ["cti_occupant", _side call CTI_CO_FNC_GetSideFromID,true];
};


//disable net for offroads (JIP issue with BIS bug) + static load
if (_net &&missionNamespace getVariable "CTI_EW_ANET" == 1 && !(_side == CTI_RESISTANCE_ID)) then {
	["SERVER","Server_Run_Net",[_vehicle,_side]] call CTI_CO_FNC_NetSend;
};

if (_vehicle isKindOf "CargoNet_01_base_F") then {
	clearBackpackCargoGlobal _vehicle;
	clearMagazineCargoGlobal  _vehicle;
	clearWeaponCargoGlobal _vehicle;
	clearItemCargoGlobal  _vehicle;
};



//--- Disabling default abilities for special trucks/pods.
if (getAmmoCargo _vehicle > 0) then {_vehicle setAmmoCargo 0};
if (getFuelCargo _vehicle > 0) then {_vehicle setFuelCargo 0};
if (getRepairCargo _vehicle > 0) then {_vehicle setRepairCargo 0};

//AdminZeus
if !( isNil "ADMIN_ZEUS") then {
	if !(CTI_isServer) then {
		["SERVER", "Server_Addeditable",[ADMIN_ZEUS,_vehicle]] call CTI_CO_FNC_NetSend;
	} else {
		ADMIN_ZEUS addCuratorEditableObjects [[_vehicle],true] ;
	};
};

//artillery radar revamp
if (missionNamespace getVariable "CTI_SM_RADAR" == 1) then {

	["SERVER", "Server_ARTR_handle",_vehicle] call CTI_CO_FNC_NetSend;
	["SERVER", "Server_AIRR_handle",_vehicle] call CTI_CO_FNC_NetSend;
};



//trophy system
if (missionNamespace getVariable "CTI_TROPHY_APS" == 1) then {
	_vehicle addEventHandler["Fired","_this call TR_HANDLER;"];
};


// weigth fix
if ((_vehicle isKindOf "Pod_Heli_Transport_04_base_F") || (_vehicle isKindOf "Slingload_01_Base_F")  ) then { _vehicle setmass [2000,0];};

//cache

if ((!((_vehicle isKindOf "Plane") || (_vehicle isKindOf "UAV") ||(_vehicle isKindOf "Pod_Heli_Transport_04_base_F") || (_vehicle isKindOf "Slingload_01_Base_F")))  && (missionNamespace getVariable "CACHE_EMPTY") == 1)then {
 ["SERVER", "Request_Cache", _vehicle] call CTI_CO_FNC_NetSend;
};

//wheel protection
if (_vehicle isKindOf "Car" && ! isnil "H_PROTECT_WHEELS") then {
	_vehicle setVariable ["wheel_prot",true,true];
	["CLIENT", "Protect_Wheels", _vehicle,true] call CTI_CO_FNC_NetSend;
	["SERVER", "Protect_Wheels", _vehicle,true] call CTI_CO_FNC_NetSend;

};

//tutorial protection
_vehicle spawn {
	while { !isNull _this && alive _this && ! cti_gameover } do {
		    sleep 20;
		    if ((([_this,getMarkerPos "CTI_TUTORIAL"] call  BIS_fnc_distance2D) < 100) && !isNull _this && alive _this) then {_this setDamage 1};
		};
};

//_vehicle addEventHandler ["getIn", {if ((isplayer (_this select 2)) && ({isplayer _x} count (crew (_this select 0)))<2) exitwith {(_this select 2) assignAsCommander (_this select 0)}}];

//Code by 1911(23.07.2016)
[_vehicle] spawn {
	sleep 3;
	if (damage (_this select 0) > 0 && damage (_this select 0) < 1) then {(_this select 0) setDamage 0;};
};

if (CTI_IRSMOKE == 1) then {
	if (_vehicle isKindOf "Tank" || _vehicle isKindOf "Wheeled_APC_F" || _vehicle isKindOf "MRAP_03_base_F" || _vehicle isKindOf "MRAP_03_gmg_base_F" || _vehicle isKindOf "MRAP_03_hmg_base_F" || _vehicle isKindOf "MRAP_02_base_F" || _vehicle isKindOf "MRAP_02_gmg_base_F" || _vehicle isKindOf "MRAP_02_hmg_base_F") then {
		_vehicle addEventHandler ["incomingMissile", {_this Spawn CTI_CO_FNC_HandleIncomingMissile;_this spawn CTI_CO_FNC_HandleIncomingMissileIRS;}];
	} else {
		if ((missionNamespace getVariable "CTI_GAMEPLAY_MISSILES_RANGE") != 0) then { //--- Max missile range.
			_vehicle addEventHandler ['incomingMissile', {_this Spawn CTI_CO_FNC_HandleIncomingMissile}]; //--- Handle incoming missiles.
		};
	};
} else {
	if ((missionNamespace getVariable "CTI_GAMEPLAY_MISSILES_RANGE") != 0) then { //--- Max missile range.
		_vehicle addEventHandler ['incomingMissile', {_this Spawn CTI_CO_FNC_HandleIncomingMissile}]; //--- Handle incoming missiles.
	};
};

/*
if (_vehicle isKindOf "Tank" || 
    _vehicle isKindOf "Wheeled_APC_F" || 
    _vehicle isKindOf "MRAP_03_base_F" || 
    _vehicle isKindOf "MRAP_03_gmg_base_F" || 
    _vehicle isKindOf "MRAP_03_hmg_base_F" || 
    _vehicle isKindOf "MRAP_02_base_F" || 
    _vehicle isKindOf "MRAP_02_gmg_base_F" || 
    _vehicle isKindOf "MRAP_02_hmg_base_F") then {
    
	if (_sideText == "WEST" || _sideText == "EAST") then {
		_upgrades = (_sideFromID) call CTI_CO_FNC_GetSideUpgrades;
		_upgrade_level = _upgrades select CTI_UPGRADE_IRS;

		if (_vehicle isKindOf "MRAP_02_base_F" || _vehicle isKindOf "MRAP_02_gmg_base_F" || _vehicle isKindOf "MRAP_02_hmg_base_F") then {
			if (_upgrade_level == 1) then {_vehicle addMagazineTurret ["SmokeLauncherMag",[-1],2]};
			if (_upgrade_level == 2) then {_vehicle addMagazineTurret ["SmokeLauncherMag",[-1],2]};
		} else {
			if (_upgrade_level == 1) then {_vehicle addMagazineTurret ["SmokeLauncherMag",[0,0],2]};
			if (_upgrade_level == 2) then {_vehicle addMagazineTurret ["SmokeLauncherMag",[0,0],2]};
		};
	};
};
*/

if (_vehicle isKindOf "Tank" || 
    _vehicle isKindOf "Wheeled_APC_F" || 
    _vehicle isKindOf "MRAP_03_base_F" || 
    _vehicle isKindOf "MRAP_03_gmg_base_F" || 
    _vehicle isKindOf "MRAP_03_hmg_base_F" || 
    _vehicle isKindOf "MRAP_02_base_F" || 
    _vehicle isKindOf "MRAP_02_gmg_base_F" || 
    _vehicle isKindOf "MRAP_02_hmg_base_F") then {
		if (_vehicle isKindOf "MRAP_02_base_F" || _vehicle isKindOf "MRAP_02_gmg_base_F" || _vehicle isKindOf "MRAP_02_hmg_base_F") then {
		   _vehicle addMagazineTurret ["SmokeLauncherMag",[-1],2];
        } else {
           _vehicle addMagazineTurret ["SmokeLauncherMag",[0,0],2]; 
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
    _vehicle removeMagazineTurret ["120Rnd_CMFlare_Chaff_Magazine",[-1]];
    _vehicle removeMagazineTurret ["240Rnd_CMFlare_Chaff_Magazine",[-1]];
	if (_upgrade_level == 1) then {
		_vehicle addMagazineTurret ["120Rnd_CMFlare_Chaff_Magazine",[-1]];
	};
    if (_upgrade_level == 2) then {
		_vehicle addMagazineTurret ["240Rnd_CMFlare_Chaff_Magazine",[-1]];
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

		_vehicle setPylonLoadOut ["pylons3", "PylonMissile_Missile_AGM_KH25_x1", false, [-1]];
		_vehicle setPylonLoadOut ["pylons4", "PylonMissile_Missile_AGM_KH25_x1", false, [-1]];
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
    if (_vehicle isKindOf "I_Plane_Fighter_04_F" && _side != CTI_RESISTANCE_ID) then {
//		for "_i" from 1 to 6 do {_vehicle setAmmoOnPylon [_i, 0]; };
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


////////////////////////////////////////////////////////////////////////////////////////////////

// code by [H]Tom JMW Thx Tom :)
	if (_vehicle isKindOf "Car") then {
		_offroads = ["I_G_Offroad_01_F", "I_G_Offroad_01_armed_F", "I_G_Offroad_01_AT_F", "B_G_Offroad_01_F", "B_G_Offroad_01_armed_F", "B_G_Offroad_01_AT_F", "O_G_Offroad_01_F", "O_G_Offroad_01_armed_F", "O_G_Offroad_01_AT_F"];
		if ((typeOf _vehicle) in _offroads) then {
		_offroadcolors = ["Guerilla_01", "Guerilla_02", "Guerilla_03", "Guerilla_04", "Guerilla_05", "Guerilla_06", "Guerilla_07", "Guerilla_08", "Guerilla_09", "Guerilla_10", "Guerilla_11", "Guerilla_12"];
		[_vehicle, [(selectRandom _offroadcolors),1], nil] call BIS_fnc_initVehicle;
		};
		_4wds = ["I_C_Offroad_02_unarmed_F", "I_C_Offroad_02_LMG_F", "I_C_Offroad_02_AT_F", "C_Offroad_02_unarmed_F"];
		if ((typeOf _vehicle) in _4wds) then {
		_4wdcolors = ["Green", "Olive", "Black", "Brown"];
		[_vehicle, [(selectRandom _4wdcolors),1], nil] call BIS_fnc_initVehicle;
		};
	};

if (_vehicle isKindOf "Heli_Attack_02_base_F" || _vehicle isKindOf "VTOL_02_base_F") then {
    	_sideFromID = (_side) call CTI_CO_FNC_GetSideFromID;
	_upgrades = (_sideFromID) call CTI_CO_FNC_GetSideUpgrades;
	_upgrade_level = _upgrades select CTI_UPGRADE_AIR_AA;
	if (_upgrade_level == 1) then {
		_vehicle addMagazineTurret ["2Rnd_Missile_AA_03_F",[0]];
		_vehicle addMagazineTurret ["2Rnd_Missile_AA_03_F",[0]];
	};
	_vehicle addWeaponTurret ["Missile_AA_03_Plane_CAS_02_F",[0]];
};




if (typeOf _vehicle == "B_UAV_05_F") then {
        _vehicle addMagazineTurret ["PylonRack_Bomb_GBU12_x2",[0]];  	       
};

 
if (typeOf _vehicle == "C_Plane_Civil_01_F" || typeOf _vehicle == "I_C_Plane_Civil_01_F") then {
        _vehicle addMagazineTurret ["200Rnd_65x39_Belt_Tracer_Yellow",[-1]]; 
        _vehicle addWeaponTurret ["LMG_Minigun2",[-1]];
};

if (typeOf _vehicle == "Land_Device_slingloadable_F") then {(_vehicle) spawn CTI_CO_FNC_NukeDeviceInit};

if (_vehicle isKindOf "B_supplyCrate_F") then {
	clearBackpackCargoGlobal _vehicle;
	clearItemCargoGlobal _vehicle;
	clearMagazineCargoGlobal _vehicle;
	clearWeaponCargoGlobal _vehicle;
};

_vehicle