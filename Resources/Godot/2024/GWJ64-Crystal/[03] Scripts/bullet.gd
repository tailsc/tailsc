extends CharacterBody3D

const speed = 1.0
func _ready():
	$AnimationPlayer.play("grow")

func _physics_process(delta):
	position -= transform.basis.z* speed


func _on_timer_timeout():
	print("dead")
	queue_free()


func _on_area_3d_body_entered(body):
	if body.is_in_group("shotable"):
		body.hit()
	print("dead")
	queue_free()
