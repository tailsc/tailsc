extends CharacterBody3D

#region External 
signal toggle_inventory()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Inventory"):
		toggle_inventory.emit

@export var inventory_data: InventoryData
#endregion

@export_category("Character Adjustments")

# Player nodes
@onready var camera: Camera3D = $head/Camera3D
@onready var head: Node3D = $head
@onready var standing_collision_shape: CollisionShape3D = $standing_collision_shape
@onready var crouching_collision_shape: CollisionShape3D = $crouching_collision_shape
@onready var overhead_ray: RayCast3D = $OverheadRay

# Constants
@export var current_speed = 4.5
@export var walking_speed = 4.5
@export var sprinting_speed = 7.0
@export var crouching_speed = 2.5
@export var crouching_depth = -0.5
@export var jump_velocity = 5.0
@export var lerp_speed = 12.0
@export var air_lerp_speed = 2.0
@export var bob_freq = 2.0
@export var bob_amp = 0.04
@export var t_bob = 0.0
@export var mouse_sens = 0.05

var direction = Vector3.ZERO

func _ready() -> void:
	# Set mouse mode to captured on ready
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	# Update camera and head rotation based on mouse movement
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
		# Clamp head rotation to limit how high and low you can look
		head.rotation.x = clamp(head.rotation.x,deg_to_rad(-80),deg_to_rad(80))

func _physics_process(delta: float) -> void:
	# Adjust movement speed and collision shapes based on player actions
	if Input.is_action_pressed("Crouch"): 
		# Crouching logic
		current_speed = lerp(current_speed,crouching_speed,delta*lerp_speed)
		head.position.y = lerp(head.position.y,1.8 + crouching_depth,delta*lerp_speed)
		standing_collision_shape.disabled = true
		crouching_collision_shape.disabled = false
		
	elif !overhead_ray.is_colliding(): # Standing
		standing_collision_shape.disabled = false
		crouching_collision_shape.disabled = true
		
		head.position.y = lerp(head.position.y,1.8,delta*lerp_speed)
		
		if Input.is_action_pressed("Sprint"): 
			# Sprinting logic
			current_speed = lerp(current_speed,sprinting_speed,delta*lerp_speed)
		else: 
			# Walking logic
			current_speed = lerp(current_speed,walking_speed,delta*lerp_speed)
	
	# Apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Determine movement direction based on player input
	var input_dir := Input.get_vector("MoveLeft", "MoveRight", "MoveForward", "MoveBackward")
	if is_on_floor():
		# Lerp towards input direction when on the ground
		direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),delta*lerp_speed)
	else:
		# Lerp towards input direction in the air
		if input_dir != Vector2.ZERO:
			direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),delta*air_lerp_speed)
	
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
		
	# Update headbob effect
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	move_and_slide()

func _headbob(time: float) -> Vector3:
	# Calculate headbob effect
	var pos = Vector3.ZERO
	pos.y = sin(time * bob_freq) * bob_amp
	pos.x = cos(time * bob_freq / 2) * bob_amp
	
	return pos
