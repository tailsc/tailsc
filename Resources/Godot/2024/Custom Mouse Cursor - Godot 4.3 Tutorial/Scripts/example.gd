extends Control

var tool_water = preload("res://Assets/tool_water.png")
var tool_axe = preload("res://Assets/tool_axe.png")
var default = preload("res://Assets/pointer.png")


func _on_enemy_texture_rect_mouse_entered() -> void:
	Input.set_custom_mouse_cursor(tool_axe, Input.CURSOR_ARROW, Vector2(16, 16))

func _on_enemy_texture_rect_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(default, Input.CURSOR_ARROW, Vector2(16, 16))

func _on_plant_texture_rect_mouse_entered() -> void:
	Input.set_custom_mouse_cursor(tool_water, Input.CURSOR_ARROW, Vector2(16, 16))

func _on_plant_texture_rect_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(default, Input.CURSOR_ARROW, Vector2(16, 16))
