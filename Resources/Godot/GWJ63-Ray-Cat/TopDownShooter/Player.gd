extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var bullet = load("res://bullet.tscn")
var laser = load("res://laser.tscn")
var instance
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var sensitivity = 0.01
var rotatioon = Vector3()
var lifes = 9
var bumped = false
var pistole = false
var animslider = 0.0
var enemysdamaging = 0
var bells = 0
var shootdelay = false
@export var mouse_sens = 0.2

@onready var raygun = $"Cat/Armature/Skeleton3D/BoneAttachment3D/Ray_gun-1a378929e3a860e034a5288202c380f8"
@onready var SPAWN =$"Cat/Armature/Skeleton3D/BoneAttachment3D/Ray_gun-1a378929e3a860e034a5288202c380f8/Node3D"
func _ready():
	raygun.visible = false
	$Camera2D/TextureProgressBar.value = 9
	$Camera2D/TextureProgressBar/Label.text = str(9)
	# PAUSE MENU 
	#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	#refresh_options()
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		$PauseMenu.pause()
	#
#func refresh_options():
	#mouse_sens = Global.mouse_sens


func _input(event):
	if Input.is_action_just_pressed("click"):
		if pistole == true:
			if !shootdelay:
				$GunShot.play()
				instance = bullet.instantiate()
				get_parent().add_child(instance)
				instance.global_rotation = global_rotation
				instance.global_position = SPAWN.global_position
				shootdelay = true
				$Timer2.start()
			#instance.active()
		#instance = bullet.instantiate()
		#get_parent().add_child(instance)
		#instance.rotation = rotation
		#instance.position = position
		#instance.position.y += 1.5
func _physics_process(delta: float) -> void:
	# Add the gravity.
	var roti = $Middle.global_position.direction_to($Middle.get_global_mouse_position()).angle()
	rotation = Vector3(0,-roti -PI/2 ,0)
	$Camera3D.global_position.x = lerp($Camera3D.global_position.x,global_position.x,0.1)
	$Camera3D.global_position.y = lerp($Camera3D.global_position.y,global_position.y+9,0.1)
	$Camera3D.global_position.z = lerp($Camera3D.global_position.z,global_position.z,0.1)
	if not is_on_floor():
		$Cat/AnimationTree.set("parameters/direction/blend_position",animslider)
		animslider = lerpf(animslider,-1.0,0.05)
		velocity.y -= gravity * delta
	if !bumped:
		# Handle jump.
		#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			#velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir := Input.get_vector("a", "d", "w", "s")
		var direction :=  Vector3(input_dir.x, 0, input_dir.y).normalized()
		if direction:
			velocity.x = move_toward(velocity.x,direction.x * SPEED, 0.3)
			velocity.z = move_toward(velocity.z,direction.z * SPEED, 0.3)
			if velocity.z <-0.1:
				$Cat/AnimationTree.set("parameters/direction/blend_position",animslider)
				animslider = lerpf(animslider,1.0,0.05)
			else:
				$Cat/AnimationTree.set("parameters/direction/blend_position",animslider)
				animslider = lerpf(animslider,0.0,0.05)
		else:
			
			velocity.x = move_toward(velocity.x, 0, 0.12)
			velocity.z = move_toward(velocity.z, 0, 0.12)
			$Cat/AnimationTree.set("parameters/direction/blend_position",animslider)
			animslider = lerpf(animslider,-1.0,0.05)
	move_and_slide()
	if lifes < 1:
		$Area3D.monitoring = false
		queue_free()
		

func _on_area_3d_body_entered(body):
	if body.is_in_group("collectable"):
		if body.is_in_group("pistole"):
			$GunGrab.play()
			pistole = true
			raygun.visible = true
		else:
			if bells <20:
				$BellsCollect.play()
			bells += 1
			$Camera2D/TextureProgressBar2.value = bells
		body.queue_free()

		

func _on_timer_timeout():
	#$Area3D.monitoring = true
	bumped = false
func take_hearts(damagee):
	lifes -= damagee
	$Camera2D/TextureProgressBar.value = lifes
	$Camera2D/TextureProgressBar/Label.text = str(lifes)
	print(lifes)
	
	


func _on_hitbox_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	pass # Replace with function body.
	


func _on_hitbox_area_entered(area):
	if enemysdamaging < 1:
		$CatHurt.play()
		$GPUParticles3D2.emitting = true
		$GPUParticles3D2.restart()
		$enemydamager.start()
	enemysdamaging += area.get_parent().damage
	take_hearts(area.get_parent().damage)
	if lifes<1:
		$CatDeath.play()
		$GPUParticles3D2.emitting = true
		$GPUParticles3D2.restart()
		$Area3D.monitoring = false
		StageManager.changeStage(StageManager.tutorial)
	
	$Timer.start()
	
	#$Area3D.monitoring = false
	bumped = true
	velocity = (global_position -area.global_position).normalized() *SPEED *area.get_parent().speed *1/3


func _on_hitbox_area_exited(area):
	enemysdamaging -= area.get_parent().damage


func _on_enemydamager_timeout():
	take_hearts(enemysdamaging)
	if lifes<1:
		$Area3D.monitoring = false
		get_tree().change_scene_to_file("res://tutorial.tscn")
	if enemysdamaging >0:
		$enemydamager.start()


func _on_timer_2_timeout():
	shootdelay = false
