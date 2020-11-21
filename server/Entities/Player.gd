extends KinematicBody2D

const SPEED = 200


puppet var move_diretion 	= Vector2.ZERO
var prev_move_diretion 		= Vector2.ZERO
var velocity 				= Vector2.ZERO

onready var world_node = get_node("/root/World")


func _ready():
	pass
	prev_move_diretion.x = 1

func _process(delta):
	
	velocity = move_diretion.normalized() * SPEED
	velocity = move_and_slide(velocity)
	
#	if move_diretion != prev_move_diretion:
#		pass
#	prev_move_diretion = move_diretion
	if velocity != Vector2.ZERO:
		for player in world_node.get_node("ConnectedPlayers").get_children():
			rset_id(int(player.name), "puppet_position", position)
			rset_id(int(player.name), "puppet_velocity", velocity)
			
	
	if Input.is_action_just_pressed("ui_accept"):
		position += Vector2(5, 5)

remote func get_speed():
	rpc_id(get_tree().get_rpc_sender_id(), "set_speed", SPEED)
