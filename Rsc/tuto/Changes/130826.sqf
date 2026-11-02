// scripts\rules_text.sqf

private _rules = switch (language) do {
    case "Russian": {
        "
Добавлена авиация стороне запад.  
<br/>
<br/>
1. UH-80 Ghost Hawk (CTRG) — вариант Assault (штурмовой / транспортно-боевой).
<br/>
2. UH-80 Ghost Hawk DAP (CTRG) — вариант DAP (огневой поддержки / ударный).
<br/>
     "
    };
    default {
        "
Added aviation to the West side
<br/>
<br/>
1. UH-80 Ghost Hawk (CTRG) — Assault variant (transport/assault).
<br/>
2. UH-80 Ghost Hawk DAP (CTRG) — DAP variant (fire support/attack).
<br/>
        "
    };
};

_rules