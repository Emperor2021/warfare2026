// scripts\rules_text.sqf

private _rules = switch (language) do {
    case "Russian": {
        "
Добавлена новая механика.  
<br/>
<br/>
Вышли из игры? Твоя армия не исчезнет.
<br/>
Купленные бойцы и техника остаются на месте последнего нахождения.
<br/>
<br/>
Бойцы:
<br/>
сохраняют свои позиции;
<br/>
могут перемещаться в радиусе 25 м от своей позиции;
<br/>
при атаке ищут укрытия и вступают в бой;
<br/>
<br/>
Техника:
<br/>
остаётся на месте;
<br/>
экипаж сохраняет свою машину.
<br/>
<br/>
Вернувшись на сервер, ты снова получаешь управление своей армией.
<br/>
Оставил армию — она продолжает держать позицию.
<br/>
<br/>
Армия привязана к конкретному слоту. Если ты играешь на слоте Альфа 1-1, твоя армия остаётся именно там. Но если ты перейдёшь на другой слот, например Альфа 1-2, ты можешь получить армию другого игрока, который играл на этом слоте раньше. В итоге ты будешь управлять уже чужой армией.

     "
    };
    default {
        "
A new mechanic has been added.  
<br/>
<br/>
Left the game? Your army won't disappear.
<br/>
Purchased soldiers and vehicles remain at their last location.
<br/>
<br/>
Soldiers:
<br/>
keep their positions;
<br/>
can move within a 25 m radius of their position;
<br/>
when attacked, they seek cover and engage in combat;
<br/>
<br/>
Vehicles:
<br/>
remain in place;
<br/>
the crew keeps their vehicle.
<br/>
<br/>
When you return to the server, you regain control of your army.
<br/>
Left your army behind — it continues to hold its position.
<br/>
<br/>
The army is tied to a specific slot. If you’re playing on slot Alpha 1-1, your army stays there. But if you switch to another slot, for example, Alpha 1-2, you might get the army of another player who played on that slot before. As a result, you’ll be controlling someone else’s army.
        "
    };
};

_rules