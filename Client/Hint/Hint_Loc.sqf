/*
    Client/Hint/Hint_Loc.sqf
    Локализации для системы подсказок
    Поддержка русского и английского языков
    
    Параметры: [_id, _side]
    _id = идентификатор подсказки (строка из cti_structure_type: "Barracks", "Light", и т.д.)
    _side = сторона игрока (west/east)
    
    Возвращает: текст с HTML форматированием на языке игрока
*/

//--- Определям язык игрока
private ["_lang"];
_lang = "russian";  // По умолчанию русский

//--- Ручной переключатель: если задан CTI_Hint_Language — используем его
if (!isNil "CTI_Hint_Language") then {
    _lang = toLower CTI_Hint_Language;
} else {
    //--- Автоматическое определение языка
    private ["_dsgText"];
    _dsgText = localize "STR_DISENGAGE";
    if (_dsgText == "Disengage") then {
        _lang = "english";
    };
};

private ["_id", "_side"];
_id = _this select 0;
_side = _this select 1;

//--- Результат
private ["_result"];
_result = "";

//=== HQ ===
if (_id isEqualTo "HQ") then {
    private ["_footer"];
    if (_lang isEqualTo "russian") then {
        _footer = "<br/><br/><t size='0.9' color='#808080' align='left'>Отключить подсказки: кнопка ~ меню планшета - видео настройки - подсказки.</t>";
    } else {
        _footer = "<br/><br/><t size='0.9' color='#808080' align='left'>Disable hints: ~ menu tablet - video settings - hints.</t>";
    };
    
    if (_side isEqualTo west) then {
        if (_lang isEqualTo "russian") then {
            _result = "<t size='1.5' color='#0000FF' shadow='1' align='center'>КШМ</t><br/><t size='1.3' color='#0000FF' shadow='1' align='center'>(Командно-штабная машина)</t><br/><br/><t size='1.1' color='#D0D0D0' align='center'>Главный объект стороны. Без КШМ и заводов сторона терпит <t color='#FFFF00'>ПОРАЖЕНИЕ</t>.</t><br/><br/><t size='1.1' color='#D0D0D0' align='left'>Функции:<br/><t color='#4488FF'>• Строительство</t> — командир строит базы, заводы, оборону (удерживай кнопку ~ и выбери иконку «Построить завод/оборону»)<br/><t color='#4488FF'>• Спутник</t> — вид спутника при построенном Центре Управления<br/><t color='#4488FF'>• Связь</t> — поддерживает связь между боевыми единицами в определённом радиусе</t><br/><br/><t size='1.0' color='#FFFF88' align='left'>Меню управления: клавиша ~</t>" + _footer;
        } else {
            _result = "<t size='1.5' color='#0000FF' shadow='1' align='center'>HQ</t><br/><t size='1.3' color='#0000FF' shadow='1' align='center'>(Mobile Headquarters)</t><br/><br/><t size='1.1' color='#D0D0D0' align='center'>Main object of your side. No HQ + factories means <t color='#FFFF00'>DEFEAT</t>.</t><br/><br/><t size='1.1' color='#D0D0D0' align='left'>Functions:<br/><t color='#4488FF'>• Construction</t> — commander builds bases, factories, defenses (hold ~ key and select «Build factory/defense» icon)<br/><t color='#4488FF'>• Satellite</t> — satellite view when Control Center is built<br/><t color='#4488FF'>• Network</t> — maintains communication between units in a given radius</t><br/><br/><t size='1.0' color='#FFFF88' align='left'>Command menu: ~ key</t>" + _footer;
        };
    };
    if (_side isEqualTo east) then {
        if (_lang isEqualTo "russian") then {
            _result = "<t size='1.5' color='#FF0000' shadow='1' align='center'>КШМ</t><br/><t size='1.3' color='#FF0000' shadow='1' align='center'>(Командно-штабная машина)</t><br/><br/><t size='1.1' color='#D0D0D0' align='center'>Главный объект стороны. Без КШМ и заводов сторона терпит <t color='#FFFF00'>ПОРАЖЕНИЕ</t>.</t><br/><br/><t size='1.1' color='#D0D0D0' align='left'>Функции:<br/><t color='#FF4444'>• Строительство</t> — командир строит базы, заводы, оборону (удерживай кнопку ~ и выбери иконку «Построить завод/оборону»)<br/><t color='#FF4444'>• Спутник</t> — вид спутника при построенном Центре Управления<br/><t color='#FF4444'>• Связь</t> — поддерживает связь между боевыми единицами в определённом радиусе</t><br/><br/><t size='1.0' color='#FFFF88' align='left'>Меню управления: клавиша ~</t>" + _footer;
        } else {
            _result = "<t size='1.5' color='#FF0000' shadow='1' align='center'>HQ</t><br/><t size='1.3' color='#FF0000' shadow='1' align='center'>(Mobile Headquarters)</t><br/><br/><t size='1.1' color='#D0D0D0' align='center'>Main object of your side. No HQ + factories means <t color='#FFFF00'>DEFEAT</t>.</t><br/><br/><t size='1.1' color='#D0D0D0' align='left'>Functions:<br/><t color='#FF4444'>• Construction</t> — commander builds bases, factories, defenses (hold ~ key and select «Build factory/defense» icon)<br/><t color='#FF4444'>• Satellite</t> — satellite view when Control Center is built<br/><t color='#FF4444'>• Network</t> — maintains communication between units in a given radius</t><br/><br/><t size='1.0' color='#FFFF88' align='left'>Command menu: ~ key</t>" + _footer;
        };
    };
};

//=== Welcome ===
if (_id isEqualTo "Welcome") then {
    private ["_title", "_text", "_footer", "_hintText"];
    
    private _titleColor = if (_side isEqualTo west) then {"#0000FF"} else {"#FF0000"};
    private _titleText = "ТАКТИЧЕСКАЯ СИСТЕМА УПРАВЛЕНИЯ";
    private _titleTextEn = "TACTICAL COMMAND SYSTEM";
    
    if (_lang isEqualTo "russian") then {
        _title = format ["<t size='1.3' color='%1' shadow='2' align='center'>%2</t>", _titleColor, _titleText];
        _text = "<t size='0.75' color='#32CD32' shadow='1' align='center'>ЭЙ, САЛАГА, СЮДА СМОТРИ, БЛЯДЬ!</t><br/>" +
        "<t size='0.6' color='#D0D0D0'>Ты теперь </t><t size='0.65' color='#32CD32' shadow='1'>КОМАНДИР ОТДЕЛЕНИЯ</t><t size='0.6' color='#D0D0D0'>! Хватит в жопе ковыряться! У тебя 14 таких же уродов под началом — </t><t size='0.6' color='#32CD32' shadow='1'>ДЕЛАЙ ИЗ НИХ АРМИЮ!</t><br/>" +
        "<t size='0.65' color='#FFFF88' shadow='1'>ЗАДАЧА ПРОСТА: </t><t size='0.6' color='#D0D0D0'>Захватывай города! Каждый город — баллы, ресурсы, стволы. Нет городов — ты </t><t size='0.6' color='#32CD32' shadow='1'>НИКТО!</t><t size='0.6' color='#D0D0D0'> Двигай фронт, пока тебя не прибили!</t><br/>" +
        "<t size='0.65' color='#FFFF88' shadow='1'>КШМ — ЭТО ТВОЁ СЕРДЦЕ, ДЕБИЛ! </t><t size='0.6' color='#D0D0D0'>Без неё ты не армия, а толпа с автоматами. Потеряешь КШМ — </t><t size='0.6' color='#32CD32' shadow='1'>ВСЁ ПИЗДЕЦ!</t><t size='0.6' color='#D0D0D0'> Обложи её турелями и бойцами — чтоб </t><t size='0.6' color='#32CD32' shadow='1'>НИ ОДИН УРОД НЕ ПОДОШЁЛ!</t><br/>" +
        "<t size='0.65' color='#FFFF88' shadow='1'>ТВОИ БОЙЦЫ — САЛАГИ! </t><t size='0.6' color='#D0D0D0'>Чем больше они воюют — тем </t><t size='0.6' color='#32CD32' shadow='1'>ПРОФЕССИОНАЛЬНЕЕ СТАНОВЯТСЯ</t><t size='0.6' color='#D0D0D0'>. Тем больше ты сможешь </t><t size='0.6' color='#32CD32' shadow='1'>УВЕЛИЧИТЬ СВОЮ АРМИЮ!</t><br/>" +
        "<t size='0.65' color='#FFFF88' shadow='1'>НАЙДИ ВРАЖЕСКУЮ БАЗУ И РАЗЪЕБИ ЕЁ К ХУЯМ! </t><t size='0.6' color='#D0D0D0'>Пока их КШМ стоит, они будут лезть к тебе снова.</t><br/>" +
        "<t size='0.65' color='#FFFF88' shadow='1'>НЕТ КОМАНДУЮЩЕГО? БЕРИ КОМАНДОВАНИЕ В СВОИ РУКИ, БЛЯДЬ! </t><t size='0.6' color='#D0D0D0'>Выбора нет! Строй базу, захватывай города, </t><t size='0.6' color='#32CD32' shadow='1'>УНИЧТОЖЬ ВРАГА!</t><br/>" +
        "<t size='0.6' color='#FFFF88' shadow='1'>Как взять командование: подойди к КШМ, нажми ~, вверху экрана жми иконку «Взять командование».</t><br/>" +
        "<t size='0.7' color='#32CD32' shadow='1' align='center'>ВСЁ, ХВАТИТ ТРЕПАТЬСЯ! В БОЙ, ПЕХОТА!</t>";
        _footer = "<t size='0.85' color='#808080' align='center'>ALTIS WARFARE 2026</t>";
    } else {
        _title = format ["<t size='1.3' color='%1' shadow='2' align='center'>%2</t>", _titleColor, _titleTextEn];
        _text = "<t size='0.75' color='#32CD32' shadow='1' align='center'>HEY YOU, MAGGOT, LOOK HERE, DAMMIT!</t><br/>" +
        "<t size='0.6' color='#D0D0D0'>You are now the </t><t size='0.65' color='#32CD32' shadow='1'>SQUAD LEADER</t><t size='0.6' color='#D0D0D0'>! Stop picking your ass! You have 14 of these same freaks under your command — </t><t size='0.6' color='#32CD32' shadow='1'>MAKE AN ARMY OUT OF THEM!</t><br/>" +
        "<t size='0.65' color='#FFFF88' shadow='1'>THE MISSION IS SIMPLE: </t><t size='0.6' color='#D0D0D0'>Capture cities! Every city means points, resources, guns. No cities — you are </t><t size='0.6' color='#32CD32' shadow='1'>NOBODY!</t><t size='0.6' color='#D0D0D0'> Push the front before they kill you!</t><br/>" +
        "<t size='0.65' color='#FFFF88' shadow='1'>THE HQ IS YOUR HEART, YOU MORON! </t><t size='0.6' color='#D0D0D0'>Without it, you're just a mob with rifles. Lose the HQ — </t><t size='0.6' color='#32CD32' shadow='1'>IT'S ALL FUCKED!</t><t size='0.6' color='#D0D0D0'> Cover it with turrets and troops — let </t><t size='0.6' color='#32CD32' shadow='1'>NO ASSHOLE GET NEAR IT!</t><br/>" +
        "<t size='0.65' color='#FFFF88' shadow='1'>YOUR TROOPS ARE GREENHORNS! </t><t size='0.6' color='#D0D0D0'>The more they fight — the more </t><t size='0.6' color='#32CD32' shadow='1'>PROFESSIONAL THEY BECOME</t><t size='0.6' color='#D0D0D0'>. The bigger </t><t size='0.6' color='#32CD32' shadow='1'>ARMY YOU CAN BUILD!</t><br/>" +
        "<t size='0.65' color='#FFFF88' shadow='1'>FIND THE ENEMY BASE AND TEAR IT TO FUCKING SHREDS! </t><t size='0.6' color='#D0D0D0'>As long as their HQ stands, they will keep coming.</t><br/>" +
        "<t size='0.65' color='#FFFF88' shadow='1'>NO FRONT COMMANDER? TAKE COMMAND YOURSELF, DAMMIT! </t><t size='0.6' color='#D0D0D0'>No choice! Build the base, capture cities, </t><t size='0.6' color='#32CD32' shadow='1'>DESTROY THE ENEMY!</t><br/>" +
        "<t size='0.6' color='#FFFF88' shadow='1'>How to take command: approach the HQ, press ~, and click the 'Take Command' icon at the top.</t><br/>" +
        "<t size='0.7' color='#32CD32' shadow='1' align='center'>THAT'S IT, ENOUGH CHATTER! INTO COMBAT, INFANTRY!</t>";
        _footer = "<t size='0.85' color='#808080' align='center'>ALTIS WARFARE 2026</t>";
    };
    
    _hintText = format ["%1<br/>%2<br/>%3", _title, _text, _footer];
    _result = _hintText;
};

//=== Factory: Barracks ===
if (_id isEqualTo "Barracks") then {
    private ["_footer"];
    if (_lang isEqualTo "russian") then {
        _footer = "<br/><br/><t size='0.9' color='#808080' align='left'>Отключить подсказки: кнопка ~ меню планшета - видео настройки - подсказки.</t>";
    } else {
        _footer = "<br/><br/><t size='0.9' color='#808080' align='left'>Disable hints: ~ menu tablet - video settings - hints.</t>";
    };
    
    if (_side isEqualTo west) then {
        if (_lang isEqualTo "russian") then {
            _result = "<t size='1.5' color='#0000FF' shadow='1' align='center'>Казарма</t><br/><br/><t size='1.1' color='#D0D0D0' align='center'>Основное здание для покупки юнитов и снаряжения.</t><br/><br/><t size='1.1' color='#D0D0D0' align='left'>Возможности:<br/><t color='#4488FF'>• Покупка снаряжения</t> — доступно при построенном Центре Управления<br/><t color='#4488FF'>• Покупка ботов</t> — набор пехоты для ваших отрядов</t><br/><br/><t size='1.0' color='#FFFF88' align='left'>Меню управления: клавиша ~</t>" + _footer;
        } else {
            _result = "<t size='1.5' color='#0000FF' shadow='1' align='center'>Barracks</t><br/><br/><t size='1.1' color='#D0D0D0' align='center'>Main building for purchasing units and gear.</t><br/><br/><t size='1.1' color='#D0D0D0' align='left'>Capabilities:<br/><t color='#4488FF'>• Gear purchase</t> — available when Control Center is built<br/><t color='#4488FF'>• Unit purchase</t> — recruit infantry for your squads</t><br/><br/><t size='1.0' color='#FFFF88' align='left'>Command menu: ~ key</t>" + _footer;
        };
    };
    if (_side isEqualTo east) then {
        if (_lang isEqualTo "russian") then {
            _result = "<t size='1.5' color='#FF0000' shadow='1' align='center'>Казарма</t><br/><br/><t size='1.1' color='#D0D0D0' align='center'>Основное здание для покупки юнитов и снаряжения.</t><br/><br/><t size='1.1' color='#D0D0D0' align='left'>Возможности:<br/><t color='#FF4444'>• Покупка снаряжения</t> — доступно при построенном Центре Управления<br/><t color='#FF4444'>• Покупка ботов</t> — набор пехоты для ваших отрядов</t><br/><br/><t size='1.0' color='#FFFF88' align='left'>Меню управления: клавиша ~</t>" + _footer;
        } else {
            _result = "<t size='1.5' color='#FF0000' shadow='1' align='center'>Barracks</t><br/><br/><t size='1.1' color='#D0D0D0' align='center'>Main building for purchasing units and gear.</t><br/><br/><t size='1.1' color='#D0D0D0' align='left'>Capabilities:<br/><t color='#FF4444'>• Gear purchase</t> — available when Control Center is built<br/><t color='#FF4444'>• Unit purchase</t> — recruit infantry for your squads</t><br/><br/><t size='1.0' color='#FFFF88' align='left'>Command menu: ~ key</t>" + _footer;
        };
    };
};

//=== Factory: Light ===
if (_id isEqualTo "Light") then {
    private ["_offroad","_medtruck","_medvan","_footer"];
    
    //--- Footer
    if (_lang isEqualTo "russian") then {
        _footer = "<br/><br/><t size='0.9' color='#808080' align='left'>Отключить подсказки: кнопка ~ меню планшета - видео настройки - подсказки.</t>";
    } else {
        _footer = "<br/><br/><t size='0.9' color='#808080' align='left'>Disable hints: ~ menu tablet - video settings - hints.</t>";
    };
    
    //--- Получаем реальные названия из конфига Arma 3
    _offroad = getText(configFile >> "CfgVehicles" >> "B_G_Offroad_01_F" >> "displayName");
    _medtruck = getText(configFile >> "CfgVehicles" >> "B_Truck_01_medical_F" >> "displayName");
    _medvan = getText(configFile >> "CfgVehicles" >> "C_Van_02_medevac_F" >> "displayName");
    
    if (_side isEqualTo west) then {
        if (_lang isEqualTo "russian") then {
            _result = "<t size='1.5' color='#0000FF' shadow='1' align='center'>Завод лёгкой техники</t><br/><br/><t size='1.1' color='#D0D0D0' align='center'>Производство и покупка лёгкой техники для вашей стороны.</t><br/><br/><t size='1.1' color='#D0D0D0' align='left'>Техника с функционалом:<br/><t color='#4488FF'>• " + _offroad + "</t> — загрузка стационарных орудий, ящиков, контейнеров<br/><t color='#4488FF'>• " + _medtruck + ", " + _medvan + "</t> — закупка снаряжения и возрождение</t><br/><br/><t size='1.0' color='#FFFF88' align='left'>Меню управления: клавиша ~</t>" + _footer;
        } else {
            _result = "<t size='1.5' color='#0000FF' shadow='1' align='center'>Light Factory</t><br/><br/><t size='1.1' color='#D0D0D0' align='center'>Production and purchase of light vehicles for your side.</t><br/><br/><t size='1.1' color='#D0D0D0' align='left'>Functional vehicles:<br/><t color='#4488FF'>• " + _offroad + "</t> — load static weapons, crates, containers in bed<br/><t color='#4488FF'>• " + _medtruck + ", " + _medvan + "</t> — gear purchase and respawn</t><br/><br/><t size='1.0' color='#FFFF88' align='left'>Command menu: ~ key</t>" + _footer;
        };
    };
    
    //--- East vehicles
    _offroad = getText(configFile >> "CfgVehicles" >> "O_G_Offroad_01_F" >> "displayName");
    _medtruck = getText(configFile >> "CfgVehicles" >> "O_Truck_03_medical_F" >> "displayName");
    _medvan = getText(configFile >> "CfgVehicles" >> "O_Truck_02_medical_F" >> "displayName");
    _medvan2 = getText(configFile >> "CfgVehicles" >> "C_IDAP_Van_02_medevac_F" >> "displayName");
    
    if (_side isEqualTo east) then {
        if (_lang isEqualTo "russian") then {
            _result = "<t size='1.5' color='#FF0000' shadow='1' align='center'>Завод лёгкой техники</t><br/><br/><t size='1.1' color='#D0D0D0' align='center'>Производство и покупка лёгкой техники для вашей стороны.</t><br/><br/><t size='1.1' color='#D0D0D0' align='left'>Техника с функционалом:<br/><t color='#FF4444'>• " + _medtruck + ", " + _medvan + ", " + _medvan2 + "</t> — закупка снаряжения и возрождение<br/><t color='#FF4444'>• " + _offroad + "</t> — загрузка стационарных орудий, ящиков, контейнеров</t><br/><br/><t size='1.0' color='#FFFF88' align='left'>Меню управления: клавиша ~</t>" + _footer;
        } else {
            _result = "<t size='1.5' color='#FF0000' shadow='1' align='center'>Light Factory</t><br/><br/><t size='1.1' color='#D0D0D0' align='center'>Production and purchase of light vehicles for your side.</t><br/><br/><t size='1.1' color='#D0D0D0' align='left'>Functional vehicles:<br/><t color='#FF4444'>• " + _medtruck + ", " + _medvan + ", " + _medvan2 + "</t> — gear purchase and respawn<br/><t color='#FF4444'>• " + _offroad + "</t> — load static weapons, crates, containers in bed</t><br/><br/><t size='1.0' color='#FFFF88' align='left'>Command menu: ~ key</t>" + _footer;
        };
    };
};

//=== Factory: Heavy ===
if (_id isEqualTo "Heavy") then {
    private ["_apc","_tank","_aa","_footer"];
    
    //--- Footer
    if (_lang isEqualTo "russian") then {
        _footer = "<br/><br/><t size='0.9' color='#808080' align='left'>Отключить подсказки: кнопка ~ меню планшета - видео настройки - подсказки.</t>";
    } else {
        _footer = "<br/><br/><t size='0.9' color='#808080' align='left'>Disable hints: ~ menu tablet - video settings - hints.</t>";
    };
    
    //--- West vehicles
    _apc = getText(configFile >> "CfgVehicles" >> "B_APC_Wheeled_01_cannon_F" >> "displayName");
    _tank = getText(configFile >> "CfgVehicles" >> "B_MBT_01_cannon_F" >> "displayName");
    _aa = getText(configFile >> "CfgVehicles" >> "B_APC_Tracked_01_AA_F" >> "displayName");
    
    if (_side isEqualTo west) then {
        if (_lang isEqualTo "russian") then {
            _result = "<t size='1.5' color='#0000FF' shadow='1' align='center'>Завод тяжёлой техники</t><br/><br/><t size='1.1' color='#D0D0D0' align='center'>Производство и покупка тяжёлой техники для вашей стороны.</t><br/><br/><t size='1.1' color='#D0D0D0' align='left'>Основная боевая техника:<br/><t color='#4488FF'>• " + _apc + "</t> — боевая бронированная машина<br/><t color='#4488FF'>• " + _tank + "</t> — основной боевой танк<br/><t color='#4488FF'>• " + _aa + "</t> — зенитная установка</t><br/><br/><t size='1.0' color='#FFFF88' align='left'>Меню управления: клавиша ~</t>" + _footer;
        } else {
            _result = "<t size='1.5' color='#0000FF' shadow='1' align='center'>Heavy Factory</t><br/><br/><t size='1.1' color='#D0D0D0' align='center'>Production and purchase of heavy vehicles for your side.</t><br/><br/><t size='1.1' color='#D0D0D0' align='left'>Combat vehicles:<br/><t color='#4488FF'>• " + _apc + "</t> — armored fighting vehicle<br/><t color='#4488FF'>• " + _tank + "</t> — main battle tank<br/><t color='#4488FF'>• " + _aa + "</t> — anti-aircraft system</t><br/><br/><t size='1.0' color='#FFFF88' align='left'>Command menu: ~ key</t>" + _footer;
        };
    };
    
    //--- East vehicles
    _apc = getText(configFile >> "CfgVehicles" >> "O_APC_Wheeled_02_rcws_F" >> "displayName");
    _tank = getText(configFile >> "CfgVehicles" >> "O_MBT_02_cannon_F" >> "displayName");
    _aa = getText(configFile >> "CfgVehicles" >> "O_APC_Tracked_02_AA_F" >> "displayName");
    
    if (_side isEqualTo east) then {
        if (_lang isEqualTo "russian") then {
            _result = "<t size='1.5' color='#FF0000' shadow='1' align='center'>Завод тяжёлой техники</t><br/><br/><t size='1.1' color='#D0D0D0' align='center'>Производство и покупка тяжёлой техники для вашей стороны.</t><br/><br/><t size='1.1' color='#D0D0D0' align='left'>Основная боевая техника:<br/><t color='#FF4444'>• " + _apc + "</t> — боевая бронированная машина<br/><t color='#FF4444'>• " + _tank + "</t> — основной боевой танк<br/><t color='#FF4444'>• " + _aa + "</t> — зенитная установка</t><br/><br/><t size='1.0' color='#FFFF88' align='left'>Меню управления: клавиша ~</t>" + _footer;
        } else {
            _result = "<t size='1.5' color='#FF0000' shadow='1' align='center'>Heavy Factory</t><br/><br/><t size='1.1' color='#D0D0D0' align='center'>Production and purchase of heavy vehicles for your side.</t><br/><br/><t size='1.1' color='#D0D0D0' align='left'>Combat vehicles:<br/><t color='#FF4444'>• " + _apc + "</t> — armored fighting vehicle<br/><t color='#FF4444'>• " + _tank + "</t> — main battle tank<br/><t color='#FF4444'>• " + _aa + "</t> — anti-aircraft system</t><br/><br/><t size='1.0' color='#FFFF88' align='left'>Command menu: ~ key</t>" + _footer;
        };
    };
};

//=== Factory: Air ===
if (_id isEqualTo "Air") then {
    private ["_nuke","_medevac","_footer"];
    
    //--- Footer
    if (_lang isEqualTo "russian") then {
        _footer = "<br/><br/><t size='0.9' color='#808080' align='left'>Отключить подсказки: кнопка ~ меню планшета - видео настройки - подсказки.</t>";
    } else {
        _footer = "<br/><br/><t size='0.9' color='#808080' align='left'>Disable hints: ~ menu tablet - video settings - hints.</t>";
    };
    
    //--- Nuke device (same for both sides)
    _nuke = localize 'STR_CTI_NUKE_DEVICE_NAME';
    
    //--- West vehicles
    _medevac = getText(configFile >> "CfgVehicles" >> "B_Slingload_01_Medevac_F" >> "displayName");
    
    if (_side isEqualTo west) then {
        if (_lang isEqualTo "russian") then {
            _result = "<t size='1.5' color='#0000FF' shadow='1' align='center'>Аэродром</t><br/><br/><t size='1.1' color='#D0D0D0' align='center'>Производство и покупка авиации для вашей стороны.</t><br/><br/><t size='1.1' color='#D0D0D0' align='left'>Техника с функционалом:<br/><t color='#4488FF'>• " + _nuke + "</t> — ядерная бомба (цепляем на вертолёт и сбрасываем на противника)<br/><t color='#4488FF'>• " + _medevac + "</t> — возможность возрождения</t><br/><br/><t size='1.0' color='#FFFF88' align='left'>Меню управления: клавиша ~</t>" + _footer;
        } else {
            _result = "<t size='1.5' color='#0000FF' shadow='1' align='center'>Air Factory</t><br/><br/><t size='1.1' color='#D0D0D0' align='center'>Production and purchase of aviation for your side.</t><br/><br/><t size='1.1' color='#D0D0D0' align='left'>Functional vehicles:<br/><t color='#4488FF'>• " + _nuke + "</t> — nuclear bomb (attach to helicopter and drop on enemy)<br/><t color='#4488FF'>• " + _medevac + "</t> — respawn capability</t><br/><br/><t size='1.0' color='#FFFF88' align='left'>Command menu: ~ key</t>" + _footer;
        };
    };
    
    //--- East vehicles
    _medevac = getText(configFile >> "CfgVehicles" >> "Land_Pod_Heli_Transport_04_medevac_F" >> "displayName");
    
    if (_side isEqualTo east) then {
        if (_lang isEqualTo "russian") then {
            _result = "<t size='1.5' color='#FF0000' shadow='1' align='center'>Аэродром</t><br/><br/><t size='1.1' color='#D0D0D0' align='center'>Производство и покупка авиации для вашей стороны.</t><br/><br/><t size='1.1' color='#D0D0D0' align='left'>Техника с функционалом:<br/><t color='#FF4444'>• " + _nuke + "</t> — ядерная бомба (цепляем на вертолёт и сбрасываем на противника)<br/><t color='#FF4444'>• " + _medevac + "</t> — возможность возрождения</t><br/><br/><t size='1.0' color='#FFFF88' align='left'>Меню управления: клавиша ~</t>" + _footer;
        } else {
            _result = "<t size='1.5' color='#FF0000' shadow='1' align='center'>Air Factory</t><br/><br/><t size='1.1' color='#D0D0D0' align='center'>Production and purchase of aviation for your side.</t><br/><br/><t size='1.1' color='#D0D0D0' align='left'>Functional vehicles:<br/><t color='#FF4444'>• " + _nuke + "</t> — nuclear bomb (attach to helicopter and drop on enemy)<br/><t color='#FF4444'>• " + _medevac + "</t> — respawn capability</t><br/><br/><t size='1.0' color='#FFFF88' align='left'>Command menu: ~ key</t>" + _footer;
        };
    };
};

//=== Factory: Repair ===
if (_id isEqualTo "Repair") then {
    private ["_repair","_fuel","_footer"];
    
    //--- Footer
    if (_lang isEqualTo "russian") then {
        _footer = "<br/><br/><t size='0.9' color='#808080' align='left'>Отключить подсказки: кнопка ~ меню планшета - видео настройки - подсказки.</t>";
    } else {
        _footer = "<br/><br/><t size='0.9' color='#808080' align='left'>Disable hints: ~ menu tablet - video settings - hints.</t>";
    };
    
    //--- West vehicles
    _repair = getText(configFile >> "CfgVehicles" >> "B_Truck_01_Repair_F" >> "displayName");
    _fuel = getText(configFile >> "CfgVehicles" >> "B_Truck_01_fuel_F" >> "displayName");
    
    if (_side isEqualTo west) then {
        if (_lang isEqualTo "russian") then {
            _result = "<t size='1.5' color='#0000FF' shadow='1' align='center'>Ремонтная база</t><br/><br/><t size='1.1' color='#D0D0D0' align='center'>Строительство обороны и ремонт техники для вашей стороны.</t><br/><br/><t size='1.1' color='#D0D0D0' align='left'>Возможности:<br/><t color='#4488FF'>• Строительство обороны</t> — с помощью техники и контейнеров строим оборону в любой точке карты (подойди к купленной техники, нажми ~, выбери сверху «Меню обороны»)<br/><t color='#4488FF'>• " + _repair + ", " + _fuel + "</t> — ремонт и заправка техники (нажми ~, выбери планшет, нажми «Сервис меню»)<br/><br/><t size='1.0' color='#FFFF88' align='left'>Меню управления: клавиша ~</t>" + _footer;
        } else {
            _result = "<t size='1.5' color='#0000FF' shadow='1' align='center'>Repair Facility</t><br/><br/><t size='1.1' color='#D0D0D0' align='center'>Building defenses and repairing vehicles for your side.</t><br/><br/><t size='1.1' color='#D0D0D0' align='left'>Capabilities:<br/><t color='#4488FF'>• Build defenses</t> — using vehicles and containers, build defenses anywhere on map (approach a purchased vehicle, press ~, select «Defense Menu» at top)<br/><t color='#4488FF'>• " + _repair + ", " + _fuel + "</t> — vehicle repair and refueling (press ~, select tablet, press «Service Menu»)<br/><br/><t size='1.0' color='#FFFF88' align='left'>Command menu: ~ key</t>" + _footer;
        };
    };
    
    //--- East vehicles
    _repair = getText(configFile >> "CfgVehicles" >> "O_Truck_03_repair_F" >> "displayName");
    _fuel = getText(configFile >> "CfgVehicles" >> "O_Truck_03_fuel_F" >> "displayName");
    
    if (_side isEqualTo east) then {
        if (_lang isEqualTo "russian") then {
            _result = "<t size='1.5' color='#FF0000' shadow='1' align='center'>Ремонтная база</t><br/><br/><t size='1.1' color='#D0D0D0' align='center'>Строительство обороны и ремонт техники для вашей стороны.</t><br/><br/><t size='1.1' color='#D0D0D0' align='left'>Возможности:<br/><t color='#FF4444'>• Строительство обороны</t> — с помощью техники и контейнеров строим оборону в любой точке карты (подойди к купленной техники, нажми ~, выбери сверху «Меню обороны»)<br/><t color='#FF4444'>• " + _repair + ", " + _fuel + "</t> — ремонт и заправка техники (нажми ~, выбери планшет, нажми «Сервис меню»)<br/><br/><t size='1.0' color='#FFFF88' align='left'>Меню управления: клавиша ~</t>" + _footer;
        } else {
            _result = "<t size='1.5' color='#FF0000' shadow='1' align='center'>Repair Facility</t><br/><br/><t size='1.1' color='#D0D0D0' align='center'>Building defenses and repairing vehicles for your side.</t><br/><br/><t size='1.1' color='#D0D0D0' align='left'>Capabilities:<br/><t color='#FF4444'>• Build defenses</t> — using vehicles and containers, build defenses anywhere on map (approach a purchased vehicle, press ~, select «Defense Menu» at top)<br/><t color='#FF4444'>• " + _repair + ", " + _fuel + "</t> — vehicle repair and refueling (press ~, select tablet, press «Service Menu»)<br/><br/><t size='1.0' color='#FFFF88' align='left'>Command menu: ~ key</t>" + _footer;
        };
    };
};

//=== Factory: Ammo ===
if (_id isEqualTo "Ammo") then {
    private ["_footer"];
    
    //--- Footer
    if (_lang isEqualTo "russian") then {
        _footer = "<br/><br/><t size='0.9' color='#808080' align='left'>Отключить подсказки: кнопка ~ меню планшета - видео настройки - подсказки.</t>";
    } else {
        _footer = "<br/><br/><t size='0.9' color='#808080' align='left'>Disable hints: ~ menu tablet - video settings - hints.</t>";
    };
    
    if (_side isEqualTo west) then {
        if (_lang isEqualTo "russian") then {
            _result = "<t size='1.5' color='#0000FF' shadow='1' align='center'>Арсенал</t><br/><br/><t size='1.1' color='#D0D0D0' align='center'>Перезарядка техники для вашей стороны.</t><br/><br/><t size='1.1' color='#D0D0D0' align='left'>Возможности:<br/><t color='#4488FF'>• Перезарядка техники</t> — пополняем боезапас всей техники (нажми ~, выбери планшет, нажми «Сервис меню»)<br/><br/><t size='1.0' color='#FFFF88' align='left'>Меню управления: клавиша ~</t>" + _footer;
        } else {
            _result = "<t size='1.5' color='#0000FF' shadow='1' align='center'>Ammo Depot</t><br/><br/><t size='1.1' color='#D0D0D0' align='center'>Vehicle rearming for your side.</t><br/><br/><t size='1.1' color='#D0D0D0' align='left'>Capabilities:<br/><t color='#4488FF'>• Vehicle rearming</t> — replenish ammunition for all vehicles (press ~, select tablet, press «Service Menu»)<br/><br/><t size='1.0' color='#FFFF88' align='left'>Command menu: ~ key</t>" + _footer;
        };
    };
    
    if (_side isEqualTo east) then {
        if (_lang isEqualTo "russian") then {
            _result = "<t size='1.5' color='#FF0000' shadow='1' align='center'>Арсенал</t><br/><br/><t size='1.1' color='#D0D0D0' align='center'>Перезарядка техники для вашей стороны.</t><br/><br/><t size='1.1' color='#D0D0D0' align='left'>Возможности:<br/><t color='#FF4444'>• Перезарядка техники</t> — пополняем боезапас всей техники (нажми ~, выбери планшет, нажми «Сервис меню»)<br/><br/><t size='1.0' color='#FFFF88' align='left'>Меню управления: клавиша ~</t>" + _footer;
        } else {
            _result = "<t size='1.5' color='#FF0000' shadow='1' align='center'>Ammo Depot</t><br/><br/><t size='1.1' color='#D0D0D0' align='center'>Vehicle rearming for your side.</t><br/><br/><t size='1.1' color='#D0D0D0' align='left'>Capabilities:<br/><t color='#FF4444'>• Vehicle rearming</t> — replenish ammunition for all vehicles (press ~, select tablet, press «Service Menu»)<br/><br/><t size='1.0' color='#FFFF88' align='left'>Command menu: ~ key</t>" + _footer;
        };
    };
};

//=== Factory: Naval ===
if (_id isEqualTo "Naval") then {
    private ["_sdv","_footer"];
    
    //--- Footer
    if (_lang isEqualTo "russian") then {
        _footer = "<br/><br/><t size='0.9' color='#808080' align='left'>Отключить подсказки: кнопка ~ меню планшета - видео настройки - подсказки.</t>";
    } else {
        _footer = "<br/><br/><t size='0.9' color='#808080' align='left'>Disable hints: ~ menu tablet - video settings - hints.</t>";
    };
    
    //--- SDV (same for both sides)
    _sdv = getText(configFile >> "CfgVehicles" >> "B_SDV_01_F" >> "displayName");
    
    if (_side isEqualTo west) then {
        if (_lang isEqualTo "russian") then {
            _result = "<t size='1.5' color='#0000FF' shadow='1' align='center'>Морская база</t><br/><br/><t size='1.1' color='#D0D0D0' align='center'>Морские средства для вашей стороны.</t><br/><br/><t size='1.1' color='#D0D0D0' align='left'>Техника с функционалом:<br/><t color='#4488FF'>• " + _sdv + "</t> — ремонт и строительство обороны (как ремонтные машины и контейнеры)<br/><br/><t size='1.0' color='#FFFF88' align='left'>Меню управления: клавиша ~</t>" + _footer;
        } else {
            _result = "<t size='1.5' color='#0000FF' shadow='1' align='center'>Naval Yard</t><br/><br/><t size='1.1' color='#D0D0D0' align='center'>Naval assets for your side.</t><br/><br/><t size='1.1' color='#D0D0D0' align='left'>Functional vehicles:<br/><t color='#4488FF'>• " + _sdv + "</t> — repair and build defenses (like repair trucks and containers)<br/><br/><t size='1.0' color='#FFFF88' align='left'>Command menu: ~ key</t>" + _footer;
        };
    };
    
    if (_side isEqualTo east) then {
        if (_lang isEqualTo "russian") then {
            _result = "<t size='1.5' color='#FF0000' shadow='1' align='center'>Морская база</t><br/><br/><t size='1.1' color='#D0D0D0' align='center'>Морские средства для вашей стороны.</t><br/><br/><t size='1.1' color='#D0D0D0' align='left'>Техника с функционалом:<br/><t color='#FF4444'>• " + _sdv + "</t> — ремонт и строительство обороны (как ремонтные машины и контейнеры)<br/><br/><t size='1.0' color='#FFFF88' align='left'>Меню управления: клавиша ~</t>" + _footer;
        } else {
            _result = "<t size='1.5' color='#FF0000' shadow='1' align='center'>Naval Yard</t><br/><br/><t size='1.1' color='#D0D0D0' align='center'>Naval assets for your side.</t><br/><br/><t size='1.1' color='#D0D0D0' align='left'>Functional vehicles:<br/><t color='#FF4444'>• " + _sdv + "</t> — repair and build defenses (like repair trucks and containers)<br/><br/><t size='1.0' color='#FFFF88' align='left'>Command menu: ~ key</t>" + _footer;
        };
    };
};

//=== Control Center ===
if (_id isEqualTo "ControlCenter") then {
    private ["_footer"];
    
    //--- Footer
    if (_lang isEqualTo "russian") then {
        _footer = "<br/><br/><t size='0.9' color='#808080' align='left'>Отключить подсказки: кнопка ~ меню планшета - видео настройки - подсказки.</t>";
    } else {
        _footer = "<br/><br/><t size='0.9' color='#808080' align='left'>Disable hints: ~ menu tablet - video settings - hints.</t>";
    };
    
    if (_side isEqualTo west) then {
        if (_lang isEqualTo "russian") then {
            _result = "<t size='1.5' color='#0000FF' shadow='1' align='center'>Центр управления</t><br/><br/><t size='1.1' color='#D0D0D0' align='center'>Управление базой и разведка для вашей стороны.</t><br/><br/><t size='1.1' color='#D0D0D0' align='left'>Возможности:<br/><t color='#4488FF'>• Развёртывание сети</t> — в радиусе сети можно закупать технику и видеть её на карте<br/><t color='#4488FF'>• Вид со спутника</t> — можно искать базу противника (работает если КШМ жива)<br/><t color='#4488FF'>• Камера юнитов</t> — можно следить за игроками и ботами<br/><t color='#4488FF'>• Улучшения</t> — улучшает технику, оборону, города, сеть и многое другое<br/><br/><t size='1.0' color='#FFFF88' align='left'>Меню управления: клавиша ~</t>" + _footer;
        } else {
            _result = "<t size='1.5' color='#0000FF' shadow='1' align='center'>Control Center</t><br/><br/><t size='1.1' color='#D0D0D0' align='center'>Base management and reconnaissance for your side.</t><br/><br/><t size='1.1' color='#D0D0D0' align='left'>Capabilities:<br/><t color='#4488FF'>• Network deployment</t> — buy vehicles and see them on map within network radius<br/><t color='#4488FF'>• Satellite view</t> — can search for enemy base (requires HQ alive)<br/><t color='#4488FF'>• Unit cameras</t> — watch players and bots behavior<br/><t color='#4488FF'>• Upgrades</t> — upgrade vehicles, defenses, towns, network and much more<br/><br/><t size='1.0' color='#FFFF88' align='left'>Command menu: ~ key</t>" + _footer;
        };
    };
    
    if (_side isEqualTo east) then {
        if (_lang isEqualTo "russian") then {
            _result = "<t size='1.5' color='#FF0000' shadow='1' align='center'>Центр управления</t><br/><br/><t size='1.1' color='#D0D0D0' align='center'>Управление базой и разведка для вашей стороны.</t><br/><br/><t size='1.1' color='#D0D0D0' align='left'>Возможности:<br/><t color='#FF4444'>• Развёртывание сети</t> — в радиусе сети можно закупать технику и видеть её на карте<br/><t color='#FF4444'>• Вид со спутника</t> — можно искать базу противника (работает если КШМ жива)<br/><t color='#FF4444'>• Камера юнитов</t> — можно следить за игроками и ботами<br/><t color='#FF4444'>• Улучшения</t> — улучшает технику, оборону, города, сеть и многое другое<br/><br/><t size='1.0' color='#FFFF88' align='left'>Меню управления: клавиша ~</t>" + _footer;
        } else {
            _result = "<t size='1.5' color='#FF0000' shadow='1' align='center'>Control Center</t><br/><br/><t size='1.1' color='#D0D0D0' align='center'>Base management and reconnaissance for your side.</t><br/><br/><t size='1.1' color='#D0D0D0' align='left'>Capabilities:<br/><t color='#FF4444'>• Network deployment</t> — buy vehicles and see them on map within network radius<br/><t color='#FF4444'>• Satellite view</t> — can search for enemy base<br/><t color='#FF4444'>• Unit cameras</t> — watch players and bots behavior<br/><t color='#FF4444'>• Upgrades</t> — upgrade vehicles, defenses, towns, network and much more<br/><br/><t size='1.0' color='#FFFF88' align='left'>Command menu: ~ key</t>" + _footer;
        };
    };
};

//=== Radar ===
if (_id isEqualTo "Radar") then {
    private ["_footer"];
    
    //--- Footer
    if (_lang isEqualTo "russian") then {
        _footer = "<br/><br/><t size='0.9' color='#808080' align='left'>Отключить подсказки: кнопка ~ меню планшета - видео настройки - подсказки.</t>";
    } else {
        _footer = "<br/><br/><t size='0.9' color='#808080' align='left'>Disable hints: ~ menu tablet - video settings - hints.</t>";
    };
    
    if (_side isEqualTo west) then {
        if (_lang isEqualTo "russian") then {
            _result = "<t size='1.5' color='#0000FF' shadow='1' align='center'>Радар</t><br/><br/><t size='1.1' color='#D0D0D0' align='center'>Воздушная и артиллерийская разведка для вашей стороны.</t><br/><br/><t size='1.1' color='#D0D0D0' align='left'>Возможности:<br/><t color='#4488FF'>• Воздушный радар</t> — показывает визуально на карте всю воздушную технику без исключения (работает после улучшения воздушного радара)<br/><t color='#4488FF'>• Артиллерийский радар</t> — показывает на карте направление артиллерии в виде жёлтых полос (работает после улучшения артиллерийского радара)<br/><br/>Радиус действия: 8 км<br/><br/><t size='1.0' color='#FFFF88' align='left'>Меню управления: клавиша ~</t>" + _footer;
        } else {
            _result = "<t size='1.5' color='#0000FF' shadow='1' align='center'>Radar</t><br/><br/><t size='1.1' color='#D0D0D0' align='center'>Air and artillery reconnaissance for your side.</t><br/><br/><t size='1.1' color='#D0D0D0' align='left'>Capabilities:<br/><t color='#4488FF'>• Air radar</t> — shows all aircraft on map visually without exception (requires air radar upgrade)<br/><t color='#4488FF'>• Artillery radar</t> — shows artillery direction on map as yellow stripes (requires artillery radar upgrade)<br/><br/>Range: 8 km<br/><br/><t size='1.0' color='#FFFF88' align='left'>Command menu: ~ key</t>" + _footer;
        };
    };
    
    if (_side isEqualTo east) then {
        if (_lang isEqualTo "russian") then {
            _result = "<t size='1.5' color='#FF0000' shadow='1' align='center'>Радар</t><br/><br/><t size='1.1' color='#D0D0D0' align='center'>Воздушная и артиллерийская разведка для вашей стороны.</t><br/><br/><t size='1.1' color='#D0D0D0' align='left'>Возможности:<br/><t color='#FF4444'>• Воздушный радар</t> — показывает визуально на карте всю воздушную технику без исключения (работает после улучшения воздушного радара)<br/><t color='#FF4444'>• Артиллерийский радар</t> — показывает на карте направление артиллерии в виде жёлтых полос (работает после улучшения артиллерийского радара)<br/><br/>Радиус действия: 8 км<br/><br/><t size='1.0' color='#FFFF88' align='left'>Меню управления: клавиша ~</t>" + _footer;
        } else {
            _result = "<t size='1.5' color='#FF0000' shadow='1' align='center'>Radar</t><br/><br/><t size='1.1' color='#D0D0D0' align='center'>Air and artillery reconnaissance for your side.</t><br/><br/><t size='1.1' color='#D0D0D0' align='left'>Capabilities:<br/><t color='#FF4444'>• Air radar</t> — shows all aircraft on map visually without exception (requires air radar upgrade)<br/><t color='#FF4444'>• Artillery radar</t> — shows artillery direction on map as yellow stripes (requires artillery radar upgrade)<br/><br/>Range: 8 km<br/><br/><t size='1.0' color='#FFFF88' align='left'>Command menu: ~ key</t>" + _footer;
        };
    };
};

//--- Возвращаем результат
_result
