extends Node

var url = "wss://localhost:5001" # Connection url

onready var client = WebSocketClient.new()

onready var api = MultiplayerAPI.new() # New network api to separate connection from game server

var timer = Timer.new()

func _ready():
	
	

	#client.set_trusted_ssl_certificate(cert)

	# Timer will start reconnections attempts
	self.add_child(timer)
	timer.one_shot = false
	timer.wait_time = 3
	timer.connect("timeout", self, "_on_Timeout")

	# Signals
	client.connect("connection_closed", self, "_on_Websocket_closed")
	client.connect("connection_error", self, "_on_Websocket_error")
	client.connect("connection_established", self, "_on_Websocket_connected")
	client.connect("data_received", self, "_on_Websocket_recieved")

	connect_to_webserver()

func connect_to_webserver():
	print("Connecting to webserver...")
	var err = client.connect_to_url(url)
	if err != OK:
		print("Unable to connect to %s" % url)
		set_process(false) # Stop process loop



func _process(delta):
	client.poll() # Data is transfered each time this function is called

# Called when connection closes
func _on_Websocket_closed(was_clean = false): # was clean if server was not notified of disconnection
	print("Closed, clean: ", was_clean)
	set_process(false)
	timer.start()

func _on_Websocket_error(was_clean = false):
	print("Closed, clean: ", was_clean)
	set_process(false)
	timer.start()

func _on_Websocket_connected(proto = ""):
	print("Connected with protocol: ", proto)
	timer.stop()
	client.get_peer(1).put_packet("Test packet".to_utf8())

func _on_Websocket_recieved():
	var token = client.get_peer(1).get_packet().get_string_from_utf8()
	var digest = JSON.parse(JwtDigest._consumeToken(token))
	if digest.error != OK:
		print("Parsing json error")
		print(digest)
	pass
	

func _on_Timeout():
	print("Attempting to reconnect")
	connect_to_webserver()
	timer.stop()
	set_process(true)
