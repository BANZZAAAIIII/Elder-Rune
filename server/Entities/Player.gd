extends Node2D

const SPEED = 500


var velocity = Vector2()
puppet var puppet_position	= Vector2()
puppet var puppet_velocity 	= Vector2()


func _ready():
	# This code is not nessecery for player movment
	# It is only to visualizer player movment on the server
	puppet_position = position


func _process(delta):
	pass
	# This code is not nessecery for player movment
	# It is only to visualizer player movment on the server
	# The code is the same on the client, but without the player functionality 
	# and movement
	
	# Sync position from clinet
	position = puppet_position
	velocity = puppet_velocity

	# move the node
	position += velocity * delta

	# This is to remove jitter. 
	# If we dont do this the puppet player will jump/jitter between
	# puppet_position and the position after move_and_slide
	puppet_position = position


remote func get_speed():
	rpc_id(get_tree().get_rpc_sender_id(), "set_speed", SPEED)
