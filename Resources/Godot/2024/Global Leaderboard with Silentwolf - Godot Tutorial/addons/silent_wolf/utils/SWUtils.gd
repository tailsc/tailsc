extends Node

const SWLogger = preload("res://addons/silent_wolf/utils/SWLogger.gd")

static func get_timestamp() -> int:
	var unix_time: float = Time.get_unix_time_from_system()
	var unix_time_int: int = unix_time
	var timestamp = round((unix_time - unix_time_int) * 1000.0)
	return timestamp


static func check_http_response(response_code, headers, body):
	SWLogger.debug("response code: " + str(response_code))
	SWLogger.debug("response headers: " + str(headers))
	SWLogger.debug("response body: " + str(body.get_string_from_utf8()))

	var check_ok = true
	if response_code == 0:
		no_connection_error()
		check_ok = false
	elif response_code == 403:
		forbidden_error()
	return check_ok


static func no_connection_error():
	SWLogger.error("Godot couldn't connect to the SilentWolf backend. There are several reasons why this might happen. See https://silentwolf.com/troubleshooting for more details. If the problem persists you can reach out to us: https://silentwolf.com/contact")


static func forbidden_error():
	SWLogger.error("You are not authorized to call the SilentWolf API - check your API key configuration or contact us: https://silentwolf.com/contact")


static func obfuscate_string(string: String) -> String:
	return string.replace(".", "*")
