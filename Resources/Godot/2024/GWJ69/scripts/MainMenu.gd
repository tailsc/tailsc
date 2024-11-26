extends Node3D

#Add new ones for elements you want to hide or show
@onready var options = $Ui/Options
@onready var menu = $Ui/MainMenu
@onready var level_select: Control = $Ui/LevelSelect
@onready var menu_fade_anim: AnimationPlayer = $MenuFadeAnim

func _ready():
	options.hide()
	$Ui/MainMenu/MenuBtn/VBoxContainer/PlayBtn.grab_focus()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func show_and_hide(first, second):
	first.show()
	second.hide()

func _on_play_btn_pressed():
	menu_fade_anim.play("Main_Menu_Fade_Out")
	ChangeScene.changeScene(ChangeScene.tutorial)

func _on_options_btn_pressed():
	menu_fade_anim.play("Main_Menu_Fade_Out")
	show_and_hide(options, menu)

func _on_level_back_btn_pressed() -> void:
	menu_fade_anim.play_backwards("Main_Menu_Fade_Out")
	show_and_hide(menu, level_select)

func _on_quit_btn_pressed():
	get_tree().quit()

func _on_back_btn_pressed():
	menu_fade_anim.play_backwards("Main_Menu_Fade_Out")
	show_and_hide(menu, options)


func _on_discord_btn_pressed():
	OS.shell_open("https://discord.gg/bQTPTc5Qrt")


func _on_level_select_btn_pressed() -> void:
	ChangeScene.changeScene(ChangeScene.LevelSelect)


func _on_level_1_1_btn_pressed() -> void:
	ChangeScene.changeScene(ChangeScene.level0101)


func _on_level_1_2_btn_pressed() -> void:
	ChangeScene.changeScene(ChangeScene.level0102)


func _on_level_1_3_btn_pressed() -> void:
	ChangeScene.changeScene(ChangeScene.level0103)


func _on_level_2_1_btn_pressed() -> void:
	ChangeScene.changeScene(ChangeScene.level0201)


func _on_level_2_2_btn_pressed() -> void:
	ChangeScene.changeScene(ChangeScene.level0202)


func _on_level_2_3_btn_pressed() -> void:
	ChangeScene.changeScene(ChangeScene.level0203)


func _on_level_3_1_btn_pressed() -> void:
	ChangeScene.changeScene(ChangeScene.level0301)


func _on_level_3_2_btn_pressed() -> void:
	ChangeScene.changeScene(ChangeScene.level0302)


func _on_level_3_3_btn_pressed() -> void:
	ChangeScene.changeScene(ChangeScene.level0303)


func _on_credits_btn_pressed() -> void:
	pass # Replace with function body.


func _steam_btn_pressed() -> void:
	OS.shell_open("https://store.steampowered.com/app/2807130/Forge_Front/")
