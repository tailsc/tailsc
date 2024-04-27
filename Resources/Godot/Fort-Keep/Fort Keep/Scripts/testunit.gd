extends CharacterBody3D

const module_camera:GDScript = preload("res://module_camera.gd")

var steer_speed:float = 6.0
var nav_path_goal_position:Vector3

@onready var nav_path_timer:Timer = $Timer
@onready var nav_agent:NavigationAgent3D = $NavigationAgent3D
@onready var gravity_raycast:RayCast3D = $RayCast3D
@onready var spr_selected:Sprite3D = $selected

var rotation_fast:bool = false

var stuck_max:int = 1
var stuck_count:int = 0
var last_position:Vector3

var selected:bool = false:
	set(new_value):
		selected = new_value
		update_selected()

func _ready() -> void:
	set_max_slides(2)
	nav_agent.velocity_computed.connect(char_move)
	nav_path_timer.timeout.connect(nav_path_timer_update)
	selected = false

func _physics_process(delta: float) -> void:
	if nav_agent.is_navigation_finished():return
	
	position.y = gravity_raycast.get_collision_point().y 
	
	var next_position:Vector3 = nav_agent.get_next_path_position()
	var direction:Vector3 = global_position.direction_to(next_position) * nav_agent.max_speed
	
	rotate_to_direction(direction,delta)
	
	var steered_velocity:Vector3 = (direction - velocity) * delta * steer_speed
	var new_agent_velocity:Vector3 = velocity + steered_velocity
	nav_agent.set_velocity(new_agent_velocity)
	
func update_selected() -> void:
	if selected:spr_selected.show()
	else:spr_selected.hide()

func rotate_to_direction(dir:Vector3,delta:float) -> void:
	if rotation_fast: # Snapped rotation
		rotation.y = atan2(-dir.x,-dir.z)
	else: # Smooth rotation
		var pos_2D:Vector2 = Vector2(-transform.basis.z.x, -transform.basis.z.z)
		var goal_2D:Vector2 = Vector2(dir.x,dir.z)
		rotation.y -= pos_2D.angle_to(goal_2D) * delta * steer_speed


func nav_path_timer_update() -> void:
	if nav_agent.is_navigation_finished():return
	nav_agent.set_target_position(nav_path_goal_position)
	stuck_check()
	last_position = global_position
	
func stuck_check() -> void:
	# Unit is stuck?
	if last_position.distance_squared_to(global_position) < 0.8:
		if stuck_count < stuck_max: stuck_count += 1
		
		# Cancel navigation if stucked for a while inside cancel min range.
		if stuck_count >= 3:
			if (global_position.distance_squared_to(nav_path_goal_position)) < 10.0 or stuck_count >= stuck_max:
				cancel_navigation()
				stuck_count = 0

func cancel_navigation() -> void:
	# Cancel navigation
	nav_agent.emit_signal("navigation_finished")
	nav_agent.set_target_position(global_position)

func char_move(new_velocity:Vector3) -> void:
	velocity = new_velocity
	
	var collision:KinematicCollision3D = move_and_collide(new_velocity * get_physics_process_delta_time())
	if collision:
		var collider:Object = collision.get_collider()
		if collider is CharacterBody3D:
			velocity = new_velocity.slide(collision.get_normal())
			
		elif collider is StaticBody3D:
			move_and_slide()
	#move_and_slide()
