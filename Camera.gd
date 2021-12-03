extends Camera

var mouse_sens = 0.3
var camera_anglev=0

func _ready():
	pass # Replace with function body.

func _input(event):     
	if event is InputEventMouseMotion:
		if (rotation_degrees.x < -73):
			rotation_degrees.x = -73
