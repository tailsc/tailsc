extends CharacterBody3D

@onready var nek = $nek
@onready var head = $nek/head
@onready var eyes = $nek/head/eyes
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

@onready var footstep : AudioStreamPlayer3D = $PlayerAudio/Footstep

# movement
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
var held_object 

var pull_power = 8
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


var spawndelay = true
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	refresh_options()
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		$PauseMenu.pause()

func _input(event):
	if event is InputEventMouseMotion and spawndelay:
		event.set_relative(Vector2(0,0))
		spawndelay = false
	if !spawndelay:
		if event is InputEventMouseMotion:
			camera_input = event.relative
		if Input.is_action_just_pressed("mouse_left"):
			if held_object:
				drop_object()
			else: 
				pick_object()
func _physics_process(delta):
	#movement states
	if !spawndelay:
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
		camera_3d.rotation.z = lerp(camera_3d.rotation.y,0.0,lerp_speed*delta)
		nek.rotation.y = lerp(nek.rotation.y,0.0,lerp_speed*delta)
		freelooking = false
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
		
		else:
			eyes.position.y = lerp(eyes.position.y, 0.0,delta*lerp_speed)
			eyes.position.x = lerp(eyes.position.x,0.0,delta*lerp_speed)
			
		#gravity
		if not is_on_floor():
			velocity.y -= gravity * delta *3
		# Handle Jump.
		if Input.is_action_just_pressed("jump") and is_on_floor() and !ray_cast_3d.is_colliding():
			velocity.y = jump_velocity*1.6

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

		move_and_slide()
		#pick up script ( hold pos)
		if held_object:
			if held_object.holding_allowed:
				var a = held_object.global_transform.origin
				var b = holdpos.global_transform.origin
				held_object.set_linear_velocity((b-a)*pull_power)
				held_object.global_rotation = camera_3d.global_rotation
			else:
				held_object = null
func _process(delta):
	if !spawndelay:
		#Cam_smoothing
		rotation_velocity = rotation_velocity.lerp(camera_input *mouse_sens, delta *smoothness)
		rotate_y(deg_to_rad(-rotation_velocity.x))
		head.rotate_x(deg_to_rad(-rotation_velocity.y))
		head.rotation_degrees.x = clamp(head.rotation_degrees.x,-90,80)
		camera_input = Vector2.ZERO
		#interaction script
		#Crosshair animations
		if interaction_ray.is_colliding():
			var body= interaction_ray.get_collider()
			if body.is_in_group("pressable"):
				if animation.current_animation == "NOTHING":
					animation.play_backwards("RESET")
				else:
					animation.queue("NOTHING_INTERACTING")
				label.text = body.text()
				if Input.is_action_just_pressed("mouse_left") and body.activation_var == true:
					body.pressed()
		#pick up script
		elif pickup.is_colliding():
			if animation.current_animation == "NOTHING":
				animation.play_backwards("RESET")
			else:
				animation.queue("NOTHING_INTERACTING")
			var body = pickup.get_collider()
			if body.is_in_group("pickable"):
				label.text = body.text()
		else:
			if animation.current_animation == "NOTHING_INTERACTING":
				animation.play("RESET")
			else:
				animation.queue("NOTHING")
			label.text = ""
	#FPS counter
	var fps = Engine.get_frames_per_second()
	FPS.text = "FPS: " + str(fps)

func pick_object():
	var collider =pickup.get_collider()
	if collider != null and collider is RigidBody3D:
		held_object = collider
func drop_object():
	if held_object != null:
		held_object = null
		
# refresh the options changed to apply on player
func refresh_options():
	mouse_sens = Global.mouse_sens
