extends CharacterBody3D

@onready var nav_agent_3d: NavigationAgent3D = $NavigationAgent3D

var SPEED = 3.0
var target_name = ""

func _physics_process(delta: float) -> void:
	var current_location = global_transform.origin
	var next_location = nav_agent_3d.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	nav_agent_3d.set_velocity(new_velocity)


func update_target_location(target_location):
	nav_agent_3d.set_target_position(target_location)


func _on_navigation_agent_3d_target_reached() -> void:
	print("In range!")

	var character_body = get_parent().get_node("Player").character  # Assuming character is a path
	if character_body:
		character_body.call("decrease_health", 1)  # Call decrease_health with amount set to 1
	else:
		print("CharacterBody3D node not found!")

func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = velocity.move_toward(safe_velocity, .25)
	move_and_slide()
