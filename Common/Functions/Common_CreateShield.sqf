private ["_vehicle", "_shield","_side"];

_vehicle = _this select 0;
_shield = _this select 1;
_side =  _this select 2;
   
 _sideFromID = (_side) call CTI_CO_FNC_GetSideFromID;
 _sideText = str _sideFromID; 

// Komish
  if (typeOf _vehicle == "O_APC_Tracked_02_cannon_F") then {
	  if (_shield) then {	
		  [_vehicle,["Hex",1],["showTracks",1,"showCamonetHull",1,"showBags",1,"showSLATHull",1]] call BIS_fnc_initVehicle; 		
		} else { 
      [_vehicle,["Hex",1],["showTracks",0,"showCamonetHull",0,"showBags",0,"showSLATHull",0]] call BIS_fnc_initVehicle; 
		};
  };
	
	
// 2S9 Sochor
  if (typeOf _vehicle == "O_APC_Tracked_02_cannon_F") then {
	  if (_shield) then {	
		  [_vehicle,["Hex",1],["showAmmobox",1,"showCanisters",1,"showCamonetTurret",1,"showCamonetHull",1,"showLog",1]] call BIS_fnc_initVehicle; 
		} else {
      [_vehicle,["Hex",1],["showAmmobox",0,"showCanisters",0,"showCamonetTurret",0,"showCamonetHull",0,"showLog",0]] call BIS_fnc_initVehicle; 
		};
  };

// AWC 301 AT &&  AWC 301 AA && AWC 301 scout && AWC 301 cannon
  if (typeOf _vehicle == "I_LT_01_AA_F" || typeOf _vehicle == "I_LT_01_AT_F" || typeOf _vehicle == "I_LT_01_scout_F" || typeOf _vehicle == "I_LT_01_cannon_F") then {
	  if (_shield) then {	
		    if (_sideText == "EAST" ) then { 
		    [_vehicle,["Indep_03",1],["showTools",1,"showCamonetHull",1,"showBags",1,"showSLATHull",1]] call BIS_fnc_initVehicle;
			};

		    if (_sideText == "WEST" ) then { 
		    [_vehicle,["Indep_Olive",1],["showTools",1,"showCamonetHull",1,"showBags",1,"showSLATHull",1]] call BIS_fnc_initVehicle;
			};
		} else {
          	if (_sideText == "EAST" ) then { 
		    [_vehicle,["Indep_03",1],["showTools",0,"showCamonetHull",0,"showBags",0,"showSLATHull",0]] call BIS_fnc_initVehicle;
			};

		    if (_sideText == "WEST" ) then { 
		    [_vehicle,["Indep_Olive",1],["showTools",0,"showCamonetHull",0,"showBags",0,"showSLATHull",0]] call BIS_fnc_initVehicle;
			};
		};
  };

  // Mora
  if (typeOf _vehicle == "I_APC_tracked_03_cannon_F") then {
	  if (_shield) then {	
		    if (_sideText == "EAST" ) then { 
		    [_vehicle,["Indep_03",1],["showBags",0,"showBags2",1,"showCamonetHull",1,"showCamonetTurret",1,"showTools",1,"showSLATHull",1,"showSLATTurret",1]] call BIS_fnc_initVehicle;
			};

		    if (_sideText == "WEST" ) then { 
		    [_vehicle,["Indep_02",1],["showBags",0,"showBags2",1,"showCamonetHull",1,"showCamonetTurret",1,"showTools",1,"showSLATHull",1,"showSLATTurret",1]] call BIS_fnc_initVehicle;
			};
		} else {
          	if (_sideText == "EAST" ) then { 
		    [_vehicle,["Indep_03",1],["showBags",1,"showBags2",0,"showCamonetHull",0,"showCamonetTurret",0,"showTools",0,"showSLATHull",0,"showSLATTurret",0]] call BIS_fnc_initVehicle;
			};

		    if (_sideText == "WEST" ) then { 
		    [_vehicle,["Indep_02",1],["showBags",1,"showBags2",0,"showCamonetHull",0,"showCamonetTurret",0,"showTools",0,"showSLATHull",0,"showSLATTurret",0]] call BIS_fnc_initVehicle;
			};
		};
  };

  // Cheetah
  if (typeOf _vehicle == "B_APC_Tracked_01_AA_F") then {
	  if (_shield) then {	
      	[_vehicle,["Sand",1],["showCamonetTurret",1,"showCamonetHull",1,"showBags",1]] call BIS_fnc_initVehicle;
	  } else {
		[_vehicle,["Sand",1],["showCamonetTurret",0,"showCamonetHull",0,"showBags",0]] call BIS_fnc_initVehicle;
	  };
    };


  // Panther
  if (typeOf _vehicle == "B_APC_Tracked_01_rcws_F") then {
	  if (_shield) then {	
      	[_vehicle,["Sand",1],["showCamonetHull",1,"showBags",1]] call BIS_fnc_initVehicle;
	  } else {
		[_vehicle,["Sand",1],["showCamonetHull",0,"showBags",0]] call BIS_fnc_initVehicle;
	  };
    };	

  // Slammer
  if (typeOf _vehicle == "B_MBT_01_cannon_F" || typeOf _vehicle == "B_MBT_01_TUSK_F") then {
	  if (_shield) then {	
      	[_vehicle,["Sand",1],["showBags",1,"showCamonetTurret",1,"showCamonetHull",1]] call BIS_fnc_initVehicle;
	  } else {
		[_vehicle,["Sand",1],["showBags",0,"showCamonetTurret",0,"showCamonetHull",0]] call BIS_fnc_initVehicle;
	  };
    };	


  // M4 Scorcher
  if (typeOf _vehicle == "B_MBT_01_arty_F") then {
	  if (_shield) then {	
      	[_vehicle,["Sand",1],["showCanisters",1,"showCamonetTurret",1,"showAmmobox",1,"showCamonetHull",1]] call BIS_fnc_initVehicle;
	  } else {
		[_vehicle,["Sand",1],["showCanisters",0,"showCamonetTurret",0,"showAmmobox",0,"showCamonetHull",0]] call BIS_fnc_initVehicle;
	  };
    };	  

  // M5 MLRS
  if (typeOf _vehicle == "B_MBT_01_mlrs_F") then {
	  if (_shield) then {	
      	[_vehicle,["Sand",1],["showCamonetTurret",1,"showCamonetHull",1]] call BIS_fnc_initVehicle;
	  } else {
		    [_vehicle,["Sand",1],["showCamonetTurret",0,"showCamonetHull",0]] call BIS_fnc_initVehicle;
	  };
    };	

// Kuma
  if (typeOf _vehicle == "I_MBT_03_cannon_F") then {
	  if (_shield) then {	
		    if (_sideText == "EAST" ) then { 
		    [_vehicle,["Indep_03",1],["HideTurret",1,"HideHull",1,"showCamonetHull",1,"showCamonetTurret",1]] call BIS_fnc_initVehicle;
			};

		    if (_sideText == "WEST" ) then { 
		    [_vehicle,["Indep_02",1],["HideTurret",1,"HideHull",1,"showCamonetHull",1,"showCamonetTurret",1]] call BIS_fnc_initVehicle;
			};
		} else {
          	if (_sideText == "EAST" ) then { 
		    [_vehicle,["Indep_03",1],["HideTurret",0,"HideHull",0,"showCamonetHull",0,"showCamonetTurret",0]] call BIS_fnc_initVehicle;
			};

		    if (_sideText == "WEST" ) then { 
		    [_vehicle,["Indep_02",1],["HideTurret",0,"HideHull",0,"showCamonetHull",0,"showCamonetTurret",0]] call BIS_fnc_initVehicle;
			};
		};
  };


  // T100
  if (typeOf _vehicle == "O_MBT_02_cannon_F") then {
	  if (_shield) then {	
      	[_vehicle,["Hex",1],["showCamonetHull",1,"showCamonetTurret",1,"showLog",1]] call BIS_fnc_initVehicle;
	  } else {
		[_vehicle,["Hex",1],["showCamonetHull",0,"showCamonetTurret",0,"showLog",0]] call BIS_fnc_initVehicle;
	  };
    };	

// Angara
  if (typeOf _vehicle == "O_MBT_04_cannon_F" || typeOf _vehicle == "O_MBT_04_command_F") then {
	  if (_shield) then {	
      	[_vehicle,["Hex",1],["showCamonetHull",1,"showCamonetTurret",1]] call BIS_fnc_initVehicle;
	  } else {
		[_vehicle,["Hex",1],["showCamonetHull",0,"showCamonetTurret",0]] call BIS_fnc_initVehicle;
	  };
    };	


// Tigris
  if (typeOf _vehicle == "O_APC_Tracked_02_AA_F") then {
	  if (_shield) then {	
      	[_vehicle,["Hex",1],["showTracks",1,"showCamonetHull",1,"showCamonetTurret",1,"showSLATHull",1]] call BIS_fnc_initVehicle;
	  } else {
		    [_vehicle,["Hex",1],["showTracks",0,"showCamonetHull",0,"showCamonetTurret",0,"showSLATHull",0]] call BIS_fnc_initVehicle;
	  };
    };

// Gorgona
  if (typeOf _vehicle == "I_APC_Wheeled_03_cannon_F") then {
	  if (_shield) then {	
		    if (_sideText == "EAST" ) then { 
		    [_vehicle,["Guerilla_02",1],["showCamonetHull",1,"showBags",1,"showBags2",1,"showTools",1,"showSLATHull",1]] call BIS_fnc_initVehicle;         
			  };

		    if (_sideText == "WEST" ) then { 
		    [_vehicle,["Guerilla_03",1],["showCamonetHull",1,"showBags",1,"showBags2",1,"showTools",1,"showSLATHull",1]] call BIS_fnc_initVehicle;
			  };
		} else {
        if (_sideText == "EAST" ) then { 
		    [_vehicle,["Guerilla_02",1],["showCamonetHull",0,"showBags",0,"showBags2",0,"showTools",0,"showSLATHull",0]] call BIS_fnc_initVehicle;
			  };
		    if (_sideText == "WEST" ) then { 
		    [_vehicle,["Guerilla_03",1],["showCamonetHull",0,"showBags",0,"showBags2",0,"showTools",0,"showSLATHull",0]] call BIS_fnc_initVehicle;
			  };
		};
  };


// Marshal
  if (typeOf _vehicle == "B_APC_Wheeled_01_cannon_F") then {
	  if (_shield) then {	
      	[_vehicle,["Sand",1],["showBags",1,"showCamonetHull",1,"showCamonetTurret",1,"showSLATHull",1,"showSLATTurret",1]] call BIS_fnc_initVehicle;
	  } else {
		    [_vehicle,["Sand",1],["showBags",0,"showCamonetHull",0,"showCamonetTurret",0,"showSLATHull",0,"showSLATTurret",0]] call BIS_fnc_initVehicle;
	  };
    };


// Marid
  if (typeOf _vehicle == "O_APC_Wheeled_02_rcws_F" || typeOf _vehicle == "O_APC_Wheeled_02_rcws_v2_F") then {
	  if (_shield) then {	
      [_vehicle,["Hex",1],["showBags",1,"showCanisters",1,"showTools",1,"showCamonetHull",1,"showSLATHull",1]] call BIS_fnc_initVehicle;
	  } else {
		  [_vehicle,["Hex",1],["showBags",0,"showCanisters",0,"showTools",0,"showCamonetHull",0,"showSLATHull",0]] call BIS_fnc_initVehicle;
	  };
    };

// Rhino
  if (typeOf _vehicle == "B_AFV_Wheeled_01_cannon_F" || typeOf _vehicle == "B_AFV_Wheeled_01_up_cannon_F") then {
	  if (_shield) then {	
      	[_vehicle,["Sand",1],["showCamonetHull",1,"showCamonetTurret",1,"showSLATHull",1]] call BIS_fnc_initVehicle;
	  } else {
		[_vehicle,["Sand",1],["showCamonetHull",0,"showCamonetTurret",0,"showSLATHull",0]] call BIS_fnc_initVehicle;
	  };
    };


// Zamak MLR
  if (typeOf _vehicle == "I_Truck_02_MRL_F" ) then {
		[_vehicle,["Opfor",1],true] call BIS_fnc_initVehicle;
    };



   
_vehicle