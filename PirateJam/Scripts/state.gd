extends Node
class_name State

signal state_change(new_state: String)

signal state_changed(new_state: String)

var state_machine: StateMachine
var inputs: Dictionary
			

func update(_delta: float) -> void:
	inputs.clear()


func physics_update(_delta: float) -> void:
	pass

func enter(_msg:={}) -> void:
	pass

func exit() -> void:
	pass
	
func init():
	pass

func _unhandled_input(_event):
	pass
