extends RigidBody3D

@export var Missile = false
@export var Mass = 1

@onready var animation_player = $AnimationPlayer

var direction_0vector
var explosione = load("res://scenes/explosion.tscn")
var pull 
var player = CharacterBody3D
var direction_vector
const Gold = false

func _ready() -> void:
	player = get_parent().get_node("player")

func _physics_process(delta):
	if Missile == true:
		direction_vector = player.position-position
		direction_0vector = direction_vector/ direction_vector.length()
		linear_velocity = direction_0vector*3
		if direction_vector.length() < 1 :
			var explosion = explosione.instantiate()
			get_parent().add_child(explosion)
			explosion.position = position
			explosion.emitting = true
			ChangeScene.changeScene(ChangeScene.mainmenu)     # 1 touch kill
			await queue_free()
	else:
		if pull:
			direction_vector= player.position-position
			var direction_0vector = direction_vector/ direction_vector.length()
			constant_force = direction_0vector*3
			if direction_vector.length() < 1 :
				animation_player.play("shrink")
		else:
			constant_force = Vector3(0,0,0)

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "shrink":
		
		queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	var explosion = explosione.instantiate()
	get_parent().add_child(explosion)
	explosion.position = position
	explosion.emitting = true
	await queue_free()
