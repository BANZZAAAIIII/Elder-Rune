extends KinematicBody2D

const SPEED 	= 150
var tick_rate 	= 0.01 # 10 m/s
var time 		= 0


puppet var move_diretion 	= Vector2.ZERO
var prev_move_diretion	 	= Vector2.ZERO
var velocity 				= Vector2.ZERO

onready var world_node 		= get_node("/root/World")


func _ready():
	# Stopps client from sending move_direction until they start moving
	rset_id(self.get_network_master(),"move_acknowledged", true)
	
	
func _physics_process(delta):
	velocity = move_diretion.normalized() * SPEED
	move_and_slide(velocity)
		
	if move_diretion != prev_move_diretion:
		rset_id(self.get_network_master(),"move_acknowledged", true)
	prev_move_diretion = move_diretion
	
	time += delta
	# Lowers the tick rate if the player isn't moving
	# This is to not send unnecessary data and to make sure the player has the latest position
	if move_diretion == Vector2.ZERO:
		tick_rate = 0.5
	else:
		tick_rate = 0.01
	
	if time > tick_rate:
		time = 0
		for player in world_node.get_node("ConnectedPlayers").get_children():
			rpc_unreliable_id(int(player.name), "process_movement", [position, velocity])
		
	

remote func get_speed():
	rpc_id(get_tree().get_rpc_sender_id(), "set_speed", SPEED)
	
