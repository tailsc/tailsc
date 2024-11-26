extends AudioStreamPlayer

@onready var musicLoop : AudioStreamPlayer = $MenuLoopA

@onready var loopTimer: Timer = $"Timer to A"

func _ready():
	pass

func _on_ready():
	musicLoop.play()
	loopTimer.start(68.59)
	print("playing init A")

func _on_timer_to_a_timeout():
	musicLoop.play()
	loopTimer.start(68.59)
	print("playing main loop")

