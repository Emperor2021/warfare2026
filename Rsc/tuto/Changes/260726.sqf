// scripts\rules_text.sqf

private _rules = switch (language) do {
    case "Russian": {
        "
Авиация:
<br/>
<br/>
1. Добавлена техника 
<br/>
2. Снижены цены
<br/>
3. Исправлена загрузка бк 

        "
    };
    default {
        "
Aviation:
<br/>
<br/>
1. Added vehicles
<br/>
2. Lowered prices
<br/>
3. Fixed ammunition loadout loading    
        
        "
    };
};

_rules