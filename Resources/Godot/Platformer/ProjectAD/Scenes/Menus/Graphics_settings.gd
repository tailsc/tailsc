extends Control


func _on_ssr_toggled(button_pressed):
	Graphics.world_environment.environment.ssr_enabled = button_pressed

func _on_ssao_toggled(button_pressed):
	Graphics.world_environment.environment.ssao_enabled = button_pressed

func _on_ssil_toggled(button_pressed):
	Graphics.world_environment.environment.ssil_enabled = button_pressed

func _on_sdfgi_toggled(button_pressed):
	Graphics.world_environment.environment.sdfgi_enabled = button_pressed

func _on_shadows_toggled(button_pressed):
	Graphics.light.shadow_enabled = button_pressed

func _on_vsync_toggled(button_pressed):
	if button_pressed==true:
		#Maybe needs to get refresh rate? DisplayServer.screen_get_refresh_rate()
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		print('enable')
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		print('disable')


func _on_glow_toggled(button_pressed):
	Graphics.world_environment.environment.glow_enabled = button_pressed

func _on_shadow_btn_item_selected(index):
	Graphics.light.directional_shadow_mode = index


func _on_resolution_btn_item_selected(index):
	match index:
		0:
			get_window().set_size(Vector2(640,480))
		1:
			get_window().set_size(Vector2(1280,720))
		2:
			get_window().set_size(Vector2(1920,1080))
		3:
			get_window().set_size(Vector2(2560,1440))
		4:
			get_window().set_size(Vector2(3840,2160))

func _on_frame_rate_btn_item_selected(index):
	match index:
		0:
			Engine.max_fps = 30;
		1:
			Engine.max_fps = 60;
		2:
			Engine.max_fps = 144;
		3:
			Engine.max_fps = 240;
		4:
			Engine.max_fps = 0;

func _on_window_btn_item_selected(index):
	match index:
		0: #Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		1: #Windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		2: #Borderless
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


@warning_ignore("unused_parameter")
func _on_master_value_changed(value):
	pass # Replace with function body.
