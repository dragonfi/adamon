extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
signal select_element

var elements = ["nature", "machine", "waste"]

var cards

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	cards = {
		"nature": get_node("Hand/NatureCard"),
		"machine": get_node("Hand/MachineCard"),
		"waste": get_node("Hand/WasteCard")
		}
	pass

func random_choice(dict):
	var values = dict.values()
	return values[randi() % len(values)]

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func disable_buttons():
	for key in cards:
		cards[key].disable()

func enable_buttons():
	for key in cards:
		cards[key].enable()

func take_damage(element = ""):
	var card = cards[element] if element else random_choice(cards)
	card.update_counter(card.counter - 1)

func clear_selection():
	enable_buttons()
	

func _on_NatureCard_selected():
	disable_buttons()
	emit_signal("select_element", "nature")

func _on_MachineCard_selected():
	disable_buttons()
	emit_signal("select_element", "machine")

func _on_WasteCard_selected():
	disable_buttons()
	emit_signal("select_element", "waste")
