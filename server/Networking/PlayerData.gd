extends Node

var players = {}


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
	self.players[player_id] = new_player
	
	return new_player

# Remove a player
func remove_player(player_id: int):
	players.erase(player_id)


func print_players():
	print("players connected ")
	for playerid in players:
		print(str(players[playerid]))
	print("---------------")
	print("")	# Spacing
