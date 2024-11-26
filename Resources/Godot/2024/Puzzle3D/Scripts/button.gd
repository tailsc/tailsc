extends StaticBody3D

@export var activation_node = "doors"
@export var text1 = "Give me a cube!"
@export var text2 = "Press me!"
@export var activation_var = false
@export var state = "closed"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func text():
	if activation_var:
		return String(text2)
	else:
		return String(text1)
func pressed():
	if state == "closed":
		get_node(activation_node).activate()
		state = "open"
	else:
		state = "closed"
		get_node(activation_node).deactivate()
func activate():
	activation_var = true
	print("true")

func deactvate(body):
	activation_var = false
	print("false")
