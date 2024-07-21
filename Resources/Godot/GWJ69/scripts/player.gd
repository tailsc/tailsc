extends CharacterBody3D

@onready var upgrades: Control = $UI/UPGRADE


@export_category("Character Adjustments")
#spawn
var bomb = load("res://scenes/Bomb.tscn")
var rock = load("res://scenes/Rock.tscn")
var instance 
# Constants
@export var current_speed = 4
@export var lerp_speed = 8.0

signal level_up

var direction = Vector3.ZERO

#game_aspects
var currency = 0
var level = 1

var xp = 0
var end_scale = Vector3(1,1,1)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		$PauseMenu.show()
		$PauseMenu.pause()

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	$rot.look_at(Vector3(0,0,0))
	
	 #Apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Determine movement direction based on player input
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	if is_on_floor():
		# Lerp towards input direction when on the ground
		direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),delta*lerp_speed)
	
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
	
	move_and_slide()
	
	# SCALE STUFF
	scale.x = lerp(scale.x,end_scale.x,0.1)
	scale = Vector3(scale.x,scale.x, scale.x)
	$"pull field".scale = Vector3(scale.x,scale.x, scale.x)

func _on_pull_field_body_entered(body): #Gold and xp check to pull in objects
	if body.is_in_group("pullable"):
		if !body.Gold:
			body.pull = true
		elif level == 10: # Was xp before change it to level so you can only after all levels upgrades
			body.pull = true

func _on_pull_field_body_exited(body):
	if body.is_in_group("pullable"):
		if !body.Gold:
			body.pull = null
		elif level == 10:
			body.pull = null

func mass_increase(value):
	end_scale += Vector3(0.5,0.5,0.5)*value


func _on_currency_btn_pressed() -> void:
	$AnimationPlayer.play("Collect")
	currency += 1
	$UI/CURRENCY/TextureProgressBar.value += 1
	emit_signal("level_up")
	if level != 10:
		%CurrencyBtn.text = str(currency)
	else:
		%CurrencyBtn.text = str("MAX")

func _on_level_up() -> void:
	match level:
		1:
			if currency >= 3:
				currency -= 3
				level += 1
				upgrades.show()
				$UI/CURRENCY/TextureProgressBar.max_value = 5
				$UI/CURRENCY/TextureProgressBar.value = 0
				if $PauseMenu.visible == true:
					pass
				else:
					$PauseMenu.pause()
					$PauseMenu.hide()
				
				%SpeedBtn.disabled = false
				%StrengthBtn.disabled = true
				%HealthBtn.disabled = true
		2:
			if currency >= 5:
				currency -= 5
				level += 1
				upgrades.show()
				$UI/CURRENCY/TextureProgressBar.max_value = 10
				$UI/CURRENCY/TextureProgressBar.value = 0
				if $PauseMenu.visible == true:
					pass
				else:
					$PauseMenu.pause()
					$PauseMenu.hide()
				
				%SpeedBtn.disabled = true
				%StrengthBtn.disabled = false
				%HealthBtn.disabled = true
		3:
			if currency >= 10:
				currency -= 10
				level += 1
				upgrades.show()
				$UI/CURRENCY/TextureProgressBar.max_value = 15
				$UI/CURRENCY/TextureProgressBar.value = 0
				if $PauseMenu.visible == true:
					pass
				else:
					$PauseMenu.pause()
					$PauseMenu.hide()
				
				%SpeedBtn.disabled = true
				%StrengthBtn.disabled = true
				%HealthBtn.disabled = false
		4:
			if currency >= 15:
				currency -= 15
				level += 1
				upgrades.show()
				$UI/CURRENCY/TextureProgressBar.max_value = 20
				$UI/CURRENCY/TextureProgressBar.value = 0
				if $PauseMenu.visible == true:
					pass
				else:
					$PauseMenu.pause()
					$PauseMenu.hide()
				%SpeedBtn.disabled = false
				%StrengthBtn.disabled = true
				%HealthBtn.disabled = true
		5:
			if currency >= 20:
				currency -= 20
				level += 1
				upgrades.show()
				$UI/CURRENCY/TextureProgressBar.max_value = 25
				$UI/CURRENCY/TextureProgressBar.value = 0
				if $PauseMenu.visible == true:
					pass
				else:
					$PauseMenu.pause()
					$PauseMenu.hide()
				%SpeedBtn.disabled = true
				%StrengthBtn.disabled = false
				%HealthBtn.disabled = true
		6:
			if currency >= 25:
				currency -= 25
				level += 1
				upgrades.show()
				$UI/CURRENCY/TextureProgressBar.max_value = 30
				$UI/CURRENCY/TextureProgressBar.value = 0
				if $PauseMenu.visible == true:
					pass
				else:
					$PauseMenu.pause()
					$PauseMenu.hide()
				%SpeedBtn.disabled = true
				%StrengthBtn.disabled = true
				%HealthBtn.disabled = false
		7:
			if currency >= 30:
				currency -= 30
				level += 1
				upgrades.show()
				$UI/CURRENCY/TextureProgressBar.max_value = 40
				$UI/CURRENCY/TextureProgressBar.value = 0
				if $PauseMenu.visible == true:
					pass
				else:
					$PauseMenu.pause()
					$PauseMenu.hide()
				%SpeedBtn.disabled = false
				%StrengthBtn.disabled = true
				%HealthBtn.disabled = true
		8:
			if currency >= 40:
				currency -= 40
				level += 1
				upgrades.show()
				$UI/CURRENCY/TextureProgressBar.max_value = 50
				$UI/CURRENCY/TextureProgressBar.value = 0
				if $PauseMenu.visible == true:
					pass
				else:
					$PauseMenu.pause()
					$PauseMenu.hide()
				%SpeedBtn.disabled = true
				%StrengthBtn.disabled = false
				%HealthBtn.disabled = true
		9:
			if currency >= 50:
				currency -= 50
				level += 1
				upgrades.show()
				if $PauseMenu.visible == true:
					pass
				else:
					$PauseMenu.pause()
					$PauseMenu.hide()
				%SpeedBtn.disabled = true
				%StrengthBtn.disabled = true
				%HealthBtn.disabled = false

func _on_speed_btn_pressed() -> void:
	current_speed += 1
	print("speed + 1")
	upgrades.hide()
	if $PauseMenu.visible == true:
		pass
	else:
		$PauseMenu.unpause()


func _on_strength_btn_pressed() -> void:
	print("strenght+1")
	upgrades.hide()
	if $PauseMenu.visible == true:
		pass
	else:
		$PauseMenu.unpause()


func _on_health_btn_pressed() -> void:
	print("health+1")
	upgrades.hide()
	if $PauseMenu.visible == true:
		pass
	else:
		$PauseMenu.unpause()


func _on_spawn_timeout() -> void:
	var spawn = randi_range(1,2)
	if spawn == 1:
		instance = rock.instantiate()
		get_parent().get_node("spawn_rot").position = position
		get_parent().get_node("spawn_rot").rotation_degrees.y = randi_range(1,360)
		instance.position = get_parent().get_node("spawn_rot/spawnpoint").global_position
		get_parent().add_child(instance)
		
	if spawn == 2:
		instance = bomb.instantiate()
		get_parent().get_node("spawn_rot").position = position
		get_parent().get_node("spawn_rot").rotation_degrees.y = randi_range(1,360)
		instance.position = get_parent().get_node("spawn_rot/spawnpoint").global_position
		get_parent().add_child(instance)
		
