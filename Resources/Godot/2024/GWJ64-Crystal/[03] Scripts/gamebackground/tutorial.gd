extends Node3D

var Goblin = load("res://[02] Scenes/Player/Goblin.tscn")
var instance 
var spawnposz = [46,36,36]
var spawnposx = [0,-32,32]
var diftime = 4
var tut_step = 0
var tut_text = ["left click to shoot!","turn around! see that Goblin? finish him!","you earned crystal!","use mousewheel to switch tool","use the cannon and place it!","with the hammer you can repair and upgrade it!","Protect the Drill at all costs!","shoot to start! survive!"]
var died = false
var tutorial = true
func _ready():
	$tutorial/Label3D.text = tut_text[0]
func _on_timer_timeout():
	$Timer.wait_time = randi_range(0.2,diftime)
	if $Timer.wait_time > diftime -0.3 and diftime > 0.2:
		diftime -=0.1
		print(diftime)
	instance = Goblin.instantiate()
	add_child(instance)
	var spawn = randi_range(0,2)
	instance.position = Vector3(spawnposx[spawn],2,spawnposz[spawn])
	


func next():
	if tutorial:
		tut_step += 1
		$tutorial/Label3D/next.position.y = 0
		if tut_step ==1:
			$tutorial/Label3D/next.position.y =-100
			instance = Goblin.instantiate()
			add_child(instance)
			instance.position = Vector3(spawnposx[0],2,spawnposz[0])
		if tut_step ==2:
			$Player.currency += 90
		if tut_step ==4:
			$tutorial/Label3D/next.position.y =-100
		if tut_step ==5:
			$tutorial/Label3D/next.position.y =-100
		if tut_step < 8:
			$tutorial/Label3D.text = tut_text[tut_step]
			
		else:
			tutorial = false
			$tutorial/Label3D.queue_free()
			$tutorial/Label3D.visible = false 
			$Timer.start()
			$Player/Timer.start()
			
		
