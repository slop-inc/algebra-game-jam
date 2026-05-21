extends CharacterBody3D


var SPEED = 0.0
var MAXSPEED = 5.0
var JUMP_VELOCITY = 4.
var DECEL = 0.80
var ACCEL = 0.20
var SENSITIVITY = 0.008


@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var dash_point = $Head/Camera3D/SpringArm3D/DashPoint

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_z(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))
	
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.double_click:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
func _input(event):
	if Input.is_action_just_pressed("dash"):
		_dash()
	
func _dash():
	print("Dashed")
	#self.global_position = dash_point.global_position
	var direction = camera.global_basis * Vector3.FORWARD
	velocity.x = direction.x * 10
	velocity.z = direction.z * 10

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left_move", "right_move", "up_move", "down_move")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if is_on_floor():
		if direction:
			# Speed up acceleration
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			if SPEED < MAXSPEED:
				SPEED = SPEED + ACCEL
			print("SPEED:",SPEED)
		elif SPEED > 0:
			# Slow down
			SPEED = SPEED - DECEL
			velocity.x = move_toward(velocity.x, SPEED, 0)
			velocity.z = move_toward(velocity.z, SPEED, 0)
			print("SPEED:",SPEED)
		else:
			# Stop
			SPEED = 0
			velocity.x = move_toward(velocity.x, 0, MAXSPEED)
			velocity.z = move_toward(velocity.z, 0, MAXSPEED)
	else:
		velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 2.0)
		velocity.y = lerp(velocity.y, direction.y * SPEED, delta * 2.0)
	move_and_slide()
