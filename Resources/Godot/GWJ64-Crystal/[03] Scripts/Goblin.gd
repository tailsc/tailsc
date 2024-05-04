extends CharacterBody3D

@onready var animation_tree = $AnimationTree
@onready var footSteps : AudioStreamPlayer3D = $FootSteps
@onready var animation_player = $AnimationPlayer

var particles = load("res://[02] Scenes/Particles/goblin_blood.tscn")

var animslider = 1
var parts
var hit_state = true
var SPEED = 5.0
var health = 2
var Target_obj
var Target 
var state = "moving"
var target_ran = 1.7
var instance 
var check_box = load("res://[02] Scenes/Objects/area_3d.tscn")
var enemies = []
func _ready():
	
	Target_obj = get_parent().get_node("Drill")
	$NavigationAgent3D.set_target_position(Target_obj.global_position)
	Target = Target_obj.global_position
	target_ran = 4
func _process(delta):
	
	if !State(target_ran):
		velocity = Vector3.ZERO
		var next_nav_point = $NavigationAgent3D.get_next_path_position()
		velocity = (next_nav_point -global_position).normalized()* SPEED
		look_at(Vector3(global_position.x+velocity.x, global_position.y, global_position.z+velocity.z))
		move_and_slide()
		animslider = lerpf(animslider,0,0.1)
		$AnimationTree.set("parameters/BlendSpace1D/blend_position",animslider)
		if footSteps.playing == false:
				footSteps.play()
	elif State(target_ran):
		animslider = lerpf(animslider,-1,0.1)
		$AnimationTree.set("parameters/BlendSpace1D/blend_position",animslider)
		look_at(Vector3(Target.x, global_position.y, Target.z))
		if $Node3D.visible and hit_state:
			instance = check_box.instantiate() 
			$Node3D.add_child(instance)
			hit_state = false
		elif !$Node3D.visible:
			hit_state = true
func hit():
	health -= 1
	$GoblinBloodHit.emitting = true
	$GoblinBloodHit.restart()
	if health < 1:
		parts =  particles.instantiate()
		get_parent().add_child(parts)
		parts.position = position
		#instance = particles.instantiate()
		get_parent().get_node("Player").currency += 2
		get_parent().next()
		queue_free()
func State(target_range):
	return global_position.distance_to($NavigationAgent3D.target_position)< target_range

func _on_range_body_entered(body):
	if body.is_in_group("shotable"):
		enemies.append(body)
		print(body)


func _on_range_body_exited(body):
	if body.is_in_group("shotable"):
		enemies.erase(body)


func _on_timer_timeout():
	if enemies != []:
		Target_obj = enemies[0]
		$NavigationAgent3D.set_target_position(Target_obj.global_position)
		Target = Target_obj.global_position
		target_ran = Target_obj.target_ran
	else:
		Target_obj = get_parent().get_node("Drill")
		$NavigationAgent3D.set_target_position(Target_obj.global_position)
		Target = Target_obj.global_position
		target_ran = Target_obj.target_ran
