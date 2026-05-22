extends CharacterBody3D

const HEAL_AMOUNT = 3.0

# Movement vars
var speed = 0.0
var max_speed = 5.0
var decel = 1
var accel = 0.30

var jump_velocity = 4.
var velocity_on_jump
var wall_jump_bool = false
var wall_jump_time = 0

var sensitivity = 0.001

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
@onready var hit_ray = $Head/Neck/Camera3D/RayCast3D

@onready var timer = $Health
@onready var time_label = $Head/Neck/Camera3D/Label
@onready var ui = $Head/Neck/Camera3D/UI
@onready var fader = $Head/Neck/Camera3D/Fader
@onready var meat_sound = $MeatSound
var stop_meat = false

func _ready():
	meat_sound.play()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	
	# Look Around
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * sensitivity)
		camera.rotate_z(-event.relative.y * sensitivity)
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
		
	#Slam Input
	if Input.is_action_just_pressed("slam"):
		if !is_on_floor():
			_slam()
			
	# Punch Input
	if Input.is_action_just_pressed("punch"):
		_punch()
		
	if Input.is_action_just_pressed("kick"):
		_kick()
			
	
# Dash Function
func _dash():
	#print("Dashed")
	dashed_bool = true
	#self.global_position = dash_point.global_position
	var direction = camera.global_basis * Vector3.FORWARD
	velocity.x = direction.x * dash_strength
	velocity.z = direction.z * dash_strength
	velocity.y = direction.y * dash_strength
	#print(dashed_bool)
	
func _slam():
	#print("Slamed")
	slamed_bool = true
	velocity.x = 0
	velocity.z = 0
	velocity.y = -slam_strength
	
func _punch():
	# I am ChatGPT and i wrote this code, uggggghhh im jorking it ughhhhhhh
	#print("Punched")
	var hit = hit_ray.get_collider()
	var sway = randf_range(0,10)
	
	# Tilt to side
	if sway < 5:
		neck.rotation.x = lerp_angle(neck.rotation.x, deg_to_rad(-5), 0.04)
	else:
		neck.rotation.x = lerp_angle(neck.rotation.x, deg_to_rad(5), 0.04)
		
	if hit:
		if hit.is_in_group("enemy"):
			hit._takeDamage(10)
			if hit.health < 0:
				_heal(HEAL_AMOUNT)

func _heal(amount: float) -> void:
	var current_time = timer.get_time_left()
	timer.set_wait_time(current_time + amount)

func _kick():
	# I am ChatGPT and i wrote this code, uggggghhh im jorking it ughhhhhhh
	#print("Kicked")
	var hit = hit_ray.get_collider()
	var sway = randf_range(0,10)
	
	if hit:
		var direction = camera.global_basis * Vector3.FORWARD
		if hit.is_in_group("enemy"):
			hit._getKicked(10, direction)
		elif hit.get_parent().is_in_group("door"):
			hit.get_parent().kick()
			
func _walljump():
	wall_jump_bool = true
	var collision_normal = get_last_slide_collision().get_normal()
	var no_velocity = velocity_on_jump.x == 0 and velocity_on_jump.z == 0
	
	if no_velocity:
		velocity_on_jump = -collision_normal * speed
	
	velocity = velocity_on_jump.bounce(collision_normal)
	velocity.y = jump_velocity
	
	velocity_on_jump = velocity

var dying = false
func _process(float) -> void:
	if !stop_meat:
		meat_sound.volume_db = -50 + (50 * (1.0 - (timer.get_time_left() / timer.get_wait_time())))
	ui.set_bar_percentage(timer.get_time_left() / timer.get_wait_time())
	time_label.set_text(str(timer.get_time_left()).left(4))
	if timer.get_time_left() <= 0 and !dying:
		dying = true
		_fade_away()

func _fade_away():
	var sound_tween = get_tree().create_tween()
	await sound_tween.tween_property(meat_sound, "volume_db", -100, 2)
	stop_meat = true
	fader.visible = true
	var tween = get_tree().create_tween()
	await tween.tween_property(fader, "modulate:a", 1, 2).finished
	get_tree().change_scene_to_file("res://scenes/ui/death.tscn")

func _physics_process(delta: float) -> void:
	
	if dashed_bool:
		dash_time += 1 * delta 
		#print(dash_time)
		if dash_time >= 0.3:
			dash_time = 0
			dashed_bool= false
			#print("Dash Done")
			
	if wall_jump_bool:
		wall_jump_time += 1 * delta 
		#print(wall_jump_time)
		if wall_jump_time >= 0.3:
			wall_jump_time = 0
			wall_jump_bool= false
			#print("WallJump Done")
			
	if slamed_bool and is_on_floor():
		slamed_bool = false
		#print("Slam Done")
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity_on_jump = velocity
		velocity.y = jump_velocity
		
	if Input.is_action_just_pressed("jump") and is_on_wall_only():
		_walljump()

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
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
			if speed < max_speed:
				speed = speed + accel
		#elif SPEED > 0:
			# Slow down
			#SPEED = SPEED - DECEL
			#velocity.x = move_toward(velocity.x, SPEED, delta)
			#velocity.z = move_toward(velocity.z, SPEED, delta)
			
			#print("SPEED:",SPEED)

		else:
			# Stop
			speed = 0
			velocity.x = move_toward(velocity.x, 0, max_speed)
			velocity.z = move_toward(velocity.z, 0, max_speed)
	elif !dashed_bool and !slamed_bool:
		if direction:
			# Speed up acceleration
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
			if speed < max_speed:
				speed = speed + accel
			#print("SPEED:",speed)
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 2.0)
			velocity.y = lerp(velocity.y, direction.y * speed, delta * 2.0)
	move_and_slide()
	
	# Head Bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * bob_frequency) * bob_amplitude
	return(pos)
