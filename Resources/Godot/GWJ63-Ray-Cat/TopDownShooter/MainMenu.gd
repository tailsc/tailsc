extends Node3D

@onready var options = $OPTIONS
@onready var menu = $Ui
@onready var animator = $AnimationPlayer

func show_and_hide(first, second):
	first.show()
	second.hide()

func _on_start_btn_pressed() -> void:
	StageManager.changeStage(StageManager.tutorial)

	
func _on_options_btn_pressed():
	animator.play("OptionsFade")
	show_and_hide(options, menu)

func _on_quit_btn_pressed():
	get_tree().quit()

func _on_back_btn_pressed():
	animator.play_backwards("OptionsFade")
	await animator.animation_finished
	show_and_hide(menu, options)
