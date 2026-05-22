extends Node3D

@onready var particle = $Debris

func _ready() -> void:
	print(particle)
	particle.emitting = true
