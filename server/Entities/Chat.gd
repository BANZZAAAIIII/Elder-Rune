extends Control


func _ready():
	pass 

#Recieve message from client/chatbox and send to server
remote func get_message(text):
	
	Server.return_chat_message(text)
