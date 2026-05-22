extends Node3D

@onready var static_door = $StaticDoor
@onready var physics_door = $PhysicsDoor
@onready var sound_player = $PhysicsDoor/AudioStreamPlayer3D
var door_kick_sounds_dir = "res://assets/sound/door_kick_sounds/"

func _kick() -> void:
	var sounds = [ ]
	if static_door:
		static_door.queue_free()
	physics_door.visible = true
	physics_door.freeze = false
	physics_door.apply_force(Vector3(-500, 250, -600))
	for sound in DirAccess.get_files_at(door_kick_sounds_dir):
		sounds.append(sound)
	sound_player.set_stream(door_kick_sounds_dir + sounds.pick_random())
	sound_player.play()

func _ready() -> void:
	physics_door.freeze = true

func _process(delta: float) -> void:
	pass
