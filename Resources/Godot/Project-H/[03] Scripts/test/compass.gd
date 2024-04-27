@tool
extends Node3D

@onready var pointer: MeshInstance3D = $compass/Pointer
@onready var target: MeshInstance3D = $Target

# Main function to update the compass rotation
func _process(delta):
	# Calculate the direction from the pointer to the target
	var direction_to_target = (target.global_transform.origin - pointer.global_transform.origin).normalized()
	
	# Calculate the angle for rotation around the y-axis
	var angle_y = atan2(direction_to_target.x, direction_to_target.z)
	
	# Apply rotation to the pointer around the y-axis with an additional 90 degrees offset
	pointer.rotation_degrees.y = rad_to_deg(angle_y) + 90
