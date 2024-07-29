extends "res://Scripts/state.gd"


func enter(_msg:={}) -> void:
	state_machine.livro = true

func exit() -> void:
	state_machine.livro = false
