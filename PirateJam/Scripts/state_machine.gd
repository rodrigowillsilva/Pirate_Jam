extends Node

class_name StateMachine

@export var initial_state: State
@export var player: CharacterBody2D

var states: Dictionary = {}
var current_state: State

var side:= 0
var livro:= false

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_change.connect(on_state_change)
			child.state_machine = self
			child.init()
	
	if initial_state:
		current_state = initial_state
		current_state.enter()

func _process(_delta: float) -> void:
	####################################################
	#Rodrigo: This should be done in another script
	####################################################
	
	#Control the animation of the player
	if not livro:
		if player.velocity.y < 0 and get_node("..").get_node("AnimatedSprite2D").animation != "pulo_0":
			get_node("..").get_node("AnimatedSprite2D").play("pulo_0")
		elif player.velocity.y > 0 and get_node("..").get_node("AnimatedSprite2D").animation != "pulo_1":
			get_node("..").get_node("AnimatedSprite2D").play("pulo_1")
		
		if player.velocity.x < 0:
			if player.velocity.y == 0:
				get_node("..").get_node("AnimatedSprite2D").play("correndo")
			side = 0
			get_node("..").get_node("AnimatedSprite2D").flip_h = true
		elif player.velocity.x > 0:
			if player.velocity.y == 0:
				get_node("..").get_node("AnimatedSprite2D").play("correndo")
			get_node("..").get_node("AnimatedSprite2D").flip_h = false
			side = 1
		elif player.velocity.x == 0 and player.velocity.y == 0:
			get_node("..").get_node("AnimatedSprite2D").flip_h = false
			if side == 0:
				get_node("..").get_node("AnimatedSprite2D").play("esquerda")
			else:
				get_node("..").get_node("AnimatedSprite2D").play("direita")
	elif livro:
		get_node("..").get_node("AnimatedSprite2D").play("livro")
	
	if current_state:
		current_state.update(_delta)

func _physics_process(_delta: float) -> void:
	if current_state:
		current_state.physics_update(_delta)

func on_state_change(state: State, new_state: String) -> void:
	if state != current_state:
		return
	
	current_state.exit()
	current_state = states.get(new_state.to_lower())
	current_state.enter()

