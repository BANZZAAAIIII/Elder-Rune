extends Node


var network
const SERVER_PORT = 6008
const MAX_PLAYERS = 100
const SERVER_ID := 1


func _ready():
	# Signals
	# Will fire (call method) when player connects or disconnects from server
	get_tree().connect("network_peer_connected", self, "_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_peer_disconnected")
	
	# Start the server
	Start_Server()

func _process(delta):
	if Input.is_action_just_pressed("ui_down"):
		rpc("server_ans", "hallo")


func Start_Server() -> bool:
	
	network = NetworkedMultiplayerENet.new()
	
	var result = network.create_server(SERVER_PORT, MAX_PLAYERS)
	if result == OK:
		get_tree().set_network_peer(network)
		print("Server Started")
		return true
	else:
		print("Failed to start server: %d" % result)
		return false

# Runs when a peer connects to the server
func _peer_connected(peer_id: int):
	print("user " + str(peer_id) + " connected")
	rpc_id(peer_id, "register_player", "Server")

# Runs when a peer disconnects from the server
func _peer_disconnected(peer_id: int):
	print("user " + str(peer_id) + " disconnected")
	
# Runs when a player connects to server
remote func register_player(peer_data):
	var id = get_tree().get_rpc_sender_id()
	PlayerData.add_player(id, peer_data)
	PlayerData.print_players()

remote func _spawn_new_player(player_info):
	pass
	# Send info to all connected peers (exept the player that just connected)
	# And spawn the player
	
remote func _get_player_position(player_position):
	#This is not working for some reason
	#var player_id = get_tree().get_rpc_sender_id()
	
	rpc("server_ans", player_position)
	

