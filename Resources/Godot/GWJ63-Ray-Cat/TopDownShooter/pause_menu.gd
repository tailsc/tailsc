extends ColorRect

@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var pausemenu: MarginContainer = $PauseMenu
@onready var options = $OPTIONS
func _ready():
	$PauseMenu/VBoxContainer/ContinueBtn.disabled = true
	$PauseMenu/VBoxContainer/OptionsBtn.disabled = true
	$PauseMenu/VBoxContainer/QuitGameBtn.disabled = true
	$PauseMenu/VBoxContainer/ExitLevelBtn.disabled = true
func show_and_hide(first, second):
	first.show()
	second.hide()

#func _ready() -> void:
	
	#$PauseMenu/VBoxContainer/OptionsBtn.disabled = true
	
func unpause():
	animator.play_backwards("Pause")
	get_tree().paused = false
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#$PauseMenu/VBoxContainer/OptionsBtn.disabled = true
	
func pause():
	#$PauseMenu/VBoxContainer/OptionsBtn.disabled = false
	animator.play("Pause")
	get_tree().paused = true
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_continue_btn_pressed():
	unpause()
	get_parent().get_parent().get_node("Player")#.refresh_options()


func _on_options_btn_pressed():
	animator.play("OptionsFade")
	show_and_hide(options, pausemenu)


func _on_exit_level_btn_pressed():
	unpause()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	StageManager.changeStage(StageManager.mainmenu)


func _on_quit_game_btn_pressed():
	get_tree().quit()

func _on_back_btn_pressed() -> void:
	animator.play_backwards("OptionsFade")
	await animator.animation_finished
	show_and_hide(pausemenu, options)
