:- dynamic(player_location/1).
:- dynamic(player_health/1).
:- dynamic(player_money/1).
:- dynamic(player_weapon/1).
:- dynamic(player_armor/1).
:- dynamic(ghost_saved/1).
:- dynamic(room_cleared/1).
:- dynamic(game_won/1).

init_game :-
    set_seed(12345),
    randomize,
    retractall(player_location(_)),
    retractall(player_health(_)),
    retractall(player_money(_)),
    retractall(player_weapon(_)),
    retractall(player_armor(_)),
    retractall(ghost_saved(_)),
    retractall(room_cleared(_)),
    retractall(game_won(_)),
    asserta(player_location(entrance)),
    asserta(player_health(100)),
    asserta(player_money(500)),
    asserta(player_weapon(basic_pistol)),
    asserta(player_armor(light_jacket)),
    asserta(ghost_saved(false)),
    asserta(game_won(false)).



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
armor(cyber_armor, 'Cyber Armor', 25, 1000).
armor(stealth_suit, 'Stealth Suit', 20, 1200).

%(type, name, max_health, damage, reward)
enemy_type(security_drone, 'Security Drone', 30, 12, 100).
enemy_type(attack_drone, 'Attack Drone', 50, 20, 150).
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
    