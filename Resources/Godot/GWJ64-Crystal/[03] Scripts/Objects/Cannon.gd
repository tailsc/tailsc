extends StaticBody3D

var target 
var enemys = []
var bullet = load("res://[02] Scenes/Objects/bullet.tscn")
var instance
var explode = load("res://[02] Scenes/Particles/explosion.tscn")
var health = 3
var level = 1
var shoting_speed = 1

@onready var healthbar = $Healthbar/SubViewport/Healthbar
const target_ran = 2
# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().next()
	$PlaceParticle.emitting = true
func _process(delta):
	if get_parent().get_node("Player").equiped == 3 and level < 3:
		$Label3D.visible = true
	else:
		$Label3D.visible = false
	if enemys != []:
		target = enemys[0]
		$Node3D/Rotate.look_at(Vector3(target.global_position.x,global_position.y,target.global_position.z))
		$Node3D/Rotate.rotation_degrees.y += 90
		$CollisionShape3D.rotation.y = $Node3D/Rotate.rotation.y
func _on_range_body_entered(body):
	if body.is_in_group("goblin"):
		enemys.append(body)


func _on_range_body_exited(body):
	if body.is_in_group("goblin"):
		enemys.erase(body)



func _on_timer_timeout():
	if enemys != []:
		$Timer.wait_time = shoting_speed
		instance = bullet.instantiate()
		get_parent().add_child(instance)
		instance.position = $Node3D/Rotate/Cannon/spawn.global_position
		instance.look_at(target.global_position)
func hit():
	if health >0:
		$AudioStreamPlayer3D.play()
		health -= 1
		healthbar.value = health
		if health <= 0:
			instance = explode.instantiate()
			get_parent().add_child(instance)
			instance.position = position
			queue_free()
	if health == 2:
		$Smoke.visible = true
	if health == 1:
		$Smoke2.visible = true
func heal():
	if health < healthbar.max_value:
		health += 1
		healthbar.value = health
	else:
		if level<3 and get_parent().get_node("Player").currency >39:
			get_parent().next()
			level+= 1
			get_parent().get_node("Player").currency -= 40
			if level == 3:
				$Label3D.visible = false
				$Node3D/Rotate/Cannon.visible = false
				$Node3D/Rotate/Cannon2.visible = true
				$Node3D/Rotate/Cannon3.visible = false
				shoting_speed -= 0.3
				health = 7
				healthbar.max_value = health
				healthbar.value = health
			if level == 2:
				$Node3D/Rotate/Cannon.visible = false
				$Node3D/Rotate/Cannon2.visible = false
				$Node3D/Rotate/Cannon3.visible = true
				shoting_speed -= 0.3
				health = 5
				healthbar.max_value = health
				healthbar.value = health
	if health == 2:
		$Smoke2.visible = false
	if health == 3:
		$Smoke.visible = false
		$Smoke2.visible = false
func _on_place_particle_finished():
	$PlaceParticle.queue_free()
