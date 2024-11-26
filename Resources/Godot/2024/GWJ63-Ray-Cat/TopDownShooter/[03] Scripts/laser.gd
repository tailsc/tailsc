extends Node3D

var distance 
const damage = 1
var i = 0

func  _process(delta): 
	if $RayCast3D.get_collider():
		distance = transform.origin.distance_to($RayCast3D.get_collision_point())
		$Scaler.scale.z = distance #
		if i <1:
			if $RayCast3D.get_collider().is_in_group("enemy"):
				$RayCast3D.get_collider().hit(global_position)
				$RayCast3D.get_collider().lifes -=1
				i+= 1
	else:
		$Scaler.scale.z = 1000
func active():
	$AnimationPlayer.play("grow")
	$GunTail.play()
	$Timer.start()

		


func _on_timer_timeout():
	$AnimationPlayer.play("shrink")
	

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "shrink":
		queue_free()
