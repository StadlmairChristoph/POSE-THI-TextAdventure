:- dynamic(player_location/1).
:- dynamic(player_health/1).
:- dynamic(player_money/1).
:- dynamic(player_weapon/1).
:- dynamic(player_armor/1).
:- dynamic(ghost_saved/1).
:- dynamic(room_cleared/1).
:- dynamic(game_won/1).

init_game :-
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

