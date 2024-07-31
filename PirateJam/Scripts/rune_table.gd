extends Control

# Signals
signal end_rune_draw(rune: String)

# Exported variables
@export var button_offset: Vector2 = Vector2(15, 15)
@export var shadow_rune_draws: Array[PackedStringArray]
@export var light_rune_draws: Array[PackedStringArray]

var rune_line: Line2D
var lightButtons: Array = []
var shadowButtons: Array = []
var drawing: bool = false
var casting: bool = false

var rune_graph: Array = []

var animation_player: AnimationPlayer
var animation_player2: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	# Reference the Line2D node
	rune_line = $Line2D
	rune_line.clear_points()

	# Create a graph for the shadow and light runes
	rune_graph.append([])
	rune_graph.append([])

	# Reference the AnimationPlayer node
	animation_player = $AnimationPlayer
	animation_player2 = $AnimationPlayer2

	# Connect the button_down signal to the on_button_down function
	for b in $ShadowArea/ShadowRunes.get_children():
		if b is TextureButton:
			shadowButtons.append(b)
			b.button_down.connect(Callable(on_button_down).bind(b))
			b.button_up.connect(Callable(on_button_up).bind(b))
			b.mouse_entered.connect(Callable(hover).bind(b))
	
	for b in $LightArea/LightRunes.get_children():
		if b is TextureButton:
			lightButtons.append(b)
			b.button_down.connect(Callable(on_button_down).bind(b))
			b.button_up.connect(Callable(on_button_up).bind(b))
			b.mouse_entered.connect(Callable(hover).bind(b))

	# Get all spells from the spells group node and subscribe to the end_spell signal
	for spell in get_tree().get_nodes_in_group("Spells"):
		spell.end_spell.connect(end_spell)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if drawing:
		rune_line.points[- 1] = get_global_mouse_position()

func on_button_down(button: TextureButton) -> void:
	# Set the drawing variable to true to start drawing the rune line
	drawing = true

	# Clear the current points in the Line2D
	rune_line.clear_points()

	# Add the first and second point to the Line2D
	rune_line.add_point(button.get_global_position() + button_offset)
	rune_line.add_point(get_global_mouse_position())

	# Add the node to the graph
	add_node(get_node_type(), button.get_name().to_lower()[ - 1])
	
func on_button_up(button: TextureButton) -> void:
	# Set the drawing variable to false to stop drawing the rune line
	drawing = false

	#remove the last point from the line
	rune_line.remove_point(rune_line.points.size() - 1)

	$Timer.start()
	
	#var final_rune_draw = get_final_rune_draw(get_node_type())
	#print(final_rune_draw)
	#end_rune_draw.emit(final_rune_draw)
	#
	## Clear the graph
	#rune_graph[0].clear()
	#rune_graph[1].clear()

func get_node_type() -> String:
	if get_global_mouse_position().x > get_viewport().size.x / 2:
		return "shadow"
	else:
		return "light"

func get_final_rune_draw(type: String) -> String:
	var rune_draw_result: String = "none"
	var rune_d: Array[PackedStringArray] = shadow_rune_draws if type == "shadow" else light_rune_draws
	var graph: Array = rune_graph[0] if type == "shadow" else rune_graph[1]

	# Check if the order of buttons in the graph match any in the rune_draws
	# Foward first
	for rune_draw in rune_d:
		#check for the rune_draws with the same size as the graph
		if rune_draw.size() != graph.size() + 1:
			continue

		for i in range(1, graph.size()):
			# Check if its the last node
			#print(rune_draw[i])
			#print(graph[i - 1])
			if graph[i - 1] != rune_draw[i]:
				break

			if i == graph.size() - 1:
				rune_draw_result = rune_draw[0]

		if rune_draw_result != "none":
			break

	# Backward
	if rune_draw_result == "none":
		for rune_draw in rune_d:
			#check for the rune_draws with the same size as the graph
			if rune_draw.size() != graph.size() + 1:
				continue

			for i in range(graph.size(), 0, -1):
				# Check if its the last node
				#print(graph[graph.size() - i])
				#print(rune_draw[i])
				if graph[graph.size() - i] != rune_draw[i]:
					break
				
				if i == 1:
					rune_draw_result = rune_draw[0]
			
			if rune_draw_result != "none":
				break

	
	return rune_draw_result

# Function for adding a node to a graph
func add_node(graph: String, node_id: String) -> void:
	match graph:
		"shadow":
			rune_graph[0].append(node_id)
		"light":
			rune_graph[1].append(node_id)

func hover(button: TextureButton) -> void:
	if drawing:
		# Check if its not the origin of the line button
		if button.get_global_position() + button_offset != rune_line.points[- 2]:
			# Create one more point in the line
			rune_line.points[- 1] = button.get_global_position() + button_offset;
			rune_line.add_point(button.get_global_position() + button_offset)

			# Add the node to the graph
			add_node(get_node_type(), button.get_name().to_lower()[ - 1])


########################################
# This function is only used as a placeholder because of the
# timing problem of button up and the spells that use the mouse
# on the sme frame
########################################
func _on_timer_timeout():
	var final_rune_draw = get_final_rune_draw(get_node_type())
	#print(final_rune_draw)

	# Clear the graph
	rune_graph[0].clear()
	rune_graph[1].clear()
	
	#clear the rune draw
	rune_line.clear_points()
	

	end_rune_draw.emit(final_rune_draw)
	
	if final_rune_draw != "none":
		hide_light_runes()
		hide_shadow_runes()
		casting = true
	
########################################

func _on_shadow_reveal_mouse_entered():
	if casting: return
	
	animation_player.speed_scale = 1
	animation_player.play("show_shadow")
	if not $HideShadowLight.is_connected("mouse_entered", hide_shadow_runes):	
		$HideShadowLight.mouse_entered.connect(hide_shadow_runes)

func _on_light_reveal_mouse_entered():
	if casting: return
	
	animation_player2.speed_scale = 1
	animation_player2.play("show_light")
	if not $HideShadowLight.is_connected("mouse_entered", hide_light_runes):
		$HideShadowLight.mouse_entered.connect(hide_light_runes)

func hide_shadow_runes():
	if $HideShadowLight.is_connected("mouse_entered", hide_shadow_runes):
		animation_player.speed_scale = 2
		animation_player.play_backwards("show_shadow")
		$HideShadowLight.disconnect("mouse_entered", hide_shadow_runes)
		
func hide_light_runes():
	if $HideShadowLight.is_connected("mouse_entered", hide_light_runes):
		animation_player2.speed_scale = 2
		animation_player2.play_backwards("show_light")
		$HideShadowLight.disconnect("mouse_entered", hide_light_runes)

func end_spell():
	casting = false
	


func _on_end_rune_draw(rune):
	pass # Replace with function body.
