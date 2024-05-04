extends CanvasLayer

@onready var timer: Timer = $Timer
@onready var AnimPlayer: AnimationPlayer = $AnimationPlayer
#Add new ones for other scenes
const tutorialLevel = ("res://[02] Scenes/Levels/tutorial.tscn")
const mainmenu = ("res://[02] Scenes/Menues/MainMenu.tscn")

func _ready():
	get_node("ColorRect").hide()
	

func changeScene(scenePath):
	timer.start()
	ResourceLoader.load_threaded_request(scenePath)
	get_tree().paused = true
	get_node("ColorRect").show()
	AnimPlayer.play("Transition")

	await AnimPlayer.animation_finished
	
	AnimPlayer.play("Loading")
	
	AnimPlayer.play_backwards("Transition")
	get_tree().change_scene_to_file(scenePath)
	get_tree().paused = false
	await AnimPlayer.animation_finished
	get_node("ColorRect").hide()
