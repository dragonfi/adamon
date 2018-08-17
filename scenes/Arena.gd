extends Node2D

const Elements = preload("res://scenes/elements.gd")

var player_adamon
var opponent_adamon

var attack_animation

var player_element = Elements.NONE
var opponent_element = Elements.NONE

enum GameState {ATTACK, DISCARD}
var state = ATTACK

enum Players {PLAYER, OPPONENT}
var waiting_for_players = [PLAYER, OPPONENT]

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	player_adamon = get_node("PlayerAdamon")
	opponent_adamon = get_node("OpponentAdamon")
	
	attack_animation = get_node("AttackAnimation")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func start_next_round():
	state = ATTACK
	player_adamon.clear_selection()
	opponent_adamon.clear_selection()
	check_end_conditions()

func check_for_tie():
	if player_adamon.has_fainted and opponent_adamon.has_fainted:
		print("both adamons fainted, it's a tie")
		return true
	return false

func check_end_conditions():
	if check_for_tie():
		pass
	elif player_adamon.has_fainted:
		print("player adamon fainted, opponent won")
	elif opponent_adamon.has_fainted:
		print("opponent adamon fainted, player won")
	else:
		return

func evaluate_turn():
	if player_element == Elements.NONE or opponent_element == Elements.NONE:
		return
	player_adamon.take_damage(player_element)
	opponent_adamon.take_damage(opponent_element)
	
	attack_animation.play_attack(player_element, opponent_element)
	yield(attack_animation, "finished")

	if player_element == opponent_element:
		attack_animation.play_tie()
		yield(attack_animation, "finished")
		
		print("tie")
		state = DISCARD
		waiting_for_players = [PLAYER, OPPONENT]
		player_adamon.clear_selection()
		opponent_adamon.clear_selection()

		
	elif Elements.is_stronger_element(player_element, opponent_element):
		attack_animation.play_player_wins()
		yield(attack_animation, "finished")
		
		print("player wins")
		state = DISCARD
		waiting_for_players = [OPPONENT]
		opponent_adamon.clear_selection()
		
	else:
		attack_animation.play_opponent_wins()
		yield(attack_animation, "finished")
		
		print("opponent wins")
		state = DISCARD
		waiting_for_players = [PLAYER]
		player_adamon.clear_selection()
		
	player_element = Elements.NONE
	opponent_element = Elements.NONE

func _on_PlayerAdamon_select_element(element):
	if state == ATTACK:
		print("player selected: ", element)
		player_element = element
		if opponent_element:
			evaluate_turn()
	elif state == DISCARD:
		attack_animation.play_player_explosion()
		player_adamon.take_damage(element)
		player_adamon.enable_buttons()
		player_adamon.disable_buttons()
		waiting_for_players.erase(PLAYER)
		print("waiting_for_players", waiting_for_players)
		if waiting_for_players.empty():
			start_next_round()

func _on_OpponentAdamon_select_element(element):
	if state == ATTACK:
		print("opponent selected: ", element)
		opponent_element = element
		if player_element:
			evaluate_turn()
	elif state == DISCARD:
		attack_animation.play_opponent_explosion()
		opponent_adamon.take_damage(element)
		opponent_adamon.enable_buttons()
		opponent_adamon.disable_buttons()
		waiting_for_players.erase(OPPONENT)
		print("waiting_for_players", waiting_for_players)
		if waiting_for_players.empty():
			start_next_round()

func _on_OpponentAdamon_fainted():
	check_for_tie()

func _on_PlayerAdamon_fainted():
	check_for_tie()
