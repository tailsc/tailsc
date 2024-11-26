extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	$GPUParticles3D.emitting = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_gpu_particles_3d_finished():
	if get_parent().name == "Goblin":
		queue_free()
