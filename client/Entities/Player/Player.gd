extends KinematicBody2D


# Movement vars
var speed 				= null
var move_diretion 		= Vector2.ZERO
var prev_move_diretion 	= Vector2.ZERO
var velocity 			= Vector2.ZERO

# Movement vars for puppet node
puppet var puppet_position 	= Vector2()
puppet var puppet_velocity	= Vector2()

#Weapon
onready var weapons = preload("res://Entities/Weapons/Weapon.tscn")

func _ready():
	if is_network_master():
		# Sets player name over character
		var player_name = PlayerData.get_player_name(
			get_tree().get_network_unique_id()
		)
		get_node("PlayerName").text = str(player_name)
		# Returns speed and sets it in set_speed
		rpc_id(1, "get_speed")
		# This is so only the player will have an activ camere node
		var camera = preload("res://Entities/Player/PlayerCamera.tscn").instance()
		self.add_child(camera)
		
	else:
		var player_name = PlayerData.get_player_name(
			self.get_network_master()
		)
		get_node("PlayerName").text = str(player_name)
		# initilizing puppet_position
		puppet_position = position
		


func _physics_process(delta):
	movement_loop()
	animation_loop()
	attack()
	change_sprite_direction()
	
	
func movement_loop():
	if is_network_master():
		# Gets input, value is either 0 or 1
		move_diretion.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		move_diretion.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
			
		velocity = move_diretion.normalized() * speed
		
		# To avoid sending data if the player hasen't moved since last frame
		if move_diretion != prev_move_diretion:
			# Updates all other connected peers about the players velocity and 
			# position when moving. If the player is holding down a button the 
			# Velocity is used to "predictit" the movment of the player.
			rset_unreliable("puppet_position", position)
			rset_unreliable("puppet_velocity", velocity)
		prev_move_diretion = move_diretion
	else:
		# Gets position and velocity from node on server
		position = puppet_position
		velocity = puppet_velocity
	
	# move_and_slide makes the character slide along collitions
	# uses delta automaticly, so no need to use it here
	velocity = move_and_slide(velocity)
	
	# This for some reason removes a lot of jittering 
	if not is_network_master():
		puppet_position = position


func animation_loop():
	# Checks of the player is moving or not and plays appropriate animation
	if move_diretion != Vector2.ZERO:
		get_node("AnimationPlayer").play("Walk")
	else:
		get_node("AnimationPlayer").play("Idle")


func change_sprite_direction():
	# Changes what diraction a puppet or master node/player is moving
	if velocity.x >= 1:
		get_node("Sprite").scale.x = 1
	if velocity.x <= -1:
		get_node("Sprite").scale.x = -1
		
		
func attack():
	if Input.is_action_just_pressed("ui_select") and is_network_master():
		get_node("TurnAxis").rotation = get_angle_to(get_global_mouse_position())
		var w = weapons.instance()
		get_node("TurnAxis/AttackPoint").add_child(w)
		w.get_node("AnimationPlayer").play("attack")
		

remote func set_speed(s_speed):
	speed = 300
