extends Node2D


var checkpoint : Vector2
@onready var player = $Player
@onready var camera = $Player/Camera2D
@onready var void_area = $void_area
@onready var checkpoint_area = $checkpoint_area
@onready var end_camera = $end_camera_area
@onready var level_end_area = $level_end_area
@onready var hurt_area = $hurt_area


func _process(_delta):
	hurt_area.position = player.position

func _on_checkpoint_area_body_entered(body):
	if body is alchemist:
		checkpoint = player.position

func _on_void_area_body_entered(body):
	if body is alchemist:
		_go_to_checkpoint()

func _go_to_checkpoint():
	player.position = checkpoint

func _on_end_camera_area_body_entered(body):
	if body is alchemist:
		camera.limit_right = end_camera.position.x + 800

func _on_level_end_area_body_entered(body):
	if body is alchemist:
		get_tree().change_scene_to_file("res://Scenes/finalScene.tscn")

func _on_hurt_area_body_entered(body):
	if body is monster_shadow:
		_go_to_checkpoint()
