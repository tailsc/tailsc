extends Node3D

@onready var midSpawn : AudioStreamPlayer3D = $"1/MidSpawn"
@onready var rightSpawn : AudioStreamPlayer3D = $"2/RightSpawn"
@onready var leftSpawn : AudioStreamPlayer3D = $"3/LeftSpawn"

func _process(_delta):
	if midSpawn.playing == false:
		midSpawn.play()
		
	if rightSpawn.playing == false:
		rightSpawn.play()
			
	if leftSpawn.playing == false:
		leftSpawn.play()
		
		

