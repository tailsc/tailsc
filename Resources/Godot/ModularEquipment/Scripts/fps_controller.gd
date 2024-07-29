extends Node



func _ready() -> void:
	Global.currency += 50

func _physics_process(delta: float) -> void:
	$Label.text = str(Global.currency)


func _on_button_pressed() -> void:
	Global.currency += 500
