extends Node

const SWUtils = preload("res://addons/silent_wolf/utils/SWUtils.gd")
const SWLogger = preload("res://addons/silent_wolf/utils/SWLogger.gd")

signal sw_save_player_data_complete
signal sw_get_player_data_complete
signal sw_delete_player_data_complete

var GetPlayerData = null
var SavePlayerData = null
var DeletePlayerData = null

# wekrefs
var wrGetPlayerData = null
var wrSavePlayerData = null
var wrDeletePlayerData = null

var player_name = null
var player_data = null


func save_player_data(player_name: String, player_data: Dictionary, overwrite: bool=true) -> Node:
	if player_name == "":
		SWLogger.error("player_name cannot be empty when calling SilentWolf.Players.save_player_data(player_name, player_data)")
	elif typeof(player_data) != TYPE_DICTIONARY:
		SWLogger.error("Player data should be of type Dictionary, instead it is of type: " + str(typeof(player_data)))
	else:
		var prepared_http_req = SilentWolf.prepare_http_request()
		SavePlayerData = prepared_http_req.request
		wrSavePlayerData = prepared_http_req.weakref
		SavePlayerData.request_completed.connect(_on_SavePlayerData_request_completed)
		SWLogger.info("Calling SilentWolf to post player data")
		var payload = { "game_id": SilentWolf.config.game_id, "player_name": player_name, "player_data": player_data, "overwrite": overwrite }
		var request_url = "https://api.silentwolf.com/push_player_data"
		SilentWolf.send_post_request(SavePlayerData, request_url, payload)
	return self


func _on_SavePlayerData_request_completed(result, response_code, headers, body) -> void:
	var status_check = SWUtils.check_http_response(response_code, headers, body)
	if is_instance_valid(SavePlayerData): 
		SilentWolf.free_request(wrSavePlayerData, SavePlayerData)
	
	if status_check:
		var json_body = JSON.parse_string(body.get_string_from_utf8())
		var sw_result: Dictionary = SilentWolf.build_result(json_body)
		if json_body.success:
			SWLogger.info("SilentWolf save player data success for player: " + str(json_body.player_name))
			var player_name = json_body.player_name
			#sw_result["player_name"] = player_name 
		else:
			SWLogger.error("SilentWolf save player data failure: " + str(json_body.error))
		sw_save_player_data_complete.emit(sw_result) 


func get_player_data(player_name: String) -> Node:
	if player_name == "":
		SWLogger.error("player_name cannot be empty when calling SilentWolf.Players.get_player_data(player_name)")
	else:
		var prepared_http_req = SilentWolf.prepare_http_request()
		GetPlayerData = prepared_http_req.request
		wrGetPlayerData = prepared_http_req.weakref
		GetPlayerData.request_completed.connect(_on_GetPlayerData_request_completed)
		SWLogger.info("Calling SilentWolf to get player data")
		var request_url = "https://api.silentwolf.com/get_player_data/" + str(SilentWolf.config.game_id) + "/" + str(player_name)
		SilentWolf.send_get_request(GetPlayerData, request_url)
	return self
	
	
func _on_GetPlayerData_request_completed(result, response_code, headers, body) -> void:
	var status_check = SWUtils.check_http_response(response_code, headers, body)
	if is_instance_valid(GetPlayerData): 
		SilentWolf.free_request(wrGetPlayerData, GetPlayerData)
	
	if status_check:
		var json_body = JSON.parse_string(body.get_string_from_utf8())
		var sw_result: Dictionary = SilentWolf.build_result(json_body)
		if json_body.success:
			SWLogger.info("SilentWolf get player data success for player: " + str(json_body.player_name))
			player_name = json_body.player_name
			player_data = json_body.player_data
			SWLogger.debug("Player data: " + str(player_data))
			sw_result["player_data"] = player_data
		else:
			SWLogger.error("SilentWolf get player data failure: " + str(json_body.error))
		sw_get_player_data_complete.emit(sw_result)


func delete_player_weapons(player_name: String) -> void:
	var weapons = { "Weapons": [] }
	delete_player_data(player_name, weapons)


func remove_player_money(player_name: String) -> void:
	var money = { "Money": 0 }
	delete_player_data(player_name, money)


func delete_player_items(player_name: String, item_name: String) -> void:
	var item = { item_name: "" }
	delete_player_data(player_name, item)


func delete_all_player_data(player_name: String) -> void:
	delete_player_data(player_name, {})


func delete_player_data(player_name: String, player_data: Dictionary) -> Node:
	var prepared_http_req = SilentWolf.prepare_http_request()
	DeletePlayerData = prepared_http_req.request
	wrDeletePlayerData = prepared_http_req.weakref
	DeletePlayerData.request_completed.connect(_on_DeletePlayerData_request_completed)
	SWLogger.info("Calling SilentWolf to remove player data")
	var payload = { "game_id": SilentWolf.config.game_id, "player_name": player_name, "player_data": player_data }
	var query = JSON.stringify(payload)
	var request_url = "https://api.silentwolf.com/remove_player_data"
	SilentWolf.send_post_request(DeletePlayerData, request_url, payload)
	return self


func _on_DeletePlayerData_request_completed(result, response_code, headers, body) -> void:
	var status_check = SWUtils.check_http_response(response_code, headers, body)
	if is_instance_valid(DeletePlayerData): 
		DeletePlayerData.queue_free()
	
	if status_check:
		var json_body = JSON.parse_string(body.get_string_from_utf8())
		var sw_result: Dictionary = SilentWolf.build_result(json_body)
		if json_body.success:
			SWLogger.info("SilentWolf delete player data success for player: " + str(json_body.player_name))
			var player_name = json_body.player_name
			# return player_data after (maybe partial) removal
			var player_data = json_body.player_data
			sw_result["player_name"] = player_name
			sw_result["player_data"] = player_data
		else:
			SWLogger.error("SilentWolf delete player data failure: " + str(json_body.error))
		sw_delete_player_data_complete.emit(sw_result)


func get_stats() -> Dictionary:
	var stats = null
	if player_data:
		stats = {
			"strength": player_data.strength,
			"speed": player_data.speed,
			"reflexes": player_data.reflexes,
			"max_health": player_data.max_health,
			"career": player_data.career
		}
	return stats


func get_inventory() -> Dictionary:
	var inventory = null
	if player_data:
		inventory = {
			"weapons": player_data.weapons,
			"gold": player_data.gold
		}
	return inventory


func set_player_data(new_player_data: Dictionary) -> void:
	player_data = new_player_data


func clear_player_data() -> void:
	player_name = null
	player_data = null
