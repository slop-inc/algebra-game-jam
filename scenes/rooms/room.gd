extends Node3D

@onready var room_marker = $RoomMarker
@onready var entrance_area = $EntranceArea
@onready var rocks = $Rocks

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

# This is a generic Room type. To see how to expand room behaviour look at straight_playground.tscn


func _on_entrance_area_body_entered(body: Node3D) -> void:
	pass # Replace with function body.
