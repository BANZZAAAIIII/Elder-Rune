extends Node

onready var player_node = preload("res://Entities/Player.tscn")

puppetsync func spawn_player(player_pos, peer_id):
	var player_instance = player_node.instance()
	
	player_instance.position = player_pos			# Sets the positions of the player
	player_instance.name = str(peer_id)				# Sets the node name of the player. This has to be uniq
	player_instance.set_network_master(peer_id) 	# Sets the network master. This has to be the peer id of the player
	
	get_node("ConnectedPlayers").add_child(player_instance)

puppetsync func despawn_player(peer_id):
	# Removes player from server dict
	PlayerData.remove_player(peer_id)
	
	# Gets the player node with the uniqe peer id and removes it
	var disconnected_player = get_node("ConnectedPlayers").get_node(str(peer_id))
	if disconnected_player:
		disconnected_player.queue_free()


func _ready():
	pass
#	PlayerData.add_player(123, "aaa")
#	PlayerData.add_player(1234, "asdbbbbasd")
#	PlayerData.add_player(12346, "ssss")
#	PlayerData.add_player(11223, "dddd")
#	PlayerData.print_players()
#
#	PlayerData.remove_player(123)
#	PlayerData.print_players()
#
#	print(PlayerData.__players[1234]["name"])
	
