extends GPUParticles3D


func _ready():
	emitting = true
	$AudioStreamPlayer3D.play()
func _on_finished():
	queue_free()
