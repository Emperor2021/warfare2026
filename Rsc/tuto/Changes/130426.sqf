// scripts\rules_text.sqf

private _rules = switch (language) do {
    case "Russian": {
        "
ДОБАВЛЕННО:
<br/>
<br/>
1. Легкие турели в оборону города и на ремонтные автомобили, контейнеры. 
<br/>
2. Появилась возможность, в обороне города, ремонтных машинах, 
<br/>
ремонтных контейнерах  подымать на высоту турели, ограждения 
<br/>
(теперь можно высаавлять турели на крышах или на вышках). 

        "
    };
    default {
        "
        ADD:
<br/>
<br/>
1. Light turrets for the defense of the city and for repair vehicles, containers. 
<br/>
2. There was an opportunity, in the defense of the city, repair vehicles, 
<br/>
raise turrets and fences to the height of repair containers. 
<br/>
(turrets can now be mounted on roofs or towers).
        "
    };
};

_rules