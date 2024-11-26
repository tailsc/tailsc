extends Node

const SWLogger = preload("res://addons/silent_wolf/utils/SWLogger.gd")
const UUID = preload("res://addons/silent_wolf/utils/UUID.gd")
const SWHashing = preload("res://addons/silent_wolf/utils/SWHashing.gd")
const SWUtils = preload("res://addons/silent_wolf/utils/SWUtils.gd")

# new signals
signal sw_get_scores_complete
signal sw_get_player_scores_complete
signal sw_top_player_score_complete
signal sw_get_position_complete
signal sw_get_scores_around_complete
signal sw_save_score_complete
signal sw_wipe_leaderboard_complete
signal sw_delete_score_complete

# leaderboard scores by leaderboard name
var leaderboards = {}
# leaderboard scores from past periods by leaderboard name and period_offset (negative integers)
var leaderboards_past_periods = {}
# leaderboard configurations by leaderboard name
var ldboard_config = {}

# contains only the scores from one leaderboard at a time
var scores = []
var player_scores = []
var player_top_score = null
var local_scores = []
#var custom_local_scores = []
var score_id = ""
var position = 0
var scores_above = []
var scores_below  = []

#var request_timeout = 3
#var request_timer = null

# latest number of scores to be fetched from the backend
var latest_max = 10

var SaveScore = null
var GetScores = null
var ScorePosition = null
var ScoresAround = null
var ScoresByPlayer = null
var TopScoreByPlayer = null
var WipeLeaderboard = null
var DeleteScore = null

# wekrefs
var wrSaveScore = null
var wrGetScores = null
var wrScorePosition = null
var wrScoresAround = null
var wrScoresByPlayer = null
var wrTopScoreByPlayer = null
var wrWipeLeaderboard = null
var wrDeleteScore = null


# metadata, if included should be a dictionary
# The score attribute could be either a score_value (int) or score_id (String)
func save_score(player_name: String, score, ldboard_name: String="main", metadata: Dictionary={}) -> Node:
	# player_name must be present
	if player_name == null or player_name == "":
		SWLogger.error("ERROR in SilentWolf.Scores.persist_score - please enter a valid player name")
	elif typeof(ldboard_name) != TYPE_STRING:
		# check that ldboard_name, if present is a String
		SWLogger.error("ERROR in SilentWolf.Scores.persist_score - leaderboard name must be a String")
	elif typeof(metadata) != TYPE_DICTIONARY:
		# check that metadata, if present, is a dictionary
		SWLogger.error("ERROR in SilentWolf.Scores.persist_score - metadata must be a dictionary")
	else:
		var prepared_http_req = SilentWolf.prepare_http_request()
		SaveScore = prepared_http_req.request
		wrSaveScore = prepared_http_req.weakref
		SaveScore.request_completed.connect(_on_SaveScore_request_completed)
		SWLogger.info("Calling SilentWolf backend to post new score...")
		var game_id = SilentWolf.config.game_id
		
		var score_uuid = UUID.generate_uuid_v4()
		score_id = score_uuid
		var payload = { 
			"score_id" : score_id, 
			"player_name" : player_name, 
			"game_id": game_id,  
			"score": score, 
			"ldboard_name": ldboard_name 
		}
		print("!metadata.empty(): " + str(!metadata.is_empty()))
		if !metadata.is_empty():
			print("metadata: " + str(metadata))
			payload["metadata"] = metadata
		SWLogger.debug("payload: " + str(payload))
		# also add to local scores
		add_to_local_scores(payload)
		var request_url = "https://api.silentwolf.com/save_score"
		SilentWolf.send_post_request(SaveScore, request_url, payload)
	return self


func _on_SaveScore_request_completed(result, response_code, headers, body) -> void:
	var status_check = SWUtils.check_http_response(response_code, headers, body)
	SilentWolf.free_request(wrSaveScore, SaveScore)
	
	if status_check:
		var json_body = JSON.parse_string(body.get_string_from_utf8())
		var sw_result: Dictionary = SilentWolf.build_result(json_body)
		if json_body.success:
			SWLogger.info("SilentWolf save score success.")
			sw_result["score_id"] = json_body.score_id
		else:
			SWLogger.error("SilentWolf save score failure: " + str(json_body.error))
		sw_save_score_complete.emit(sw_result)


func get_scores(maximum: int=10, ldboard_name: String="main", period_offset: int=0) -> Node:
	var prepared_http_req = SilentWolf.prepare_http_request()
	GetScores = prepared_http_req.request
	wrGetScores = prepared_http_req.weakref
	GetScores.request_completed.connect(_on_GetScores_request_completed)
	SWLogger.info("Calling SilentWolf backend to get scores...")
	# resetting the latest_number value in case the first requests times out, we need to request the same amount of top scores in the retry
	latest_max = maximum
	var request_url = "https://api.silentwolf.com/get_scores/" + str(SilentWolf.config.game_id) + "?max=" + str(maximum)  + "&ldboard_name=" + str(ldboard_name) + "&period_offset=" + str(period_offset)
	SilentWolf.send_get_request(GetScores, request_url)
	return self


func _on_GetScores_request_completed(result, response_code, headers, body) -> void:
	var status_check = SWUtils.check_http_response(response_code, headers, body)
	SilentWolf.free_request(wrGetScores, GetScores)
	
	if status_check:
		var json_body = JSON.parse_string(body.get_string_from_utf8())
		var sw_result: Dictionary = SilentWolf.build_result(json_body)
		if json_body.success:
			SWLogger.info("SilentWolf get scores success, found " + str(json_body.top_scores.size()) + " scores.")
			scores = translate_score_fields_in_array(json_body.top_scores)
			SWLogger.debug("Scores: " + str(scores))
			var ld_name = json_body.ld_name
			var ld_config = json_body.ld_config
			if "period_offset" in json_body:
				var period_offset = str(json_body["period_offset"])
				leaderboards_past_periods[ld_name + ";" + period_offset] = scores
			else:
				leaderboards[ld_name] = scores
			ldboard_config[ld_name] = ld_config
			sw_result["scores"] = scores
			sw_result["ld_name"] = ld_name
		else:
			SWLogger.error("SilentWolf get scores failure: " + str(json_body.error))
		sw_get_scores_complete.emit(sw_result)


func get_scores_by_player(player_name: String, maximum: int=10, ldboard_name: String="main", period_offset: int=0) -> Node:
	if player_name == null:
		SWLogger.error("Error in SilentWolf.Scores.get_scores_by_player: provided player_name is null")
	else:
		var prepared_http_req = SilentWolf.prepare_http_request()
		ScoresByPlayer = prepared_http_req.request
		wrScoresByPlayer = prepared_http_req.weakref
		ScoresByPlayer.request_completed.connect(_on_GetScoresByPlayer_request_completed)
		SWLogger.info("Calling SilentWolf backend to get scores for player: " + str(player_name))
		# resetting the latest_number value in case the first requests times out, we need to request the same amount of top scores in the retry
		latest_max = maximum
		var request_url = "https://api.silentwolf.com/get_scores_by_player/" + str(SilentWolf.config.game_id) + "?max=" + str(maximum)  + "&ldboard_name=" + str(ldboard_name.uri_encode()) + "&player_name=" + str(player_name.uri_encode()) + "&period_offset=" + str(period_offset)
		SilentWolf.send_get_request(ScoresByPlayer, request_url)
	return self


func _on_GetScoresByPlayer_request_completed(result, response_code, headers, body) -> void:
	var status_check = SWUtils.check_http_response(response_code, headers, body)
	SilentWolf.free_request(wrScoresByPlayer, ScoresByPlayer)
	
	if status_check:
		var json_body = JSON.parse_string(body.get_string_from_utf8())
		var sw_result: Dictionary = SilentWolf.build_result(json_body)
		if json_body.success:
			SWLogger.info("SilentWolf get scores by player success, found " + str(json_body.top_scores.size()) + " scores.")
			player_scores = translate_score_fields_in_array(json_body.top_scores)
			SWLogger.debug("Scores for " + json_body.player_name +  ": " + str(player_scores))
			var ld_name = json_body.ld_name
			var ld_config = json_body.ld_config
			var player_name = json_body.player_name
			sw_result["scores"] = player_scores
		else:
			SWLogger.error("SilentWolf get scores by player failure: " + str(json_body.error))
		sw_get_player_scores_complete.emit(sw_result)	


func get_top_score_by_player(player_name: String, maximum: int=10, ldboard_name: String="main", period_offset: int=0) -> Node:
	if player_name == null:
		SWLogger.error("Error in SilentWolf.Scores.get_top_score_by_player: provided player_name is null")
	else:
		var prepared_http_req = SilentWolf.prepare_http_request()
		TopScoreByPlayer = prepared_http_req.request
		wrTopScoreByPlayer = prepared_http_req.weakref
		TopScoreByPlayer.request_completed.connect(_on_GetTopScoreByPlayer_request_completed)
		SWLogger.info("Calling SilentWolf backend to get top score for player: " + str(player_name))
		# resetting the latest_number value in case the first requests times out, we need to request the same amount of top scores in the retry
		latest_max = maximum
		var request_url = "https://api.silentwolf.com/get_top_score_by_player/" + str(SilentWolf.config.game_id) + "?max=" + str(maximum)  + "&ldboard_name=" + str(ldboard_name.uri_encode()) + "&player_name=" + str(player_name.uri_encode()) + "&period_offset=" + str(period_offset)
		SilentWolf.send_get_request(TopScoreByPlayer, request_url)
	return self


func _on_GetTopScoreByPlayer_request_completed(result, response_code, headers, body) -> void:
	var status_check = SWUtils.check_http_response(response_code, headers, body)
	SilentWolf.free_request(wrTopScoreByPlayer, TopScoreByPlayer)
	
	if status_check:
		var json_body = JSON.parse_string(body.get_string_from_utf8())
		var sw_result: Dictionary = SilentWolf.build_result(json_body)
		if json_body.success:
			SWLogger.info("SilentWolf get top score by player success, found top score? " + str(!json_body.top_score.is_empty()))
			if !json_body.top_score.is_empty():
				player_top_score = translate_score_fields(json_body.top_score)
				SWLogger.debug("Top score for " + json_body.player_name +  ": " + str(player_top_score))
				var ld_name = json_body.ld_name
				var ld_config = json_body.ld_config
				var player_name = json_body.player_name
				sw_result["top_score"] = player_top_score
		else:
			SWLogger.error("SilentWolf get top score by player failure: " + str(json_body.error))
		sw_top_player_score_complete.emit(sw_result)	


# The score attribute could be either a score_value (int) or score_id (Sstring)
func get_score_position(score, ldboard_name: String="main") -> Node:
	var score_id = null
	var score_value = null
	print("score: " + str(score))
	if UUID.is_uuid(str(score)):
		score_id = score 
	else:
		score_value = score
	var prepared_http_req = SilentWolf.prepare_http_request()
	ScorePosition = prepared_http_req.request
	wrScorePosition = prepared_http_req.weakref
	ScorePosition.request_completed.connect(_on_GetScorePosition_request_completed)
	SWLogger.info("Calling SilentWolf to get score position")
	var payload = { "game_id": SilentWolf.config.game_id, "ldboard_name": ldboard_name }
	if score_id:
		payload["score_id"] = score_id
	if score_value:
		payload["score_value"] = score_value
	var request_url = "https://api.silentwolf.com/get_score_position"
	SilentWolf.send_post_request(ScorePosition, request_url, payload)
	return self


func _on_GetScorePosition_request_completed(result, response_code, headers, body) -> void:
	var status_check = SWUtils.check_http_response(response_code, headers, body)
	SilentWolf.free_request(wrScorePosition, ScorePosition)
	
	if status_check:
		var json_body = JSON.parse_string(body.get_string_from_utf8())
		var sw_result: Dictionary = SilentWolf.build_result(json_body)
		if json_body.success:
			SWLogger.info("SilentWolf get score position success: " + str(json_body.position))
			sw_result["position"] =  int(json_body.position)
		else:
			SWLogger.error("SilentWolf get score position failure: " + str(json_body.error))
		sw_get_position_complete.emit(sw_result)


# The score attribute couldd be either a score_value (int) or score_id (Sstring)
func get_scores_around(score, scores_to_fetch=3, ldboard_name: String="main") -> Node:
	var score_id = "Null"
	var score_value = "Null"
	print("score: " + str(score))
	if UUID.is_uuid(str(score)):
		score_id = score 
	else:
		score_value = score
	var prepared_http_req = SilentWolf.prepare_http_request()
	ScoresAround = prepared_http_req.request
	wrScoresAround = prepared_http_req.weakref
	ScoresAround.request_completed.connect(_on_ScoresAround_request_completed)
	
	SWLogger.info("Calling SilentWolf backend to scores above and below a certain score...")
	# resetting the latest_number value in case the first requests times out, we need to request the same amount of top scores in the retry
	#latest_max = maximum
	var request_url = "https://api.silentwolf.com/get_scores_around/" + str(SilentWolf.config.game_id) + "?scores_to_fetch=" + str(scores_to_fetch)  + "&ldboard_name=" + str(ldboard_name) + "&score_id=" + str(score_id) + "&score_value=" + str(score_value)
	SilentWolf.send_get_request(ScoresAround, request_url)
	return self


func _on_ScoresAround_request_completed(result, response_code, headers, body) -> void:
	var status_check = SWUtils.check_http_response(response_code, headers, body)
	
	SilentWolf.free_request(wrScoresAround, ScoresAround)
	
	if status_check:
		var json_body = JSON.parse_string(body.get_string_from_utf8())
		var sw_result: Dictionary = SilentWolf.build_result(json_body)
		if json_body.success:
			SWLogger.info("SilentWolf get scores around success.")
			sw_result["scores_above"] = translate_score_fields_in_array(json_body.scores_above)
			sw_result["scores_below"] = translate_score_fields_in_array(json_body.scores_below)
			if "score_position" in json_body:
				sw_result["position"] = json_body.score_position
		else:
			SWLogger.error("SilentWolf get scores around failure: " + str(json_body.error))
		sw_get_scores_around_complete.emit(sw_result)



func delete_score(score_id: String, ldboard_name: String='main') -> Node:
	var prepared_http_req = SilentWolf.prepare_http_request()
	DeleteScore = prepared_http_req.request
	wrDeleteScore = prepared_http_req.weakref
	DeleteScore.request_completed.connect(_on_DeleteScore_request_completed)
	SWLogger.info("Calling SilentWolf to delete a score")
	var request_url = "https://api.silentwolf.com/delete_score?game_id=" + str(SilentWolf.config.game_id) + "&ldboard_name=" + str(ldboard_name) + "&score_id=" + str(score_id)
	SilentWolf.send_get_request(DeleteScore, request_url)
	return self


func _on_DeleteScore_request_completed(result, response_code, headers, body) -> void:
	var status_check = SWUtils.check_http_response(response_code, headers, body)
	SilentWolf.free_request(wrDeleteScore, DeleteScore)
	
	if status_check:
		var json_body = JSON.parse_string(body.get_string_from_utf8())
		var sw_result: Dictionary = SilentWolf.build_result(json_body)
		if json_body.success:
			SWLogger.info("SilentWolf delete score success")
		else:
			SWLogger.error("SilentWolf delete score failure: " + str(json_body.error))
		sw_delete_score_complete.emit(sw_result)


# Deletes all your scores for your game
# Scores are permanently deleted, no going back!
func wipe_leaderboard(ldboard_name: String='main') -> Node:
	var prepared_http_req = SilentWolf.prepare_http_request()
	WipeLeaderboard = prepared_http_req.request
	wrWipeLeaderboard = prepared_http_req.weakref
	WipeLeaderboard.request_completed.connect(_on_WipeLeaderboard_request_completed)
	SWLogger.info("Calling SilentWolf backend to wipe leaderboard...")
	var payload = { "game_id": SilentWolf.config.game_id, "ldboard_name": ldboard_name }
	var request_url = "https://api.silentwolf.com/wipe_leaderboard"
	SilentWolf.send_post_request(WipeLeaderboard, request_url, payload)
	return self


func _on_WipeLeaderboard_request_completed(result, response_code, headers, body) -> void:
	var status_check = SWUtils.check_http_response(response_code, headers, body)
	SilentWolf.free_request(wrWipeLeaderboard, WipeLeaderboard)
	
	if status_check:
		var json_body = JSON.parse_string(body.get_string_from_utf8())
		var sw_result: Dictionary = SilentWolf.build_result(json_body)
		if json_body.success:
			SWLogger.info("SilentWolf wipe leaderboard success.")
		else:
			SWLogger.error("SilentWolf wipe leaderboard failure: " + str(json_body.error))
		sw_wipe_leaderboard_complete.emit(sw_result)


func add_to_local_scores(game_result: Dictionary, ld_name: String="main") -> void:
	var local_score = { "score_id": game_result.score_id, "game_id" : game_result.game_id, "player_name": game_result.player_name, "score": game_result.score }
	local_scores.append(local_score)
	SWLogger.debug("local scores: " + str(local_scores))


func translate_score_fields_in_array(scores: Array) -> Array:
	var translated_scores = []
	for score in scores:
		var new_score = translate_score_fields(score)
		translated_scores.append(new_score)
	return translated_scores


func translate_score_fields(score: Dictionary) -> Dictionary:
	var translated_score = {}
	translated_score["score_id"] = score["sid"]
	translated_score["score"] = score["s"]
	translated_score["player_name"] = score["pn"]
	if "md" in score:
		translated_score["metadata"] = score["md"]
	if "position" in score:
		translated_score["position"] = score["position"]
	if "t" in score:
		translated_score["timestamp"] = score["t"]
	return translated_score
