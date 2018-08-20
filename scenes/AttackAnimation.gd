extends AnimationPlayer

const Elements = preload("res://scenes/elements.gd")

signal finished

var player_attack
var opponent_attack

var player_animation_player
var opponent_animation_player

var element_sprites = {
	Elements.NATURE: "res://images/nature.png",
	Elements.MACHINE: "res://images/gear.png",
	Elements.WASTE: "res://images/radioactive.png"
}

func _ready():
	player_attack = get_node("PlayerAttack")
	opponent_attack = get_node("OpponentAttack")
	
	player_animation_player = get_node("PlayerAttack/AnimationPlayer")
	opponent_animation_player = get_node("OpponentAttack/AnimationPlayer")
	
	player_attack.modulate = Color(1, 1, 1, 0)
	opponent_attack.modulate = Color(1, 1, 1, 0)
	
func play_attack(player_element, opponent_element):
	player_attack.texture = load(element_sprites[player_element])
	opponent_attack.texture = load(element_sprites[opponent_element])
	play("MutualAttack")
	yield(self, "animation_finished")
	emit_signal("finished")
	
func play_tie():
	play("Tie")
	yield(self, "animation_finished")
	emit_signal("finished")
	
func play_player_wins():
	play("PlayerWins")
	yield(self, "animation_finished")
	emit_signal("finished")
	
func play_opponent_wins():
	play("OpponentWins")
	yield(self, "animation_finished")
	emit_signal("finished")

func play_player_explosion():
	opponent_animation_player.play("Explosion")

func play_opponent_explosion():
	player_animation_player.play("Explosion")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
