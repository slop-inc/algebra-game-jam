extends Node3D

@onready var particle = $Debris
@onready var particle2 = $Debris2
@onready var particle3 = $Debris3
@onready var sound = $Sound

func _ready() -> void:
	sound.play()
	print(particle)
	particle.emitting = true
	particle2.emitting = true
	particle3.emitting = true
