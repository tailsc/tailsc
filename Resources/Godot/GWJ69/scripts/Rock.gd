extends RigidBody3D

@export var masss = 1
@export var Gold = false

@onready var animation_player = $AnimationPlayer

var player = CharacterBody3D
var pull
var direction_vector

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Gold == false:
		$Rock/Gold.visible = false
		$Rock/Rock.visible = true
	else:
		$Rock/Gold.visible = true
		$Rock/Rock.visible = false
		
	player = get_parent().get_node("player")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
		if pull:
			direction_vector = player.position-position
			var direction_0vector = direction_vector/ direction_vector.length()
			constant_force = direction_0vector*3
			if direction_vector.length() < 1 :
				animation_player.play("shrink")
				$Explosion.emitting = true
		else:
			constant_force = Vector3(0,0,0)
	
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "shrink":
		player.xp += 1
		player._on_currency_btn_pressed()
		if Gold == false:
			queue_free()
		else: 
			ChangeScene.changeScene(ChangeScene.mainmenu)



