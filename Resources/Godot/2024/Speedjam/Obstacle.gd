extends Node3D

@onready var RockWall = preload("res://rock_wall.tscn").instantiate()
@onready var LeftWater = preload("res://LeftWater.tscn").instantiate()
@onready var RightWater = preload("res://RightWater.tscn").instantiate()
@onready var Anchor = preload("res://Anchor.tscn").instantiate()
@onready var Coral = preload("res://Coral.tscn").instantiate()

func _ready() -> void:
	_spawn_rng()


func _spawn_rng():
	var rng = randi_range(1, 10)
	if rng == 10:
		add_child(Coral)
	elif rng == 9:
		add_child(Anchor)
	elif  rng == 8:
		add_child(LeftWater)
	elif rng == 7:
		add_child(RightWater)
	else:
		add_child(RockWall)


func _on_area_3d_area_entered(area: Area3D) -> void:
	queue_free()
