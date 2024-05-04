extends Node

@onready var loopTimer : Timer = $LoopTimer

func _ready():
	pass
	
func _on_ready():
	get_tree().call_group("StartingMusic", "play")
	loopTimer.start(33.99)



func _on_loop_timer_timeout():
	get_tree().call_group("Battle", "play")
	loopTimer.start(33.99)
	
	
