extends Node3D

@onready var room_marker = $RoomMarker

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func _on_entrance_area_body_entered(body: Node3D) -> void:
	print("you have entered a room")
	pass
