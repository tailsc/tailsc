extends Node3D

@onready var pointer = $Fish
@onready var target: MeshInstance3D = $Target

func _process(delta: float) -> void:
	# Calculate the direction from the pointer to the target
	var direction_to_target = (target.global_transform.origin - pointer.global_transform.origin).normalized()
	
	# Calculate the angle for rotation around the y-axis
	var angle_y = atan2(direction_to_target.x, direction_to_target.z)
	
	# Apply rotation to the pointer around the y-axis with an additional 90 degrees offset
	pointer.rotation_degrees.y = rad_to_deg(angle_y) + 90
