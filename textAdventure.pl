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

