extends Node


var network = NetworkedMultiplayerENet.new()
var ip = "localhost"
var port = 6007


func _ready():
	Connect_To_Server()
	print_debug("Connect_To_Server")


func Connect_To_Server():
	network.create_client(ip, port)
	get_tree().set_network_peer(network)

	network.connect("connection_failed", self, "_On_Connection_Failed")
	network.connect("connection_succeeded", self, "_On_Connection_succeeded")


func _On_Connection_Failed():
	print("Failed to connect")
	
	
func _On_Connection_succeeded():
	print("Succesfully connected")
	
	
func send_position(player_position):
	rpc_id(1, "get_player_posistion", player_position)
	
	
remote func server_ans(player_position):
	print_debug(player_position)
