extends CharacterBody3D

# Movement vars
var SPEED = 0.0
var MAXSPEED = 5.0
var JUMP_VELOCITY = 4.
var DECEL = 1
var ACCEL = 0.30
var SENSITIVITY = 0.001

# Dash vars
var dashed_bool = false
var dash_time = 0
var dash_strength = 15

# Slam vars
var slamed_bool = false
var slam_strength = 15

# Fluf vars
var bob_frequency = 1.5
var bob_amplitude = 0.05
var t_bob = 0.0 


@onready var head = $Head
@onready var camera = $Head/Neck/Camera3D
@onready var neck = $Head/Neck

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	
	# Look Around
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_z(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))
	
	# Unlock mouse
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
	# Lock Mouse
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.double_click:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			

func _input(event):
	
	# Dash Input
	if Input.is_action_just_pressed("dash"):
		_dash()
		
	if Input.is_action_just_pressed("slam"):
		if !is_on_floor():
			_slam()
	
# Dash Function
func _dash():
	print("Dashed")
	dashed_bool = true
	#self.global_position = dash_point.global_position
	var direction = camera.global_basis * Vector3.FORWARD
	velocity.x = direction.x * dash_strength
	velocity.z = direction.z * dash_strength
	velocity.y = direction.y * dash_strength
	print(dashed_bool)
	
func _slam():
	print("Slamed")
	slamed_bool = true
	velocity.x = 0
	velocity.z = 0
	velocity.y = -slam_strength

func _physics_process(delta: float) -> void:
	
	if dashed_bool:
		dash_time += 1 * delta 
		print(dash_time)
		if dash_time >= 0.3:
			dash_time = 0
			dashed_bool= false
			print("Dash Done")
			
	if slamed_bool and is_on_floor():
		slamed_bool = false
		print("Slam Done")
		
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

	if input_dir.x < 0:
		neck.rotation.x = lerp_angle(neck.rotation.x, deg_to_rad(-4), 0.02)
	if input_dir.x > 0:
		neck.rotation.x = lerp_angle(neck.rotation.x, deg_to_rad(4), 0.02)
	if input_dir.x == 0:
		neck.rotation.x = lerp_angle(neck.rotation.x, deg_to_rad(0), 0.02)
	
	if is_on_floor() and !dashed_bool and !slamed_bool:
		if direction:
			# Speed up acceleration
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			if SPEED < MAXSPEED:
				SPEED = SPEED + ACCEL
			print("SPEED:",SPEED)
		#elif SPEED > 0:
			# Slow down
			#SPEED = SPEED - DECEL
			#velocity.x = move_toward(velocity.x, SPEED, delta)
			#velocity.z = move_toward(velocity.z, SPEED, delta)
			
			#print("SPEED:",SPEED)

		else:
			# Stop
			SPEED = 0
			velocity.x = move_toward(velocity.x, 0, MAXSPEED)
			velocity.z = move_toward(velocity.z, 0, MAXSPEED)
	elif !dashed_bool and !slamed_bool:
		if direction:
			# Speed up acceleration
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			if SPEED < MAXSPEED:
				SPEED = SPEED + ACCEL
			print("SPEED:",SPEED)
		else:
			velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 2.0)
			velocity.y = lerp(velocity.y, direction.y * SPEED, delta * 2.0)
	move_and_slide()
	
	# Head Bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * bob_frequency) * bob_amplitude
	return(pos)
