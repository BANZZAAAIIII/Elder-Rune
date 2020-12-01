extends Node

var url = "wss://localhost:5001" # Connection url

onready var client = WebSocketClient.new()

onready var api = MultiplayerAPI.new() # New network api to separate connection from game server

func _ready():
	
	# Signals
	client.connect("connection_closed", self, "_on_Websocket_closed")
	client.connect("connection_error", self, "_on_Websocket_error")
	client.connect("connection_established", self, "_on_Websocket_connected")
	client.connect("data_received", self, "_on_Websocket_recieved")
	
	# Connect to Asp.Net websocket
	var err = client.connect_to_url(url)
	if err != OK:
		print("Unable to connect to %s" % url)
		set_process(false) # Stop process loop
	
	set_custom_multiplayer(api)
		
func _process(delta):
	client.poll() # Data is transfered each time this function is called

# Called when connection closes
func _on_Websocket_closed(was_clean = false): # was clean if server was not notified of disconnection
	print("Closed, clean: ", was_clean)
	set_process(false)

func _on_Websocket_error(was_clean = false):
	print("Closed, clean: ", was_clean)
	set_process(false)
	
func _on_Websocket_connected(proto = ""):
	print("Connected with protocol: ", proto)
	client.get_peer(1).put_packet("Test packet".to_utf8())

func _on_Websocket_recieved():
	print("Got data from server: ", client.get_peer(1).get_packet().get_string_from_utf8())
