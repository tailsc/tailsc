extends Node

var z_position = 20 # Spawn Pos
const Z_INCREMENT = 5.5  # Increase for distance between

@onready var Obstacle = preload("res://Obstacle.tscn").instantiate()


func _on_timer_timeout() -> void:
	$Spawner.start()
	
	var Obstacle = preload("res://Obstacle.tscn").instantiate()
	Obstacle.position.x = randf_range(-3.0, 3.0)
	Obstacle.position.z = z_position
	z_position += Z_INCREMENT
	add_child(Obstacle)
	
	var Rockwall = preload("res://Rock.tscn").instantiate()
	Rockwall.position.x = 0.0
	Rockwall.position.z = z_position
	add_child(Rockwall)
	
