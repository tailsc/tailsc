extends Node3D

var placable= true
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("yes")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	$AnimationPlayer.play("no")
	placable= false


func _on_area_3d_body_exited(body):
	$AnimationPlayer.play("yes")
	placable= true
