extends Control

@onready var backGround = $backGround

func _ready():
	backGround.play("anim")

func _on_start_pressed():
	get_tree().change_scene_to_file("res://furlan_levels/level_furlan1.tscn")

func _on_quit_pressed():
	get_tree().quit()
