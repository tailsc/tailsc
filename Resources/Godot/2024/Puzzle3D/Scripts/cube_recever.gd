extends StaticBody3D


@export var activation_node = "doors"
@export var text1 = "Give me a cube!"
@export var text2 = "Press me!"
@export var activation_var = false
@export var state = "closed"
@export var object_name = "key"

signal deactivatedd

var self_destruct = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self_destruct:
		if activation_node == "self":
			if !$GPUParticles3D3.emitting:
				queue_free()


func _on_area_3d_body_entered(body):
	if body.Name == String(object_name):
		if body.Name == String("shear"):
			pass
		else:
			body.leave()
		if $block:
			
			$block.visible = true
		#deactivate()
		if activation_node == "self":
			$AnimationPlayer.play("disappear")
			if $block:
				
				$block.visible = false
			$GPUParticles3D3.emitting = true
			print("olaf")
		else:
			if state == "closed":
				get_node(activation_node).activate()
				state = "open"
			else:
				state = "closed"
				get_node(activation_node).deactivate()



func text():
	if activation_var:
		return String(text2)
	else:
		return String(text1)
func pressed():
	if activation_var:
		
		if activation_node == "Leaver" and state == "open":
			print("wdasawad")
			get_node(activation_node).deactivate()
			deactivate()
		else:
			$Area3D.monitoring = true
			$Timer.start()
func activate():
	activation_var = true
	print("true")

func deactivate():
	activation_var = false
	print("false")
	emit_signal("deactivatedd")

func _on_timer_timeout():
	$Area3D.monitoring =false
	


func _on_animation_player_animation_finished(anim_name):
	self_destruct = true
