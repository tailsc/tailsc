extends Node3D

@onready var options = $OPTIONS
@onready var menu = $Ui
@onready var animator = $AnimationPlayer
@onready var Hover : AudioStreamPlayer = $MenuButtonHover
@onready var Press : AudioStreamPlayer = $MenuButtonPress
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
func show_and_hide(first, second):
	first.show()
	second.hide()

func _on_start_btn_pressed() -> void:
	ChangeScene.changeScene(ChangeScene.tutorialLevel)
	Press.play()
	
func _on_options_btn_pressed():
	animator.play("OptionsFade")
	show_and_hide(options, menu)
	Press.play()
	
func _on_quit_btn_pressed():
	get_tree().quit()

func _on_back_btn_pressed():
	animator.play_backwards("OptionsFade")
	await animator.animation_finished
	show_and_hide(menu, options)
	Press.play()
	
func _on_start_btn_mouse_entered():
	Hover.play()

func _on_options_btn_mouse_entered():
	Hover.play()

func _on_quit_btn_mouse_entered():
	Hover.play()

func _on_back_btn_mouse_entered():
	Hover.play()
