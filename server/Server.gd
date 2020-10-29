extends Node


var network = NetworkedMultiplayerENet.new()
var port = 6007
var MAX_PLAYERS = 100


func _ready():
	Start_Server()


func Start_Server():
	network.create_server(port, MAX_PLAYERS)
	
	get_tree().set_network_peer(network)
	
	print("Server Started")
	
	# Signals
	# Will fire (call method) when player connects or disconnects from server
	network.connect("peer_connected", self, "_Peer_Connection")
	network.connect("peer_disconnected", self, "_Peer_Disconnected")



func _Peer_Connection(player_id):
	print("user " + str(player_id) + " connected")
	
	
func _Peer_Disconnected(player_id):
	print("user " + str(player_id) + " disconnected")
	
