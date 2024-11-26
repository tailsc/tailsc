extends Node3D

@onready var level_1: Node3D = $Level_1
@onready var level_2: Node3D = $Level_2
@onready var level_3: Node3D = $Level_3
@onready var level_4: Node3D = $Level_4
@onready var level_5: Node3D = $Level_5


var current_level_index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_interactable_interacted(interactor: Interactor) -> void:
	# Check if we're at the last level
	if current_level_index == 4:  # Adjusted index to account for starting level
		return  # Do nothing if already at the last level

	# Increment the index
	current_level_index += 1

	# Hide the previous level (if applicable)
	if current_level_index > 0:
		get_node("Level_" + str(current_level_index)).hide()

	# Show the current level based on the index (adjusted for starting level)
	match current_level_index:
		1:
			level_2.show()
		2:
			level_3.show()
		3:
			level_4.show()
		4:
			level_5.show()
