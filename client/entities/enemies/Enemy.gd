extends KinematicBody2D

# movement vars
var speed = 2
var move_diretion = Vector2.ZERO
var velocity = Vector2.ZERO

var health = 100

#Weapon
onready var texture = preload("res://Entities/enemies/enemy sprits/big_goblin_1.tres")


func _ready():
	get_node("Sprite").set_texture(texture)


func _physics_process(delta):
	animation_loop()
	change_sprite_direction()


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


func _on_Hurtbox_area_entered(area):
	health -= 10
	print(health)
	if health < 0:
		queue_free()
