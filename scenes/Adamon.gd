extends Node2D

const Elements = preload("res://scenes/elements.gd")

signal select_element
signal fainted

var controls_are_disabled = false
var has_fainted = false
var cards

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	cards = {
		Elements.NATURE: get_node("Hand/NatureCard"),
		Elements.MACHINE: get_node("Hand/MachineCard"),
		Elements.WASTE: get_node("Hand/WasteCard")
	}

func reset_with_element_counts(nature, machine, waste):
	cards[Elements.NATURE].update_counter(nature)
	cards[Elements.MACHINE].update_counter(machine)
	cards[Elements.WASTE].update_counter(waste)
	
	has_fainted = false
	
	clear_selection()


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func disable_buttons():
	controls_are_disabled = true
	for key in cards:
		cards[key].disable()

func enable_buttons():
	var still_have_controls = false
	for key in cards:
		var new_status = cards[key].enable()
		still_have_controls = still_have_controls or new_status
	controls_are_disabled = not still_have_controls

func take_damage(element = Elements.NONE):
	var card = cards[element] if element != Elements.NONE else random_choice(cards)
	card.update_counter(card.counter - 1)

func clear_selection():
	enable_buttons()

func _on_NatureCard_selected():
	disable_buttons()
	emit_signal("select_element", Elements.NATURE)

func _on_MachineCard_selected():
	disable_buttons()
	emit_signal("select_element", Elements.MACHINE)

func _on_WasteCard_selected():
	disable_buttons()
	emit_signal("select_element", Elements.WASTE)


func _on_counter_reached_zero():
	var can_still_fight = false
	for element in cards:
		can_still_fight = can_still_fight or cards[element].counter > 0
	if not can_still_fight:
		has_fainted = true
		emit_signal("fainted")
