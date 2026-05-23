extends Node3D

var rng = RandomNumberGenerator.new()

@onready var root = $".."
@onready var game = get_tree().root.get_child(0)
@onready var static_door = $StaticDoor
@onready var physics_door = $PhysicsDoor
@onready var sound_player = $PhysicsDoor/AudioStreamPlayer3D
var door_kick_sounds_dir = "res://assets/sound/door_kick_sounds/"
var kick_sounds = [ ]
var is_kicked = false
var time_until_collision_enabled_s = 0.1
const TIME_UNTIL_COLLISION_DISABLED_S = 5

func kick() -> void:
	if is_kicked:
		return
	is_kicked = true
	if static_door:
		static_door.queue_free()
	physics_door.visible = true
	physics_door.freeze = false
	
	var local_force = Vector3(
		rng.randf_range(-250.0, 250.0),
		rng.randf_range(150.0, 250.0),
		rng.randf_range(600.0, 200.0) )
	var global_force = physics_door.global_transform.basis * local_force
	
	physics_door.apply_force(global_force)
	sound_player.play()
	if game.has_method("advance"):
		game.advance()
	await get_tree().create_timer(time_until_collision_enabled_s).timeout
	$PhysicsDoor/CollisionShape3D.disabled = false
	
	await get_tree().create_timer(TIME_UNTIL_COLLISION_DISABLED_S).timeout
	physics_door.freeze = true
	$PhysicsDoor/CollisionShape3D.disabled = true

func _ready() -> void:
	for i in DirAccess.get_files_at(door_kick_sounds_dir):
		if i.ends_with(".ogg"):
			kick_sounds.append(load(door_kick_sounds_dir + i))
			sound_player.set_stream(kick_sounds.pick_random())
	physics_door.freeze = true

var stop = 0.01
var ticks_of_rest = 15
func _process(_delta: float) -> void:
	if physics_door.freeze == false:
		var velocity = physics_door.get_linear_velocity()
		#print(velocity)
		if velocity.x <= stop and velocity.x >= -stop and velocity.y <= stop and velocity.y >= -stop and velocity.z <= stop and velocity.z >= -stop:
			ticks_of_rest -= 1
		else:
			ticks_of_rest = 30
		if ticks_of_rest <= 0:
			physics_door.freeze = true
			$PhysicsDoor/CollisionShape3D.disabled = true
