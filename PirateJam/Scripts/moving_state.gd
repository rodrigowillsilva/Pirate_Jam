extends State

var player: CharacterBody2D

@export var gravity: float = 980
@export var max_velocity: float = 1000
@export var acceleration: float = 1000
@export var friction: float = 1000
@export var jump_height: float = 100

var velocity: Vector2 = Vector2.ZERO

var input_dir: Vector2 = Vector2.ZERO

func init():
	player = state_machine.player
	print("Player: ", player)

func enter(_msg:={}) -> void:
	pass

func update(delta: float) -> void:
	input_dir = input()
	

func physics_update(delta: float) -> void:
	calc_gravity(delta)
	calc_jump()
	if input_dir != Vector2.ZERO:
		calc_vel(delta)
	else:
		fric(delta)
	player.velocity = velocity
	player.move_and_slide()
	velocity = player.velocity
	#print(player.velocity, "real")
	#print(player.get_real_velocity())
	print(player.get_floor_angle() * 180 / PI)
	print(player.get_floor_normal())
	

func input() -> Vector2:
	input_dir = Vector2.ZERO
	
	input_dir.x += 1 if Input.is_action_pressed("right") else 0
	input_dir.x -= 1 if Input.is_action_pressed("left") else 0
	input_dir = input_dir.normalized()
	return input_dir

func calc_vel(delta):
	velocity.x = move_toward(velocity.x, max_velocity * input_dir.x, acceleration * delta)

func calc_jump():
	if player.is_on_floor() and Input.is_action_just_pressed("up"):
		velocity.y = -sqrt(2 * gravity * jump_height)


func fric(delta: float):
	if player.is_on_floor():
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	else:
		velocity.x = (Vector2.RIGHT * velocity.x).move_toward(Vector2.ZERO, friction * delta).x
	
func calc_gravity(delta: float):
	velocity.y += gravity * delta
	if player.is_on_floor():
		#velocity.y = 0
		pass
	else:
		pass
	
