extends VBoxContainer

@onready var full_screen_option_button: OptionButton = $WindowModePanel/WindowModeButton
@onready var resolution_option_button: OptionButton = $ResolutionPanel/ResolutionBtn
@onready var scale_label: Label = $ScalePanel/ProcentLabel
@onready var scale_slider: HSlider = $ScalePanel/ScaleSlider
@onready var ScalePanel: Panel = $ScalePanel
@onready var vsync_option_button: OptionButton = $VsyncPanel/VsyncBtn
@onready var fsr_options: Panel = $AmdFsrPanel
@onready var screen_selector: OptionButton = $TargetDisplayPanel/TargetDisplayBtn

@onready var viewport_rid = get_tree().get_root().get_viewport_rid()

var Resolutions: Dictionary = {"3840x2160":Vector2i(3840,2160),
								"2560x1440":Vector2i(2560,1080),
								"1920x1080":Vector2i(1920,1080),
								"1366x768":Vector2i(1366,768),
								"1536x864":Vector2i(1536,864),
								"1280x720":Vector2i(1280,720),
								"1440x900":Vector2i(1440,900),
								"1600x900":Vector2i(1600,900),
								"1152x648":Vector2i(1152,648),
								"1024x600":Vector2i(1024,600),
								"800x600": Vector2i(800,600)}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var video_settings = ConfigFileHandler.load_video_settings()
	%WindowModeButton.selected = video_settings.WindowMode
	#%TargetDisplayBtn.selected = video_settings.TargetDisplay
	#%ResolutionBtn.selected = video_settings.Resolution
	%FrameRateCapBtn.selected = video_settings.FrameRateCap
	%VsyncBtn.selected = video_settings.Vsync
	%RenderScaleBtn.selected = video_settings.RenderingScalingMode
	%AmdFsrBtn.selected = video_settings.AmdFsr
	%ShadowsBtn.selected = video_settings.Shadows
	%ShadowQualityBtn.selected = video_settings.ShadowQuality
	%SsrBtn.selected = video_settings.Ssr
	%SsaoBtn.selected = video_settings.Ssao
	%SsilBtn.selected = video_settings.Ssil
	%SdfgiBtn.selected = video_settings.Sdfgi
	%GlowBtn.selected = video_settings.Glow
	%MsaaBtn.selected = video_settings.Msaa
	%TaaBtn.selected = video_settings.Taa
	%SsaaBtn.selected = video_settings.Ssaa
	
	# Call options functions in ready
	Check_Variables()
	Add_Resolutions()
	Get_Screens()
	
	_on_window_mode_button_item_selected(video_settings.WindowMode)
	#_on_target_display_btn_item_selected(video_settings.TargetDisplay)
	#_on_resolution_btn_item_selected(video_settings.Resolution)
	_on_frame_rate_cap_btn_item_selected(video_settings.FrameRateCap)
	_on_vsync_btn_item_selected(video_settings.Vsync)
	_on_render_scale_btn_item_selected(video_settings.RenderingScalingMode)
	_on_amd_fsr_btn_item_selected(video_settings.AmdFsr)
	#_on_scale_slider_value_changed(video_settings.WindowMode)
	_on_shadows_btn_item_selected(video_settings.Shadows)
	_on_shadow_quality_btn_item_selected(video_settings.ShadowQuality)
	_on_ssr_btn_item_selected(video_settings.Ssr)
	_on_ssao_btn_item_selected(video_settings.Ssao)
	_on_ssil_btn_item_selected(video_settings.Ssil)
	_on_sdfgi_btn_item_selected(video_settings.Sdfgi)
	_on_glow_btn_item_selected(video_settings.Glow)
	_on_msaa_btn_item_selected(video_settings.Msaa)
	_on_taa_btn_item_selected(video_settings.Taa)
	_on_ssaa_btn_item_selected(video_settings.Ssaa)


func Check_Variables():
	var _window = get_window()
	var mode = _window.get_mode()
	
	if mode == Window.MODE_FULLSCREEN:
		resolution_option_button.set_disabled(true)
		full_screen_option_button.set_pressed_no_signal(true)
		
	if DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_ENABLED:
		vsync_option_button.set_pressed_no_signal(true)


func Set_Resolution_Text():
	var Resolution_Text = str(get_window().get_size().x)+"x"+str(get_window().get_size().y)
	resolution_option_button.set_text(Resolution_Text)
	
	scale_slider.set_value_no_signal(100.00)
	_on_scale_slider_value_changed(100.00)


func Add_Resolutions():
	var Current_Resolution = get_window().get_size()
	var ID = 0
	
	for r in Resolutions:
		resolution_option_button.add_item(r, ID)
		
		if Resolutions[r] == Current_Resolution:
			resolution_option_button.select(ID)
		
		ID += 1


func Centre_Window():
	var Centre_Screen = DisplayServer.screen_get_position()+DisplayServer.screen_get_size()/2
	var Window_Size = get_window().get_size_with_decorations()
	get_window().set_position(Centre_Screen-Window_Size/2)


func Get_Screens():
	var Screens = DisplayServer.get_screen_count()
	
	for s in Screens:
		screen_selector.add_item("Screen: "+str(s))


func _on_window_mode_button_item_selected(index: int) -> void:
	ConfigFileHandler.save_video_settings("WindowMode", index)
	resolution_option_button.set_disabled(index==0)
	match index:
		0: #Fullscreen
			get_window().set_mode(Window.MODE_FULLSCREEN)
			Set_Resolution_Text()
		1: #Windowed
			get_window().set_mode(Window.MODE_WINDOWED)
			Centre_Window()
	get_tree().create_timer(.05).timeout.connect(Set_Resolution_Text)


func _on_target_display_btn_item_selected(index: int) -> void:
	#ConfigFileHandler.save_video_settings("TargetDisplay", index)
	var _window = get_window()
	
	var mode = _window.get_mode()

	_window.set_mode(Window.MODE_WINDOWED)
	_window.set_current_screen(index)
	
	if mode == Window.MODE_FULLSCREEN:
		_window.set_mode(Window.MODE_FULLSCREEN)


func _on_resolution_btn_item_selected(index: int) -> void:
	#ConfigFileHandler.save_video_settings("Resolution", index)
	var ID = resolution_option_button.get_item_text(index)
	get_window().set_size(Resolutions[ID])
	Set_Resolution_Text()
	Centre_Window()


func _on_frame_rate_cap_btn_item_selected(index: int) -> void:
	ConfigFileHandler.save_video_settings("FrameRateCap", index)
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


func _on_vsync_btn_item_selected(index: int) -> void:
	ConfigFileHandler.save_video_settings("Vsync", index)
	match index:
		0:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		1:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)


func _on_render_scale_btn_item_selected(index: int) -> void:
	ConfigFileHandler.save_video_settings("RenderingScalingMode", index)
	var _viewport = get_viewport()
	
	match index:
		1:
			_viewport.set_scaling_3d_mode(Viewport.SCALING_3D_MODE_BILINEAR)
			scale_slider.set_editable(true)
			fsr_options.hide()
			ScalePanel.show()
		2:
			_viewport.set_scaling_3d_mode(Viewport.SCALING_3D_MODE_FSR2)
			scale_slider.set_editable(false)
			fsr_options.show()
			ScalePanel.hide()


func _on_amd_fsr_btn_item_selected(index: int) -> void:
	ConfigFileHandler.save_video_settings("AmdFsr", index)
	match index:
		1:
			_on_scale_slider_value_changed(50.00)
		2:
			_on_scale_slider_value_changed(59.00)
		3:
			_on_scale_slider_value_changed(67.00)
		4:
			_on_scale_slider_value_changed(77.00)


func _on_scale_slider_value_changed(value: float) -> void:
	var Resolution_Scale = value/100.00
	print(value)
	var Resolution_Text = str(round(get_window().get_size().x*Resolution_Scale))+"x"+str(round(get_window().get_size().y*Resolution_Scale))
	
	scale_label.set_text(str(value)+"%")
	get_viewport().set_scaling_3d_scale(Resolution_Scale)


func _on_shadows_btn_item_selected(index: int) -> void:
	ConfigFileHandler.save_video_settings("Shadows", index)
	match index:
		0:
			Global.light.shadow_enabled = false
		1:
			Global.light.shadow_enabled = true


func _on_shadow_quality_btn_item_selected(index):
	ConfigFileHandler.save_video_settings("ShadowQuality", index)
	Global.light.directional_shadow_mode = index


func _on_ssr_btn_item_selected(index: int) -> void:
	ConfigFileHandler.save_video_settings("Ssr", index)
	match index:
		0:
			Global.world_environment.environment.ssr_enabled = false
		1:
			Global.world_environment.environment.ssr_enabled = true


func _on_ssao_btn_item_selected(index: int) -> void:
	ConfigFileHandler.save_video_settings("Ssao", index)
	match index:
		0:
			Global.world_environment.environment.ssao_enabled = false
		1:
			Global.world_environment.environment.ssao_enabled = true


func _on_ssil_btn_item_selected(index: int) -> void:
	ConfigFileHandler.save_video_settings("Ssil", index)
	match index:
		0:
			Global.world_environment.environment.ssil_enabled = false
		1:
			Global.world_environment.environment.ssil_enabled = true


func _on_sdfgi_btn_item_selected(index: int) -> void:
	ConfigFileHandler.save_video_settings("Sdfgi", index)
	match index:
		0:
			Global.world_environment.environment.sdfgi_enabled = false
		1:
			Global.world_environment.environment.sdfgi_enabled = true


func _on_glow_btn_item_selected(index: int) -> void:
	ConfigFileHandler.save_video_settings("Glow", index)
	match index:
		0:
			Global.world_environment.environment.glow_enabled = false
		1:
			Global.world_environment.environment.glow_enabled = true


func _on_msaa_btn_item_selected(index: int) -> void:
	ConfigFileHandler.save_video_settings("Msaa", index)
	match index:
		0:
			RenderingServer.viewport_set_msaa_3d(viewport_rid, RenderingServer.VIEWPORT_MSAA_DISABLED)
		1:
			RenderingServer.viewport_set_msaa_3d(viewport_rid, RenderingServer.VIEWPORT_MSAA_2X)
		2:
			RenderingServer.viewport_set_msaa_3d(viewport_rid, RenderingServer.VIEWPORT_MSAA_4X)
		3:
			RenderingServer.viewport_set_msaa_3d(viewport_rid, RenderingServer.VIEWPORT_MSAA_8X)


func _on_taa_btn_item_selected(index: int) -> void:
	ConfigFileHandler.save_video_settings("Taa", index)
	match index:
		0:
			get_viewport().use_taa = false
		1:
			get_viewport().use_taa = true


func _on_ssaa_btn_item_selected(index: int) -> void:
	ConfigFileHandler.save_video_settings("Ssaa", index)
	match index:
		0:
			get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA
		1:
			get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED


func _on_reset_button_pressed() -> void:
	ConfigFileHandler._reset_all_settings()
	print("RESET BTN")
	_ready()


func _on_load_pressed() -> void:
	ConfigFileHandler.load_video_settings()

func _on_tails_pressed() -> void:
	OS.shell_open("https://discord.com/users/364076254812438538")

func _on_crab_pressed() -> void:
	OS.shell_open("https://discord.com/users/744122961509744660")
