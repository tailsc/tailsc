extends Resource
class_name Equipment

@export var cost: Array[int] = []
@export var damage: Array[int] = []
var level: int = 0
@export var mesh: Mesh

func _apply_upgrade():
	# Example upgrade logic: Increase damage or other attributes
	if level < damage.size():
		# Implement the actual upgrade logic here
		print("Upgrade applied: New damage is ", damage[level])
