extends Node3D

### ### #### ##### ###### ##### #### ### ###
### CHANGE ORDER OF GENERATED ROOMS HERE ###
### ### #### ##### ###### ##### #### ### ###
# 1. Spawn room
# 2. Tutorial room, then:
var room_generation = [ "catacomb", "catacomb", "catacomb", "catacomb",
						"church", "church", "church", "church", "church",
						"forest", "forest", "forest", "forest", "forest" ]

# dep
var rng = RandomNumberGenerator.new()
var rooms_dir = "res://scenes/rooms/"

# Special rooms
var playground = preload("res://scenes/rooms/special_rooms/straight_playground.tscn")

@onready var newest_room = $Rooms/StartRoom
@onready var rooms = $Rooms
@onready var bend = 0
var doors_kicked = 0

# Generate random room of specified level
# Pass "catacomb" / "church" / "forest"
func _generate_room() -> void:
	# 50% chance for straight, 25% for each curve
	var random = rng.randf_range(0.0, 1.0)
	var room_type = "straight"
	match bend:
		-1:
			if random < 0.5:
				room_type = "curved_right"
				bend += 1
		0:
			if random < 0.33:
				room_type = "curved_left"
				bend -= 1
			elif random < 0.66:
				room_type = "curved_right"
				bend += 1
		1:
			if random < 0.5:
				room_type = "curved_left"
				bend -= 1
	
	# Selecting random room from [area > type]
	var area = room_generation[0]
	room_generation.pop_front()
	print(area)
	print(room_generation)
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
	_spawn_room(scene)

func _spawn_room(room: PackedScene) -> void:
	var future_room = room.instantiate()
	print(newest_room.position)
	print(newest_room.room_marker)
	newest_room.room_marker.add_child(future_room)
	newest_room = future_room
	newest_room.reparent(rooms)

func _del_oldest_room():
	rooms.get_child(0).queue_free()

func advance():
	if doors_kicked > 2:
		_generate_room()
		_del_oldest_room()
	

func _ready() -> void:
	_spawn_room(playground)
	for i in range(1):
		_generate_room()

func _process(_delta: float) -> void:
	pass
