extends Control

@onready var ResOptionButton = $ResolutionsContainer/OptionButton
@onready var FullscreenToggle = $FullScreenContainer/FullscreenToggle

func _on_ResolutionBtn_item_selected(index):
#	click_sound.play()
#	match index:
#		0:
#			get_window().set_size(Vector2(1280,720))
#			OS.center_window()
#		1:
#			get_window().set_size(Vector2(1920,1080))
#			OS.center_window()
var Resolutions: Dictionary = { "3840x2160":Vector2(3840,2160),
								"2560x1440":Vector2(2560,1440),
								"1920x1080":Vector2(1920,1080),
								"1366x768":Vector2(1366,768),
								"1536x864":Vector2(1536,864),
								"1280x720":Vector2(1280,720),
								"1440x900":Vector2(1440,900),
								"1600x900":Vector2(1600,900),
								"1024x600":Vector2(1024,600),
								"800x600": Vector2(800,600)}

func _ready():
	AddResolutions()
	FullscreenToggle.button_pressed = ((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN))
	
	
func AddResolutions():
	var CurrentResolution = get_viewport().get_size()
	
	var Index = 0
	
	for r in Resolutions:
		ResOptionButton.add_item(r,Index)
		
		if Resolutions[r] == CurrentResolution:
			ResOptionButton._select_int(Index)
			Index += 1

func _on_OptionButton_item_selected(index):
	var size = Resolutions.get(ResOptionButton.get_item_text(index))
	get_window().set_size(size)
	OS.center_window()
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT,SceneTree.STRETCH_ASPECT_KEEP, size)

func _on_FullscreenToggle_toggled(button_pressed):
	get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (button_pressed) else Window.MODE_WINDOWED

	if button_pressed == false:
		var size = get_viewport().get_size()
		get_window().set_size(size)
		OS.center_window()
