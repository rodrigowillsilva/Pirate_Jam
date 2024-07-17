extends StaticBody2D

class_name ShadowObject

var lightO: LightOccluder2D
var shadowPoints: PackedVector2Array
var drawing: bool = false
var light: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	lightO = $LightOccluder2D
	shadowPoints.resize(4)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if drawing:
		# Get the mouse position
		var pos = get_global_mouse_position()
		
		# Set the last point in the light occluder to the mouse position
		var p = lightO.occluder
		p.polygon[1] = pos
		lightO.occluder = p
		print(pos)
		print(lightO.occluder.polygon[1])

func start_draw(pos: Vector2, light: Node2D) -> void:
	# Clear the shadow points
	shadowPoints.clear()
	shadowPoints.resize(4)
	
	# Set the first point inthe light occluder to the mouse position
	var p = lightO.occluder
	p.polygon[0] = pos
	lightO.occluder = p
	
	drawing = true
	self.light = light
	
func stop_draw() -> void:
	drawing = false
	print(shadowPoints.size())
	
	# ceate the shadow points to form the static body
	shadowPoints[0] = lightO.occluder.polygon[0] + (lightO.occluder.polygon[0] - light.global_position) * 1000
	shadowPoints[3] = lightO.occluder.polygon[1] + (lightO.occluder.polygon[1] - light.global_position) * 1000
	shadowPoints[1] = lightO.occluder.polygon[0] 
	shadowPoints[2] = lightO.occluder.polygon[1]
	
	$CollisionPolygon2D.polygon = shadowPoints
