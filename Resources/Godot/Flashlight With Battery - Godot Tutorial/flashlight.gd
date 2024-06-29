extends Node3D


func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("Toggle") and $Battery.value > 0:
		$SpotLight3D.light_energy = 16
	else:
		$SpotLight3D.light_energy = 0

func _physics_process(delta: float) -> void:
	if $SpotLight3D.light_energy == 16:
		$Battery.value -= 1
