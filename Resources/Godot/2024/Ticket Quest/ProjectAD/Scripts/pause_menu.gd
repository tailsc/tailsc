extends ColorRect

@onready var world_environment: WorldEnvironment
@onready var light: DirectionalLight3D
@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var continue_btn: Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/ContineBtn
@onready var option_button: Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/OptionsBtn
@onready var exit_button: Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/ExitBtn
@onready var options = $Options
@onready var menu = $CenterContainer

func _ready() -> void:
	continue_btn.pressed.connect(unpause)
	#option_button.pressed.connect(show_and_hide(options, menu))
	#exit_button.pressed(SceneTransition.change_scene_to_file("res://Scenes/Menus/MainMenu.tscn"))
	

func unpause():
	animator.play("Unpause")
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func pause():
	animator.play("Pause")
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func show_and_hide(first, second):
	first.show()
	second.hide()

func _on_options_btn_pressed():
	show_and_hide(options, menu)

func _on_back_btn_pressed():
	show_and_hide(menu, options)

func _on_exit_btn_pressed():
	unpause()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	SceneTransition.change_scene_to_file("res://Scenes/Menus/MainMenu.tscn")
