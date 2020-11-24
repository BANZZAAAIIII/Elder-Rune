extends Control


onready var chatLog 	= get_node("VBoxContainer/RichTextLabel")
onready var inputLabel 	= get_node("VBoxContainer/HBoxContainer/Label")
onready var inputField 	= get_node("VBoxContainer/HBoxContainer/LineEdit")
var SERVER_ID = Server.SERVER_ID


func _ready():
	inputField.connect("text_entered", self, "text_entered")
	
	
#Activates input field if Enter is pressed
func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ENTER:
			inputField.grab_focus()
			
		if event.pressed and event.scancode == KEY_ESCAPE:
			inputField.release_focus()
	
#Get text from input field and release focus after
func text_entered(text):
	if text != '':
		add_message(text)
		inputField.text = ""
		inputField.release_focus()

#Send text to Server through RPC.
func add_message(text):
	var player_name = PlayerData.get_player_name(
		self.get_network_master()
	)
	text = "[" + str(player_name) + "]: " + text
	rpc_id(SERVER_ID, "get_message", text)

#Prints messages recieved from server
func print_chat_message(complete_text):
	chatLog.bbcode_text += "\n" + complete_text 
