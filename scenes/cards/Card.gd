extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
signal selected

export var counter = 2
export var inactive = false
var selected = false

var animation
var label_animation
var button
var label

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	button = get_node("CenterContainer/TextureButton")
	animation = get_node("CenterContainer/TextureButton/AnimationPlayer")
	label = get_node("CenterContainer/TextureButton/Label")
	label_animation = get_node("CenterContainer/TextureButton/Label/AnimationPlayer")
	if inactive:
		button.disabled = true
	update_counter(counter)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func update_counter(count):
	counter = count
	label.text = str(counter)
	if counter <= 0:
		button.disabled = true
	label_animation.queue("UpdateLabel")

func disable():
	button.disabled = true

func enable():
	button.disabled = false
	if selected:
		selected = false
		animation.queue("DeselectButton")

func _on_TextureButton_mouse_entered():
	if button.disabled:
		return
	animation.queue("HoverButton")


func _on_TextureButton_mouse_exited():
	if button.disabled:
		return
	animation.queue("UnhoverButton")


func _on_TextureButton_pressed():
	selected = true
	animation.queue("SelectButton")
	emit_signal("selected")
