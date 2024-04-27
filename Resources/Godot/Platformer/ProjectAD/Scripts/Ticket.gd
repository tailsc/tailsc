extends Area3D

signal ticketCollected


func _ready():
	pass 


func _physics_process(delta):
	rotate_y(deg_to_rad(3))


func _on_body_entered(body):
	if body.name == "Player":
		$AnimationPlayer.play("bounce")
		$Timer.start()


func _on_timer_timeout():
	emit_signal("ticketCollected")
	queue_free()
