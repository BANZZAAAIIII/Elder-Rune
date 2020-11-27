extends Control


onready var username = $GridContainer/Username
onready var password = $GridContainer/Password
onready var world = $GridContainer/World
var request = null


func _ready():
	request = HTTPRequest.new()
	self.add_child(request)
	
	request.connect("request_completed", self, "_on_request_completed")

func _on_LoginButton_pressed():
	
	var headers = PoolStringArray([
		"Content-Type: application/json",
		"Accept: */*",
		
		"Host: localhost:5001",
		"Accept-Encoding: gzip, deflate, br",
		"Connection: keep-alive",
		"Content-Length: 45"
	])
	var body = {
		"UserName": username.text,
		"Password": password.text,
		"World": world.selected
	}
	
	
	#var body = "UserName:user1, Password:Password1."
	var test = "UserName=user1&Password=Password1."
	
	
	var error = request.request("https://localhost:5001/api/Login", ["Content-Type: application/json"], false, HTTPClient.METHOD_POST, JSON.print(body))
		
	if error != OK:
		push_error("Http request got an error")
	
	
#	if name != "":
#		Server.register_new_player(name)

func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		Server.register_new_player(username.text)
		password.text = "" # Reset password
