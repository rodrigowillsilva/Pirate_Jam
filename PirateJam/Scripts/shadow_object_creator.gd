extends Node2D

signal end_spell
signal clear_shadows

var shadow_object_p: PackedScene = preload("res://Scenes/Objects/shadow_object.tscn")
@export var ray: RayCast2D

var active: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	ray = $RayCast2D
	ray.enabled = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# if the player is not drawing, return
	if not active: return
	
	print("active")
	if Input.is_action_just_pressed("mouse1"):
		start_draw()	
	
	if Input.is_action_just_released("mouse1"):
		stop_draw()	

func start_draw() -> void:
	var sucess:= true
	# get all the lights in the Lights group that see the mouse position
	for light in get_tree().get_nodes_in_group("Lights"):
		if light is PointLight2D:
			# raycast from the light to the mouse position
			ray.global_position = get_global_mouse_position()
			ray.target_position = light.global_position
			ray.force_update_transform()
			ray.force_raycast_update()

			# if it doenst hit anything, add the light to the list
			if not ray.is_colliding():
				# Create a new shadow object
				var shadow_object: ShadowObject = shadow_object_p.instantiate() as ShadowObject
				shadow_object.position = Vector2.ZERO

				# Add the shadow object to the scene
				var soNode = get_tree().root
				soNode.add_child(shadow_object)

				#Start drawing the shadow object
				shadow_object.start_draw(get_global_mouse_position(), light)
				end_spell.connect(shadow_object.stop_draw)
				sucess = true
		else:
			# raycast from the light to the mouse position
			ray.global_position = get_global_mouse_position()
			ray.target_position = -Vector2(0, 1000).rotated(light.global_rotation)
			print(rad_to_deg(light.rotation))
			ray.force_update_transform()
			ray.force_raycast_update()

			# if it does hit the area2d, add the light to the list
			if not ray.is_colliding():
				# Create a new shadow object
				var shadow_object: ShadowObject = shadow_object_p.instantiate() as ShadowObject
				shadow_object.position = Vector2.ZERO

				# Add the shadow object to the scene
				var soNode = get_tree().root
				soNode.add_child(shadow_object)

				#Start drawing the shadow object
				shadow_object.start_draw(get_global_mouse_position(), light)
				end_spell.connect(shadow_object.stop_draw)
				sucess = true
			
		if not sucess:
			stop_draw()

func stop_draw() -> void:
	active = false
	end_spell.emit()	


func _on_rune_table_end_rune_draw(rune):
	if rune == "line":
		active = true
