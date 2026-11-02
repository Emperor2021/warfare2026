/*
  # HEADER #
	Description:	Add Town Structures
	Authors: 	Liveandletdie, 1911
*/

Private ["_bridge", "_bridgeAddition", "_bridgeAdditions", "_bridgeSection", "_bridgeSections", "_marker_b", "_object", "_pos"];



/*Vikos Outpost*/
_pos = [12854.365234,9790.572266,0.0631251];
_object = createVehicle ["Land_i_Barracks_V2_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 325;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [12880.53125,9810.557617,0.086236];
_object = createVehicle ["Land_Cargo_Tower_V1_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 326;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [12877.564453,9827.969727,0.209559];
_object = createVehicle ["Land_Mil_WiredFence_Gate_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 58.9998;
_object setPosATL _pos;
_object enableSimulationGlobal false;



if (CTI_MAP_BRIDGE == 1) then {

/*Ramp Vikos*/
_pos = [12884.527344,9831.919922,-5.46277];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;
[_object, 0, -2] call BIS_fnc_setPitchBank;

_pos = [12919.0839844,9851.542969,-3.06228];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;
[_object, 0, -2] call BIS_fnc_setPitchBank;

/*Start Bridge Vikos*/
_pos = [12953.0966797,9870.874023,7.80951];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [12987.558594,9890.446289,18.0167];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [13022.272461,9910.163086,32.2417];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [13057.0419922,9929.911133,44.937];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [13091.810547,9949.661133,58.7617];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [13126.592773,9969.421875,70.4785];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [13161.368164,9989.186523,78.1631];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [13196.146484,10008.941406,84.5412];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [13230.915039,10028.696289,94.3858];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [13265.693359,10048.453125,102.584];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [13300.470703,10068.209961,108.778];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [13335.239258,10087.959961,113.171];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [13370.0166016,10107.71582,112.79];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [13404.795898,10127.472656,110.814];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [13439.575195,10147.232422,114.581];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [13474.350586,10166.995117,115.127];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

/*Bridge Section Start*/
//_pos = [13509.126953,10186.750977,117.447];
//_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
//_object setDir 330.4;
//_object setPosATL _pos;
_object enableSimulationGlobal false;
_pos = [13493.644531,10177.865234,120.97];
_object = createVehicle ["BlockConcrete_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 60.2999;
_object setPosATL _pos;
_object enableSimulationGlobal false;
_pos = [13497.91211,10180.30371,121.335];
_object = createVehicle ["BlockConcrete_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 60.2999;
_object setPosATL _pos;
_object enableSimulationGlobal false;
_pos = [13502.17969,10182.74219,121.454];
_object = createVehicle ["BlockConcrete_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 60.2999;
_object setPosATL _pos;
_object enableSimulationGlobal false;
_pos = [13506.44727,10185.18066,121.514];
_object = createVehicle ["BlockConcrete_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 60.2999;
_object setPosATL _pos;
_object enableSimulationGlobal false;
_pos = [13510.71485,10187.61914,121.414];
_object = createVehicle ["BlockConcrete_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 60.2999;
_object setPosATL _pos;
_object enableSimulationGlobal false;
_pos = [13514.98242,10190.05761,121.674];
_object = createVehicle ["BlockConcrete_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 60.2999;
_object setPosATL _pos;
_object enableSimulationGlobal false;
_pos = [13519.25,10192.49609,121.664];
_object = createVehicle ["BlockConcrete_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 60.2999;
_object setPosATL _pos;
_object enableSimulationGlobal false;
_pos = [13523.51758,10194.93457,121.724];
_object = createVehicle ["BlockConcrete_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 60.2999;
_object setPosATL _pos;
_object enableSimulationGlobal false;
_pos = [13527.78516,10197.37304,121.984];
_object = createVehicle ["BlockConcrete_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 60.2999;
_object setPosATL _pos;
_object enableSimulationGlobal false;
/*Bridge Section End*/

_pos = [13543.900391,10206.506836,119.971];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [13578.673828,10226.262695,121.808];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [13613.447266,10246.0185547,124.228];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [13648.220703,10265.774414,123.819];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [13682.994141,10285.530273,124.475];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [13717.767578,10305.286133,126.8];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [13752.541016,10325.0419922,127.425];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [13787.314453,10344.797852,130.807];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [13822.0878906,10364.553711,128.622];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [13856.861328,10384.30957,128.99];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [13891.634766,10404.0654297,130.952];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [13926.408203,10423.821289,132.55];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [13961.181641,10443.577148,131.547];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [13995.955078,10463.333008,127.773];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [14030.728516,10483.0888672,122.674];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

/*Bridge Section Start*/
//_pos = [14065.501953,10502.844727,122.385];
//_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
//_object setDir 330.4;
//_object setPosATL _pos;
_object enableSimulationGlobal false;
_pos = [14050.0996094,10494.174805,5.54823];
_object = createVehicle ["BlockConcrete_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 60.2999;
_object setPosASL _pos;
_object enableSimulationGlobal false;
_pos = [14054.367188,10496.613281,5.54823];
_object = createVehicle ["BlockConcrete_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 60.2999;
_object setPosASL _pos;
_object enableSimulationGlobal false;
_pos = [14058.63477,10499.05176,5.54823];
_object = createVehicle ["BlockConcrete_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 60.2999;
_object setPosASL _pos;
_object enableSimulationGlobal false;
_pos = [14062.90235,10501.49023,5.54823];
_object = createVehicle ["BlockConcrete_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 60.2999;
_object setPosASL _pos;
_object enableSimulationGlobal false;
_pos = [14067.16992,10503.92871,5.54823];
_object = createVehicle ["BlockConcrete_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 60.2999;
_object setPosASL _pos;
_object enableSimulationGlobal false;
_pos = [14071.4375,10506.36719,5.54823];
_object = createVehicle ["BlockConcrete_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 60.2999;
_object setPosASL _pos;
_object enableSimulationGlobal false;
_pos = [14075.70508,10508.80566,5.54823];
_object = createVehicle ["BlockConcrete_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 60.2999;
_object setPosASL _pos;
_object enableSimulationGlobal false;
_pos = [14079.97266,10511.24414,5.54823];
_object = createVehicle ["BlockConcrete_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 60.2999;
_object setPosASL _pos;
_object enableSimulationGlobal false;
_pos = [14084.24024,10513.68261,5.54823];
_object = createVehicle ["BlockConcrete_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 60.2999;
_object setPosASL _pos;
_object enableSimulationGlobal false;
/*Bridge Section End*/

_pos = [14100.275391,10522.600586,119.52];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [14135.0488281,10542.356445,100.117];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [14169.822266,10562.112305,90.749];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [14204.595703,10581.868164,85.046];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [14239.369141,10601.624023,79.394];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [14274.142578,10621.379883,73.303];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [14308.916016,10641.135742,67.033];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [14343.689453,10660.891602,63.894];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [14378.462891,10680.647461,59.068];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [14413.236328,10700.40332,45.654];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [14448.00976563,10720.15918,41.427];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [14482.783203,10739.915039,30.491];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [14517.556641,10759.670898,23.806];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [14552.330078,10779.426758,16.755];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [14587.103516,10799.182617,8.33002];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [14621.876953,10818.938477,5.038];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [14656.650391,10838.694336,4.327];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;

/*Ramp Faronaki*/
_pos = [14689.830078,10857.553711,-4.58748];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 330.4;
_object setPosATL _pos;
_object enableSimulationGlobal false;
[_object, 0, 4] call BIS_fnc_setPitchBank;

_pos = [14709.195313,10868.397461,0.12802];
_object = createVehicle ["Land_GH_Platform_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 331;
_object setPosATL _pos;
_object enableSimulationGlobal false;
[_object, -0.1, 17.0794] call BIS_fnc_setPitchBank;

};



/*Outpost Faronaki*/
/*
_pos = [14708.521484,10867.962891,0.793589];
_object = createVehicle ["Land_Mil_WiredFence_Gate_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 241;
_object setPosATL _pos;
_object enableSimulationGlobal false;
*/

_pos = [14728.318359,10858.640625,0.0723901];
_object = createVehicle ["Land_Cargo_Tower_V1_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 172;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [14755.374023,10861.150391,-0.112361];
_object = createVehicle ["Land_i_Barracks_V2_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 352;
_object setPosATL _pos;
_object enableSimulationGlobal false;



/****CASTLE****/

_pos = [17620.611328,17296.880859,-0.480667];
_object = createVehicle ["Land_Castle_01_wall_03_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 310;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [17655.625,17274.517578,-1.29478];
_object = createVehicle ["Land_Castle_01_wall_04_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 50;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [17644.546875,17239.220703,-2.55485];
_object = createVehicle ["Land_Castle_01_wall_14_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 0;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [17638.0878906,17199.699219,-1.90575];
_object = createVehicle ["Land_Castle_01_wall_08_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 180;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [17586.460938,17192.046875,-1.45049];
_object = createVehicle ["Land_Castle_01_wall_03_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 129;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [17557.738281,17209.917969,-4.16091];
_object = createVehicle ["Land_Castle_01_wall_14_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 123;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [17537.449219,17211.537109,-4.8199];
_object = createVehicle ["Land_Castle_01_wall_03_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 209;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [17551.363281,17264.0839844,-2.03796];
_object = createVehicle ["Land_Castle_01_wall_14_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 205;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [17560.816406,17286.337891,-2.08663];
_object = createVehicle ["Land_Castle_01_wall_13_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 140;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [17572.523438,17280.873047,-5.75603];
_object = createVehicle ["Land_Castle_01_wall_03_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 270;
_object setPosATL _pos;
_object enableSimulationGlobal false;

/*inner*/

_pos = [17638.603516,17224.839844,-0.427528];
_object = createVehicle ["Land_Castle_01_church_a_ruin_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 181;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [17622,17222.509766,-0.0937119];
_object = createVehicle ["Land_Castle_01_tower_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 89.9999;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [17629.623047,17204.976563,-2.1951];
_object = createVehicle ["Land_Castle_01_house_ruin_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 79.9998;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [17600.648438,17220.294922,-0.164139];
_object = createVehicle ["Land_Castle_01_tower_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 220;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [17592.232422,17206.0566406,-0.185066];
_object = createVehicle ["Land_Castle_01_church_a_ruin_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 310;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [17544.246094,17228.740234,0.0982666];
_object = createVehicle ["Land_Castle_01_tower_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 210;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [17580.0390625,17261.886719,-0.192162];
_object = createVehicle ["Land_Castle_01_tower_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 210;
_object setPosATL _pos;
_object enableSimulationGlobal false;

_pos = [17635.664063,17286.296875,0.0465775];
_object = createVehicle ["Land_Castle_01_tower_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 309;
_object setPosATL _pos;
_object enableSimulationGlobal false;

/*ramp*/

_pos = [17621.193359,17287.373047,1.01382];
_object = createVehicle ["Land_Castle_01_step_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 39.9999;
_object setPosATL _pos;
_object enableSimulationGlobal false;
[_object, 30, 2.95756e-006] call BIS_fnc_setPitchBank;

_pos = [17585.275391,17201.0839844,0.25631];
_object = createVehicle ["Land_Castle_01_step_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 40;
_object setPosATL _pos;
_object enableSimulationGlobal false;
[_object, -10, -1.30042e-006] call BIS_fnc_setPitchBank;





//--- 1911 Code

if (CTI_MAP_BRIDGE > 0) then {
	_marker_b = CreateMarker ["marker_bridge_viskas_faranahi", [13794.1,10348.3]];
	_marker_b setMarkerShape "RECTANGLE";
	_marker_b setMarkerBrush "SolidFull";
	_marker_b setMarkerDir 330.4;
	_marker_b setMarkerSize [1050,3];
	_marker_b setMarkerColor "ColorWhite";
	_marker_b setMarkerAlpha 1;
};



BuildBridge = {
	{
		_object = createVehicle [_x select 0, _x select 1, [], 0, "CAN_COLLIDE"];
		_object setDir (_x select 2);
		_object setPosASL (_x select 1);
		if ((count _x) > 3) then {[_object, _x select 3, _x select 4] call BIS_fnc_setPitchBank};
		_object enableSimulationGlobal false;
	} forEach _this;
};



BuildBridgeAdditions = {
	_pos = [13801.917,10353.1467,2];
	_object = createVehicle ["Land_AirstripPlatform_01_F", _pos, [], 0, "CAN_COLLIDE"];
	_object setDir 330.4;
	_object setPosASL _pos;
	_object enableSimulationGlobal false;

	_bridgeSections = _pos nearObjects ["Land_AirstripPlatform_01_F", 1040];
	{
		_bridgeSection = _x;
		{
			_bridgeAddition = createVehicle [_x select 0, getPos _bridgeSection, [], 0, "CAN_COLLIDE"];
			_bridgeAddition attachTo [_bridgeSection,_x select 1];
			detach _bridgeAddition;
			_bridgeAddition setDir (getDir _bridgeSection + (_x select 2));
			_bridgeAddition enableSimulationGlobal false;
		} forEach _this;
	} forEach _bridgeSections;

	deleteVehicle _object;
};



_bridge = [
	["Land_AirstripPlatform_01_F",[12893.5,9836.94,0.72],330.4,0,-8],
	["Land_AirstripPlatform_01_F",[12909.415,9845.9824,2],330.4],
	["Land_AirstripPlatform_01_F",[12926.912,9855.9248,2],330.4],
	["Land_AirstripPlatform_01_F",[12944.417,9865.8711,2],330.4],
	["Land_AirstripPlatform_01_F",[12961.917,9875.8155,2],330.4],
	["Land_AirstripPlatform_01_F",[12979.417,9885.7599,2],330.4],
	["Land_AirstripPlatform_01_F",[12996.917,9895.7043,2],330.4],
	["Land_AirstripPlatform_01_F",[13014.417,9905.6487,2],330.4],
	["Land_AirstripPlatform_01_F",[13031.917,9915.5931,2],330.4],
	["Land_AirstripPlatform_01_F",[13049.417,9925.5375,2],330.4],
	["Land_AirstripPlatform_01_F",[13066.917,9935.4819,2],330.4],
	["Land_AirstripPlatform_01_F",[13084.417,9945.4263,2],330.4],
	["Land_AirstripPlatform_01_F",[13101.917,9955.3707,2],330.4],
	["Land_AirstripPlatform_01_F",[13119.417,9965.3151,2],330.4],
	["Land_AirstripPlatform_01_F",[13136.917,9975.2595,2],330.4],
	["Land_AirstripPlatform_01_F",[13154.417,9985.2039,2],330.4],
	["Land_AirstripPlatform_01_F",[13171.917,9995.1483,2],330.4],
	["Land_AirstripPlatform_01_F",[13189.417,10005.0927,2],330.4],
	["Land_AirstripPlatform_01_F",[13206.917,10015.0371,2],330.4],
	["Land_AirstripPlatform_01_F",[13224.417,10024.9815,2],330.4],
	["Land_AirstripPlatform_01_F",[13241.917,10034.9259,2],330.4],
	["Land_AirstripPlatform_01_F",[13259.417,10044.8703,2],330.4],
	["Land_AirstripPlatform_01_F",[13276.917,10054.8147,2],330.4],
	["Land_AirstripPlatform_01_F",[13294.417,10064.7591,2],330.4],
	["Land_AirstripPlatform_01_F",[13311.917,10074.7035,2],330.4],
	["Land_AirstripPlatform_01_F",[13329.417,10084.6479,2],330.4],
	["Land_AirstripPlatform_01_F",[13346.917,10094.5923,2],330.4],
	["Land_AirstripPlatform_01_F",[13364.417,10104.5367,2],330.4],
	["Land_AirstripPlatform_01_F",[13381.917,10114.4811,2],330.4],
	["Land_AirstripPlatform_01_F",[13399.417,10124.4255,2],330.4],
	["Land_AirstripPlatform_01_F",[13416.917,10134.3699,2],330.4],
	["Land_AirstripPlatform_01_F",[13434.417,10144.3143,2],330.4],
	["Land_AirstripPlatform_01_F",[13451.917,10154.2587,2],330.4],
	["Land_AirstripPlatform_01_F",[13469.417,10164.2031,2],330.4],
	["Land_AirstripPlatform_01_F",[13486.917,10174.1475,2],330.4],
	["Land_AirstripPlatform_01_F",[13504.417,10184.0919,2],330.4],
	["Land_AirstripPlatform_01_F",[13521.917,10194.0363,2],330.4],
	["Land_AirstripPlatform_01_F",[13539.417,10203.9807,2],330.4],
	["Land_AirstripPlatform_01_F",[13556.917,10213.9251,2],330.4],
	["Land_AirstripPlatform_01_F",[13574.417,10223.8695,2],330.4],
	["Land_AirstripPlatform_01_F",[13591.917,10233.8139,2],330.4],
	["Land_AirstripPlatform_01_F",[13609.417,10243.7583,2],330.4],
	["Land_AirstripPlatform_01_F",[13626.917,10253.7027,2],330.4],
	["Land_AirstripPlatform_01_F",[13644.417,10263.6471,2],330.4],
	["Land_AirstripPlatform_01_F",[13661.917,10273.5915,2],330.4],
	["Land_AirstripPlatform_01_F",[13679.417,10283.5359,2],330.4],
	["Land_AirstripPlatform_01_F",[13696.917,10293.4803,2],330.4],
	["Land_AirstripPlatform_01_F",[13714.417,10303.4247,2],330.4],
	["Land_AirstripPlatform_01_F",[13731.917,10313.3691,2],330.4],
	["Land_AirstripPlatform_01_F",[13749.417,10323.3135,2],330.4],
	["Land_AirstripPlatform_01_F",[13766.917,10333.2579,2],330.4],
	["Land_AirstripPlatform_01_F",[13784.417,10343.2023,2],330.4],


	["Land_Sidewalk_01_8m_F",[13798.634,10346.6767,7],150.4],
	["Land_Sidewalk_01_8m_F",[13803.904,10349.6767,7.01],150.4],
	["Land_Sidewalk_01_8m_F",[13809.174,10352.6767,7],150.4],

	["Land_Sidewalk_01_8m_F",[13796.647,10350.1467,7],150.4],
	["Land_Sidewalk_01_8m_F",[13801.917,10353.1467,7.01],150.4],
	["Land_Sidewalk_01_8m_F",[13807.187,10356.1467,7],150.4],

	["Land_Sidewalk_01_8m_F",[13794.66,10353.6167,7],150.4],
	["Land_Sidewalk_01_8m_F",[13799.93,10356.6167,7.01],150.4],
	["Land_Sidewalk_01_8m_F",[13805.20,10359.6167,7],150.4],


	["Land_Sidewalk_01_8m_F",[13798.634,10346.6777,6.7],150.4,0,180],
	["Land_Sidewalk_01_8m_F",[13803.904,10349.6777,6.69],150.4,0,180],
	["Land_Sidewalk_01_8m_F",[13809.174,10352.6777,6.7],150.4,0,180],

	["Land_Sidewalk_01_8m_F",[13796.647,10350.1467,6.7],150.4,0,180],
	["Land_Sidewalk_01_8m_F",[13801.917,10353.1467,6.69],150.4,0,180],
	["Land_Sidewalk_01_8m_F",[13807.187,10356.1467,6.7],150.4,0,180],

	["Land_Sidewalk_01_8m_F",[13794.66,10353.6157,6.7],150.4,0,180],
	["Land_Sidewalk_01_8m_F",[13799.93,10356.6157,6.69],150.4,0,180],
	["Land_Sidewalk_01_8m_F",[13805.20,10359.6157,6.7],150.4,0,180],


	["Land_AirstripPlatform_01_F",[13819.417,10363.0911,2],330.4],
	["Land_AirstripPlatform_01_F",[13836.917,10373.0355,2],330.4],
	["Land_AirstripPlatform_01_F",[13854.417,10382.9799,2],330.4],
	["Land_AirstripPlatform_01_F",[13871.917,10392.9243,2],330.4],
	["Land_AirstripPlatform_01_F",[13889.417,10402.8687,2],330.4],
	["Land_AirstripPlatform_01_F",[13906.917,10412.8131,2],330.4],
	["Land_AirstripPlatform_01_F",[13924.417,10422.7575,2],330.4],
	["Land_AirstripPlatform_01_F",[13941.917,10432.7019,2],330.4],
	["Land_AirstripPlatform_01_F",[13959.417,10442.6463,2],330.4],
	["Land_AirstripPlatform_01_F",[13976.917,10452.5907,2],330.4],
	["Land_AirstripPlatform_01_F",[13994.417,10462.5351,2],330.4],
	["Land_AirstripPlatform_01_F",[14011.917,10472.4795,2],330.4],
	["Land_AirstripPlatform_01_F",[14029.417,10482.4239,2],330.4],
	["Land_AirstripPlatform_01_F",[14046.917,10492.3683,2],330.4],
	["Land_AirstripPlatform_01_F",[14064.417,10502.3127,2],330.4],
	["Land_AirstripPlatform_01_F",[14081.917,10512.2571,2],330.4],
	["Land_AirstripPlatform_01_F",[14099.417,10522.2015,2],330.4],
	["Land_AirstripPlatform_01_F",[14116.917,10532.1459,2],330.4],
	["Land_AirstripPlatform_01_F",[14134.417,10542.0903,2],330.4],
	["Land_AirstripPlatform_01_F",[14151.917,10552.0347,2],330.4],
	["Land_AirstripPlatform_01_F",[14169.417,10561.9791,2],330.4],
	["Land_AirstripPlatform_01_F",[14186.917,10571.9235,2],330.4],
	["Land_AirstripPlatform_01_F",[14204.417,10581.8679,2],330.4],
	["Land_AirstripPlatform_01_F",[14221.917,10591.8123,2],330.4],
	["Land_AirstripPlatform_01_F",[14239.417,10601.7567,2],330.4],
	["Land_AirstripPlatform_01_F",[14256.917,10611.7011,2],330.4],
	["Land_AirstripPlatform_01_F",[14274.417,10621.6455,2],330.4],
	["Land_AirstripPlatform_01_F",[14291.917,10631.5899,2],330.4],
	["Land_AirstripPlatform_01_F",[14309.417,10641.5343,2],330.4],
	["Land_AirstripPlatform_01_F",[14326.917,10651.4787,2],330.4],
	["Land_AirstripPlatform_01_F",[14344.417,10661.4231,2],330.4],
	["Land_AirstripPlatform_01_F",[14361.917,10671.3675,2],330.4],
	["Land_AirstripPlatform_01_F",[14379.417,10681.3119,2],330.4],
	["Land_AirstripPlatform_01_F",[14396.917,10691.2563,2],330.4],
	["Land_AirstripPlatform_01_F",[14414.417,10701.2007,2],330.4],
	["Land_AirstripPlatform_01_F",[14431.917,10711.1451,2],330.4],
	["Land_AirstripPlatform_01_F",[14449.417,10721.0895,2],330.4],
	["Land_AirstripPlatform_01_F",[14466.917,10731.0339,2],330.4],
	["Land_AirstripPlatform_01_F",[14484.417,10740.9783,2],330.4],
	["Land_AirstripPlatform_01_F",[14501.917,10750.9227,2],330.4],
	["Land_AirstripPlatform_01_F",[14519.417,10760.8671,2],330.4],
	["Land_AirstripPlatform_01_F",[14536.917,10770.8115,2],330.4],
	["Land_AirstripPlatform_01_F",[14554.417,10780.7559,2],330.4],
	["Land_AirstripPlatform_01_F",[14571.917,10790.7003,2],330.4],
	["Land_AirstripPlatform_01_F",[14589.417,10800.6447,2],330.4],
	["Land_AirstripPlatform_01_F",[14606.917,10810.5891,2],330.4],
	["Land_AirstripPlatform_01_F",[14624.417,10820.5335,2],330.4],
	["Land_AirstripPlatform_01_F",[14641.917,10830.4779,2],330.4],
	["Land_AirstripPlatform_01_F",[14659.417,10840.4223,2],330.4],
	["Land_AirstripPlatform_01_F",[14676.917,10850.3667,2],330.4],
	["Land_AirstripPlatform_01_F",[14694.417,10860.3111,2],330.4],
	["Land_AirstripPlatform_01_F",[14709.95,10869.14,0.45],330.4,0,10]
];



_bridgeAdditions = [
	["Land_CrashBarrier_01_8m_F",[-6.1,-5.75,12.85],180],
	["Land_CrashBarrier_01_8m_F",[0,-5.75,12.85],180],
	["Land_CrashBarrier_01_8m_F",[6.1,-5.75,12.85],180],
	["Land_CrashBarrier_01_8m_F",[-6.1,5.75,12.85],0],
	["Land_CrashBarrier_01_8m_F",[0,5.75,12.85],0],
	["Land_CrashBarrier_01_8m_F",[6.1,5.75,12.85],0],
	["Land_LampHarbour_F",[0,-5.55,15.4],0],
	["Land_LampHarbour_F",[0,5.55,15.4],180]
];



if (CTI_MAP_BRIDGE == 2) then {
	(_bridge) call BuildBridge;
	(_bridgeAdditions) call BuildBridgeAdditions;
};
