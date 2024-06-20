extends Control

@onready var options = $"../Options"
@onready var menu = $"."

func show_and_hide(first, second):
	first.show()
	second.hide()

func _ready():
	pass

func _on_start_world_1_btn_pressed():
	SceneTransition.change_scene_to_file("res://Scenes/Worlds/Demo.tscn")

func _on_start_world_1_btn_2_pressed():
	SceneTransition.change_scene_to_file("res://Scenes/Worlds/Grassland.tscn")

func _on_start_world_2_btn_pressed():
	SceneTransition.change_scene_to_file("res://Scenes/Worlds/Graveyard.tscn")


func _on_start_world_3_btn_2_pressed():
	SceneTransition.change_scene_to_file("res://Scenes/Worlds/volcano.tscn")


func _on_quit_btn_pressed():
	get_tree().quit()


func _on_texture_button_pressed():
	OS.shell_open("https://discord.gg/bQTPTc5Qrt")


func _on_texture_button_2_pressed():
	OS.shell_open("https://www.youtube.com/@SuperCrow")


func _on_texture_button_3_pressed():
	OS.shell_open("https://ko-fi.com/supercrow")


func _on_back_btn_pressed():
	show_and_hide(menu, options)


func _on_options_btn_pressed():
	show_and_hide(options, menu)
