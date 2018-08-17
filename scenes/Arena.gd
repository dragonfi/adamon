extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

const Utils = preload("res://scenes/utils.gd")

var player_adamon
var opponent_adamon

var attack_animation

var player_element = ""
var opponent_element = ""

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

func evaluate_turn():
	if player_element == "" or opponent_element == "":
		return
	player_adamon.take_damage(player_element)
	opponent_adamon.take_damage(opponent_element)
	
	attack_animation.play_attack(player_element, opponent_element)
	yield(attack_animation, "finished")

	if player_element == opponent_element:
		attack_animation.play_tie()
		yield(attack_animation, "finished")
		player_adamon.take_damage()
		opponent_adamon.take_damage()
		print("tie")
	elif Utils.is_stronger_element(player_element, opponent_element):
		attack_animation.play_player_wins()
		yield(attack_animation, "finished")
		opponent_adamon.take_damage()
		print(player_element + " wins")
	else:
		attack_animation.play_opponent_wins()
		yield(attack_animation, "finished")
		player_adamon.take_damage()
		print(opponent_element + " wins")
	player_element = ""
	opponent_element = ""
	player_adamon.clear_selection()
	opponent_adamon.clear_selection()

func _on_PlayerAdamon_select_element(element):
	print("player selected: ", element)
	player_element = element
	if opponent_element:
		evaluate_turn()
	

func _on_OpponentAdamon_select_element(element):
	print("opponent selected: ", element)
	opponent_element = element
	if player_element:
		evaluate_turn()
