extends CharacterBody3D
var particles = load("res://gpu_particles_3d_2.tscn")
var instance 
@export var speed =5
var Speeed = 5
var accel =10
@export var lifes = 10
@export var damage = 1
var bumped = false
var seen_player= false
@onready var navigation = $NavigationAgent3D
@export var scalee = Vector3(1,1,1)
@export var active = true

var dogflag = false

signal output
func _ready():
	$AnimationPlayer.play("Idle Gun")
	$eyes/CollisionShape3D.scale = scalee
	$eyes.monitoring = active
	Speeed = speed
func _physics_process(delta):
	var direction = Vector3()
	if seen_player:
		if !dogflag:
			$DogDeath.play()
			dogflag = !dogflag
		if $AnimationPlayer.is_playing():
			if $AnimationPlayer.current_animation == "Idle Gun":
				$AnimationPlayer.play("Walking Gun")
		$AnimationPlayer.speed_scale = speed
		if get_parent().get_parent().get_node("Player"):
			navigation.target_position = get_parent().get_parent().get_node("Player").global_position
			look_at(get_parent().get_parent().get_node("Player").global_position)
			rotation_degrees.y -= 180
		if !bumped:
			direction = navigation.get_next_path_position() -global_position
			direction = direction.normalized()
			velocity = velocity.lerp(direction * speed,accel * delta)
	move_and_slide()
	if lifes < 1:
		$DogDeath.play()
		dogflag = false
		instance = particles.instantiate()
		get_parent().add_child(instance)
		instance.position = position
		instance.emitting = true

		emit_signal("output")
		queue_free()
		
func hit(hit_p):
	$DogHurt.play()
	$GPUParticles3D2.emitting = true
	$GPUParticles3D2.restart()
	speed = Speeed *1/2
	$Timer.start()
	seen_player = true

func _on_timer_timeout():
	speed = Speeed

func _on_area_3d_body_entered(body):
	seen_player = true
	
