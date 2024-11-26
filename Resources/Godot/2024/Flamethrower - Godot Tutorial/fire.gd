extends Node3D


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Fire"):
		if $GPUParticles3D.process_material.gravity.x < 10:
			$GPUParticles3D.process_material.gravity.x += 1
			$GPUParticles3D.emitting = true
			$Timer.start()
	if event.is_action_released("Fire"):
		$GPUParticles3D.process_material.gravity.x = 0
		$GPUParticles3D.emitting = false
		$Timer.stop()


func _on_timer_timeout() -> void:
	if $GPUParticles3D.process_material.gravity.x < 10:
		$GPUParticles3D.process_material.gravity.x += 1
		$Timer.start()


func _physics_process(delta: float) -> void:
	print($GPUParticles3D.process_material.gravity.x)
