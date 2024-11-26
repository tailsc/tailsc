extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_leaver_solved():
	var tween = create_tween()
	tween.tween_property(self,"rotation_degrees",Vector3(0,-90,0),1)
