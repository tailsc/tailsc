extends Node

var world_environment: WorldEnvironment
var light:DirectionalLight3D

var mouse_sens = 0.05

func _ready() -> void:
	SilentWolf.configure({
	"api_key": "TR2ASCkK115f1WvG353gg6ZAyra4ts1q5TkPujkB",
	"game_id": "fish",
	"log_level": 1
  })

	SilentWolf.configure_scores({
	"open_scene_on_close": "res://tutorial.tscn"
  })
