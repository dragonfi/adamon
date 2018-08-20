extends "res://scenes/Adamon.gd"

var choice_handlers

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	._ready()
	.disable_buttons()
	
	choice_handlers = {
		Elements.NATURE: funcref(self, "_on_NatureCard_selected"),
		Elements.MACHINE: funcref(self, "_on_MachineCard_selected"),
		Elements.WASTE: funcref(self, "_on_WasteCard_selected")
	}

func random_choice(values):
	return values[randi() % len(values)]

func select_random_element():
	var valid_choices = []
	for element in cards:
		for index in range(0, cards[element].counter):
			valid_choices.append(choice_handlers[element])
	#print(valid_choices)
	random_choice(valid_choices).call_func()

func ai_select_attack():
	if controls_are_disabled:
		print("Should choose attack element, but controls are disabled")
	select_random_element()

func ai_select_discard():
	if controls_are_disabled:
		print("Should choose discard element, but controls are disabled")
		return
	select_random_element()

func disable_buttons():
	controls_are_disabled = true

func enable_buttons():
	var still_have_controls = false
	for key in cards:
		still_have_controls = still_have_controls or cards[key].counter > 0
	controls_are_disabled = not still_have_controls

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
