extends Control


# TODO: Error message when connection failes
	# Remember to never give extra information about login, 
	# such as confirming wether or not it was username or password that was wrong

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
		"Content-Type: application/json"
		
	])
	var body = {
		"UserName": username.text,
		"Password": password.text,
		"World": world.selected
	}
	
	var error = request.request("https://localhost:5001/api/Login", headers, false, HTTPClient.METHOD_POST, JSON.print(body))
		
	if error != OK:
		push_error("Http request got an error")

# TODO: Maybe move the connection failed and successfull signals here instead of in singelton
func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		Server.Connect_To_Server(body.get_string_from_utf8()) # Connect to game server
