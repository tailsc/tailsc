extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  SilentWolf.configure({
	"api_key": "I0AWLXI10S1cpF597rsTi6tUCJjGgzyo2D9G7ec0",
	"game_id": "subscribe",
	"log_level": 1
  })

  SilentWolf.configure_scores({
	"open_scene_on_close": "res://example.tscn"
  })
