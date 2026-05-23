extends Node3D

@onready var particle = $Debris
@onready var particle2 = $Debris2
@onready var particle3 = $Debris3

func _ready() -> void:
	print(particle)
	particle.emitting = true
	particle2.emitting = true
	particle3.emitting = true
