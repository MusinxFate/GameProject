extends KinematicBody

export var speed = 15
export var fall_acceleration = 50
export var jump_impulse = 20

# cam look
var minLookAngle : float = -90.0
var maxLookAngle : float = 90.0
var lookSensitivity : float = 10.0

# vectors
# var vel : Vector3 = Vector3()
var mouseDelta : Vector2 = Vector2()

# components
onready var camera : Camera = get_node("CameraOrbit/Camera")
# onready var muzzle : Spatial = get_node("Camera/Muzzle")

var velocity = Vector3.ZERO

func _physics_process(delta):
	var direction = Vector3.ZERO
	var camera_x = camera.global_transform.basis.x
	var camera_z = camera.global_transform.basis.z

	if Input.is_action_pressed("movright"):
		direction += camera_x
	if Input.is_action_pressed("movleft"):
		direction -= camera_x
	if Input.is_action_pressed("movdown"):
		direction += camera_z
	if Input.is_action_pressed("movup"):
		direction -= camera_z
		get_node("AnimationPlayer").play("Walking")
	elif Input.is_action_just_released("movup"):
		get_node("AnimationPlayer").stop()
		get_node("AnimationPlayer").play("Idle")
	#sprinting
	if Input.is_action_pressed("boost"):
		speed = 15
	if Input.is_action_just_released("boost"):
		speed = 5



	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	# Jumping.
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y += jump_impulse

	velocity.y -= fall_acceleration * (delta)
	velocity = move_and_slide(velocity, Vector3.UP)

func _ready():
	# hide and lock the mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) 
	var anim = get_node("AnimationPlayer").get_animation("Idle")
	anim.loop = true
	get_node("AnimationPlayer").play("Idle")

func _process(delta):
	# rotate the camera along the x axis
	camera.rotation_degrees.x -= mouseDelta.y * lookSensitivity * delta

	# clamp camera x rotation axis
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, minLookAngle, maxLookAngle)

	# rotate the player along their y-axis
	rotation_degrees.y -= mouseDelta.x * lookSensitivity * delta

	# reset the mouseDelta vector
	mouseDelta = Vector2()

func _input(event):
	if event is InputEventMouseMotion:
		mouseDelta = event.relative
