
/*
	Original File: fn_keyHandler.sqf
	Author: Bryan "Tonic" Boardwine

	File: Client_KeyHandlerUp.sqf
	Author: 1911

	Description:
	Main key handler for event 'keyUp'
*/

private ["_alt","_code","_ctrl","_ctrlKey","_dir","_return","_shift"];

_ctrl = _this select 0;
_code = _this select 1;
_shift = _this select 2;
_ctrlKey = _this select 3;
_alt = _this select 4;

_return = false;

if ( _code in ([(profilenamespace getvariable ['CTI_TABLET_KEY',41])] + (actionKeys "User5")) ) then {_code = 41};

switch (_code) do {

	//--- Interaction (~) Key
	case 41: {
		disableSerialization;

		if ( isNull (findDisplay 60490) && !isNil {uiNamespace getVariable 'cti_dialog_ui_interractions'} && isNil {uiNamespace getVariable 'cti_dialog_ui_tabletmain'} && isNil {uiNamespace getVariable 'cti_dialog_ui_buildmenu'} && isNil {uiNamespace getVariable 'cti_dialog_ui_videosettingsmenu'} && isNil {uiNamespace getVariable 'cti_dialog_ui_transferresourcesmenu'} && isNil {uiNamespace getVariable 'cti_dialog_ui_servicemenu'} && isNil {uiNamespace getVariable 'cti_dialog_ui_purchasemenu'} && isNil {uiNamespace getVariable 'cti_dialog_ui_upgrademenu'} && isNil {uiNamespace getVariable 'cti_dialog_ui_workersmenu'} && isNil {uiNamespace getVariable 'cti_dialog_ui_defensemenu'} && isNil {uiNamespace getVariable 'cti_dialog_ui_requestmenu'} && isNil {uiNamespace getVariable 'cti_dialog_ui_onlinehelpmenu'} && isNil {uiNamespace getVariable 'cti_dialog_ui_gear'} && isNil {uiNamespace getVariable 'cti_dialog_ui_respawnmenu'} && isNil {uiNamespace getVariable 'cti_dialog_ui_satcam'} && isNil {uiNamespace getVariable 'cti_dialog_ui_unitscam'} && isNil {uiNamespace getVariable 'cti_dialog_ui_teamsmenu'} && isNil {uiNamespace getVariable 'cti_dialog_ui_mapcommandmenu'} && isNil {uiNamespace getVariable 'cti_dialog_ui_hookmenu'} && isNil {uiNamespace getVariable 'cti_dialog_ui_aimicromenu'} && isNil {uiNamespace getVariable 'cti_dialog_ui_artillerymenu'} && isNil {uiNamespace getVariable 'cti_dialog_ui_aircraftloadoutmenu'} ) then {
			closeDialog 0;
		};

	};

};

_return
