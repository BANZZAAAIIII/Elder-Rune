extends Node

# Create a connection to the server


var network
const SERVER_IP := "localhost"
const SERVER_PORT := 6008
const SERVER_ID := 1

var client_name = "Anders"


func _ready():
	
	# Signals
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	get_tree().connect("network_peer_connected", self, "_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_peer_disconnected")
	
	# Create client & connect to server
	Connect_To_Server()
	

# Connect to server
func Connect_To_Server():
	
	# Create client
	network = NetworkedMultiplayerENet.new()
	var result = network.create_client(SERVER_IP, SERVER_PORT)
	if result == OK:
		get_tree().set_network_peer(network)
		print("Connecting to server.....")
		return true
	else:
		print("Failed to connect to server")
		return false

func _connected_fail():
	print("Failed to connect")
	
func _connected_ok():
	#Send something to server to spawn player
	print("Succesfully connected")
	
func _server_disconnected():
	print("Server kicked you")

# Triggers when a new player connects to server
func _peer_connected(id):
	rpc_id(id, "register_player", client_name)
	print("")

# Triggers when a player disconnects
func _peer_disconnected(id):
	PlayerData.remove_player(id)
	print(str(id) + " disconnected")


func send_position(player_position):
	rpc_id(1, "get_player_posistion", player_position)
	
# Register a connected player
remote func register_player(data):
	var id = get_tree().get_rpc_sender_id() # Gets id of connected player
	PlayerData.add_player(id, data)

remote func server_ans(player_position):
	print_debug(player_position)


remote func spawn_new_player(player_data):
	# Gets a new player from server and spawns it at
	pass
