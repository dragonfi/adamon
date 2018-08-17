extends AnimationPlayer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

signal finished

var player_attack
var opponent_attack

var element_sprites = {
	"nature": "res://images/nature.png",
	"machine": "res://images/gear.png",
	"waste": "res://images/radioactive.png"
}

func _ready():
	player_attack = get_node("PlayerAttack")
	opponent_attack = get_node("OpponentAttack")
	
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

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
