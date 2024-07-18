extends CharacterBody2D

const velocidade = 550
const forcaPulo = -2000
const acc = 50
const fric = 70
const gravidade = 120
const maxPulo = 2
var quantPulo = 1

func _physics_process(delta):
	var input_dir: Vector2 = input()
	
	if input_dir != Vector2.ZERO:
		acelerar(input_dir)
	else:
		friccao()
	
	movimento()
	pulo()

func input() -> Vector2:
	var input_dir = Vector2.ZERO
	
	input_dir.x = Input.get_axis("ui_left", "ui_right")
	input_dir = input_dir.normalized()
	return input_dir

func acelerar(direcao):
	velocity = velocity.move_toward(velocidade * direcao, acc)

func friccao():
	velocity = velocity.move_toward(Vector2.ZERO, fric)

func movimento():
	move_and_slide()

func pulo():
	if Input.is_action_just_pressed("ui_up"):
		if quantPulo < maxPulo:
			velocity.y = forcaPulo
			quantPulo += 1
	
	else:
		velocity.y += gravidade

	if is_on_floor():
		quantPulo = 1
