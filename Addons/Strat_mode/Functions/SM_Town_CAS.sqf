SM_TCAS_MAINLOOP = compile '
	private ["_town","_type","_fly","_pos","_ppos","_dir","_veh","_wp","_wp2"];
	_town = _this select 0;
	_type = _this select 1;
	_group = createGroup resistance;
	_pos = [_town,1500,2000] call CTI_CO_FNC_GetRandomPosition;
	_pos set [2,1000];
	_dir = [_pos, _town] call CTI_CO_FNC_GetDirTo;
	_veh = [_type, _pos, _dir, resistance, false, true, true, "FLY"] call CTI_CO_FNC_CreateVehicle;

	if (_veh isKindOf "I_UAV_02_F") then {
		_veh addMagazineTurret ["2Rnd_Missile_AA_03_F",[0]];
		_veh addWeaponTurret ["Missile_AA_03_Plane_CAS_02_F",[0]];
	};
    
    	if (_veh isKindOf "I_Heli_light_03_dynamicLoadout_F") then {    	            
	       	_veh setPylonLoadOut [1, "PylonRack_12Rnd_PG_missiles", false, []];
    		_veh setPylonLoadOut [2, "PylonRack_12Rnd_missiles", false, []];                        
            _veh setAmmoOnPylon [1, 12];
            _veh setAmmoOnPylon [2, 12];              
    	};
    
        if (_veh isKindOf "I_Plane_Fighter_03_CAS_F") then {
        _veh removeMagazineTurret ["240Rnd_CMFlare_Chaff_Magazine",[-1]];
		_veh addMagazineTurret ["120Rnd_CMFlare_Chaff_Magazine",[-1]];
	};
    
	createVehicleCrew _veh;
	(crew _veh) join _group;
	_group selectLeader (driver _veh);
	{_x setSkill 1} forEach (crew _veh);
	if !( isNil "ADMIN_ZEUS") then { ADMIN_ZEUS addCuratorEditableObjects [([_veh]),true];};
	if !( isNil "ADMIN_ZEUS") then { ADMIN_ZEUS addCuratorEditableObjects [(units _group),true];};
	 if (_veh isKindOf "I_Heli_light_03_dynamicLoadout_F") then {
	   _veh flyInHeight 150;
       } else {
      if (_veh isKindOf "I_UAV_02_F") then { _veh flyInHeight 500; } else { _veh flyInHeight 1800; };                        
       };    
	_pos = getPos _town;
	_pos set [2,500];
	_wp = _group addWaypoint [_pos, 100];
	_wp setWaypointType "MOVE";
	_wp setWaypointBehaviour "CARELESS";
	_wp setWaypointCombatMode "GREEN";
	_wp setWaypointTimeout [0,0,0];
	_wp setWaypointCompletionRadius 1000;
	_wp setWaypointSpeed "FULL";
	_wp2 = _group addWaypoint [_pos, 100];
	_wp2 setWaypointType "SAD";
	_wp2 setWaypointBehaviour "COMBAT";
	_wp2 setWaypointCombatMode "RED";
	_group setCurrentWaypoint _wp;
	diag_log format ["Town CAS ::  %1 Calling CAS %2", _town,_type];
	[_group,_veh]';



SM_TCAS_CREATE = compile '
	private ["_town","_rnd","_cas"];
	_town = _this;
	_rnd = random (1);
    _rnd2 = random (1);
	_cas = "";
	if (_rnd > 0.95) then {
	   if (_rnd2 > 0.5) then {
		_cas = [_town, "I_Plane_Fighter_04_F"] call SM_TCAS_MAINLOOP;
        } else {
        _cas = [_town, "I_Plane_Fighter_04_Cluster_F"] call SM_TCAS_MAINLOOP;    
        }    
	} else {
	  if (_rnd > 0.70) then {   
		_cas = [_town, "I_Plane_Fighter_03_CAS_F"] call SM_TCAS_MAINLOOP;
      } else {  
         if (_rnd > 0.40) then {   
		_cas = [_town, "I_Heli_light_03_dynamicLoadout_F"] call SM_TCAS_MAINLOOP;
        } else {
        _cas = [_town, "I_UAV_02_F"] call SM_TCAS_MAINLOOP;            
       };        
      };
	};
	diag_log _cas;
	_cas';


SM_TCAS_CLEANUP = compile '
	private ["_cas"];
	_cas = _this;
	if (count _cas > 0) then {
		if (! isNull (_cas select 0)) then {
			{deleteVehicle vehicle (_x); deleteVehicle _x;} count units (_cas select 0);
			deleteGroup (_cas select 0);
		};
	};';
