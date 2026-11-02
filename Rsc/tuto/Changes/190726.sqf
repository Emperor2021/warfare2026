// scripts\rules_text.sqf

private _rules = switch (language) do {
    case "Russian": {
        "
1. В -меню артиллерия- исправлен баг стрельбы.
<br/>
<br/>
2. Добавлено в -список артиллерийских установок- 
<br/>
количество боеприпасов и расход боеприпасов 
<br/>
<br/>
PS: артиллерия будет улучшаться и дорабатываться  

        "
    };
    default {
        "
1. Fixed a shooting bug in the -artillery menu-.
<br/>
<br/>
 2. Added the number of ammunition and ammunition consumption to the -Artillery Units-.
<br/>
 The artillery will be improved and modified
 <br/>
 <br/>
 PS: The artillery will be improved and modified.       
        
        "
    };
};

_rules