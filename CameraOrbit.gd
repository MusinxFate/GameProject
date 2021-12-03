extends Spatial

var lookSensitivity : float = 15.0
var minLookAngle : float = -0.0
var maxLookAngle : float = 1.0
var mouseDelta : Vector2 = Vector2()
onready var player = get_parent()
onready var camera = get_node("Camera")

func _input(event):  
	if event is InputEventMouseMotion: mouseDelta = event.relative
	if (event is InputEventMouseMotion) :
		print(camera.rotation_degrees.x)
		if (camera.rotation_degrees.x < 73):
			camera.rotation_degrees.x = 73

func _process(delta):  
	var rot = Vector3(mouseDelta.y, mouseDelta.x, 0) * lookSensitivity * delta	
	rotation_degrees.x -= rot.x
	rotation_degrees.x = clamp(rotation_degrees.x, minLookAngle, maxLookAngle)
  
	player.rotation_degrees.y -= rot.y
  
	mouseDelta = Vector2()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
