extends Control

onready var client_name = "Anders"

onready var chatLog = get_node("VBoxContainer/RichTextLabel")
onready var inputLabel = get_node("VBoxContainer/HBoxContainer/Label")
onready var inputField = get_node("VBoxContainer/HBoxContainer/LineEdit")

var clientnetwork = load("res://Globals/ClientNetworking.gd").new()

func _ready():
	inputField.connect("text_entered", self, "text_entered")

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			inputField.release_focus()

func add_message(username, text):
	
	$"/root/Server".add_message(username, text)
	
remote func chat_text(complete_text):
	chatLog.bbcode_text += complete_text

func text_entered(text):
	if text != '':
		add_message(client_name, text)
		inputField.text = ""
	
