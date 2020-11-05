#extends Node
#
#var players = {}
#
#
#const PLAYER_ID = "id"
#const PLAYER_NAME = "name"
#
#
## Create a player object to store data in
#func create_new_player(playerId: int, playerName: String) -> Dictionary:
#	return { PLAYER_ID: playerId, PLAYER_NAME: playerName }
#
#func add_player(playerId: int, playerName: String):
#	var newPlayer = create_new_player(playerId, playerName)
#	self.players[playerId] = newPlayer
#
## Remove a player
#func remove_player(playerId: int):
#	players.erase(playerId)
#
## Reset player data
#func reset():
#	self.players = {}
