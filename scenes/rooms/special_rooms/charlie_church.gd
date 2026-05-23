extends "res://scenes/rooms/room.gd"

@onready var marker_marker = $MarkerMarker
var player

func _ready() -> void:
	super._ready()

func _process(delta: float) -> void:
	super._process(delta)


func _on_marker_marker_body_entered(body: Node3D) -> void:
	player = get_tree().get_first_node_in_group("player")
	player.is_in_boss_room = true
