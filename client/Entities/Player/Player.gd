extends KinematicBody2D


# Movement vars
var speed 				= 0	# Assigned by server
var move_direction		= Vector2.ZERO
var prev_move_direction	= Vector2.ZERO
var moved				= false
var velocity 			= Vector2.ZERO

# Movement vars from server
var server_position 			= [Vector2.ZERO]
var last_server_position 		= Vector2.ZERO
var server_velocity				= Vector2.ZERO
var divergence:float			= 0
remote var move_acknowledged	= false

# Testing
onready var position_label_loc = get_node("PosLoc")
onready var position_label_pup = get_node("PosPup")

#Weapon
onready var weapons = preload("res://Entities/Weapons/Iron_spear.tscn")

# Tick rate
const TICK_RATE = 0.1
var time 		= 0

var timer_time		= 0
var timer_timeout	= 0.0
var ping			= 0


func _ready():
	if is_network_master():
		# Returns speed and applies it in set_speed
		rpc_unreliable_id(1, "get_speed")
		# TODO: Player should wait until speed from server is ready
		
		# Creates instances of scenes only the player should have
		var camera_node = preload("res://Entities/Player/PlayerCamera.tscn").instance()
		var chat_node 	= preload("res://Entities/Player/Chat.tscn").instance()
		var ping_node 	= preload("res://Entities/Player/ServerPing.tscn").instance()
		ping_node.connect("PingAnswer", self, "_on_PingAnswer")
		
		self.add_child(ping_node)
		self.add_child(chat_node)
		self.add_child(camera_node)
		
		
	# Sets player name over character
	var player_name = PlayerData.get_player_name(
		self.get_network_master()
	)
	get_node("PlayerName").text = str(player_name)
	
	
func _physics_process(delta):
	movement_loop(delta)
	position_disp()
	animation_loop()
	attack()

	
func movement_loop(delta):
	if is_network_master():	

		# This is just to try and give a little faster feedback when a player moves
		# Does not realy work as prodicting the movement as the linear_interpolate
		# later will pull the player back to last known server_posistion
		velocity = move_direction.normalized() * speed
		# warning-ignore:return_value_discarded
		move_and_slide(velocity) 
		
		# Gets input, value is either 0 or 1
		move_direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		move_direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		
		if move_direction != prev_move_direction:
			moved = true
			timer_timeout = ping + 2*delta * 1000
			print(delta * 1000)
		else:
			moved = false
		prev_move_direction = move_direction
		
#		rpc_unreliable_id(Server.SERVER_ID, "get_move", move_direction, OS.get_system_time_msecs())
		time += delta
		# Will send until server has acknowledg that the move_direction has changed
		if !move_acknowledged and time > TICK_RATE:
			time = 0
			var clienttime = OS.get_system_time_msecs()
			rpc_unreliable_id(Server.SERVER_ID, "get_move", move_direction, clienttime)
		elif moved:
			var clienttime = OS.get_system_time_msecs()
			rpc_unreliable_id(Server.SERVER_ID, "get_move", move_direction, clienttime)
			move_acknowledged = false # Will now start to send until acknowledged		
		
		# Converts detla to msec
		timer_time += delta * 1000
		if timer_time > timer_timeout:
			# Synces the player smoothly with the position from server
			divergence = (position - server_position.front()).length()
			if divergence > 1:
				divergence = clamp(divergence * 2, 5, 20)
				position = position.linear_interpolate(server_position.front(), delta * divergence)
			else:
				position = server_position.front()

			
			timer_time = 0
			timer_timeout = 0
			if server_position.size() != 1:
				server_position.pop_back()
		
		else:
			print("not syncing : " + str(OS.get_system_time_msecs()))
			
		
#		position = position.linear_interpolate(server_position.front(), delta)
			
	else:
		# This is realy just to get change_sprite_direction() to work on puppet players
		velocity = server_velocity
		# Synces the player smoothly with the position from server
		if (position - server_position.front()).length() > 1:
			position = position.linear_interpolate(server_position.front(), delta*10)
		else:
			position = server_position.front()

#	print("pos : " + str(position) + " \t move : " + str(move_direction)
#		+ "\nser_pos : " + str(server_position) 
#		+ "\n ------------------------ "
#	)
#
						
remote func process_movement(s_movement):
	server_position.push_front(s_movement[0]) 
#	server_position.push_front(Vector2.ZERO) 
	server_velocity = s_movement[1]


func position_disp():
	# Debuging/testing text below the player
	position_label_loc.text = "loc: " + str(position)
	position_label_pup.text = "ser: " + str(server_position.front())
	if position > server_position.front():
		position_label_loc.add_color_override("font_color", Color(1,0,0))
	elif position == server_position.front():
		position_label_loc.add_color_override("font_color", Color(0,1,0))
	elif position < server_position.front():
		position_label_loc.add_color_override("font_color", Color(0,0,1))
		
		
func animation_loop():
	# Checks of the player is moving or not and plays appropriate animation
	if move_direction != Vector2.ZERO:
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
	
	
func _on_PingAnswer(pingAns):
	ping = pingAns
