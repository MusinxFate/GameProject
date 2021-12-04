extends KinematicBody

export var speed = 15
export var fall_acceleration = 50
export var jump_impulse = 20

# cam look
var isRunning : bool = false
var minLookAngle : float = -90.0
var maxLookAngle : float = 90.0
var lookSensitivity : float = 10.0

# vectors
# var vel : Vector3 = Vector3()
var mouseDelta : Vector2 = Vector2()

# components
onready var camera : Camera = get_node("CameraOrbit/Camera")
onready var animationPlayer : AnimationPlayer = get_node("AnimationPlayer")
# onready var muzzle : Spatial = get_node("Camera/Muzzle")

var velocity = Vector3.ZERO

func _physics_process(delta):
	var direction = Vector3.ZERO
	var camera_x = camera.global_transform.basis.x
	var camera_z = camera.global_transform.basis.z

	#MoveRight
	if Input.is_action_pressed("movright"):
		direction += camera_x
		if Input.is_action_pressed("movright") && Input.is_action_pressed("movdown"):
			animationPlayer.play("BackRightWalk")
		else:
			animationPlayer.play("RightWalk")
		
	elif Input.is_action_just_released("movright"):
		stopAnimation()

	#MoveLeft
	if Input.is_action_pressed("movleft"):
		direction -= camera_x
		if Input.is_action_pressed("movleft") && Input.is_action_pressed("movdown"):
			animationPlayer.play("BackLeftWalk")
		else:
			animationPlayer.play("LeftWalk")	
	elif Input.is_action_just_released("movleft"):
		stopAnimation()

	if Input.is_action_pressed("movdown"):
		direction += camera_z
		if ((!animationPlayer.current_animation == "BackLeftWalk") && !animationPlayer.current_animation == "BackRightWalk"):
			animationPlayer.play("BackWalk")
	elif Input.is_action_just_released("movdown"):
		stopAnimation()

	if (Input.is_action_pressed("movup") && !isRunning):
		direction -= camera_z
		animationPlayer.play("Walking")
	elif Input.is_action_just_released("movup"):
		stopAnimation()
		
	if (isRunning && Input.is_action_pressed("movup")):
		direction -= camera_z

	#sprinting
	if ((Input.is_action_pressed("boost") && Input.is_action_pressed("movup")) && (isRunning == false)):
		speed = 15
		isRunning = true
		animationPlayer.get_animation("Running").loop = true
		animationPlayer.play("Running")
	elif ((!Input.is_action_pressed("boost") || !Input.is_action_pressed("movup")) && isRunning == true):
		speed = 5
		isRunning = false
		stopAnimation()


	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	# Jumping.
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		animationPlayer.play("Jumping")

	velocity.y -= fall_acceleration * (delta)
	velocity = move_and_slide(velocity, Vector3.UP)

func stopAnimation():
	print(animationPlayer.get_assigned_animation())
	if (animationPlayer.get_assigned_animation() != "Idle"):
		animationPlayer.stop()
		animationPlayer.play("Idle")

func _ready():
	# hide and lock the mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) 
	var anim = animationPlayer.get_animation("Idle")
	anim.loop = true
	animationPlayer.play("Idle")

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


func _on_AnimationPlayer_animation_finished(anim_name):
	if (anim_name == "Jumping"):
		animationPlayer.play("Landing")
	elif (anim_name == "Landing"):
		animationPlayer.play("Idle")

func _on_AnimationPlayer_animation_started(anim_name):
	if (anim_name == "Jumping"):
		velocity.y += jump_impulse
		velocity = move_and_slide(velocity, Vector3.UP)
