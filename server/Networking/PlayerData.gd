extends Node

var __players = {}


const PLAYER_ID = "id"
const PLAYER_NAME = "name"

func _ready():
	DatabaseConnection.getPlayerPosition(1)				# gets user by id / name??
	DatabaseConnection.updatePlayerPosition(1, 20, 20)	# set x,y values
	DatabaseConnection.getPlayerPosition(1)				# checks updated values
	

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


func get_all_players():
	return __players
	
func get_player(peer_id):
	return __players[peer_id]

func print_players():
	print("players connected ")
	for player in __players.values():
		print("Peer ID:" + str(player[PLAYER_ID]) + ", Name: " + player[PLAYER_NAME])
	print("---------------")
	print("")	# Spacing
