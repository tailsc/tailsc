extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("Level_Spin")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_interactable_interacted(interactor: Interactor) -> void:
	get_tree().change_scene_to_file("res://[02] Scenes/Levels/demo_level.tscn")
