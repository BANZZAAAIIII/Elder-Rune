extends Control


func _on_JoinButton_pressed():
	var name = $VBoxContainer/HBoxContainer/Name.text
	
	if name != "":
		Server.register_new_player(name)
