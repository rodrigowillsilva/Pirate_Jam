extends CharacterBody2D

class_name monster_shadow

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var speed : int = 50
var direction : Vector2
var direction_array : Array = [Vector2.LEFT,Vector2.RIGHT]
@onready var animated = $AnimatedSprite2D
@onready var raycast_wall = $RayCast2D
@onready var raycast_void = $RayCast2D2
@onready var raycast_chase = $RayCast2D3
@onready var random_stop_timer = $random_stop_timer
var chasing : bool = false
var Player

func _ready():
	Player = get_parent().find_child("Player")
	direction = direction_array.pick_random()
	random_stop_timer.wait_time = randi_range(5,20)
	random_stop_timer.start()

func _on_random_stop_timer_timeout():
	_random_stop()
	_process_timer()

func _process(_delta):
	_check_direction()
	if raycast_wall.is_colliding() and raycast_wall.enabled == true:
		_stop_and_change()
	if not raycast_void.is_colliding() and raycast_void.enabled == true:
		_stop_and_change()
	_change_state()

func _physics_process(delta):
	if is_on_floor():
		velocity = direction * speed
	else:
		velocity.y += gravity * delta
	move_and_slide()

func _check_direction():
	if direction == Vector2.RIGHT:
		animated.flip_h = true
		raycast_wall.target_position = Vector2(0,-19)
		raycast_void.target_position = Vector2(18,-20)
		raycast_chase.target_position = Vector2(75,0)
	elif direction == Vector2.LEFT:
		animated.flip_h = false
		raycast_wall.target_position = Vector2(0,19)
		raycast_void.target_position = Vector2(18,20)
		raycast_chase.target_position = Vector2(-75,0)

func _stop_and_change():
	raycast_wall.enabled = false
	raycast_void.enabled = false
	direction = Vector2.ZERO
	animated.play("idle")
	await animated.animation_finished
	animated.play("walking")
	raycast_wall.enabled = true
	raycast_void.enabled = true
	if animated.flip_h == true:
		direction = direction_array[0]
	elif animated.flip_h == false:
		direction = direction_array[1]

func _random_stop():
	raycast_wall.enabled = false
	raycast_void.enabled = false
	direction = Vector2.ZERO
	animated.play("idle")
	await animated.animation_finished
	animated.play("walking")
	raycast_wall.enabled = true
	raycast_void.enabled = true
	direction = direction_array.pick_random()

func _change_state():
	if raycast_chase.get_collider() == Player:
		chasing = true
		speed = 150
		raycast_wall.enabled = false
		raycast_void.enabled = false
		random_stop_timer.stop()
	elif raycast_chase.get_collider() != Player:
		chasing = false
		speed = 50
		raycast_wall.enabled = true
		raycast_void.enabled = true
		random_stop_timer.stop()

func _process_timer():
	random_stop_timer.wait_time = randi_range(5,20)
