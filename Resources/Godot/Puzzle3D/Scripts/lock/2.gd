extends MeshInstance3D
var pos = Vector3()
var tween 
var current_inp = 1
func _ready():
	
	pos = rotation_degrees
	print(self.name + str(rotation_degrees))
func activate():
		current_inp += 1
		if current_inp == 6:
			current_inp =1
			
		tween = create_tween()
		pos += Vector3(72,0,0)
		tween.tween_property(self,"rotation_degrees",pos,0.4)
		
		print(self.name + str(rotation_degrees))
func deactivate():
	activate()
	
