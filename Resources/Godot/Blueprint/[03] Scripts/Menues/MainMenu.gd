extends Node3D

#Add new ones for elements you want to hide or show
@onready var options = $Ui/OPTIONS
@onready var menu = $Ui/MainMenu
@onready var save_load = $Ui/SAVE_LOAD
@onready var Save_load = $Ui/SAVE_LOAD
@onready var animator = $AnimationPlayer

func _ready():
	$Ui/MainMenu/MenuBtn/VBoxContainer/PlayBtn.grab_focus()
	$AnimationPlayer.play("CameraMove")
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func show_and_hide(first, second):
	first.show()
	second.hide()

#Play
func _on_play_btn_pressed():
	#show_and_hide(save_load, menu)
	ChangeScene.changeScene(ChangeScene.tutorialLevel)
	#DisplayServer


func _on_options_btn_pressed():
	animator.play("OptionsFade")
	show_and_hide(options, menu)


func _on_quit_btn_pressed():
	get_tree().quit()


func _on_back_btn_pressed():
	show_and_hide(menu, options)


func _on_youtube_video_btn_pressed():
	OS.shell_open("https://youtu.be/gIK02BgCCBI?si=TiHl5fCWozaqa4h_")



func _on_discord_btn_pressed():
	OS.shell_open("https://discord.gg/bQTPTc5Qrt")


func _on_youtube_btn_pressed():
	OS.shell_open("https://www.youtube.com/@SuperCrow")


func _on_kofi_btn_pressed():
	OS.shell_open("https://ko-fi.com/supercrow")
