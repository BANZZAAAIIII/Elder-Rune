extends KinematicBody2D


# Movement vars
var speed 				= 1
var move_diretion 		= Vector2.ZERO
var prev_move_diretion 	= Vector2.ZERO
var velocity 			= Vector2.ZERO

# Movement vars for puppet node
remote var puppet_position 	= Vector2()
var prev_puppet_position	= Vector2.ZERO
remote var puppet_velocity	= Vector2()

#Weapon
onready var weapons = preload("res://Entities/Weapons/Iron_spear.tscn")

# Testing
onready var position_label_loc = get_node("PosLoc")
onready var position_label_pup = get_node("PosPup")

var moving = false


func _ready():
	if is_network_master():
		# Sets player name over character
		var player_name = PlayerData.get_player_name(
			get_tree().get_network_unique_id()
		)
		get_node("PlayerName").text = str(player_name)
		# Returns speed and sets it in set_speed
		rpc_id(1, "get_speed")
		# TODO: Player should wait until speed from server is ready
		
		# This is so only the master will have an activ camere and chat scene
		var camera = preload("res://Entities/Player/PlayerCamera.tscn").instance()
		var chat = preload("res://Globals/Chat.tscn").instance()
		self.add_child(chat)
		self.add_child(camera)
		
	else:
		var player_name = PlayerData.get_player_name(
			self.get_network_master()
		)
		get_node("PlayerName").text = str(player_name)
	


func _physics_process(delta):
	movement_loop(delta)
	animation_loop()
	attack()


	
func movement_loop(delta):
	if is_network_master():	
		# Gets input, value is either 0 or 1
		move_diretion.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		move_diretion.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
					
		# To avoid sending data if the player hasen't moved since last frame
		if move_diretion != prev_move_diretion:
			moving = true
			rset_id(1, "move_diretion", move_diretion)
			
			position = puppet_position
			
			
		else:
			moving = false

			
		prev_move_diretion = move_diretion
	else:
		position = puppet_position
		velocity = puppet_velocity

	velocity = move_diretion.normalized() * speed
	velocity = move_and_slide(velocity)
	

		
#	velocity = move_diretion.normalized() * speed
#	velocity = move_and_slide(velocity)
	

#	if !moving:
#		position = puppet_position
#	else:
#		pass
#		if (position - puppet_position).length() > 0.1:
#			position = position.linear_interpolate(puppet_position, delta*10)
	
	
	# Debuging/testing text below the player
	position_label_loc.text = "loc: " + str(position)
	position_label_pup.text = "ser: " + str(puppet_position)
	
	

func animation_loop():
	# Checks of the player is moving or not and plays appropriate animation
	if move_diretion != Vector2.ZERO:
		get_node("PlayerSprite/SpriteAnimation").play("Walk")
		change_sprite_direction()
	else:
		get_node("PlayerSprite/SpriteAnimation").play("Idle")


func change_sprite_direction():
	# Changes what diraction a puppet or master node/player is moving
	if velocity.x >= 1:
		get_node("PlayerSprite/Sprite").scale.x = 1
	if velocity.x <= -1:
		get_node("PlayerSprite/Sprite").scale.x = -1


func attack():
	if Input.is_action_just_pressed("ui_select") and is_network_master():
		get_node("TurnAxis").rotation = get_angle_to(get_global_mouse_position())
		var w = weapons.instance()
		get_node("TurnAxis/AttackPoint").add_child(w)
		w.get_node("AnimationPlayer").play("attack")


remote func set_speed(s_speed):
	speed = s_speed
