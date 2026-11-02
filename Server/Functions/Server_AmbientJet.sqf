/*
Server_AmbientJet.sqf
Modified: Индивидуальные вылеты для каждого игрока (2-4 раза).
Оптимизировано для стабильного движения ИИ.
*/

if (!isServer) exitWith {};

/* STREAMING_CHUNK:Настройка глобальных параметров */
waitUntil {!isNil "CTI_Init_Server" && {CTI_Init_Server}};

AA_Altitude = 50; //Высота полета
AA_Speed = 400; // Скорость (в м/с).
AA_SpawnDistance = 4000; // появление начальное 
AA_DeleteDistance = 4000; // исчезает 
AA_Count = 2;  // Количество самолетов
AA_Spacing = 40; //дистанция между самолетами. Ширина строя (расстояние между крыльями в метрах).

AA_TimeBetweenFlybys = [60, 120]; // Интервал между вылетами (в секундах).

AA_WestTypes = ["B_Plane_Fighter_01_F", "B_Plane_CAS_01_dynamicLoadout_F"];
AA_EastTypes = ["O_Plane_Fighter_02_F", "O_Plane_CAS_02_dynamicLoadout_F"];

/* STREAMING_CHUNK:Основной цикл обработки игроков */
while {isNil "CTi_GameOver" || {!CTi_GameOver}} do {

{
    private _player = _x;
    if (isPlayer _player && {alive _player}) then {
        
        // Инициализация переменных для игрока
        if (isNil {_player getVariable "AA_DoneFlybys"}) then {
            _player setVariable ["AA_DoneFlybys", 0];
            _player setVariable ["AA_TargetFlybys", floor (random [2, 3, 4])]; //сколько раз случайно бдут вылетать самолеты 
            _player setVariable ["AA_NextFlybyTime", diag_tickTime + 30];  // время ативации самолетов сек 
        };

        private _done = _player getVariable "AA_DoneFlybys";
        private _target = _player getVariable "AA_TargetFlybys";
        private _next = _player getVariable "AA_NextFlybyTime";

        if (_done < _target && {diag_tickTime > _next}) then {
            
            private _center = getPosASL _player;
            private _dir = random 360;
            private _side = side group _player;
            private _classes = if (_side == west) then {AA_WestTypes} else {AA_EastTypes};
            private _jets = [];

            // Спавним группу
            for "_i" from 0 to (AA_Count - 1) do {
                private _ofs = (_i - ((AA_Count - 1) / 2)) * AA_Spacing;
                private _spawn = _center getPos [AA_SpawnDistance, _dir];
                private _end = _center getPos [AA_DeleteDistance, _dir + 180];

                _spawn = [(_spawn#0) + (_ofs * cos (_dir + 90)), (_spawn#1) + (_ofs * sin (_dir + 90)), AA_Altitude];
                _end = [(_end#0) + (_ofs * cos (_dir + 90)), (_end#1) + (_ofs * sin (_dir + 90)), AA_Altitude];

                private _jet = createVehicle [selectRandom _classes, _spawn, [], 0, "FLY"];
                createVehicleCrew _jet;
                _jets pushBack _jet;
                
                _jet allowDamage false;
                _jet flyInHeight AA_Altitude;
                _jet setDir (_dir + 180);
                _jet setVelocityModelSpace [0, AA_Speed, 0];

                // Настройка ИИ: отключаем боевые функции, оставляем движение
                {
                    _x disableAI "TARGET";
                    _x disableAI "AUTOTARGET";
                    _x disableAI "FSM";
                    _x setBehaviour "CARELESS";
                } forEach crew _jet;

                if (alive _jet) then {
                    (driver _jet) doMove _end;
                };
            };

            // Синхронизация столкновений
            {
                private _j1 = _x;
                {
                    _j1 disableCollisionWith _x;
                } forEach _jets;
            } forEach _jets;

            // Удаление после пролета
            [_jets, _center] spawn {
                params ["_jets", "_center"];
                waitUntil {
                    sleep 5;
                    // Удаляем, если все самолеты уничтожены или улетели слишком далеко
                    private _allGone = true;
                    {
                        if (alive _x && (_x distance2D _center < 4500)) then { _allGone = false; };
                    } forEach _jets;
                    _allGone
                };
                {
                    if (!isNull _x) then {
                        {deleteVehicle _x} forEach crew _x;
                        deleteVehicle _x;
                    };
                } forEach _jets;
            };

            _player setVariable ["AA_DoneFlybys", _done + 1];
            _player setVariable ["AA_NextFlybyTime", diag_tickTime + (AA_TimeBetweenFlybys # 0) + random ((AA_TimeBetweenFlybys # 1) - (AA_TimeBetweenFlybys # 0))];
            
            diag_log format ["[AmbientJet] Игрок %1 получил вылет %2 из %3", name _player, _done + 1, _target];
        };
    };
} forEach allPlayers;

sleep 10;


};