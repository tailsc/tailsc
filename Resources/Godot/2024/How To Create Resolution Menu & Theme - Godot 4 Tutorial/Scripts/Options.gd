extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_option_button_item_selected(index):
	match index:
		0:
			get_window().set_size(Vector2(1280,720))
		1:
			get_window().set_size(Vector2(1920, 1080))
		2:
			get_window().set_size(Vector2(2560,1440))
		3:
			get_window().set_size(Vector2(3840,2160))
