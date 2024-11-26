extends Node

signal fps_displayed(value)
signal bloom_toggled(value)
signal brightness_updated(value)
signal fov_updated(value)
signal mouse_sens_updated(value)

	
func toggle_fullscreen(value):
	get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (value) else Window.MODE_WINDOWED
	
func toggle_windowed(value):
	get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (!value) else Window.MODE_WINDOWED
	
func toggle_borderless(value):
	get_window().borderless = value
	
	
func toggle_vsync(value):
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if (value) else DisplayServer.VSYNC_DISABLED)
	
	
func toggle_fps_display(value):
	emit_signal("fps_displayed", value)
	

func toggle_bloom(value):
	emit_signal("bloom_toggled", value)
	
	
func update_brightness(value):
	emit_signal("brightness_updated", value)
	
	
#bus_idx add music, sfx
func update_master_vol(vol):
	AudioServer.set_bus_volume_db(0, vol) 
	
func update_music_vol(vol):
	AudioServer.set_bus_volume_db(1, vol) 

func update_sfx_vol(vol):
	AudioServer.set_bus_volume_db(2, vol) 
	
	
func update_fov(value):
	emit_signal("fov_updated", value)
	#put in player script later to change fov/mouse sens
	#GlobalSettings.connect("fov_updated", self, "_on_fov_updated")
	#GlobalSettings.connect("mouse_sens_updated", self, "_on_mouse_sens_updated")
#func _on_fov_updated(value):
#	Camera.fov = value
#func _on_mouse_sens_updated(value):
#	mouse_sensitivity = value
	
	
func update_mouse_sens(value):
	emit_signal("mouse_sens_updated", value)


