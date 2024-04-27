extends CanvasLayer


const demo = ("res://Scenes/Demo.tscn")
const dungeon = ("res://Scenes/dungeon_demo.tscn")
const mainmenu = ("res://Scenes/Ui/MainMenu.tscn")

func _ready():
	get_node("ColorRect").hide()

func changeStage(stagePath):
	get_tree().paused = true
	get_node("ColorRect").show()
	get_node("AnimationPlayer").play("Transition")

	await get_node("AnimationPlayer").animation_finished
	get_node("AnimationPlayer").play_backwards("Transition")
	get_tree().change_scene_to_file(stagePath)
	get_tree().paused = false
	await get_node("AnimationPlayer").animation_finished
	get_node("ColorRect").hide()
