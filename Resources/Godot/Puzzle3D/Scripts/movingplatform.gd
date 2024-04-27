extends Node3D
@export var Target_loc: Vector3
@export var Begin_loc: Vector3
@export var with_button = true
var parent_loc = Vector3()
var parent_end_loc = Vector3()
func _ready():
	parent_loc = get_parent().position
	parent_end_loc = Target_loc +parent_loc
	
func activate():
	var tween = create_tween()
	if not with_button:
		tween.tween_property($StaticBody3D,"position",Target_loc,1)
	
	else:
		
		tween.tween_property(get_parent(),"position",parent_end_loc,1)
		
	
func deactivate():
	var tween = create_tween()
	if not with_button:
		tween.tween_property($StaticBody3D,"position",Begin_loc,1)
	
	else:
		tween.tween_property(get_parent(),"position",parent_loc,1)
	
