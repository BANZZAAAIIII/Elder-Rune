extends Node

# Create a connection to the server


var network
const SERVER_IP := "localhost"
const SERVER_PORT := 6008
const SERVER_ID := 1

remote var token = ""


func _ready():
	
	# Signals
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	get_tree().connect("network_peer_connected", self, "_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_peer_disconnected")

# Connect to server
func Connect_To_Server(jwt):
	
	# Create client
	network = NetworkedMultiplayerENet.new()
	var result = network.create_client(SERVER_IP, SERVER_PORT)
	if result == OK:
		get_tree().set_network_peer(network)
		print("Connecting to server.....")
		token = jwt
		return true
	else:
		print("Failed to connect to server")
		return false
		

func _connected_fail():
	print("Failed to connect")
	

func _connected_ok():
	print("Succesfully connected")
	

func _server_disconnected():
	# TODO: Despawn/disconect the player localy
	print("Server kicked you")
	get_node("/root/Menu").show()
	queue_free()

# Triggers when a new player connects to server
func _peer_connected(peer_id):
	pass
#	print_debug(str(peer_id) + " connected to server")
#	print("")


# Triggers when a player disconnects
func _peer_disconnected(peer_id):
	pass
#	print_debug(str(peer_id) + " disconnected")
#	print("")

# Sends the token to the game server when asked for
remote func fetch_token():
	rpc_id(1, "send_token", token)


remote func register_new_player(player_name):
	rpc_id(1, "register_new_player", player_name)
	
	# Hides the main menu
	get_node("/root/Menu").hide()
	
	# Loads the world to the root scene
	var world = load("res://Scenes/World.tscn").instance()
	get_tree().get_root().add_child(world)
	
	# Spawns other players and adds this player to server
	rpc_id(1, "initiate_world")


# Adds new users that connect to dict with all connected users
puppet func register_new_players(player_peer_id: int, player_name: String):
	PlayerData.add_player(player_peer_id, player_name)


puppet func remove_player(peer_id):
	PlayerData.remove_player(peer_id)
	
#Recieve chat message from server and access current players chatbox
remote func recieve_complete_chat(complete_text):
	var player_id = get_tree().get_network_unique_id()
	var path = "/root/World/ConnectedPlayers/" + str(player_id) + "/ChatBox"
	print_debug(path)
	get_node(path)
	get_node(path).print_chat_message(complete_text)
