extends KinematicBody2D

var speed = 2
var move_diretion = Vector2.ZERO

var velocity = Vector2.ZERO

func _ready():
	pass


func _physics_process(delta):
	movement_loop()
	animation_loop()
	change_sprite_direction()
	
func _process(delta):
	pass


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
		

