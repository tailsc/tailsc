extends Node3D

@onready var AnimPlayer: AnimationPlayer = $AnimationPlayer
@onready var Sound = $Shot

# Flare Gun Nodes
@onready var gun_ray: RayCast3D = $RayCast3D


# Bullet Nodes and vars
@onready var SPEED = 40.0
@onready var bullet: MeshInstance3D = $Bullet/MeshInstance3D
@onready var bullet_ray: RayCast3D = $Bullet/RayCast3D


func _process(delta: float) -> void:
	# Check for the "Interact" input to toggle the flashlight
	if Input.is_action_just_pressed("Interact"):
		shoot()
		
func shoot():
	if AnimPlayer.is_playing():
		pass
	else:
		AnimPlayer.play("Kick")
		Sound.set_pitch_scale(randf_range(.7,.9))
