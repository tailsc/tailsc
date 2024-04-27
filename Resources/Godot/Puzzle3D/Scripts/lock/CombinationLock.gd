
extends Node3D


@export var rotations = Vector3()

func _time():
	print($"button2/1".current_inp)
	print( $"button/2".current_inp )
	print( $"button3/3".current_inp )
	
	if $"button/2".current_inp == 2 and $"button3/3".current_inp == 3 and $"button2/1".current_inp == 1:
		var tween = create_tween()
		tween.tween_property(get_parent().get_parent(),"rotation_degrees",rotations,1)
		print("succes")
