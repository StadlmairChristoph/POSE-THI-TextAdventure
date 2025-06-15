:- dynamic(player_location/1).
:- dynamic(player_health/1).
:- dynamic(player_money/1).
:- dynamic(player_weapon/1).
:- dynamic(player_armor/1).
:- dynamic(ghost_saved/1).
:- dynamic(room_cleared/1).
:- dynamic(game_won/1).
:- dynamic(room_enemy/4).

init_game :-
    set_seed(23456),
    randomize,
    retractall(player_location(_)),
    retractall(player_health(_)),
    retractall(player_money(_)),
    retractall(player_weapon(_)),
    retractall(player_armor(_)),
    retractall(ghost_saved(_)),
    retractall(room_cleared(_)),
    retractall(game_won(_)),
    retractall(room_enemy(_, _, _, _)),
    asserta(player_location(entrance)),
    asserta(player_health(100)),
    asserta(player_money(500)),
    asserta(player_weapon(basic_pistol)),
    asserta(player_armor(light_jacket)),
    asserta(ghost_saved(false)),
    asserta(game_won(false)),
    spawn_initial_enemies.

spawn_initial_enemies :-
    % Entrance: 2 security drones
    asserta(room_enemy(entrance, 1, security_drone, 30)),
    asserta(room_enemy(entrance, 2, security_drone, 30)),
    
    % Lobby: 1 security drone
    asserta(room_enemy(lobby, 3, security_drone, 30)),
    
    % Security Hub: 1 attack drone
    asserta(room_enemy(security_hub, 4, attack_drone, 50)),
    
    % Server Room: 2 security drones
    asserta(room_enemy(server_room, 5, security_drone, 30)),
	asserta(room_enemy(server_room, 6, security_drone, 30)),
    
    % Ghost Trap: 3 attack drones
    asserta(room_enemy(ghost_trap, 7, attack_drone, 50)),
    asserta(room_enemy(ghost_trap, 8, attack_drone, 50)),
    
    % Data Core: 1 Aegis-9
    asserta(room_enemy(data_core, 9, aegis_9, 200)).

room(entrance, 'Zenith Corporation - Main Entrance', 
     'Neon lights flicker across the corporate plaza. Security drones patrol overhead.').
room(lobby, 'Corporate Lobby', 
     'A sterile lobby with holographic displays. Corporate music plays softly.').
room(security_hub, 'Security Hub', 
     'Banks of monitors show surveillance feeds. Warning lights flash red.').
room(nova_shop, 'Nova\'s Black Market Den', 
     'Hidden behind false walls, Nova\'s cybernetic shop gleams with illegal tech.').
room(server_room, 'Server Farm', 
     'Humming servers stretch into darkness. Data streams flow like digital rivers.').
room(ghost_trap, 'Detention Cell Block', 
     'Ghost is trapped here, surrounded by attack drones. Time is running out.').
room(data_core, 'Zenith Data Core', 
     'The heart of corporate power. Aegis-9\'s presence fills the air like electric death.').

%(name, damage, cost)
weapon(basic_pistol, 'Basic Pistol', 15, 0).
weapon(plasma_rifle, 'Plasma Rifle', 35, 800).
weapon(neural_disruptor, 'Neural Disruptor', 50, 1200).
weapon(cyber_katana, 'Cyber Katana', 45, 1000).
weapon(ion_cannon, 'Ion Cannon', 60, 1500).

%(name, protection, cost)
armor(light_jacket, 'Light Jacket', 5, 0).
armor(kevlar_vest, 'Kevlar Vest', 15, 600).
armor(stealth_suit, 'Stealth Suit', 20, 800).
armor(cyber_armor, 'Cyber Armor', 25, 1000).

%(type, name, max_health, damage, reward)
enemy_type(security_drone, 'Security Drone', 30, 12, 150).
enemy_type(attack_drone, 'Attack Drone', 40, 25, 200).
enemy_type(aegis_9, 'Aegis-9 AI Core', 200, 40, 2000).

%(current_room, direction, connected_room)
connected(entrance, north, lobby).
connected(lobby, south, entrance).
connected(lobby, east, security_hub).
connected(lobby, west, nova_shop).
connected(lobby, north, server_room).
connected(security_hub, west, lobby).
connected(security_hub, north, ghost_trap).
connected(nova_shop, east, lobby).
connected(server_room, south, lobby).
connected(server_room, north, data_core).
connected(ghost_trap, south, security_hub).
connected(ghost_trap, north, data_core).
connected(data_core, south, server_room).

start_game :-
    init_game,
    write('========================================='), nl,
    write('    NEON SHADOW: INFILTRATION PROTOCOL'), nl,
    write('========================================='), nl,
    write('Neo-Tokyo Prime, 2093'), nl,
    write('The neon-soaked streets buzz with corporate oppression.'), nl,
    write('You are ONI, elite netrunner on a mission to infiltrate'), nl,
    write('Zenith Corporation and shut down their surveillance grid.'), nl,
    write('========================================='), nl, nl,
    display_status,
    look_around,
    game_loop.

game_loop :-
	nl,
    game_won(true),
    write('MISSION ACCOMPLISHED!'), nl,
    write('You have shut down Aegis-9 and freed Neo-Tokyo Prime!'), nl,
    !.
game_loop :-
	nl,
    player_health(Health),
    Health =< 0,
    write('GAME OVER - You have been eliminated by corporate security.'), nl,
    write('Your digital ghost fades into the neon void...'), nl,
    !.
game_loop :-
    nl,
    write('What do you want to do?'), nl,
    show_actions,
    write('> '),
    read(Action),
    process_action(Action),
	write('--------------------------------------------------------------------'),
    game_loop.

display_status :-
    player_health(Health),
    player_money(Money),
    player_weapon(WeaponCode),
    player_armor(ArmorCode),
    weapon(WeaponCode, WeaponName, _, _),
    armor(ArmorCode, ArmorName, _, _),
    write('STATUS: Health: '), write(Health),
    write(' | Money: '), write(Money), write(' credits'),
    write(' | Weapon: '), write(WeaponName),
    write(' | Armor: '), write(ArmorName), nl.

look_around :-
    player_location(Location),
    room(Location, Name, Description),
    write('LOCATION: '), write(Name), nl,
    write(Description), nl,
    check_enemies(Location),
    check_special_room(Location).

show_actions :-
    write('ACTIONS:'), nl,
    show_movement_actions,
    show_combat_actions,
    show_special_actions,
    write('- status (check your status)'), nl,
    write('- quit (exit game)'), nl.

show_movement_actions :-
    player_location(Current),
    write('MOVE: '),
    findall(Direction, connected(Current, Direction, _), Directions),
    show_directions(Directions).

show_directions([]).
show_directions([Dir|Rest]) :-
	player_location(Current),
	connected(Current, Dir, Next),
    write(Dir), write(' ('), write(Next), write('), '),
    show_directions(Rest).

show_combat_actions :-
    player_location(Location),
    has_enemies(Location),
    write('COMBAT: attack, hack'), nl.
show_combat_actions.

show_special_actions :-
    player_location(nova_shop),
    write('SHOP: buy_weapon, buy_armor'), nl.
show_special_actions :-
    player_location(ghost_trap),
    ghost_saved(false),
    write('RESCUE: save_ghost'), nl.
show_special_actions :-
    player_location(data_core),
    \+ has_enemies(data_core),
    write('MISSION: shutdown_core'), nl.
show_special_actions.

process_action(north) :- move(north).
process_action(south) :- move(south).
process_action(east) :- move(east).
process_action(west) :- move(west).
process_action(attack) :- combat_attack.
process_action(hack) :- combat_hack.
process_action(buy_weapon) :- shop_buy_weapon.
process_action(buy_armor) :- shop_buy_armor.
process_action(save_ghost) :- rescue_ghost.
process_action(shutdown_core) :- shutdown_data_core.
process_action(status) :- display_status.
process_action(quit) :- 
    write('Thanks for playing NEON SHADOW!'), nl,
    halt.
process_action(_) :-
    write('Invalid action. Try again.'), nl.

move(Direction) :-
    player_location(Current),
    connected(Current, Direction, Destination),
    has_enemies(Current),
    write('You cannot leave while enemies are present!'), nl,
    !.
move(Direction) :-
    player_location(Current),
    connected(Current, Direction, Destination),
    retract(player_location(Current)),
    asserta(player_location(Destination)),
    write('You move '), write(Direction), write('.'), nl,
    look_around,
    !.
move(_) :-
    write('You cannot go that way.'), nl.

has_enemies(Room) :-
    room_enemy(Room, _, _, _), !.

count_enemies(Room, Count) :-
    findall(Enemy, room_enemy(Room, Enemy, _, _), Enemies),
    length(Enemies, Count).

check_enemies(Location) :-
    count_enemies(Location, Count),
    Count > 0,
    write('THREAT DETECTED: '), write(Count), 
    (Count =:= 1 -> write(' enemy') ; write(' enemies')),
    write(' in this area!'), nl,
    list_enemies(Location),
    !.
check_enemies(_) :-
    write('Area secure - no enemies detected.'), nl.

list_enemies(Room) :-
    forall(room_enemy(Room, EnemyId, EnemyType, Health),
           (enemy_type(EnemyType, EnemyName, _, _, _),
            write('- '), write(EnemyName), write(' ('), write(EnemyId), 
            write(', Health: '), write(Health), write(')'), nl)).

check_special_room(nova_shop) :-
    write('Nova grins behind her cybernetic visor: "Need some hardware, choom?"'), nl.
check_special_room(ghost_trap) :-
    ghost_saved(false),
    has_enemies(ghost_trap),
    write('Ghost is pinned down by attack drones! He needs immediate rescue!'), nl.
check_special_room(ghost_trap) :-
    ghost_saved(false),
    \+ has_enemies(ghost_trap),
    write('The area is clear. You can rescue Ghost now!'), nl.
check_special_room(ghost_trap) :-
    ghost_saved(true),
    write('This detention block is now empty.'), nl.
check_special_room(data_core) :-
    \+ has_enemies(data_core),
    write('The data core hums with vulnerable energy. Time to shut it down!'), nl.
check_special_room(_).

combat_attack :-
    player_location(Location),
    \+ has_enemies(Location),
    write('No enemies to attack.'), nl,
    !.
combat_attack :-
    player_location(Location),
    write('Select target: '), nl,
    list_enemies(Location),
    write('Enter enemy ID: '),
    read(TargetId),
    attack_enemy(Location, TargetId).

attack_enemy(Location, TargetId) :-
    room_enemy(Location, TargetId, EnemyType, CurrentHealth),
    enemy_type(EnemyType, EnemyName, _, _, _),
    player_weapon(WeaponCode),
    weapon(WeaponCode, WeaponName, WeaponDamage, _),
    write('You attack '), write(EnemyName), write(' ('), write(TargetId), 
    write(') with '), write(WeaponName), write('!'), nl,
    NewHealth is CurrentHealth - WeaponDamage,
    (   NewHealth =< 0 ->
        defeat_enemy(Location, TargetId, EnemyType)
    ;   % Update enemy health
        retract(room_enemy(Location, TargetId, EnemyType, CurrentHealth)),
        asserta(room_enemy(Location, TargetId, EnemyType, NewHealth)),
        write('The '), write(EnemyName), write(' takes '), write(WeaponDamage), 
        write(' damage! (Health: '), write(NewHealth), write(')'), nl,
        all_enemies_counterattack(Location)
    ).
attack_enemy(_, TargetId) :-
    write('Invalid target: '), write(TargetId), nl.

combat_hack :-
    player_location(Location),
    \+ has_enemies(Location),
    write('No systems to hack.'), nl,
    !.
combat_hack :-
    player_location(Location),
    write('Select target to hack: '), nl,
    list_enemies(Location),
    write('Enter enemy ID: '),
    read(TargetId),
    hack_enemy(Location, TargetId).

hack_enemy(Location, TargetId) :-
    room_enemy(Location, TargetId, EnemyType, _),
    enemy_type(EnemyType, EnemyName, _, _, _),
    random_hack_roll(Roll),
    write('Attempting to hack '), write(EnemyName), write(' ('), write(TargetId), write(')...'), nl,
    (   Roll >= 6 ->
        write('Hack successful! You disable the '), write(EnemyName), write('!'), nl,
        defeat_enemy(Location, TargetId, EnemyType)
    ;   write('Hack failed! (Rolled '), write(Roll), write('/10)'), nl,
        all_enemies_counterattack(Location)
    ).
hack_enemy(_, TargetId) :-
    write('Invalid target: '), write(TargetId), nl.

all_enemies_counterattack(Location) :-
    findall(EnemyType, room_enemy(Location, _, EnemyType, _), EnemyTypes),
    counterattack_sequence(EnemyTypes).

counterattack_sequence([]).
counterattack_sequence([EnemyType|Rest]) :-
    enemy_type(EnemyType, EnemyName, _, Damage, _),
    write('The '), write(EnemyName), write(' retaliates!'), nl,
    player_armor(ArmorCode),
    armor(ArmorCode, _, Protection, _),
    ActualDamage is max(1, Damage - Protection),
    player_health(CurrentHealth),
    NewHealth is CurrentHealth - ActualDamage,
    retract(player_health(CurrentHealth)),
    asserta(player_health(NewHealth)),
    write('You take '), write(ActualDamage), write(' damage!'), nl,
    counterattack_sequence(Rest).

defeat_enemy(Location, EnemyId, EnemyType) :-
    enemy_type(EnemyType, EnemyName, _, _, Reward),
    retract(room_enemy(Location, EnemyId, EnemyType, _)),
    player_money(CurrentMoney),
    NewMoney is CurrentMoney + Reward,
    retract(player_money(CurrentMoney)),
    asserta(player_money(NewMoney)),
    write(EnemyName), write(' ('), write(EnemyId), write(') destroyed! '),
    write('You earned '), write(Reward), write(' credits.'), nl,
    
    (   \+ has_enemies(Location) ->
        write('Area secured!'), nl
    ;   true
    ).

shop_buy_weapon :-
    player_location(nova_shop),
    write('NOVA\'S WEAPON INVENTORY:'), nl,
    write('1. Plasma Rifle - 800 credits (35 damage)'), nl,
    write('2. Neural Disruptor - 1200 credits (50 damage)'), nl,
    write('3. Cyber Katana - 1000 credits (45 damage)'), nl,
    write('4. Ion Cannon - 1500 credits (60 damage)'), nl,
    write('Enter weapon number (1-4): '),
    read(Choice),
    buy_weapon_choice(Choice).
shop_buy_weapon :-
    write('You can only shop at Nova\'s den.'), nl.

buy_weapon_choice(1) :- attempt_purchase(plasma_rifle).
buy_weapon_choice(2) :- attempt_purchase(neural_disruptor).
buy_weapon_choice(3) :- attempt_purchase(cyber_katana).
buy_weapon_choice(4) :- attempt_purchase(ion_cannon).
buy_weapon_choice(_) :- write('Invalid choice.'), nl.

shop_buy_armor :-
    player_location(nova_shop),
    write('NOVA\'S ARMOR INVENTORY:'), nl,
    write('1. Kevlar Vest - 600 credits (15 protection)'), nl,
	write('2. Stealth Suit - 800 credits (20 protection)'), nl,
    write('3. Cyber Armor - 1000 credits (25 protection)'), nl,
    write('Enter armor number (1-3): '),
    read(Choice),
    buy_armor_choice(Choice).
shop_buy_armor :-
    write('You can only shop at Nova\'s den.'), nl.

buy_armor_choice(1) :- attempt_purchase(kevlar_vest).
buy_armor_choice(2) :- attempt_purchase(stealth_suit).
buy_armor_choice(3) :- attempt_purchase(cyber_armor).
buy_armor_choice(_) :- write('Invalid choice.'), nl.

attempt_purchase(ItemCode) :-
    weapon(ItemCode, ItemName, _, Cost),
    player_money(Money),
    Money >= Cost,
    retract(player_money(Money)),
    NewMoney is Money - Cost,
    asserta(player_money(NewMoney)),
    retract(player_weapon(_)),
    asserta(player_weapon(ItemCode)),
    write('You purchased '), write(ItemName), write('!'), nl,
    !.
attempt_purchase(ItemCode) :-
    armor(ItemCode, ItemName, _, Cost),
    player_money(Money),
    Money >= Cost,
    retract(player_money(Money)),
    NewMoney is Money - Cost,
    asserta(player_money(NewMoney)),
    retract(player_armor(_)),
    asserta(player_armor(ItemCode)),
    write('You purchased '), write(ItemName), write('!'), nl,
    !.
attempt_purchase(_) :-
    write('Not enough credits for that item.'), nl.

rescue_ghost :-
    player_location(ghost_trap),
    ghost_saved(false),
    \+ has_enemies(ghost_trap),
    retract(ghost_saved(false)),
    asserta(ghost_saved(true)),
    write('You successfully rescue Ghost from the detention cell!'), nl,
    write('Ghost: "Oni! Perfect timing. I owe you one, choom."'), nl,
    player_health(CurrentHealth),
    NewHealth is min(100, CurrentHealth + 30),
    retract(player_health(CurrentHealth)),
    asserta(player_health(NewHealth)),
    write('Ghost treats your wounds. Health restored!'), nl,
    !.
rescue_ghost :-
    player_location(ghost_trap),
    ghost_saved(true),
    write('Ghost has already been rescued.'), nl,
    !.
rescue_ghost :-
    player_location(ghost_trap),
    write('You must defeat all the attack drones first!'), nl,
    !.
rescue_ghost :-
    write('Ghost is not here.'), nl.

shutdown_data_core :-
    player_location(data_core),
    \+ has_enemies(data_core),
    write('You access the main terminal and begin the shutdown sequence...'), nl,
    write('AEGIS-9: "IMPOSSIBLE... SYSTEMS... FAILING..."'), nl,
    write('The data core goes dark. Corporate surveillance grid OFFLINE!'), nl,
    write('Neon lights flicker across the city as freedom returns to Neo-Tokyo Prime!'), nl,
    asserta(game_won(true)),
    !.
shutdown_data_core :-
    player_location(data_core),
    write('You must defeat Aegis-9 first!'), nl,
    !.
shutdown_data_core :-
    write('You are not at the data core.'), nl.

random_hack_roll(Result) :-
    random(1, 11, Result).

main :-
    write('Welcome to NEON SHADOW: INFILTRATION PROTOCOL'), nl,
    write('Type "start_game." to begin your mission.'), nl.

:- initialization(main).