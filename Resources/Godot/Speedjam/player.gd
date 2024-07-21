extends CharacterBody3D

@export_category("Character Adjustments")

# Player nodes
@onready var camera: Camera3D = $head/Camera3D
@onready var head: Node3D = $head
@onready var standing_collision_shape: CollisionShape3D = $standing_collision_shape

# Constants
@export var current_speed = 4.5
@export var walking_speed = 4.5
@export var sprinting_speed = 7.0
@export var jump_velocity = 5.0
@export var lerp_speed = 12.0
@export var air_lerp_speed = 2.0

var direction = Vector3.ZERO

# Leaderboard
var player_name
var score = randi() % 101
@onready var leaderboard_scene = $Leaderboard
@onready var tutorial = ("res://tutorial.tscn")
@onready var explosion = load("res://explosion.tscn").instantiate()
var zero_score = 0

func _unhandled_input(event: InputEvent) -> void:
	pass
	#if event.is_action_pressed("ui_cancel"):
		#$PauseMenu.show()
		#$PauseMenu.pause()


func _ready() -> void:
	var current_text = str(int($".".position.z / 10))
	%ScoreLabel.text = current_text
	
	$Ui.hide()
	$Leaderboard.hide()

func _input(event: InputEvent) -> void:
	pass


func _physics_process(delta: float) -> void:
	$CSGCombiner3D.position.z = global_position.z
	var current_text = str(int($".".position.z / 10))
	if %ScoreLabel.text != current_text:
		%ScoreLabel.text = current_text
		zero_score += 1
		if zero_score > 0:
			%AnimationPlayer.play("+1")

	if not is_on_floor():
		velocity += get_gravity() * delta

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	if is_on_floor():
		direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),delta*lerp_speed)
	else:
		if input_dir != Vector2.ZERO:
			direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),delta*air_lerp_speed)
	
	if direction:
		velocity.x = direction.x * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
	
	velocity.z = current_speed 
	move_and_slide()
	
	$standing_collision_shape.rotation.y = lerp_angle($standing_collision_shape.rotation.y, - input_dir.x * deg_to_rad(45), 1 * delta)

func _on_submit_btn_pressed() -> void:
	var current_text = str(int($".".position.z / 10))
	if %LineEdit.text != "":
		player_name = %LineEdit.text
		SilentWolf.Scores.save_score(player_name, current_text)
		var sw_result: Dictionary = await SilentWolf.Scores.get_scores(0).sw_get_scores_complete
		#print("All scores: " + str(sw_result.scores))
		%LineEdit.hide()
		%SubmitBtn.hide()

func _on_play_btn_pressed() -> void:
	#get_tree().reload_current_scene()
	ChangeScene.changeScene(ChangeScene.tutorial)

func _on_exit_btn_pressed() -> void:
	ChangeScene.changeScene(ChangeScene.mainmenu)

func _on_area_3d_area_entered(area: Area3D) -> void:
	add_child(explosion)
	explosion.emitting = true
	$standing_collision_shape/NewFish.hide()
	current_speed = 0
	$CSGCombiner3D/AnimationPlayer.stop()
	$Ui.show()
	$Leaderboard.show()

func _on_discord_btn_pressed() -> void:
	OS.shell_open("https://discord.gg/bQTPTc5Qrt")
