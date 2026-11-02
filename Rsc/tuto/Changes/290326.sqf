// scripts\rules_text.sqf

private _rules = switch (language) do {
    case "Russian": {
        "
1. Если в городе нет игрока в раддиусе 800м.,
<br/>
деактивация города увеличилась с 30 сек. до 30 мин.
<br/>
<br/>
2. Апгрейд завода тяжелой техники до 2 уровня 
<br/>
сократилось с 30 мин., до 5 мин.


        "
    };
    default {
        "
1. If there is no player in the city within a 800 meter radius,
<br/>
the city's deactivation time has increased from 30 seconds to 30 minutes.
<br/>
<br/>
2. Upgrading the heavy equipment factory to level 2 has been reduced
<br/> from 30 minutes to 5 minutes.
        "
    };
};

_rules