extends StaticBody2D

class_name ShadowObject

var lightO: LightOccluder2D
var shadowSegments: Array[CollisionShape2D]
var drawing: bool = false
var light: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	lightO = $LightOccluder2D
	shadowSegments.resize(4)
	shadowSegments[0] = $CollisionShape2D
	shadowSegments[1] = $CollisionShape2D2
	shadowSegments[2] = $CollisionShape2D3
	shadowSegments[3] = $CollisionShape2D4


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if drawing:
		# Get the mouse position
		var pos = get_global_mouse_position()
		
		# Set the last point in the light occluder to the mouse position
		var p = lightO.occluder
		p.polygon[1] = pos
		lightO.occluder = p
		#print(pos)
		#print(lightO.occluder.polygon[1])

func start_draw(pos: Vector2, light: Node2D) -> void:
	# Clear the collision shapes
	for s in shadowSegments:
		s.shape = null
	
	# Set the first point inthe light occluder to the mouse position
	var p = lightO.occluder
	p.polygon[0] = pos
	lightO.occluder = p
	
	drawing = true
	self.light = light
	
func stop_draw() -> void:
	drawing = false
	
	# Check if the iight is point or directional
	 
	if light is PointLight2D:
		# Create the 4 shadow segments to form the shadow object
		shadowSegments[0].shape = SegmentShape2D.new()
		shadowSegments[0].shape.a = lightO.occluder.polygon[0]
		shadowSegments[0].shape.b = lightO.occluder.polygon[1]

		shadowSegments[1].shape = SegmentShape2D.new()
		shadowSegments[1].shape.a = lightO.occluder.polygon[0]
		shadowSegments[1].shape.b = lightO.occluder.polygon[0] + ((lightO.occluder.polygon[0] - light.global_position).normalized() * 1000)

		shadowSegments[2].shape = SegmentShape2D.new()
		shadowSegments[2].shape.a = lightO.occluder.polygon[1]
		shadowSegments[2].shape.b = lightO.occluder.polygon[1] + ((lightO.occluder.polygon[1] - light.global_position).normalized() * 1000)

		shadowSegments[3].shape = SegmentShape2D.new()
		shadowSegments[3].shape.a = lightO.occluder.polygon[0] + ((lightO.occluder.polygon[0] - light.global_position).normalized() * 1000)
		shadowSegments[3].shape.b = lightO.occluder.polygon[1] + ((lightO.occluder.polygon[1] - light.global_position).normalized() * 1000)

	elif light is DirectionalLight2D:
		# get the rotation of the light
		var rot = light.global_rotation
		
		# Create the 4 shadow segments to form the shadow object
		shadowSegments[0].shape = SegmentShape2D.new()
		shadowSegments[0].shape.a = lightO.occluder.polygon[0]
		shadowSegments[0].shape.b = lightO.occluder.polygon[1]

		shadowSegments[1].shape = SegmentShape2D.new()
		shadowSegments[1].shape.a = lightO.occluder.polygon[0]
		shadowSegments[1].shape.b = lightO.occluder.polygon[0] + Vector2(0, 1000).rotated(rot)

		shadowSegments[2].shape = SegmentShape2D.new()
		shadowSegments[2].shape.a = lightO.occluder.polygon[1]
		shadowSegments[2].shape.b = lightO.occluder.polygon[1] + Vector2(0, 1000).rotated(rot)

		shadowSegments[3].shape = SegmentShape2D.new()
		shadowSegments[3].shape.a = shadowSegments[1].shape.b
		shadowSegments[3].shape.b = shadowSegments[2].shape.b

	else:
		print("Light type not supported")
