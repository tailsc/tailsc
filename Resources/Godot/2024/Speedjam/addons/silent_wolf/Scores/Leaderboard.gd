@tool
extends Node2D

const ScoreItem = preload("ScoreItem.tscn")
const SWLogger = preload("res://addons/silent_wolf/utils/SWLogger.gd")

var list_index = 0
# Replace the leaderboard name if you're not using the default leaderboard
var ld_name = "main"
var max_scores = 10


func _ready():
	print("SilentWolf.Scores.leaderboards: " + str(SilentWolf.Scores.leaderboards))
	print("SilentWolf.Scores.ldboard_config: " + str(SilentWolf.Scores.ldboard_config))
	var scores = SilentWolf.Scores.scores
	#var scores = []
	if ld_name in SilentWolf.Scores.leaderboards:
		scores = SilentWolf.Scores.leaderboards[ld_name]
	var local_scores = SilentWolf.Scores.local_scores
	
	if len(scores) > 0: 
		render_board(scores, local_scores)
	else:
		# use a signal to notify when the high scores have been returned, and show a "loading" animation until it's the case...
		add_loading_scores_message()
		var sw_result = await SilentWolf.Scores.get_scores().sw_get_scores_complete
		scores = sw_result.scores
		hide_message()
		render_board(scores, local_scores)


func render_board(scores: Array, local_scores: Array) -> void:
	var all_scores = scores
	if ld_name in SilentWolf.Scores.ldboard_config and is_default_leaderboard(SilentWolf.Scores.ldboard_config[ld_name]):
		all_scores = merge_scores_with_local_scores(scores, local_scores, max_scores)
		if scores.is_empty() and local_scores.is_empty():
			add_no_scores_message()
	else:
		if scores.is_empty():
			add_no_scores_message()
	if all_scores.is_empty():
		for score in scores:
			add_item(score.player_name, str(int(score.score)))
	else:
		for score in all_scores:
			add_item(score.player_name, str(int(score.score)))


func is_default_leaderboard(ld_config: Dictionary) -> bool:
	var default_insert_opt = (ld_config.insert_opt == "keep")
	var not_time_based = !("time_based" in ld_config)
	return default_insert_opt and not_time_based


func merge_scores_with_local_scores(scores: Array, local_scores: Array, max_scores: int=10) -> Array:
	if local_scores:
		for score in local_scores:
			var in_array = score_in_score_array(scores, score)
			if !in_array:
				scores.append(score)
			scores.sort_custom(sort_by_score);
	if scores.size() > max_scores:
		var new_size = scores.resize(max_scores)
	return scores


func sort_by_score(a: Dictionary, b: Dictionary) -> bool:
	if a.score > b.score:
		return true;
	else:
		if a.score < b.score:
			return false;
		else:
			return true;


func score_in_score_array(scores: Array, new_score: Dictionary) -> bool:
	var in_score_array =  false
	if !new_score.is_empty() and !scores.is_empty():
		for score in scores:
			if score.score_id == new_score.score_id: # score.player_name == new_score.player_name and score.score == new_score.score:
				in_score_array = true
	return in_score_array


func add_item(player_name: String, score_value: String) -> void:
	var item = ScoreItem.instantiate()
	list_index += 1
	item.get_node("PlayerName").text = str(list_index) + str(". ") + player_name
	item.get_node("Score").text = score_value
	item.offset_top = list_index * 100
	$"Board/HighScores/ScoreItemContainer".add_child(item)


func add_no_scores_message() -> void:
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


func clear_leaderboard() -> void:
	var score_item_container = $"Board/HighScores/ScoreItemContainer"
	if score_item_container.get_child_count() > 0:
		var children = score_item_container.get_children()
		for c in children:
			score_item_container.remove_child(c)
			c.queue_free()


func _on_CloseButton_pressed() -> void:
	var scene_name = SilentWolf.scores_config.open_scene_on_close
	SWLogger.info("Closing SilentWolf leaderboard, switching to scene: " + str(scene_name))
	#global.reset()
	get_tree().change_scene_to_file(scene_name)
