// Rsc/tuto/Changes/Changelog.sqf
// Все изменения миссии в одном файле
// Формат: [Дата, Русский текст, Английский текст]

private _changelog = [
    ["21.10.2026",
     "Добавлены в меню обороны новые сооружения и мины.",
     "Added new structures and mines to the defense menu."],

    ["12.10.2026",
     "Добавлены точки респауна ботов и техники для базы и городов.<br/>Строить их можно через меню обороны.<br/>Радиус взаимодействия точки возрождения от завода — 100 м.<br/>Количество точек на 1 завод — 6 штук.",
     "Added respawn points for bots and vehicles for the base and cities.<br/>They can be built through the defense menu.<br/>Respawn point interaction radius from factory — 100 m.<br/>Number of points per factory — 6."],

    ["25.09.2026",
     "Добавлена автоматическая перезарядка боевой техники у складов БК, грузовиков и контейнеров с боекомплектом (радиус 25 м, время перезарядки 30 сек).",
     "Added automatic reararm for combat vehicles near ammo trucks, containers, and ammo depots (25 m radius, 30 sec recharge time)."],

    ["23.09.2026",
     "Исправлены баги в меню «Камера юнитов».",
     "Fixed bugs in the 'Unit Camera' menu."],

    ["29.03.2026",
     "1. Если в городе нет игрока в радиусе 800м.<br/>деактивация города увеличилась с 30 сек. до 30 мин.<br/><br/>2. Апгрейд завода тяжелой техники до 2 уровня сократился с 30 мин. до 5 мин.",
     "1. If there is no player in the city within an 800 meter radius, the city's deactivation time has increased from 30 seconds to 30 minutes.<br/><br/>2. Upgrading the heavy equipment factory to level 2 has been reduced from 30 minutes to 5 minutes."],

    ["01.04.2026",
     "ДОБАВЛЕНО:<br/><br/>1. Возможность перезарядки авиации<br/>2. Отображение на карте боекомплекта техники и ботов (наведи курсор на иконку техники или бота)",
     "ADD:<br/><br/>1. Added the ability to recharge aircraft<br/>2. Displaying equipment and bots on the map (hover the cursor over the equipment or bot icon)"],

    ["08.04.2026",
     "ДОБАВЛЕНО:<br/><br/>1. Артиллерия через планшет<br/>2. Удаление ботов через командное меню 0-8 (поддержка)",
     "ADD:<br/><br/>1. Artillery via tablet<br/>2. Removing bots via command menu 0-8 (support)"],

    ["13.04.2026",
     "ДОБАВЛЕНО:<br/><br/>1. Легкие турели в оборону города и на ремонтные автомобили, контейнеры<br/>2. Появилась возможность в обороне города, ремонтных машинах, ремонтных контейнерах поднимать на высоту турели, ограждения (теперь можно выставлять турели на крышах или на вышках)",
     "ADD:<br/><br/>1. Light turrets for the defense of the city and for repair vehicles, containers<br/>2. There was an opportunity, in the defense of the city, repair vehicles, raise turrets and fences to the height of repair containers (turrets can now be mounted on roofs or towers)"],

    ["14.05.2026",
     "ДОБАВЛЕНО:<br/><br/>Уменьшены цены на самолеты.",
     "ADD:<br/><br/>Reduced prices for airplanes."],

    ["19.07.2026",
     "1. В меню артиллерии исправлен баг стрельбы<br/><br/>2. Добавлено в список артиллерийских установок количество боеприпасов и расход боеприпасов<br/><br/>PS: артиллерия будет улучшаться и дорабатываться",
     "1. Fixed a shooting bug in the artillery menu<br/><br/>2. Added the number of ammunition and ammunition consumption to the artillery units list<br/><br/>PS: The artillery will be improved and modified."],

    ["26.07.2026",
     "Авиация:<br/><br/>1. Добавлена техника<br/>2. Снижены цены<br/>3. Исправлена загрузка БК",
     "Aviation:<br/><br/>1. Added vehicles<br/>2. Lowered prices<br/>3. Fixed ammunition loadout loading"],

    ["13.08.2026",
     "Добавлена авиация стороне Запад.<br/><br/>1. UH-80 Ghost Hawk (CTRG) — вариант Assault (штурмовой / транспортно-боевой)<br/>2. UH-80 Ghost Hawk DAP (CTRG) — вариант DAP (огневой поддержки / ударный)",
     "Added aviation to the West side<br/><br/>1. UH-80 Ghost Hawk (CTRG) — Assault variant (transport/assault)<br/>2. UH-80 Ghost Hawk DAP (CTRG) — DAP variant (fire support/attack)"],

    ["12.09.2026",
     "Добавлена новая механика.<br/><br/>Вышли из игры? Твоя армия не исчезнет.<br/>Купленные бойцы и техника остаются на месте последнего нахождения.<br/><br/>Бойцы:<br/>сохраняют свои позиции;<br/>могут перемещаться в радиусе 25 м от своей позиции;<br/>при атаке ищут укрытия и вступают в бой;<br/><br/>Техника:<br/>остаётся на месте;<br/>экипаж сохраняет свою машину.<br/><br/>Вернувшись на сервер, ты снова получаешь управление своей армией.<br/>Оставил армию — она продолжает держать позицию.<br/><br/>Армия привязана к конкретному слоту. Если ты играешь на слоте Альфа 1-1, твоя армия остаётся именно там. Но если ты перейдёшь на другой слот, например Альфа 1-2, ты можешь получить армию другого игрока, который играл на этом слоте раньше. В итоге ты будешь управлять уже чужой армией.",
     "A new mechanic has been added.<br/><br/>Left the game? Your army won't disappear.<br/>Purchased soldiers and vehicles remain at their last location.<br/><br/>Soldiers:<br/>keep their positions;<br/>can move within a 25 m radius of their position;<br/>when attacked, they seek cover and engage in combat;<br/><br/>Vehicles:<br/>remain in place;<br/>the crew keeps their vehicle.<br/><br/>When you return to the server, you regain control of your army.<br/>Left your army behind — it continues to hold its position.<br/><br/>The army is tied to a specific slot. If you're playing on slot Alpha 1-1, your army stays there. But if you switch to another slot, for example, Alpha 1-2, you might get the army of another player who played on that slot before. As a result, you'll be controlling someone else's army."],

    ["19.09.2026",
     "В конце миссии добавлен 3 минуты дебрифинг свободная камера, можно посмотреть обстановку.",
     "At the end of the mission, a 3-minute debriefing session is added, with a free camera so you can take a look at the situation."],

    ["21.09.2026",
     "У ботов обороны базы исправлен баг.<br/><br/>Добавлены в оборону базы корабельные установки:<br/>Praetorian 1C<br/>Mk49 Spartan<br/>Mk21 Centurion<br/>MK45 Hammer<br/>MK41 VLS",
     "The base defense bots have had a bug fixed.<br/><br/>The following ship-based installations have been added to the base defense:<br/>Praetorian 1C<br/>Mk49 Spartan<br/>Mk21 Centurion<br/>MK45 Hammer<br/>MK41 VLS"]
];

_changelog
