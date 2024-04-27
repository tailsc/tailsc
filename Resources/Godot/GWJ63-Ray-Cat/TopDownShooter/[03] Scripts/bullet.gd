extends CharacterBody3D


var SPEED = 25

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("spawn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	velocity = transform.basis * Vector3(0,0,-SPEED)
	move_and_slide()
		


func _on_area_3d_body_entered(body):
	if body.is_in_group("enemy"):
			body.lifes -=1
			body.hit(global_position)
	queue_free()


func _on_timer_timeout():
	queue_free()
