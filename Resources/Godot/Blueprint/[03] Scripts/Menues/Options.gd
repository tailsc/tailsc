extends Control

func _ready():
#region Ready input
	MoveForward.pressed.connect(_on_button_pressed.bind(MoveForward))
	MoveBackward.pressed.connect(_on_button_pressed.bind(MoveBackward))
	MoveLeft.pressed.connect(_on_button_pressed.bind(MoveLeft))
	MoveRight.pressed.connect(_on_button_pressed.bind(MoveRight))
	Jump.pressed.connect(_on_button_pressed.bind(Jump))
	Sprint.pressed.connect(_on_button_pressed.bind(Sprint))

	_update_labels()
#endregion
#region Call options functions in ready
	Add_Resolutions()
	Check_Variables()
	Get_Screens()
#endregion

#region Input

#region Input
var current_button : Button

@onready var MoveForward : Button = $ScrollContainer/MarginContainer/TabContainer/Controls/MoveForwardPanel/MoveForward
@onready var MoveLeft : Button = $ScrollContainer/MarginContainer/TabContainer/Controls/MoveLeftPanel/MoveLeft
@onready var MoveBackward : Button = $ScrollContainer/MarginContainer/TabContainer/Controls/MoveBackwardPanel/MoveBackward
@onready var MoveRight : Button = $ScrollContainer/MarginContainer/TabContainer/Controls/MoveRightPanel/MoveRight
@onready var Jump : Button = $ScrollContainer/MarginContainer/TabContainer/Controls/JumpPanel/Jump
@onready var Sprint : Button = $ScrollContainer/MarginContainer/TabContainer/Controls/SprintPanel/Sprint
#endregion

func _input(event: InputEvent) -> void:
	if !current_button: # return if no current_button is null
		return
		
	if event is InputEventKey || event is InputEventMouseButton:
		
		# This part is for deleting duplicate assignments:
		# Add all assigned keys to a dictionary
		var all_ies : Dictionary = {}
		for ia in InputMap.get_actions():
			for iae in InputMap.action_get_events(ia):
				all_ies[iae.as_text()] = ia
		
		# check if the new key is already in the dict.
		# If yes, delete the old one.
		if all_ies.keys().has(event.as_text()):
			InputMap.action_erase_events(all_ies[event.as_text()])
		
		# Erase the event in the Input map
		InputMap.action_erase_events(current_button.name)
		# And assign the new event to it
		InputMap.action_add_event(current_button.name, event)
		
		# After a key is assigned, set current_button back to null
		current_button = null

		_update_labels() # refresh the labels

func _on_button_pressed(button: Button) -> void:
	current_button = button # assign clicked button to current_button

func _update_labels() -> void:
	# This is just a quick way to update the labels:
	var eb1 : Array[InputEvent] = InputMap.action_get_events("MoveForward")
	if !eb1.is_empty():
		MoveForward.text = eb1[0].as_text()
	else:
		MoveForward.text = ""
		
	var eb2 : Array[InputEvent] = InputMap.action_get_events("MoveLeft")
	if !eb2.is_empty():
		MoveLeft.text = eb2[0].as_text()
	else:
		MoveLeft.text = ""
		
	var eb3 : Array[InputEvent] = InputMap.action_get_events("MoveBackward")
	if !eb3.is_empty():
		MoveBackward.text = eb3[0].as_text()
	else:
		MoveBackward.text = ""
		
	var eb4 : Array[InputEvent] = InputMap.action_get_events("MoveRight")
	if !eb4.is_empty():
		MoveRight.text = eb4[0].as_text()
	else:
		MoveRight.text = ""
		
	var eb5 : Array[InputEvent] = InputMap.action_get_events("Jump")
	if !eb5.is_empty():
		Jump.text = eb5[0].as_text()
	else:
		Jump.text = ""
		
	var eb6 : Array[InputEvent] = InputMap.action_get_events("Sprint")
	if !eb6.is_empty():
		Sprint.text = eb6[0].as_text()
	else:
		Sprint.text = ""
#endregion

#region Options

@onready var full_screen_option_button = $ScrollContainer/MarginContainer/TabContainer/Video/WindowModePanel/WindowModeBtn
@onready var resolution_option_button = $ScrollContainer/MarginContainer/TabContainer/Video/ResolutionPanel/ResolutionBtn
@onready var scale_label = $ScrollContainer/MarginContainer/TabContainer/Video/ScalePanel/ProcentLabel
@onready var scale_slider = $ScrollContainer/MarginContainer/TabContainer/Video/ScalePanel/ScaleSlider
@onready var ScalePanel = $ScrollContainer/MarginContainer/TabContainer/Video/ScalePanel
@onready var vsync_option_button = $ScrollContainer/MarginContainer/TabContainer/Video/VsyncPanel/VsyncBtn
@onready var fsr_options = $ScrollContainer/MarginContainer/TabContainer/Video/AmdFsrPanel
@onready var screen_selector = $ScrollContainer/MarginContainer/TabContainer/Video/TargetDisplayPanel/TargetDisplayBtn

@onready var viewport_rid = get_tree().get_root().get_viewport_rid()

#Add more for more resolutions
var Resolutions: Dictionary = {"3840x2160":Vector2i(3840,2160),
								"2560x1440":Vector2i(2560,1080),
								"1920x1080":Vector2i(1920,1080),
								"1366x768":Vector2i(1366,768),
								"1536x864":Vector2i(1536,864),
								"1280x720":Vector2i(1280,720),
								"1440x900":Vector2i(1440,900),
								"1600x900":Vector2i(1600,900),
								"1024x600":Vector2i(1024,600),
								"800x600": Vector2i(800,600)}

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

func _on_window_mode_btn_item_selected(index):
	resolution_option_button.set_disabled(index==0)
	match index:
		0: #Fullscreen
			get_window().set_mode(Window.MODE_FULLSCREEN)
			Set_Resolution_Text()
		1: #Windowed
			get_window().set_mode(Window.MODE_WINDOWED)
			Centre_Window()
	get_tree().create_timer(.05).timeout.connect(Set_Resolution_Text)

func _on_resolution_btn_item_selected(index):
	var ID = resolution_option_button.get_item_text(index)
	get_window().set_size(Resolutions[ID])
	Set_Resolution_Text()
	Centre_Window()
	
func Centre_Window():
	var Centre_Screen = DisplayServer.screen_get_position()+DisplayServer.screen_get_size()/2
	var Window_Size = get_window().get_size_with_decorations()
	get_window().set_position(Centre_Screen-Window_Size/2)

func Get_Screens():
	var Screens = DisplayServer.get_screen_count()
	
	for s in Screens:
		screen_selector.add_item("Screen: "+str(s))


func _on_target_display_btn_item_selected(index):
	var _window = get_window()
	
	var mode = _window.get_mode()

	_window.set_mode(Window.MODE_WINDOWED)
	_window.set_current_screen(index)
	
	if mode == Window.MODE_FULLSCREEN:
		_window.set_mode(Window.MODE_FULLSCREEN)

func _on_frame_rate_cap_btn_item_selected(index):
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


func _on_vsync_btn_item_selected(index):
	match index:
		0:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		1:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)


func _on_scale_slider_value_changed(value):
	var Resolution_Scale = value/100.00
	print(value)
	var Resolution_Text = str(round(get_window().get_size().x*Resolution_Scale))+"x"+str(round(get_window().get_size().y*Resolution_Scale))
	
	scale_label.set_text(str(value)+"%")
	get_viewport().set_scaling_3d_scale(Resolution_Scale)


func _on_render_scale_btn_item_selected(index):
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


func _on_amd_fsr_btn_item_selected(index):
	match index:
		1:
			_on_scale_slider_value_changed(50.00)
		2:
			_on_scale_slider_value_changed(59.00)
		3:
			_on_scale_slider_value_changed(67.00)
		4:
			_on_scale_slider_value_changed(77.00)


func _on_shadows_btn_item_selected(index):
	match index:
		0:
			Global.light.shadow_enabled = false
		1:
			Global.light.shadow_enabled = true

func _on_shadow_quality_btn_item_selected(index):
	Global.light.directional_shadow_mode = index


func _on_ssr_btn_item_selected(index):
	match index:
		0:
			Global.world_environment.environment.ssr_enabled = false
		1:
			Global.world_environment.environment.ssr_enabled = true

func _on_ssao_btn_item_selected(index):
	match index:
		0:
			Global.world_environment.environment.ssao_enabled = false
		1:
			Global.world_environment.environment.ssao_enabled = true


func _on_ssil_btn_item_selected(index):
	match index:
		0:
			Global.world_environment.environment.ssil_enabled = false
		1:
			Global.world_environment.environment.ssil_enabled = true


func _on_sdfgi_btn_item_selected(index):
	match index:
		0:
			Global.world_environment.environment.sdfgi_enabled = false
		1:
			Global.world_environment.environment.sdfgi_enabled = true


func _on_glow_btn_item_selected(index):
	match index:
		0:
			Global.world_environment.environment.glow_enabled = false
		1:
			Global.world_environment.environment.glow_enabled = true


func _on_msaa_btn_item_selected(index):
	match index:
		0:
			RenderingServer.viewport_set_msaa_3d(viewport_rid, RenderingServer.VIEWPORT_MSAA_DISABLED)
		1:
			RenderingServer.viewport_set_msaa_3d(viewport_rid, RenderingServer.VIEWPORT_MSAA_2X)
		2:
			RenderingServer.viewport_set_msaa_3d(viewport_rid, RenderingServer.VIEWPORT_MSAA_4X)
		3:
			RenderingServer.viewport_set_msaa_3d(viewport_rid, RenderingServer.VIEWPORT_MSAA_8X)


func _on_taa_btn_item_selected(index):
	match index:
		0:
			get_viewport().use_taa = false
		1:
			get_viewport().use_taa = true

func _on_ssaa_btn_item_selected(index):
	match index:
		0:
			get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA
		1:
			get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED


#endregion
