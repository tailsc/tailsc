extends TextureRect

var player_name = null
var login_scene = "res://addons/silent_wolf/Auth/Login.tscn"


# Called when the node enters the scene tree for the first time.
func _ready():
	$"RequestFormContainer/ProcessingLabel".hide()
	$"PwdResetFormContainer/ProcessingLabel".hide()
	$"PasswordChangedContainer".hide()
	$"PwdResetFormContainer".hide()
	$"RequestFormContainer".show()
	SilentWolf.Auth.sw_request_password_reset_complete.connect(_on_send_code_complete)
	SilentWolf.Auth.sw_reset_password_complete.connect(_on_reset_complete)
	if "login_scene" in SilentWolf.Auth:
		login_scene = SilentWolf.Auth.login_scene


func _on_BackButton_pressed() -> void:
	get_tree().change_scene_to_file(login_scene)


func _on_PlayerNameSubmitButton_pressed() -> void:
	player_name = $"RequestFormContainer/FormContainer/FormInputFields/PlayerName".text
	SilentWolf.Auth.request_player_password_reset(player_name)
	$"RequestFormContainer/ProcessingLabel".show()


func _on_send_code_complete(sw_result: Dictionary) -> void:
	if sw_result.success:
		send_code_success()
	else:
		send_code_failure(sw_result.error)


func send_code_success() -> void:
	$"RequestFormContainer/ProcessingLabel".hide()
	$"RequestFormContainer".hide()
	$"PwdResetFormContainer".show()


func send_code_failure(error: String) -> void:
	$"RequestFormContainer/ProcessingLabel".hide()
	$"RequestFormContainer/ErrorMessage".text = "Could not send confirmation code. " + str(error)
	$"RequestFormContainer/ErrorMessage".show()


func _on_NewPasswordSubmitButton_pressed() -> void:
	var code = $"PwdResetFormContainer/FormContainer/FormInputFields/Code".text
	var password = $"PwdResetFormContainer/FormContainer/FormInputFields/Password".text
	var confirm_password = $"PwdResetFormContainer/FormContainer/FormInputFields/ConfirmPassword".text
	SilentWolf.Auth.reset_player_password(player_name, code, password, confirm_password)
	$"PwdResetFormContainer/ProcessingLabel".show()


func _on_reset_complete(sw_result: Dictionary) -> void:
	if sw_result.success:
		reset_success()
	else:
		reset_failure(sw_result.error)


func reset_success() -> void:
	$"PwdResetFormContainer/ProcessingLabel".hide()
	$"PwdResetFormContainer".hide()
	$"PasswordChangedContainer".show()


func reset_failure(error: String) -> void:
	$"PwdResetFormContainer/ProcessingLabel".hide()
	$"PwdResetFormContainer/ErrorMessage".text = "Could not reset password. " + str(error)
	$"PwdResetFormContainer/ErrorMessage".show()


func _on_CloseButton_pressed() -> void:
	get_tree().change_scene_to_file(login_scene)
