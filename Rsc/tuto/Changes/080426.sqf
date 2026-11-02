// scripts\rules_text.sqf

private _rules = switch (language) do {
    case "Russian": {
        "
        ДОБАВЛЕНО:
        <br/>
        <br/>
1. Артелерия через планшет. <br/>
2. Удаление ботов через комндное меню 0-8 (поддержка).
        "
    };
    default {
        "
ADD:
        <br/>
        <br/>
1. Artillery via tablet. <br/>
2. Removing bots via command menu 0-8 (support).
        "
    };
};

_rules