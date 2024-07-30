extends CharacterBody2D

const speed : int = 100
var direction : Vector2
var direction_array : Array = [Vector2.LEFT,Vector2.RIGHT]
@onready var animated = $AnimatedSprite2D
@onready var raycast_wall = $RayCast2D
@onready var raycast_void = $RayCast2D2
@onready var random_stop_timer = $random_stop_timer

func _ready():
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

func _physics_process(_delta):
	velocity = direction * speed
	move_and_slide()

func _check_direction():
	if direction == Vector2.RIGHT:
		animated.flip_h = true
		raycast_wall.target_position = Vector2(0,-19)
		raycast_void.target_position = Vector2(18,-20)
	elif direction == Vector2.LEFT:
		animated.flip_h = false
		raycast_wall.target_position = Vector2(0,19)
		raycast_void.target_position = Vector2(18,20)

func _stop_and_change():
	raycast_wall.enabled = false
	raycast_void.enabled = false
	direction = Vector2.ZERO
	animated.play("idle")
	await animated.animation_finished
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
	raycast_wall.enabled = true
	raycast_void.enabled = true
	direction = direction_array.pick_random()

func _process_timer():
	random_stop_timer.wait_time = randi_range(5,20)
