extends Control


onready var username = $GridContainer/Username
onready var password = $GridContainer/Password


func _on_LoginButton_pressed():
	var name = username.text
	
	if name != "":
		Server.register_new_player(name)
