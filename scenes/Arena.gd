extends Node2D

const Elements = preload("res://scenes/elements.gd")

var player_adamon
var opponent_adamon

var attack_animation

var indicator_label
var restart_button

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
	
	indicator_label = get_node("IndicatorLabel")
	restart_button = get_node("RestartButton")
	
	reset_arena()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func reset_arena():
	indicator_label.hide()
	restart_button.hide()
	player_adamon.reset_with_element_counts(2, 2, 2)
	opponent_adamon.reset_with_element_counts(2, 2, 2)
	waiting_for_players = []
	state = ATTACK
	player_element = Elements.NONE
	opponent_element = Elements.NONE

func show_game_end_message(message):
	indicator_label.text = message
	indicator_label.show()
	restart_button.show()

func start_next_round():
	state = ATTACK
	player_adamon.clear_selection()
	opponent_adamon.clear_selection()
	check_end_conditions()

func check_end_conditions():
	print("checking conditions")
	print("controls:", player_adamon.controls_are_disabled, opponent_adamon.controls_are_disabled)
	var all_controls_are_disabled = player_adamon.controls_are_disabled and opponent_adamon.controls_are_disabled
	if player_adamon.has_fainted and opponent_adamon.has_fainted:
		print("both adamons fainted, it's a tie")
		show_game_end_message("It's a tie!")
	elif player_adamon.has_fainted and all_controls_are_disabled:
		print("player adamon fainted, opponent won")
		show_game_end_message("Opponent wins!")
	elif opponent_adamon.has_fainted and all_controls_are_disabled:
		print("opponent adamon fainted, player won")
		show_game_end_message("Player wins!")
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
		if player_adamon.has_fainted:
			opponent_adamon.ai_select_discard()
		check_end_conditions()

	elif Elements.is_stronger_element(player_element, opponent_element):
		attack_animation.play_player_wins()
		yield(attack_animation, "finished")
		
		print("player wins")
		state = DISCARD
		waiting_for_players = [OPPONENT]
		opponent_adamon.clear_selection()
		opponent_adamon.ai_select_discard()
		check_end_conditions()
		
	else:
		attack_animation.play_opponent_wins()
		yield(attack_animation, "finished")
		
		print("opponent wins")
		state = DISCARD
		waiting_for_players = [PLAYER]
		player_adamon.clear_selection()
		check_end_conditions()
		
	player_element = Elements.NONE
	opponent_element = Elements.NONE

func _on_PlayerAdamon_select_element(element):
	if state == ATTACK:
		print("player selected: ", element)
		player_element = element
		if opponent_element:
			evaluate_turn()
		else:
			opponent_adamon.ai_select_attack()
	elif state == DISCARD:
		attack_animation.play_player_explosion()
		player_adamon.take_damage(element)
		player_adamon.enable_buttons()
		player_adamon.disable_buttons()
		waiting_for_players.erase(PLAYER)
		print("waiting_for_players", waiting_for_players)
		check_end_conditions()
		if waiting_for_players.empty():
			start_next_round()
		else:
			opponent_adamon.ai_select_discard()

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
		check_end_conditions()
		if waiting_for_players.empty():
			start_next_round()

func _on_RestartButton_pressed():
	reset_arena()
