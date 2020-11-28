extends Node


var network
const SERVER_PORT 	= 6008
const MAX_PLAYERS 	= 100
const SERVER_ID 	:= 1



func _ready():
	Token.connect("ValidatePlayer", self, "_On_Client_Validated")
	
	Start_Server()

func Start_Server():
	# Signals
	# Will fire (call method to the right) when player connects or disconnects from server
	get_tree().connect("network_peer_connected", self, "_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_peer_disconnected")

	network = NetworkedMultiplayerENet.new()
	network.always_ordered = true

	var result = network.create_server(SERVER_PORT, MAX_PLAYERS)
	
	if result == OK:
		get_tree().set_network_peer(network)
		print_debug("Server Started" )
	else:
		print_debug("Failed to start server: %d" % result)


# Runs when a peer connects to the server
func _peer_connected(peer_id):
	rpc_id(peer_id, "fetch_token") # Get client token
	print("\nCLIENT TOKEN VALIDATION\n")	

func _peer_disconnected(peer_id):
	# Removes player node from the world
	get_node("/root/World").rpc("despawn_player", peer_id)
	print("User disconnected: ", str(peer_id))


func register_new_player(peer_id, player_name):
	var player_peer_id = peer_id
	# Sends the client all currently connected users
	PlayerData.rpc_id(
		player_peer_id, "get_player_list", PlayerData.get_all_players()
	)
	
	# Adds the new player to a dict of all connected users
	PlayerData.add_player(player_peer_id, player_name)
	
	# Tells other conected peers to register the new player
	rpc("register_new_players", player_peer_id, player_name)
	
	rpc_id(player_peer_id, "start_game", player_name)

	var player = PlayerData.get_player(player_peer_id)
	print("New player: " + str(player["id"]) + " has connected as: " + str(player["name"]))


# TODO: Does this need to happen for each player that connects?
remote func initiate_world():
	var player_peer_id = get_tree().get_rpc_sender_id()
	var world_node = get_node("/root/World")
	
	# Spawns connected players to newly connected player
	# Loops over all player nodes in the world, AKA connected players
	for player in world_node.get_node("ConnectedPlayers").get_children():
		world_node.rpc_id(
			player_peer_id,
			"spawn_player", 
			player.position, 
			player.get_network_master()
		)

	# Spawns the connected player to the world
	world_node.rpc("spawn_player", Vector2(0,0), player_peer_id)

#Return chat message to ClientNetworking	
func return_chat_message(complete_text):
	rpc("recieve_complete_chat", complete_text)

	
# Add token from client to list
remote func set_token(c_token):
	var peer_id = get_tree().get_rpc_sender_id()
	Token.addClient(peer_id, c_token)


func _On_Client_Validated(peer_id, username, validation): # Runs when tokens have been validated
	if(validation):
		register_new_player(peer_id, username) # Start login process
	else:
		network.disconnect_peer(peer_id, false) # TODO: Should we disconnect immidiatly without flushing messages?
