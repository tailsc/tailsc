@tool
extends Node2D

const ScoreItem = preload("res://addons/silent_wolf/Scores/ScoreItem.tscn")
const SWLogger = preload("res://addons/silent_wolf/utils/SWLogger.gd")

var list_index = 0
var ld_name = "main"

func _ready():
	var scores = []
	if ld_name in SilentWolf.Scores.leaderboards:
		scores = SilentWolf.Scores.leaderboards[ld_name]
	
	if len(scores) > 0: 
		render_board(scores)
	else:
		# use a signal to notify when the high scores have been returned, and show a "loading" animation until it's the case...
		add_loading_scores_message()
		var sw_result = await SilentWolf.Scores.get_high_scores().sw_get_scores_complete
		scores = sw_result["scores"]
		hide_message()
		render_board(scores)


func render_board(scores: Array) -> void:
	if scores.is_empty():
		add_no_scores_message()
	else:
		if len(scores) > 1 and scores[0].score > scores[-1].score:
			scores.reverse()
		for i in range(len(scores)):
			var score = scores[i]
			add_item(score.player_name, str(int(score.score)))
			
			#var time = display_time(scores[i].score)
			#add_item(score.player_name, time)
			
#func display_time(time_in_millis):
#	var minutes = int(floor(time_in_millis / 60000))
#	var seconds = int(floor((time_in_millis % 60000) / 1000))
#	var millis = time_in_millis - minutes*60000 - seconds*1000
#	var displayable_time = str(minutes) + ":" + str(seconds) + ":" + str(millis)
#	return displayable_time
			

func reverse_order(scores: Array) -> Array:
	if len(scores) > 1 and scores[0].score > scores[-1].score:
		scores.reverse()
	return scores


func sort_by_score(a: Dictionary, b: Dictionary) -> bool:
	if a.score > b.score:
		return true;
	else:
		if a.score < b.score:
			return false;
		else:
			return true;


func add_item(player_name: String, score_value: String) -> void:
	var item = ScoreItem.instance()
	list_index += 1
	item.get_node("PlayerName").text = str(list_index) + str(". ") + player_name
	item.get_node("Score").text = score_value
	item.offset_top = list_index * 100
	$"Board/HighScores/ScoreItemContainer".add_child(item)

func add_no_scores_message():
	var item = $"Board/MessageContainer/TextMessage"
	item.text = "No scores yet!"
	$"Board/MessageContainer".show()
	item.offset_top = 135


func add_loading_scores_message() -> void:
	var item = $"Board/MessageContainer/TextMessage"
	item.text = "Loading scores..."
	$"Board/MessageContainer".show()
	item.offset_top = 135


func hide_message() -> void:
	$"Board/MessageContainer".hide()


func _on_CloseButton_pressed() -> void:
	var scene_name = SilentWolf.scores_config.open_scene_on_close
	print("scene_name: " + str(scene_name))
	get_tree().change_scene_to_file(scene_name)
