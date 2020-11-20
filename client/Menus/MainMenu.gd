extends Control

onready var username = $LoginContainer/UsernameContainer/Username
onready var password = $LoginContainer/PasswordContainer/Password


func _on_LoginButton_pressed():
	var name = username.text
	
	if name != "":
		Server.register_new_player(name)
