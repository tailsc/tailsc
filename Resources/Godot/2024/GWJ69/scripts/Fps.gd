@tool
extends Control

@onready var FPS = $Label

func _process(delta: float) -> void:
	var fps = Engine.get_frames_per_second()
	FPS.text = "FPS: " + str(fps)
