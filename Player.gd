extends KinematicBody
var isRunning : bool = false
var curHp : int = 10
var maxHp : int = 10
var damage : int = 1
var gold : int = 0
var attackRate : float = 0.3
var lastAttackTime : int = 0
var moveSpeed : float = 5.0
var jumpForce : float = 10.0
var gravity : float = 15.0
var vel : Vector3 = Vector3()
onready var camera = get_node("CameraOrbit")

# called every physics step (60 times a second)
func _physics_process(delta):  
  vel.x = 0
  vel.z = 0
  
  var input = Vector3()
  
  # movement inputs
  if Input.is_action_pressed("up"): input.z -= 1
  if Input.is_action_pressed("down"): input.z += 1
  if Input.is_action_pressed("left"): input.x -= 1
  if Input.is_action_pressed("right"): input.x += 1

  if Input.is_action_just_pressed("boost"): isRunning = true
  if Input.is_action_just_released("boost"): isRunning = false
  
  # normalize the input vector to prevent increased diagonal speed
  input = input.normalized()
  
  # get the relative direction
  var dir = (transform.basis.z * input.z + transform.basis.x * input.x)
  
  # apply the direction to our velocity
  if !isRunning:
   vel.x = dir.x * moveSpeed
   vel.z = dir.z * moveSpeed

  if isRunning:
   vel.x = dir.x * moveSpeed * 5
   vel.z = dir.z * moveSpeed * 5
  
  # gravity
  vel.y -= gravity * delta
  
  if Input.is_action_pressed("jump") and is_on_floor(): vel.y = jumpForce
	
  # move along the current velocity
  vel = move_and_slide(vel, Vector3.UP)
