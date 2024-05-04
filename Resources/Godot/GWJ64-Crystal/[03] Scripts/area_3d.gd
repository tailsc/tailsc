extends Area3D


# Called when the node enters the scene tree for the first time.


func _on_body_entered(body):
	if body.is_in_group("shotable"):
		body.hit()
		queue_free()


func _on_timer_timeout():
	queue_free()
