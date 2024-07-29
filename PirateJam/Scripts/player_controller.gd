extends CharacterBody2D

var state_machime: StateMachine

func _ready():
	state_machime = $"State Machine"
	
func _on_rune_table_end_rune_draw(rune):
	match rune:
		"line":
			state_machime.on_state_change(state_machime.current_state, "Casting".to_lower())


func _on_shadow_object_creator_end_spell():
	state_machime.on_state_change(state_machime.current_state, "Moving".to_lower())
