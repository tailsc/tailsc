extends Node3D

signal solved
func activate():
	$AnimationPlayer.play("appear")
	
func deactivate():
	$AnimationPlayer.play("torch_down")
	emit_signal("solved")
