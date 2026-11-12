private ["_side_id","_side","_sl","_hud_targets","_return","_lines","_cache","_ug","_object","_texture","_color","_pos","_size","_text","_p_icon","_unc","_s_icon","_special","_man_in_network","_man_side_id","_man_conn","_man_up_r","_man_side","_man_up","_man_max_dist"];
waitUntil {! isNil {player getVariable "CTI_Net"}};
_side_id = player getVariable ["CTI_Net",-10];
_side = _side_id call CTI_CO_FNC_GetSideFromID;
_sl = CTI_P_SideJoined call CTI_CO_FNC_GetSideLogic;
_hud_targets = _sl getVariable ["CTI_HUD_SHARED",[]];

_return = [];
_lines = [];
_group = [];
_cache = SHOWTOMAP;

waitUntil {! isNil {player getVariable "AN_iNet" }};
_ug = units player;

// ================== ГРУППА ИГРОКА (иконки + надписи) ==================
_count_ug = count _ug;

// === ЕСЛИ ИГРОК НЕ В СЕТИ — скрывать всех кроме себя ===
_player_connected = (player getVariable ["AN_iNet", -1]) == _side_id;

for "_i" from 0 to (_count_ug - 1) do {
    _object = _ug select _i;
    
    if (vehicle _object != _object) then { continue; };
    
    // === Если игрок не в сети — показывать только игрока ===
    if (!_player_connected && {isPlayer _object}) then {
        // Игрок всегда виден
    } else {
        if (!_player_connected) then { continue; };
    };
    
    // === ДЛЯ ПЕХОТЫ: проверяем радиус сети (как у техники) ===
    if (_object isKindOf "Man") then {
        _man_in_network = true;
        _man_side_id = _object getVariable ["CTI_Net", -11];
        _man_conn = _object getVariable ["AN_Conn", objNull];
        if (!isNil "_man_conn" && !isNull _man_conn) then {
            _man_up_r = 0;
            _man_side = if (_man_side_id < 0) then {side _object} else {(_man_side_id) call CTI_CO_FNC_GetSideFromID};
            if (_man_side in [east,west]) then {
                _man_up = (_man_side) call CTI_CO_FNC_GetSideUpgrades;
                _man_up_r = _man_up select CTI_UPGRADE_NETR;
            };
            _man_max_dist = 100 + 200 * _man_up_r;
            if (_object distance _man_conn > _man_max_dist) then {
                _man_in_network = false;
            };
        } else {
            // Нет AN_Conn — объект не в сети
            _man_in_network = false;
        };
        if (!_man_in_network) then { continue; };
    };
    
    _size = [18, 18];
    if (vehicle _object != vehicle player || vehicle player == player) then {
        _texture = format ["a3\ui_f\data\map\Markers\NATO\%1inf", CTI_P_MarkerPrefix];
        _color = [1,0.65,0,1];
        if (! alive _object) then {_color = [0,0,0,1];};
        _pos = getPosASL _object;
        _pos = _pos vectorAdd [(_i - (_count_ug - 1)/2) * 0.5, -0.8, 0];

        _text = _object call CTI_CL_FNC_GetAIDigit;
        if (isPlayer _object) then {
            if (group _object == (CTI_P_SideJoined) call CTI_CO_FNC_GetSideCommander) then {
                _text = format ["[%1]%2", localize "STR_Com", name _object];
            } else {
                _text = format ["[%1]%2", groupID (group _object), name _object];
            };
        };
        _return set [count _return, [_object, _texture, _color, _pos, _size select 0, _size select 1, 0, _text, 0, 0.05, 'PuristaMedium', 'right']];
        _group set [count _group, [_object, _texture, _color, _pos, _size select 0, _size select 1, 0, _text, 0, 0.05, 'PuristaMedium', 'right']];
    };
    if (!isnull (lasertarget _object)) then {_return set [count _return,[lasertarget _object,"\a3\ui_f\data\IGUI\RscIngameUI\RscOptics\laser_designator_iconlaseron", [1,0,0,1],  getPos (lasertarget _object),_size select 0,_size select 1, 0, "", 0, 0.05,'PuristaMedium', 'right']];};
    if (!isnull (laserTarget getConnectedUAV _object)) then {_return set [count _return,[lasertarget getConnectedUAV _object,"\a3\ui_f\data\IGUI\RscIngameUI\RscOptics\laser_designator_iconlaseron", [1,0,0,1],  getPos (lasertarget getConnectedUAV _object),_size select 0,_size select 1, 0, "", 0, 0.05,'PuristaMedium', 'right']];};
};

if !( (player) getVariable "AN_iNet" == _side_id && (player getVariable ["CTI_Net",-10]) >= 0) exitWith {
    // === Игрок не в сети — скрываем ВСЕ иконки кроме игрока ===
    private _only_player = [];
    {
        if (isPlayer _x && vehicle _x == _x) then {
            private _pos = getPosASL _x;
            _only_player set [count _only_player, [_x, "a3\ui_f\data\map\Markers\NATO\b_inf", [1,0.65,0,1], _pos, 18, 18, 0, format ["[%1]%2", localize "STR_Com", name _x], 0, 0.05, 'PuristaMedium', 'right']];
        };
    } forEach units player;
    [_only_player, [], []];
};

// ================== ОСТАЛЬНЫЕ ГРУППЫ (иконки для всех союзников, надписи только для своей группы) ==================
{
    _pgroup = _x;
    _units = units _pgroup;
    _count_units = count _units;
    for "_j" from 0 to (_count_units - 1) do {
        _object = _units select _j;
        
        if (vehicle _object != _object) then { continue; };
        
        _side_id = -1;
        if (!isNil {_object getVariable "CTI_Net"}) then {_side_id=_object getVariable "CTI_Net";};
        if (!isNil {_object getVariable "AN_iNet"}) then {_side_id=_object getVariable "AN_iNet";};
        _side= (_side_id)  call CTI_CO_FNC_GetSideFromID;
        
        _isFriendly = (_side_id == (player getVariable ["CTI_Net",-10]));
        
        // === НАДПИСИ ТОЛЬКО ДЛЯ СВОЕЙ ГРУППЫ ===
        _showText = (_isFriendly && (_pgroup == group player));
        
        _p_icon= switch (_side) do {
            case west:{ "b_" };
            case east:{ "o_" };
            case resistance:{ "n_" };
            default { "n_" };
        };
        _texture= format ["a3\ui_f\data\map\Markers\NATO\%1inf",_p_icon];
        _color = switch (_side) do {
            case west:{ [0,0,1,1] };
            case east:{ [1,0,0,1] };
            case resistance:{ [0,1,0,1] };
            default { [1,1,1,1] };
        };
        if (! alive _object) then {_color = [0,0,0,1];};
        if (_object getvariable ["REV_UNC",false]) then {_color = [0.5,0.32,0.09,1]};
        _pos = getPosASL _object;
        _pos = _pos vectorAdd [(_j - (_count_units - 1)/2) * 0.5, -0.8, 0];
        _size = [18, 18];
        
        // Текст только для своих юнитов
        _text = "";
        if (_showText && isplayer _object && _object isKindOf "Man") then {
            if (_pgroup == ((_side) call CTI_CO_FNC_GetSideCommander)) then {
                _text = format ["[%1]%2", localize "STR_Com", name _object];
            }else {
                _text = format ["[%1]%2", groupID (group _object), name _object];
            };
        };
        if (_showText && !isplayer _object) then {
            _text = _object call CTI_CL_FNC_GetAIDigit;
        };
        
        // === ИКОНКИ ДОБАВЛЯЕМ ДЛЯ ВСЕХ СОЮЗНИКОВ (БЕЗ УСЛОВИЯ _showText) ===
        // === НО ТОЛЬКО ЕСЛИ ОБЪЕКТ ПОДКЛЮЧЁН К СЕТИ И ИГРОК В СЕТИ ===
        // === ИГРОКИ ВСЕГДА ВИДНЫ (у них нет AN_iNet) ===
        private _isOtherPlayer = isPlayer _object && _object != player;
        if (_player_connected && _isFriendly && {!_isOtherPlayer || {(_object getVariable ["AN_iNet", -1]) > -1}}) then {
            _return set [count _return,[_object,_texture, _color, _pos,_size select 0,_size select 1, 0, _text, 0, 0.05,'PuristaMedium', 'right']];
        };
        
        if (!isnull (lasertarget _object)) then {_return set [count _return,[lasertarget _object,"\a3\ui_f\data\IGUI\RscIngameUI\RscOptics\laser_designator_iconlaseron", [0,0,1,1],  getPos (lasertarget _object),_size select 0,_size select 1, 0, "", 0, 0.05,'PuristaMedium', 'right']];};
        if (!isnull (laserTarget getConnectedUAV _object)) then {_return set [count _return,[lasertarget getConnectedUAV _object,"\a3\ui_f\data\IGUI\RscIngameUI\RscOptics\laser_designator_iconlaseron", [1,0,0,1],  getPos (lasertarget getConnectedUAV _object),_size select 0,_size select 1, 0, "", 0, 0.05,'PuristaMedium', 'right']];};
    };
} forEach ( (_side call CTI_CO_FNC_GetSideGroups) - [group player] );

// ================== ГОРОДА ==================
{
    _side_id=-1;
    if (!isNil {_x getVariable "AN_iNet"}) then {_side_id=_x getVariable "AN_iNet";};
    _side = (_side_id) call CTI_CO_FNC_GetSideFromID;
    _color = switch (_side) do {
        case west:{ [0,0,1,1] };
        case east:{ [1,0,0,1] };
        case resistance:{ [0,1,0,1] };
        default { [1,1,1,1] };
    };
    if ( ! isNull(_x getVariable "AN_Conn") && _side_id == (player getVariable ["CTI_NET",-11]) && !(_x isKindOf "Man")) then {
        _lines set [count _lines, [_x,visiblePosition _x, visiblePosition (_x getVariable "AN_Conn"), _color]];
    };
} count CTI_Towns;

// ================== ТЕХНИКА (иконки для всех союзников, надписи только для своей техники, без беспилотников) ==================
{
    _vehicle = _x;
    if (true) then {
        _side_id = _vehicle getVariable ["CTI_Net",-10];
        _side = if (_side_id < 0) then {side _vehicle} else {(_side_id) call CTI_CO_FNC_GetSideFromID};

        // Показываем иконки для союзной техники
        _isFriendlyVeh = (_side_id == (player getVariable ["CTI_Net",-10]));
        
        // Проверяем радиус сети для техники
        // Связность техники берём из AN_iNet — это состояние считает сервер.
        // Было: только дистанция до AN_Conn и БЕЗ ветки else.
        // Когда AN_Reconfigure очищал AN_Conn (техника вне сети), проверка
        // пропускалась и _in_network_range оставался true -> иконка висела вне сети.
        // Для расшаренных вражеских целей (HUD_T_OBJ / CTI_HUD_SHARED) поведение не меняем.
        _in_network_range = true;
        if (_isFriendlyVeh && {!(_vehicle isKindOf "Man")}) then {
            private _vehNet = _vehicle getVariable ["AN_iNet", -1];
            _in_network_range = (_vehNet > -1) && {_vehNet == _side_id};
        };
        
        if (_player_connected && ((_isFriendlyVeh || _vehicle in HUD_T_OBJ || _vehicle in (_sl getVariable "CTI_HUD_SHARED")) && _in_network_range)) then {

            _p_icon = switch (_side) do {
                case west:{ "b_" };
                case east:{ "o_" };
                case resistance:{ "n_" };
                default { "n_" };
            };
            _s_icon = 0 call {
                if (_x isKindOf "Man") exitWith { "inf" };
                if ((_x isKindOf "Car" || _x isKindOf "Motorcycle") && !(_x isKindOf "Wheeled_APC_F")) exitWith { "motor_inf" };
                if (_x isKindOf "Wheeled_APC_F")exitWith { "mech_inf" };
                if (_x isKindOf "Ship")exitWith { "naval" };
                if (_x isKindOf "Tank")exitWith { "armor" };
                if (_x isKindOf "Helicopter")exitWith { "air" };
                if (_x isKindOf "Plane")exitWith { "plane" };
                "inf"
            };
            _special = _vehicle getVariable "cti_spec";
            if (isNil '_special') then { _special = [] };
            if (CTI_SPECIAL_REPAIRTRUCK in _special) then {_s_icon = "maint"};
            if (CTI_SPECIAL_AMMOTRUCK in _special) then {_s_icon = "support"};
            if (CTI_SPECIAL_MEDICALVEHICLE in _special) then {_s_icon = "med"};
            _vehicleTexture = format ["a3\ui_f\data\map\Markers\NATO\%1%2", _p_icon, _s_icon];
            if (_vehicle isKindOf "ReammoBox_F" && !(_vehicle isKindOf "Slingload_base_F")) then {_vehicleTexture = "\A3\ui_f\data\map\vehicleicons\iconCrateAmmo_ca"};

            _color = switch (_side) do {
                case west:{ [0,0,1,1] };
                case east:{ [1,0,0,1] };
                case resistance:{ [0,1,0,1] };
                default { [1,1,1,1] };
            };
            if (! alive _vehicle) then {_color = [0,0,0,1];};
            _keys = _vehicle getVariable ["v_keys",["",grpNull]];
            _second_color = _color;
            if ((_vehicle == vehicle player || group player == _keys select 1 || getPlayerUID player == _keys select 0) && isNil {_vehicle getVariable "cti_start_vehicle"}) then {_second_color = [1,0.65,0,1];};
            
            _pos = getPosASL _vehicle;
            _size = [25, 25];
            
            // ==== Иконка техники (без текста) ====
            _return set [count _return, [_vehicle, _vehicleTexture, _second_color, _pos, _size select 0, _size select 1, 0, "", 0, 0.05, 'PuristaMedium', 'right']];
            
            // ==== ЦИФРЫ ЭКИПАЖА ТОЛЬКО ДЛЯ СВОЕЙ ТЕХНИКИ (БЕЗ БЕСПИЛОТНИКОВ) ====
            _crew = crew _vehicle;
            _count_crew = count _crew;
            
            // Проверяем, является ли техника своей (принадлежит group player)
            _isMyVehicle = false;
            {
                if (group _x == group player) exitWith { _isMyVehicle = true; };
            } forEach _crew;
            
            // Проверяем, является ли техника беспилотником
            _isUAV = (_vehicle isKindOf "UAV" || _vehicle isKindOf "UAV_01_base_F" || _vehicle isKindOf "UAV_02_base_F" || _vehicle isKindOf "UAV_03_base_F" || _vehicle isKindOf "UAV_04_base_F" || _vehicle isKindOf "UAV_05_base_F");
            
            if (_count_crew > 0 && _isMyVehicle && !_isUAV) then {
                _crewText = "";
                {
                    _num = _x call CTI_CL_FNC_GetAIDigit;
                    if (_num == "Leader") then { _num = "0"; };
                    if (_num == "Player") then { _num = "P"; };
                    
                    _role = assignedVehicleRole _x;
                    _roleStr = "";
                    if (count _role > 0) then {
                        _roleType = _role select 0;
                        
                        if (_x == commander _vehicle) then { 
                            _roleStr = localize "STR_CREW_COMMANDER_SHORT"; 
                        } else {
                            if (_roleType == "Driver") then { _roleStr = localize "STR_CREW_DRIVER_SHORT"; };
                            if (_roleType == "Commander") then { _roleStr = localize "STR_CREW_COMMANDER_SHORT"; };
                            if (_roleType == "Gunner") then { _roleStr = localize "STR_CREW_GUNNER_SHORT"; };
                            if (_roleType == "Turret") then { _roleStr = localize "STR_CREW_GUNNER_SHORT"; };
                            if (_roleType == "Cargo") then { _roleStr = localize "STR_CREW_CARGO_SHORT"; };
                        };
                    };
                    
                    _crewText = _crewText + format["%1[%2] ", _num, _roleStr];
                } forEach _crew;
                if (count _crewText > 0) then { _crewText = _crewText select [0, count _crewText - 1]; };
                
                _posText = _pos vectorAdd [0, -5.0, 0];
                
                // ТЕНЬ (черный текст, смещен вправо-вниз)
                _posShadow = _posText vectorAdd [2, -2, 0];
                _return set [count _return, [objNull, "#(argb,8,8,3)color(0,0,0,0)", [0,0,0,1], _posShadow, 0, 0, 0, _crewText, 0, 0.08, 'PuristaMedium', 'center']];
                
                // ОСНОВНОЙ ТЕКСТ (зеленый)
                _return set [count _return, [objNull, "#(argb,8,8,3)color(0,0,0,0)", [0,1,0,1], _posText, 0, 0, 0, _crewText, 0, 0.08, 'PuristaMedium', 'center']];
            };
            
            // ==== Линии связи ====
if (!isNil {_vehicle getVariable "AN_Conn"} && !isNull (_vehicle getVariable "AN_Conn") && !(_vehicle isKindOf "Man") && _side_id == (player getvariable ["AN_iNet",-1])) then {
    // Проверяем расстояние до объекта подключения
    _conn = _vehicle getVariable "AN_Conn";
    _up_r = 0;
    if (_side in [east,west]) then {
        _up = (_side) call CTI_CO_FNC_GetSideUpgrades;
        _up_r = _up select CTI_UPGRADE_NETR;
    };
    _max_dist = 1000 + 1000 * _up_r;
    if (_vehicle distance _conn <= _max_dist) then {
        _lines set [count _lines, [_vehicle,visiblePosition _vehicle, visiblePosition _conn,_color]];
    };
};
            if (!isnull (lasertarget _vehicle)) then {_return set [count _return,[lasertarget _vehicle,"\a3\ui_f\data\IGUI\RscIngameUI\RscOptics\laser_designator_iconlaseron", [1,0,0,1],  getPos (lasertarget _vehicle),_size select 0,_size select 1, 0, "", 0, 0.05,'PuristaMedium', 'right']];};
        };
    };
} count (vehicles);

[_group,_return,_lines]