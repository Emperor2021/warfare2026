// scripts\rules_text.sqf

private _rules = switch (language) do {
    case "Russian": {
        "
ДОБАВЛЕННО:
<br/>
<br/>
Уменьшены цены на самолеты.  
        "
    };
    default {
        "
        ADD:
<br/>
<br/>
Reduced prices for airplanes.
        "
    };
};

_rules