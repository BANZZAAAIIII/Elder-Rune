extends KinematicBody2D

const SPEED 	= 150
var tick_rate 	= 0.1
var time 		= 0


puppet var move_direction	= Vector2.ZERO
var prev_move_direction	 	= Vector2.ZERO
var velocity 				= Vector2.ZERO

var latest_state_recived 	= 0

onready var world_node 		= get_node("/root/World")


func _ready():
	# Stopps client from sending move_direction until they start moving
	rset_id(self.get_network_master(),"move_acknowledged", true)
	
	
	
func _physics_process(delta):
	velocity = move_direction.normalized() * SPEED
	move_and_slide(velocity)
	
	if move_direction != prev_move_direction:
		rset_id(self.get_network_master(),"move_acknowledged", true)
	prev_move_direction = move_direction
	
	time += delta
	# Lowers the tick rate if the player isn't moving
	# This is to not send unnecessary data and to make sure the player has the latest position
	if move_direction == Vector2.ZERO:
		tick_rate = 0.1
	else:
		tick_rate = 0.02
	
	if time > tick_rate: # TODO make timer to gain better controll?
		time = 0
		for player in world_node.get_node("ConnectedPlayers").get_children():
			rpc_unreliable_id(int(player.name), "process_movement", [position, velocity])
		
	

remote func get_speed():
	rpc_id(get_tree().get_rpc_sender_id(), "set_speed", SPEED)
	
	
remote func get_move(move_dir, client_time):
#	print(str(client_time) + " : " + str(latest_state_recived))
	if client_time > latest_state_recived:
		latest_state_recived = client_time
		move_direction = move_dir
	else:
		print_debug("Player packet out of order")
	
