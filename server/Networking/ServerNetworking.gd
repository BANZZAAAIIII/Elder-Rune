extends Node


var network
const SERVER_PORT = 6008
const MAX_PLAYERS = 100
const SERVER_ID := 1

func _ready():
	Start_Server()

func Start_Server():
	# Signals
	# Will fire (call method to the right) when player connects or disconnects from server
	get_tree().connect("network_peer_connected", self, "_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_peer_disconnected")

	network = NetworkedMultiplayerENet.new()

	var result = network.create_server(SERVER_PORT, MAX_PLAYERS)
	
	if result == OK:
		get_tree().set_network_peer(network)
		print_debug("Server Started" )
	else:
		print_debug("Failed to start server: %d" % result)
		


# Runs when a peer connects to the server
func _peer_connected(peer_id):
	# printt("user connected: ", str(peer_id))
	pass


func _peer_disconnected(peer_id):
	# Removes player from server dict
	PlayerData.remove_player(peer_id)
	
	# Removes player node from the world
	get_node("/root/World").rpc("despawn_player", peer_id)
	print("User disconnected: ", str(peer_id))


remote func register_new_player(player_name):
	var player_peer_id = get_tree().get_rpc_sender_id()
	
	# Sends the client all currently connected users
	PlayerData.rpc_id(player_peer_id, "get_player_list", PlayerData.get_all_players())
	
	# Adds the new player to a dict of all connected users
	PlayerData.add_player(player_peer_id, player_name)
	
	# Tells other conected peers to register the new player
	rpc("register_new_players", player_peer_id, player_name)
	
	print("New player: " + str(player_peer_id) + " has connected as: " + str(player_name))


remote func initiate_world():
	var player_peer_id = get_tree().get_rpc_sender_id()
	var world_node = get_node("/root/World")
	
	# Spawns connected players to newly connected player
	# Loops over all player nodes in the world, AKA connected players
	for player in world_node.get_node("ConnectedPlayers").get_children():
		world_node.rpc_id(player_peer_id, "spawn_player", player.position, player.get_network_master())

	# Spawns the connected player to the world
	world_node.rpc("spawn_player", Vector2(0,0), player_peer_id)

#Return chat message to ClientNetworking	
func return_chat_message(complete_text):
	rpc("recieve_complete_chat", complete_text)
	
	
