/* Исправленный GUI_ArtilleryMenu.sqf - добавлены проверки параметров */
params [["_ctrl", controlNull], ["_index", -1]];

// Если скрипт вызван из onLoad (без параметров), ничего не делаем или выполняем инициализацию
if (isNull _ctrl) exitWith {}; 

_selected = _ctrl lbData _index;
if (_selected == "") exitWith {};

_get = missionNamespace getVariable [format ["CTI_ARTILLERY_%1", _selected], []];
if (count _get < 4) exitWith {};

// Получаем массив всех диапазонов
_allRanges = _get select 4;

// Получаем индекс выбранного снаряда
_magIndex = lbCurSel 290009;
if (_magIndex < 0) then { _magIndex = 0; }; // Защита
_currentRange = _allRanges select _magIndex;

// Безопасное обновление UI
_display = uiNamespace getVariable ["cti_dialog_ui_artillerymenu", displayNull];
if (!isNull _display) then {
    _ctrlRangeText = _display displayCtrl 1002;
    if (!isNull _ctrlRangeText) then {
        _ctrlRangeText ctrlSetText format ["Range: %1 - %2 m", _currentRange select 0, _currentRange select 1];
    };
    // Сохраняем актуальный диапазон для стрельбы
    uiNamespace setVariable ["cti_dialog_ui_artillerymenu_artillery_range", _currentRange];
    
    // Обновляем дополнительную информацию
    private _data = uiNamespace getVariable ["cti_dialog_ui_artillerymenu_artillery_data", []];
    private _magData = [];
    if (count _data > _magIndex) then {
        _magData = _data select _magIndex;
    };
    private _magInfo = [_selected, _magData] call CTI_CO_FNC_GetMagazineInfo;
    uiNamespace setVariable ["cti_dialog_ui_artillerymenu_artillery_info", _magInfo];
    [_display, _magInfo] call CTI_UI_Artillery_UpdateInfoDisplay;
};

true