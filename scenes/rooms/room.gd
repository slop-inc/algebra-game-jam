extends Node3D

@onready var room_marker = $RoomMarker
@onready var entrance_area = $EntranceArea
@onready var rocks = $Rocks
#@onready var door = $CatacombsDoor
@onready var enemies = $Enemies
#var game

func _on_entrance_area_body_entered(body: Node3D) -> void:
	for enemy in enemies.get_children():
		print(enemy)
		print(enemy.is_awake)
		enemy.is_awake = true

func _ready() -> void:
	#game = get_tree().root.get_child(0)
	pass

func _process(_delta: float) -> void:
	pass

# This is a generic Room type. To see how to expand room behaviour look at straight_playground.tscn
