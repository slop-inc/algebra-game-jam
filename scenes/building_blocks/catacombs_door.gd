extends Node3D

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
	physics_door.apply_force(Vector3(-250, 250, -600))
	sound_player.play()
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

func _process(delta: float) -> void:
	#print(physics_door.get_linear_velocity())
	
	pass
