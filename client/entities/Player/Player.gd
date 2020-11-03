extends KinematicBody2D


# movement vars
var speed = 5
var move_diretion = Vector2.ZERO
var velocity = Vector2.ZERO

#Weapon
onready var weapons = preload("res://entities/Weapons/Weapon.tscn")


func _ready():
	pass


func _physics_process(delta):
	movement_loop()
	animation_loop()
	change_sprite_direction()
	attack()
	
	
func movement_loop():
	# Gets input, value is either 0 or 1
	move_diretion.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	move_diretion.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		
	var motion = move_diretion.normalized() * speed
	
	# move_and_collide makes the character slide along collitions
	# uses delta automaticly, so no need to use it here
	motion = move_and_collide(motion)
	

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

		# update server
		var player_pos = get_node("global_posistion").global_position
		ClientNetwork.send_position(player_pos)
