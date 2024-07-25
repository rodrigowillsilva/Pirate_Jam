extends Node

class_name StateMachine

@export var initial_state: State
@export var player: CharacterBody2D

var states: Dictionary = {}
var current_state: State


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
