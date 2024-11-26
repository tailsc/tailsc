extends RigidBody3D

@export var Name = "shear"
var not_clipping = true
var holding_allowed = true
var not_drop = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func deactivate():
	$CollisionShape3D.disabled = true
func activate():
	$CollisionShape3D.disabled = false
func leave():
	if Name == "shear":
		if not_drop:
			pass
		else:
			holding_allowed = false
			queue_free()
	else:
		holding_allowed = false
		queue_free()
		
func text():
	return "PICK UP"
# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta):
	pass
	


@warning_ignore("unused_parameter")
func _on_area_3d_area_entered(area):
	not_drop = true


@warning_ignore("unused_parameter")
func _on_area_3d_area_exited(area):
	not_drop = false
