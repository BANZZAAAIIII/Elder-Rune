extends Node


var network = NetworkedMultiplayerENet.new()
var port = 6007
var max_players = 100


func _ready():
	Start_Server()
	

func _process(delta):
	if Input.is_action_just_pressed("ui_down"):
		rpc("server_ans", "hallo")


func Start_Server():
	network.create_server(port, max_players)
	
	get_tree().set_network_peer(network)
	
	print("Server Started")
	
	# Signals
	# Will fire (call method) when player connects or disconnects from server
	network.connect("peer_connected", self, "_Peer_Connection")
	network.connect("peer_disconnected", self, "_Peer_Disconnected")


func _Peer_Connection(peer_id):
	print("user " + str(peer_id) + " connected")


func _Peer_Disconnected(peer_id):
	print("user " + str(peer_id) + " disconnected")
	
	
remote func get_player_posistion(player_position):
	#This is not working for some reason
	#var player_id = get_tree().get_rpc_sender_id()
	
	rpc("server_ans", player_position)
	

