// scripts\rules_text.sqf

private _rules = switch (language) do {
    case "Russian": {
        "
        ДОБАВЛЕНО:
        <br/>
        <br/>
1. Возможность перезарядки авиации
<br/>
2. Отображение на карте  боекомплекта техники и ботов
<br/>
(наведи курсор на иконку техники или бота)
        "
    };
    default {
        "
ADD:
        <br/>
        <br/>
1. added the ability to recharge aircraft
<br/>
2. Displaying equipment and bots on the map
<br/>
(hover the cursor over the equipment or bot icon)

        "
    };
};

_rules