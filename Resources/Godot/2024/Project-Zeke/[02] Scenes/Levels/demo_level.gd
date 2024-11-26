extends Node3D

@onready var player: Node3D = $Player/SubViewportContainer/SubViewport/CharacterBody3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	get_tree().call_group("enemies", "update_target_location", player.global_transform.origin)


func _on_interactable_interacted(interactor: Interactor) -> void:
	$Node3D/CSGBox3D.hide()
	$Node3D/CSGCylinder3D.show()
