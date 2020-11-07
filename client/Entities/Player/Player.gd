extends KinematicBody2D


# movement vars
var speed = 200
var move_diretion = Vector2.ZERO
var prev_move_diretion = Vector2.ZERO
var velocity = Vector2.ZERO


puppet var puppet_pos
puppet var puppet_vel = Vector2()

#Weapon
onready var weapons = preload("res://entities/Weapons/Weapon.tscn")

func _ready():
	if is_network_master():
		# This is so only the player will have an activ camere node
		var camera = preload("res://Entities/Player/PlayerCamera.tscn").instance()
		self.add_child(camera)
#		var player_name = PlayerData.get_player_name(get_tree().get_network_unique_id())
#		print(player_name)
#		get_node("PlayerName").text = player_name


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
			
		var motion = move_diretion.normalized() * speed
		
		# move_and_slide makes the character slide along collitions
		# uses delta automaticly, so no need to use it here
		motion = move_and_slide(motion)
		
		rset_unreliable("puppet_pos", position)
		rset_unreliable("puppet_vel", velocity)
		
		# To avoid sending data if the player hasen't moved since last frame
		if move_diretion != prev_move_diretion:
			# TODO RCP movment to server
			pass

		prev_move_diretion = move_diretion
	else:
		position = puppet_pos
		velocity = puppet_vel
		

func animation_loop():
	# Checks of the player is moving or not and plays appropriate animation
	if move_diretion != Vector2.ZERO:
		get_node("AnimationPlayer").play("Walk")
	else:
		get_node("AnimationPlayer").play("Idle")


func change_sprite_direction():
	if move_diretion.x == 1:
		get_node("Sprite").scale.x = 1
	if move_diretion.x == -1:
		get_node("Sprite").scale.x = -1
		
		
func attack():
	if Input.is_action_just_pressed("ui_select"):
		get_node("TurnAxis").rotation = get_angle_to(get_global_mouse_position())
		var w = weapons.instance()
		get_node("TurnAxis/AttackPoint").add_child(w)
		w.get_node("AnimationPlayer").play("attack")

