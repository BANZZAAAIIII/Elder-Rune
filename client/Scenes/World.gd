extends Node2D

onready var player_node = preload("res://Entities/Player/Player.tscn")

puppet func spawn_player(player_pos, peer_id):
	var player_instance = player_node.instance()
	
	# TODO spanw player in last known location
	player_instance.position = player_pos			# Sets the positions of the player
	player_instance.name = str(peer_id)				# Sets the node name of the player. This has to be uniq
	player_instance.set_network_master(peer_id) 	# Sets the network master. This has to be the peer id of the player
	
	get_node("ConnectedPlayers").add_child(player_instance)

puppet func despawn_player(peer_id):
	get_node("ConnectedPlayers").get_node(str(peer_id)).queue_free()
