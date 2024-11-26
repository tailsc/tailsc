extends Node3D
func _ready():
	pass
func activate():
	$AnimationPlayer.play("open")
func deactivate():
	$AnimationPlayer.play_backwards("open")
