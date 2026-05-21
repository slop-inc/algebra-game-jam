extends Node3D

var rng = RandomNumberGenerator.new()

var rooms_dir = "res://scenes/rooms/"

@onready var bend = 0

# Pass "catacomb" / "church" / "forest"
func _generate_room(area: String) -> void:
	# 50% chance for straight, 25% for each curve
	var room_type = "straight"
	var random = rng.randf_range(0.0, 1.0)
	if random < 0.25:
		room_type = "curved_left"
	elif random < 0.5:
		room_type = "curved_right"
	
	# Hack at making rooms not clip into each other.
	if bend == -1 and room_type == "curved_left":
		room_type = "straight"
	if bend == 1 and room_type == "curved_right":
		room_type = "straight"
	
	# Selecting random room from [area > type]
	var selected_room_dir = rooms_dir + area + "/" + room_type + "/"
	var room_scenes = [ ]
	for room in DirAccess.get_files_at(selected_room_dir):
		if room.ends_with(".tscn"):
			room_scenes.append(room)
	var random_room = room_scenes.pick_random()
	var room_path = selected_room_dir + random_room
	print("I have selected the following room: " + room_path)
	
	# Spawning the room
	var scene = load(room_path)
	room_marker.add_child(scene.instantiate())
	
	pass

func _ready() -> void:
	var room_marker = $room_marker
	_generate_room("catacomb")
	pass


func _process(delta: float) -> void:
	pass
