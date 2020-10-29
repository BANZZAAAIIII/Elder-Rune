extends Node


var network = NetworkedMultiplayerENet.new()
var ip = "localhost"
var port = 6007


func _ready():
	Connect_To_Server()
	print("hallo?")


func Connect_To_Server():
	network.create_client(ip, port)
	get_tree().set_network_peer(network)

	network.connect("connection_failed", self, "_On_Connection_Failed")
	network.connect("connection_succeeded", self, "_On_Connection_succeeded")


func _On_Connection_Failed():
	print("Failed to connect")
	
	
func _On_Connection_succeeded():
	print("Succesfully connected")
	
