extends Node3D

@onready var options = $OPTIONS
@onready var menu = $UI

func show_and_hide(first, second):
	first.show()
	second.hide()

func _on_demo_btn_pressed():
	StageManager.changeStage(StageManager.demo)


func _on_options_btn_pressed():
	show_and_hide(options, menu)


func _on_quit_btn_pressed():
	get_tree().quit()


func _on_back_btn_pressed():
	show_and_hide(menu, options)


func _on_texture_btn_youtube_pressed():
	OS.shell_open("https://www.youtube.com/@SuperCrow")


func _on_texture_btn_kofi_pressed():
	OS.shell_open("https://ko-fi.com/supercrow")


func _on_texture_btn_discord_pressed():
	OS.shell_open("https://discord.gg/bQTPTc5Qrt")


func _on_dungeon_btn_pressed() -> void:
	StageManager.changeStage(StageManager.dungeon)
