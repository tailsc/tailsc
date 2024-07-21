extends HSlider

@onready var VolumeSliderLabel = $Label
@export var bus_name: String

var bus_index: int


func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(_on_value_changed)
	
	value = db_to_linear(
		AudioServer.get_bus_volume_db(bus_index)
	)
	var audio_settings = ConfigFileHandler.load_audio_settings()
	%MasterVolumeSlider.value = min(audio_settings.Master, 1.0) * 100
	%MusicVolumeSlider.value = min(audio_settings.Music, 1.0) * 100
	%SfxVolumeSlider.value = min(audio_settings.Sfx, 1.0) * 100


func _on_value_changed(value: float) -> void:
	VolumeSliderLabel.set_text(str(value*100)+"%")
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(value)
	)


func _on_drag_ended(value_changed: bool) -> void:
	if %MasterVolumeSlider.value_changed:
		ConfigFileHandler.save_audio_settings("Master", %MasterVolumeSlider.value / 100)
	if %MusicVolumeSlider.value_changed:
		ConfigFileHandler.save_audio_settings("Music", %MusicVolumeSlider.value / 100)
	if %SfxVolumeSlider.value_changed:
		ConfigFileHandler.save_audio_settings("Sfx", %SfxVolumeSlider.value / 100)
		print("HELLOS")
