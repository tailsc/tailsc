extends Node3D

var voices = DisplayServer.tts_get_voices_for_language("en")
@onready var voice_id = voices[0]

@onready var focus: Label3D = $FOCUS
@onready var interacted: Label3D = $INTERACTED
@onready var unfocused: Label3D = $UNFOCUSED


func _on_interactable_focused(interactor: Interactor) -> void:
	focus.show()
	interacted.hide()
	unfocused.hide()

func _on_interactable_interacted(interactor: Interactor) -> void:
	if Input.is_action_just_pressed("interact"):
		DisplayServer.tts_speak("you are a good boy", voice_id)
		#print(voices)
		focus.hide()
		interacted.show()
		unfocused.hide()

func _on_interactable_unfocused(interactor: Interactor) -> void:
	focus.hide()
	interacted.hide()
	unfocused.show()
