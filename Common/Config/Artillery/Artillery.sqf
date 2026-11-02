//--- Classname
_c = [];
//--- Magazines
_m = [];
//--- Burst
_b = [];
//--- Ranges
_r = [];
//--- Дополнительные данные о снарядах: [время_полета, разброс, время_перезарядки]
_d = [];

// ========== МИНОМЕТЫ ==========
_c = _c + ["B_Mortar_01_F"];
_m = _m + [["8Rnd_82mm_Mo_shells", "8Rnd_82mm_Mo_Smoke_white", "8Rnd_82mm_Mo_Flare_white", "8Rnd_82mm_Mo_LG"]];
_b = _b + [[1, 2, 4, 8, 16, 24, 32]];
_r = _r + [[[30,2500], [30,3000], [30,3500], [30,4000]]];
_d = _d + [[
    [12, 15, 8],
    [12, 15, 8],
    [12, 15, 8],
    [10, 12, 10]
]];

_c = _c + ["O_Mortar_01_F"];
_m = _m + [["8Rnd_82mm_Mo_shells", "8Rnd_82mm_Mo_Smoke_white", "8Rnd_82mm_Mo_Flare_white", "8Rnd_82mm_Mo_LG"]];
_b = _b + [[1, 2, 4, 8, 16, 24, 32]];
_r = _r + [[[30,2500], [30,3000], [30,3500], [30,4000]]];
_d = _d + [[
    [12, 15, 8],
    [12, 15, 8],
    [12, 15, 8],
    [10, 12, 10]
]];

// ========== САМОХОДНАЯ АРТИЛЛЕРИЯ ==========
_c = _c + ["B_MBT_01_arty_F"];
_m = _m + [["32Rnd_155mm_Mo_shells", "2Rnd_155mm_Mo_Cluster", "2Rnd_155mm_Mo_guided", "2Rnd_155mm_Mo_LG", "6Rnd_155mm_Mo_smoke", "6Rnd_155mm_Mo_mine", "6Rnd_155mm_Mo_AT_mine"]];
_b = _b + [[1, 2, 4, 6, 8, 16, 32]];
_r = _r + [[[800,20000], [800,20000], [800,20000], [800,20000], [800,20000], [800,20000], [800,20000]]];
_d = _d + [[
    [30, 25, 10],
    [35, 40, 15],
    [25, 15, 12],
    [28, 20, 10],
    [30, 25, 10],
    [32, 30, 12],
    [32, 30, 12]
]];

_c = _c + ["O_MBT_02_arty_F"];
_m = _m + [["32Rnd_155mm_Mo_shells_O", "2Rnd_155mm_Mo_Cluster_O", "2Rnd_155mm_Mo_guided_O", "2Rnd_155mm_Mo_LG", "6Rnd_155mm_Mo_smoke_O", "6Rnd_155mm_Mo_mine_O", "6Rnd_155mm_Mo_AT_mine_O"]];
_b = _b + [[1, 2, 4, 6, 8, 16, 32]];
_r = _r + [[[800,20000], [800,20000], [800,20000], [800,20000], [800,20000], [800,20000], [800,20000]]];
_d = _d + [[
    [30, 25, 10],
    [35, 40, 15],
    [25, 15, 12],
    [28, 20, 10],
    [30, 25, 10],
    [32, 30, 12],
    [32, 30, 12]
]];

// ========== РСЗО ==========
_c = _c + ["B_MBT_01_mlrs_F"];
_m = _m + [["12Rnd_230mm_rockets"]];
_b = _b + [[2, 3, 6, 12]];
_r = _r + [[[800,20000], [800,20000], [800,20000], [800,20000]]];
_d = _d + [[[20, 35, 15]]];

_c = _c + ["I_Truck_02_MRL_F"];
_m = _m + [["12Rnd_230mm_rockets"]];
_b = _b + [[2, 3, 6, 12]];
_r = _r + [[[800,20000], [800,20000], [800,20000], [800,20000]]];
_d = _d + [[[20, 35, 15]]];

// ========== ВЫЗОВ С КОМПИЛЯЦИЕЙ ==========
// ВАЖНО: проверяем, что все массивы одинаковой длины
if ((count _c) != (count _m) || (count _c) != (count _b) || (count _c) != (count _r) || (count _c) != (count _d)) then {
    diag_log format ["[ARTILLERY ERROR] Arrays length mismatch! C:%1 M:%2 B:%3 R:%4 D:%5", count _c, count _m, count _b, count _r, count _d];
} else {
    diag_log format ["[ARTILLERY] Loading %1 artillery types with data", count _c];
    [_c, _m, _b, _r, _d] call compile preprocessFileLineNumbers "Common\Config\Artillery\Set_Artillery.sqf";
};