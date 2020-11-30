extends Node

var __players = {}


const PLAYER_ID = "id"
const PLAYER_NAME = "name"


# Create a player object to store data in
func create_new_player(player_id: int, player_name: String) -> Dictionary:
	return { 
		PLAYER_ID: player_id, PLAYER_NAME: player_name 
	}

# Adds a player to currently connected players
func add_player(player_id: int, player_name: String):
	var new_player = create_new_player(player_id, player_name)
	self.__players[player_id] = new_player
	
	return new_player

# Remove a player
func remove_player(player_id: int):
	if __players.has(player_id):
		__players.erase(player_id)
	else:
		print_debug("Player with ID:" + str(player_id) + " wasnt found")


func get_player_name(peer_id):
	# This returns the ID as well, usefull for debugging	
#	return players[peer_id]
	return __players[peer_id][PLAYER_NAME]
	

func print_players():
	print("players connected ")
	for player in __players.values():
		print("Peer ID:" + str(player[PLAYER_ID]) + ", Name: " + player[PLAYER_NAME])
	print("---------------")
	print("")	# Spacing


# Gets a list of all currently connected users from the server when the player first connects
remote func get_player_list(s_players):
	__players = s_players
