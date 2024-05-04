extends Node3D

@onready var healthbar = $Healthbar/SubViewport/Healthbar
@onready var animation_player = $AnimationPlayer
@onready var Hitheal : AudioStreamPlayer3D = $HitHeal
var health = 100
const target_ran = 4
# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("DrillAnim")
	healthbar.value = health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func hit():
	if health >0:
		health -= 1
		healthbar.value = health
		Hitheal.play()
		if health < 1:
			$Timer.start()
			$Camera3D.current = true
			$Healthbar.visible = false 
			get_parent().get_node("Player").position = Vector3(100,0,190)
			$AnimationTree.play("endscene")
			$black_smoke.emitting = true
			$black_smoke2.emitting = true
			$black_smoke3.emitting = true
			$black_smoke4.emitting = true
			$black_smoke5.emitting = true
			$black_smoke6.emitting = true
func heal():
	if health < 100:
		health += 1
		healthbar.value = health
		Hitheal.play()
	
	
	


func _on_timer_timeout():
	ChangeScene.changeStage(ChangeScene.mainmenu)
	#get_tree().change_scene_to_file("res://[02] Scenes/Menues/MainMenu.tscn")
