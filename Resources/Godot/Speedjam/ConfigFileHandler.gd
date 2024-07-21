extends Node


var config = ConfigFile.new()
const SETTINGS_FILE_PATH = "user://settings.ini"

var video_config = {
	"WindowMode": 1,  # Integer for window mode selection
	#"TargetDisplay": 3,  # Uncomment if needed (bool)
	#"Resolution": 1,    # Uncomment if needed (value depends on format)
	"FrameRateCap": 4,  # Integer for frame rate limit
	"Vsync": 0,        # Integer for vsync setting
	"RenderingScalingMode": 0,  # Integer for scaling mode
	"AmdFsr": 0,        # Integer for AMD FSR setting
	"Shadows": 1,       # Integer for shadow quality level
	"ShadowQuality": 0, # Integer for additional shadow quality setting
	"Ssr": 0,           # Integer for SSR setting
	"Ssao": 0,          # Integer for SSAO setting
	"Ssil": 0,          # Integer for SSIL setting (if applicable)
	"Sdfgi": 0,         # Integer for SDFGI setting (if applicable)
	"Glow": 0,          # Integer for glow setting
	"Msaa": 0,           # Integer for MSAA setting
	"Taa": 0,           # Integer for TAA setting
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		config.set_value("keybinding", "move_forward", "W")
		config.set_value("keybinding", "move_left", "A")
		config.set_value("keybinding", "move_backward", "S")
		config.set_value("keybinding", "move_right", "D")
		
		config.set_value("video", "WindowMode", 1)
		#config.set_value("video", "TargetDisplay", 3)
		#config.set_value("video", "Resolution", 1)
		config.set_value("video", "FrameRateCap", 4)
		config.set_value("video", "Vsync", 0)
		config.set_value("video", "RenderingScalingMode", 0)
		config.set_value("video", "AmdFsr", 0)
		config.set_value("video", "Shadows", 1)
		config.set_value("video", "ShadowQuality", 0)
		config.set_value("video", "Ssr", 0)
		config.set_value("video", "Ssao", 0)
		config.set_value("video", "Ssil", 0)
		config.set_value("video", "Sdfgi", 0)
		config.set_value("video", "Glow", 0)
		config.set_value("video", "Msaa", 0)
		config.set_value("video", "Taa", 0)
		config.set_value("video", "Ssaa", 0)
		
		config.set_value("audio", "Master", 1.0)
		config.set_value("audio", "Music", 1.0)
		config.set_value("audio", "Sfx", 1.0)
		config.set_value("audio", "MouseSens", 0.05)
		
		config.save(SETTINGS_FILE_PATH)
	else:
		config.load(SETTINGS_FILE_PATH)

func save_video_settings(key: String, index):
	config.set_value("video", key, index)
	config.save(SETTINGS_FILE_PATH)

func load_video_settings():
	var video_settings = {}
	for key in config.get_section_keys("video"):
		video_settings[key] = config.get_value("video", key)
	return video_settings

func save_audio_settings(key: String, value):
	config.set_value("audio", key, value)
	config.save(SETTINGS_FILE_PATH)
	
func load_audio_settings():
	var audio_settings = {}
	for key in config.get_section_keys("audio"):
		audio_settings[key] = config.get_value("audio", key)
	return audio_settings

func save_keybinding(action: StringName, event: InputEvent):
	var event_str
	if event is InputEventKey:
		event_str = OS.get_keycode_string(event.physical_keycode)
	elif event is InputEventMouseButton:
		event_str = "mouse_" + str(event.button_index)
		
	config.set_value("keybinding", action, event_str)
	config.save(SETTINGS_FILE_PATH)
	
func load_keybindings():
	var keybindings = {}
	var keys = config.get_section_keys("keybinding")
	for key in keys:
		var input_event
		var event_str = config.get_value("keybinding", key)
		
		if event_str.contains("mouse_"):
			input_event = InputEventMouseButton.new()
			input_event.button_index = int(event_str.split("_")[1])
		else:
			input_event = InputEventKey.new()
			input_event.keycode = OS.find_keycode_from_string(event_str)
			
		keybindings[key] = input_event
	return keybindings

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _reset_all_settings():
	config.set_value("video", "WindowMode", 1)
	#config.set_value("video", "TargetDisplay", null)
	#config.set_value("video", "Resolution", 1)
	config.set_value("video", "FrameRateCap", 4)
	config.set_value("video", "Vsync", 0)
	config.set_value("video", "RenderingScalingMode", 0)
	config.set_value("video", "AmdFsr", 0)
	config.set_value("video", "Shadows", 1)
	config.set_value("video", "ShadowQuality", 0)
	config.set_value("video", "Ssr", 0)
	config.set_value("video", "Ssao", 0)
	config.set_value("video", "Ssil", 0)
	config.set_value("video", "Sdfgi", 0)
	config.set_value("video", "Glow", 0)
	config.set_value("video", "Msaa", 0)
	config.set_value("video", "Taa", 0)
	config.set_value("video", "Ssaa", 0)
	
	config.set_value("audio", "Master", 1.0)
	config.set_value("audio", "Music", 1.0)
	config.set_value("audio", "Sfx", 1.0)
	
	config.save(SETTINGS_FILE_PATH)
