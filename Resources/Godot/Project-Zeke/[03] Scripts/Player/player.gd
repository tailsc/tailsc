extends CharacterBody3D

@export_category("Character Adjustments")

# Player nodes
@onready var camera: Camera3D = $Camera3D
@onready var standing_collision_shape: CollisionShape3D = $standing_collision_shape

# Constants
@export var current_speed = 4.5
@export var walking_speed = 4.5
@export var sprinting_speed = 7.0
@export var jump_velocity = 5.0
@export var lerp_speed = 12.0

var direction = Vector3.ZERO

@export var health = 100
@onready var health_bar: ProgressBar = $Sprite3D/SubViewport/HealthBar

func _ready() -> void:
	# Set mouse mode to captured on ready
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
		pass
		# Clamp head rotation to limit how high and low you can look

func _physics_process(delta: float) -> void:
	# Adjust movement speed and collision shapes based on player actions
	if Input.is_action_pressed("Sprint"): 
		# Sprinting logic
		current_speed = lerp(current_speed, sprinting_speed, delta * lerp_speed)
	else: 
		# Walking logic
		current_speed = lerp(current_speed, walking_speed, delta * lerp_speed)
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction relative to the camera's orientation
	var input_dir := Input.get_vector("MoveLeft", "MoveRight", "MoveForward", "MoveBackward")
	var movement_input = Vector3(input_dir.x, 0, input_dir.y)

	# Rotate the movement input by 45 degrees around the Y-axis
	var rotated_input = movement_input.rotated(Vector3.UP, deg_to_rad(45))

	# Determine movement direction based on player input
	var direction = rotated_input.normalized()

	# Apply movement
	velocity.x = direction.x * current_speed
	velocity.z = direction.z * current_speed
	
	move_and_slide()

func decrease_health(amount: int = 1) -> void:
	health -= amount
	health_bar.set_value(health)  # Update the health bar visually

	# Handle player death (optional):
	if health <= 0:
		# Play death animation, disable movement, etc. (add your logic here)
		print("Player Died!")
		get_tree().quit()
			
