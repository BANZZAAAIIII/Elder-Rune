extends KinematicBody2D

# movement vars
var speed = 2
var move_diretion = Vector2.ZERO
var velocity = Vector2.ZERO

#Weapon
onready var texture = preload("res://entities/Enemy/enemy sprits/big_demon_1.tres")


func _ready():
	get_node("Sprite").set_texture(texture)


func _physics_process(delta):
	animation_loop()
	change_sprite_direction()
	#attack()

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

