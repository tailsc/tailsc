#extends Popup
#
#@onready var hover_sound = get_node("UI_Hover")
#@onready var click_sound = get_node("UI_Click")
## video Settings
#@onready var display_options = $SettingTabs/Video/MarginContainer/VideoSettings/DisplayOptionBtn
#@onready var vsync_btn = $SettingTabs/Video/MarginContainer/VideoSettings/VsyncButton
#@onready var display_fps_btn = $SettingTabs/Video/MarginContainer/VideoSettings/DisplayFpsBtn
#@onready var max_fps_val = $SettingTabs/Video/MarginContainer/VideoSettings/MaxFpsOptionBtn
#@onready var Bloom_btn = $SettingTabs/Video/MarginContainer/VideoSettings/BloomBtn
#@onready var brightness_slider = $SettingTabs/Video/MarginContainer/VideoSettings/BrightnessSlider
#@onready var Resolution_btn = $SettingTabs/Video/MarginContainer/VideoSettings/ResolutionBtn
#
## audio settings
#@onready var master_vol_slider = $SettingTabs/Audio/MarginContainer/AudioSettings/MasterVolSlider
#@onready var music_vol_slider = $SettingTabs/Audio/MarginContainer/AudioSettings/MusicVolSlider
#@onready var sfx_vol_slider = $SettingTabs/Audio/MarginContainer/AudioSettings/SfxVolSlider
#@onready var Backsound_btn =  $SettingTabs/Audio/MarginContainer/AudioSettings/Backsoundbtn
#
## Gameplay settings
#@onready var fov_val = $SettingTabs/Gameplay/MarginContainer/GameSettings/HBoxContainer/FovVal
#@onready var fov_slider = $SettingTabs/Gameplay/MarginContainer/GameSettings/HBoxContainer/FovSlider
#@onready var mouse_sens_val = $SettingTabs/Gameplay/MarginContainer/GameSettings/HBoxContainer2/MouseSensVal
#@onready var mouse_sens_slider = $SettingTabs/Gameplay/MarginContainer/GameSettings/HBoxContainer2/MouseSensSlider
#
func _ready():
	pass
#
#	#func _on_VsyncButton_toggled(button_pressed):
##    GlobalSettings.toggle_vsync(button_pressed)
##    if button_pressed:
##        VsyncButton.text = "Vsync On"
##        VsyncButton.modulate = Color(0, 1, 0)
##    else:
##        VsyncButton.text = "Vsync Off"
##        VsyncButton.modulate = Color(1, 0, 0)
#	#pass
#	#display_options.select(1 if Save.game_data.fullscreen_on else 0)
#	#GlobalSettings.toggle_fullscreen(Save.game_data.fullscreen_on)
#	#vsync_btn.pressed = Save.game_data.vsync_on
#	#display_fps_btn.pressed = Save.game_data.display_fps
#	#max fps options NEED FIX
#	#Bloom_btn.pressed = Save.game_data.bloom_on
#	#brightness_slider.value = Save.game_data.brightness
#
#	#master_vol_slider.value = Save.game_data.master_vol
#
#	#fov_slider.value = Save.game_data.fov
#	#mouse_sens_slider.value = Save game_data.mouse_sens
#
#
#
#func _on_DisplayOptionBtn_item_selected(index):
#	click_sound.play()
#	match index:
#		0:
#			GlobalSettings.toggle_fullscreen(true if index == 0 else false)
#		1:
#			GlobalSettings.toggle_windowed(true if index == 1 else false)
#		2:
#			GlobalSettings.toggle_borderless(true if index == 2 else false)
#
#func _on_VsyncButton_toggled(button_pressed):
#	click_sound.play()
#	GlobalSettings.toggle_vsync(button_pressed)
#
#
#func _on_DisplayFpsBtn_toggled(button_pressed):
#	click_sound.play()
#	GlobalSettings.toggle_fps_display(button_pressed)
#
#
##Skappa ny items i node MaxFpsOptionBtn och matcha id här för att ändra
#const TARGET_FPS_MAP = {
#	0: 25,
#	1: 30,
#	2: 60,
#	3: 80,
#	4: 120,
#	5: 144,
#	6: 240,
#	7: 0
#}
#
#var target_fps: int = 60
#
#func _ready() -> void:
#	Engine.target_fps = target_fps
#
#func _on_MaxFpsOptionBtn_item_selected(index: int) -> void:
#	click_sound.play()
#
#	if TARGET_FPS_MAP.has(index):
#		target_fps = TARGET_FPS_MAP[index]
#		Engine.target_fps = target_fps
#
#func _physics_process(delta: float) -> void:
#	Engine.time_scale = target_fps > 0 ? target_fps / Engine.target_fps : 0
#
#
#
#func _on_BloomBtn_toggled(button_pressed):
#	click_sound.play()
#	GlobalSettings.toggle_bloom(button_pressed)
#
#
#func _on_BrightnessSlider_value_changed(value):
#	click_sound.play()
#	GlobalSettings.update_brightness(value)
#
##Funkar bara i windowed mode 
#func _on_ResolutionBtn_item_selected(index):
#	click_sound.play()
#	match index:
#		0:
#			get_window().set_size(Vector2(1280,720))
#			OS.center_window()
#		1:
#			get_window().set_size(Vector2(1920,1080))
#			OS.center_window()
#		2:
#			get_window().set_size(Vector2(2560,1440))
#			OS.center_window()
#		3:
#			get_window().set_size(Vector2(3840,2160))
#			OS.center_window()
#
#
#func _on_MasterVolSlider_value_changed(value):
#	click_sound.play()
#	AudioServer.set_bus_volume_db(0, value) 
#
#
#func _on_MusicVolSlider_value_changed(value):
#	click_sound.play()
#	AudioServer.set_bus_volume_db(1, value) 
#
#
#func _on_SfxVolSlider_value_changed(value):
#	click_sound.play()
#	AudioServer.set_bus_volume_db(2, value) 
#
#
##Funkar mer som en mute knapp men vill att den ska muta när man tab out
#func _on_Backsoundbtn_toggled(value):
#	click_sound.play()
#	var bus_index = AudioServer.get_bus_index("Master")
#	if value:
#		# Enable sound
#		AudioServer.set_bus_mute(bus_index, false)	
#	else:
#		# Mute sound
#		AudioServer.set_bus_mute(bus_index, true)
#
##NEED FIX
##func _on_FovSlider_value_changed(value):
##	GlobalSettings.update_fox(value)
##	fov_val.text = str(value)
#
##NEED FIX
##func _on_MouseSensSlider_value_changed(value):
##	GlobalSettings.update_mouse_sens(value)
##	mouse_sens_val.text = str(value)
#
#
#func _on_DisplayOptionBtn_mouse_entered():
#	hover_sound.play()
#
#
#func _on_VsyncButton_mouse_entered():
#	hover_sound.play()
#
#
#func _on_DisplayFpsBtn_mouse_entered():
#	hover_sound.play()
#
#
#func _on_MaxFpsOptionBtn_mouse_entered():
#	hover_sound.play()
#
#
#func _on_BloomBtn_mouse_entered():
#	hover_sound.play()
#
#
#func _on_BrightnessSlider_mouse_entered():
#	hover_sound.play()
#
#
#func _on_ResolutionBtn_mouse_entered():
#	hover_sound.play()
#
#
#func _on_MasterVolSlider_mouse_entered():
#	hover_sound.play()
#
#
#func _on_MusicVolSlider_mouse_entered():
#	hover_sound.play()
#
#
#func _on_SfxVolSlider_mouse_entered():
#	hover_sound.play()
#
#
#func _on_Backsoundbtn_mouse_entered():
#	hover_sound.play()
