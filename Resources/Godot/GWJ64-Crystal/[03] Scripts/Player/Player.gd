extends CharacterBody3D
#region onready vars
@onready var muzzleflash = $nek/head/eyes/arm/hands/Rifle/GPUParticles3D

@onready var nek = $nek
@onready var head = $nek/head
@onready var eyes = $nek/head/eyes
@onready var hands = $nek/head/eyes/arm/hands
@onready var standing_collision = $standing_collision
@onready var crouching_collision = $crouching_collision
@onready var ray_cast_3d = $RayCast3D
@onready var camera_3d = $nek/head/eyes/Camera3D
@onready var interaction_ray = $nek/head/eyes/Camera3D/Interaction_ray
@onready var pickup = $nek/head/eyes/Camera3D/pickup
@onready var holdpos = $nek/head/eyes/Camera3D/holdpos
@onready var animation = $UI/Crosshair/Center/AnimationPlayer
@onready var FPS = $"Fps counter/Center/Label"
@onready var label = $UI/Label
@onready var TakeHit : AudioStreamPlayer3D = $PlayerAudio/TakeHIt
@onready var Jump : AudioStreamPlayer3D = $PlayerAudio/Jump
@onready var Sprint : AudioStreamPlayer3D = $PlayerAudio/Sprint
@onready var Walk : AudioStreamPlayer3D = $PlayerAudio/Walk
@onready var Death : AudioStreamPlayer3D = $PlayerAudio/Death
@onready var HammerSwing : AudioStreamPlayer3D = $PlayerAudio/HammerSwing
@onready var RifleShoot : AudioStreamPlayer3D = $PlayerAudio/RifleShoot
@onready var action = $nek/head/eyes/arm/action
@onready var switch = $nek/head/eyes/arm/switch
@onready var timer = $nek/head/eyes/arm/Timer
@onready var rifle = $nek/head/eyes/arm/hands/Rifle
@onready var hammer = $nek/head/eyes/arm/hands/Hammer
@onready var Currency = $UI/currency
@onready var place_cannon = $nek/head/eyes/arm/hands/place_cannon
@onready var interaction_ray_2 = $nek/head/eyes/Camera3D/Interaction_ray2
@onready var progress_bar = $UI/ProgressBar

# movement
#region vars
var current_speed = 5.0

const sprinting_speed = 7.0
const walking_speed = 4.0
const crouching_speed = 3.0

# STates
var walking = false
var sprinting = false
var crouching = false
var freelooking = false

# Head bobbings vars

const head_bobbing_sprinting_speed = 22.0
const head_bobbing_walking_speed = 14.0
const head_bobbing_crouching_speed = 10.0

const head_bobbing_sprinting_intensity = 0.15
const head_bobbing_walking_intensity = 0.05
const head_bobbing_crouching_intensity = 0.05

var head_bobbing_vector = Vector2.ZERO
var head_bobbing_index = 0.0
var head_bobbing_current_intensity = 0.0

#movement vars
var crouching_depth = -0.5

const jump_velocity = 6.5

var lerp_speed = 10.0

var tilt_amount = -5

var direction = Vector3()

var input_dir = Vector2()

#Camera
@export var mouse_sens = 0.2
const smoothness = 20
var camera_input : Vector2
var rotation_velocity : Vector2
#grabbing object vars
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


var spawndelay = true

#hand
var equiped = 2
var instance 
var cannone
var bullet = load("res://[02] Scenes/Objects/bullet.tscn")
var currency = 0
var cannon = load("res://[02] Scenes/Objects/Cannon.tscn")

#health
const target_ran = 1.7
var health = 10
var dead = false
#endregion
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	refresh_options()
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		$PauseMenu.pause()
#region mouse input

func _input(event):
	if event is InputEventMouseMotion and spawndelay:
		event.set_relative(Vector2(0,0))
		spawndelay = false
	if !spawndelay or !dead:
		if event is InputEventMouseMotion:
			camera_input = event.relative
		pass
#endregion
func _physics_process(delta):
#region movement
	if !spawndelay or !dead:
		if Input.is_action_pressed("crouch"):
			current_speed = crouching_speed
			head.position.y = lerp(head.position.y,0.0+crouching_depth,delta*lerp_speed)
			standing_collision.disabled = true
			crouching_collision.disabled = false
			walking = false 
			sprinting = false
			crouching = true
		elif !ray_cast_3d.is_colliding():
			crouching_collision.disabled = true
			standing_collision.disabled = false
			head.position.y = lerp(head.position.y,0.0 ,delta*lerp_speed)
			if Input.is_action_pressed("sprint"):
				current_speed = sprinting_speed
				walking = false
				sprinting = true
				crouching = false
			else:
				current_speed = walking_speed
				walking = true
				sprinting = false
				crouching = false
			
		# Handle Freelooking
		#camera_3d.rotation.z = lerp(camera_3d.rotation.y,0.0,lerp_speed*delta)
		#nek.rotation.y = lerp(nek.rotation.y,0.0,lerp_speed*delta)
		#freelooking = false
		# Handle Headbob
		if sprinting:
			head_bobbing_current_intensity = head_bobbing_sprinting_intensity
			head_bobbing_index += head_bobbing_sprinting_speed*delta
		elif walking:
			head_bobbing_current_intensity = head_bobbing_walking_intensity
			head_bobbing_index += head_bobbing_walking_speed*delta
		elif crouching:
			head_bobbing_current_intensity = head_bobbing_crouching_intensity
			head_bobbing_index += head_bobbing_crouching_speed*delta
		if is_on_floor() && input_dir != Vector2.ZERO:
			head_bobbing_vector.y = sin(head_bobbing_index)
			head_bobbing_vector.x = sin(head_bobbing_index/2)+0.5
			
			eyes.position.y = lerp(eyes.position.y, head_bobbing_vector.y*(head_bobbing_current_intensity/2.0),delta*lerp_speed)
			eyes.position.x = lerp(eyes.position.x, head_bobbing_vector.x*(head_bobbing_current_intensity),delta*lerp_speed)
			hands.position.y = lerp(hands.position.y, head_bobbing_vector.y*(head_bobbing_walking_intensity/5.0),delta*lerp_speed)
			hands.position.x = lerp(hands.position.x, head_bobbing_vector.x*(head_bobbing_walking_intensity/2.0),delta*lerp_speed)
		else:
			eyes.position.y = lerp(eyes.position.y, 0.0,delta*lerp_speed)
			eyes.position.x = lerp(eyes.position.x,0.0,delta*lerp_speed)
			hands.position.y = lerp(hands.position.y, 0.0,delta*lerp_speed)
			hands.position.x = lerp(hands.position.x,0.0,delta*lerp_speed)
			
		#gravityf
		if not is_on_floor():
			velocity.y -= gravity * delta *3
		# Handle Jump.
		if Input.is_action_just_pressed("jump") and is_on_floor() and !ray_cast_3d.is_colliding():
			velocity.y = jump_velocity*1.6
			Jump.play()

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		input_dir = Input.get_vector("left","right", "forward", "backward")

		direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),delta* lerp_speed)
		if direction:
			velocity.x = direction.x * current_speed
			velocity.z = direction.z * current_speed
		else:
			velocity.x = move_toward(velocity.x, 0, current_speed)
			velocity.z = move_toward(velocity.z, 0, current_speed)

		
#endregion
#region rifle and hammer
	if !dead:
		if equiped == 1:
			if currency >=50:
				get_parent().get_node("Node_3D").visible = true	
				if interaction_ray_2.is_colliding():
					get_parent().get_node("Node_3D").position = interaction_ray_2.get_collision_point()
					
			else:
				get_parent().get_node("Node_3D").visible = false
		if Input.is_action_just_pressed("mousewheel"):
			if !switch.is_playing():
				switch.play("switch")
				timer.start()
		if Input.is_action_pressed("action"):
			if !switch.is_playing():
				if equiped == 3:
					if !action.is_playing():
						action.play("hammer")
						HammerSwing.play()
						if interaction_ray.is_colliding():
							if interaction_ray.get_collider().is_in_group("healable"):
								interaction_ray.get_collider().heal()
				elif equiped == 2:
					if !action.is_playing():
						action.play("gun")
						RifleShoot.play()
						muzzleflash.emitting = true
						muzzleflash.restart()
						instance = bullet.instantiate()
						get_parent().add_child(instance)
						instance.rotation = camera_3d.global_rotation
						instance.position = $nek/head/eyes/arm/hands/Rifle/spawnpoint.global_position
				else:
					if !action.is_playing():
						action.play("place")
						if get_parent().get_node("Node_3D").placable == true and currency >= 50:
							currency -= 50
							cannone = cannon.instantiate()
							get_parent().add_child(cannone)
							cannone.position = interaction_ray_2.get_collision_point()
	if !dead:
		move_and_slide()
#endregion
#region handle SFX
	if walking == true: 
		if is_on_floor() && input_dir != Vector2.ZERO:
			if Walk.playing == false:
				Walk.play()
		else:
			Walk.stop()
	elif sprinting == true:
		if is_on_floor() && input_dir != Vector2.ZERO:
			if Sprint.playing == false:
				Sprint.play()
		else:
			Sprint.stop()
#endregion
	
	
	
func _process(delta):
	if !spawndelay or !dead:
		#Cam_smoothing
		rotation_velocity = rotation_velocity.lerp(camera_input *mouse_sens, delta *smoothness)
		rotate_y(deg_to_rad(-rotation_velocity.x))
		head.rotate_x(deg_to_rad(-rotation_velocity.y))
		head.rotation_degrees.x = clamp(head.rotation_degrees.x,-90,80)
		camera_input = Vector2.ZERO
		#interaction script
		
	#FPS counter
	var fps = Engine.get_frames_per_second()
	FPS.text = "FPS: " + str(fps)
	Currency.text = str(currency)
	progress_bar.value = health
# refresh the options changed to apply on player
func refresh_options():
	mouse_sens = Global.mouse_sens


func _on_timer_timeout():
	if equiped == 1:
		equiped = 2
		hammer.visible = false
		place_cannon.visible = false
		rifle.visible = true
		get_parent().get_node("Node_3D").visible = false
	elif equiped == 2:
		hammer.visible = true
		rifle.visible = false
		place_cannon.visible = false
		get_parent().get_node("Node_3D").visible = false
		equiped = 3
	else:
		hammer.visible = false
		rifle.visible = false
		place_cannon.visible = true
		equiped = 1
func hit():
	if !dead:
		$UI/Crosshair/AnimationPlayer.play("damage")
		health -= 1
		TakeHit.play()
		
		if health <1:
			$AnimationPlayer.play("die")
			Death.play()
			dead = true
			


func _on_animation_player_animation_finished(anim_name):
	ChangeScene.changeStage(ChangeScene.mainmenu)
	#get_tree().change_scene_to_file("res://[02] Scenes/Menues/MainMenu.tscn")



func currency_plus():
	currency += 1
	
