extends Node3D

@onready var static_door = $StaticDoor
@onready var physics_door = $PhysicsDoor

func _kick() -> void:
	if static_door:
		static_door.queue_free()
	physics_door.visible = true
	physics_door.freeze = false
	physics_door.apply_force(Vector3(-500, 250, -600))

func _ready() -> void:
	physics_door.freeze = true

func _process(delta: float) -> void:
	pass
