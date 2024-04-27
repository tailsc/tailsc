extends Area3D

@onready var animator: AnimationPlayer = $".."
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.bells > 19:
		get_parent().play("open")
	await animator.animation_finished
	StageManager.changeStage(StageManager.mainmenu)
