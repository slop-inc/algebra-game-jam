extends Node3D

@onready var root = $".."
@onready var static_door = $StaticDoor
@onready var physics_door = $PhysicsDoor
@onready var sound_player = $PhysicsDoor/AudioStreamPlayer3D
var door_kick_sounds_dir = "res://assets/sound/door_kick_sounds/"
var kick_sounds = [ ]
var is_kicked = false

func _kick() -> void:
	if is_kicked:
		return
	is_kicked = true
	if static_door:
		static_door.queue_free()
	physics_door.visible = true
	physics_door.freeze = false
	physics_door.apply_force(Vector3(-500, 250, -600))
	sound_player.play()
	root.advance()

func _ready() -> void:
	for i in DirAccess.get_files_at(door_kick_sounds_dir):
		if i.ends_with(".ogg"):
			kick_sounds.append(load(door_kick_sounds_dir + i))
			sound_player.set_stream(kick_sounds.pick_random())
	physics_door.freeze = true

func _process(delta: float) -> void:
	pass
