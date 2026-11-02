/*
    Обработчик для отображения боекомплекта на карте
    Отслеживает движение мыши и показывает информацию только при открытой карте (M)
    НЕ перезаписывает чужие hint в игре
*/

//--- Глобальная переменная для хранения ID события
CTI_MapAmmoInfo_EventID = -1;

//--- Функция запуска отслеживания
CTI_StartMapAmmoTracking = {
    //--- Если уже запущено, не запускаем повторно
    if (CTI_MapAmmoInfo_EventID >= 0) exitWith {};

    //--- Добавляем обработчик на главном дисплее (46)
    CTI_MapAmmoInfo_EventID = (findDisplay 46) displayAddEventHandler ["MouseMoving", {
        //--- Проверяем, открыта ли полноэкранная карта (display 12)
        //--- findDisplay 12 возвращает null если карта закрыта
        if (!isNull (findDisplay 12)) then {
            //--- Вызываем функцию отображения боекомплекта
            [] call CTI_CL_FNC_ShowAmmoInfo;
        };
        //--- Если карта закрыта - ничего не делаем, не перезаписываем hint
    }];
};

//--- Функция остановки отслеживания
CTI_StopMapAmmoTracking = {
    if (CTI_MapAmmoInfo_EventID >= 0) then {
        (findDisplay 46) displayRemoveEventHandler ["MouseMoving", CTI_MapAmmoInfo_EventID];
        CTI_MapAmmoInfo_EventID = -1;
        //--- НЕ очищаем hint - это может удалить чужие hint миссии
    };
};