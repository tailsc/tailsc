extends Node3D

# Variables
var is_flashlight_on = false

# Spotlight node
@onready var flashlight_spotlight: SpotLight3D = $flashlight/SpotLight3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Check for the "Interact" input to toggle the flashlight
	if Input.is_action_just_pressed("Interact"):
		toggle_flashlight()

# Toggle the flashlight on and off
func toggle_flashlight() -> void:
	is_flashlight_on = !is_flashlight_on
	flashlight_spotlight.visible = is_flashlight_on
	# You can add additional functionality here, such as adjusting intensity or color based on the flashlight state
