extends Node3D

@onready var lights = $Node
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	while true:
		for light in lights.get_children():
			var random = rng.randf_range(0.5, 1.0)
			var tween = get_tree().create_tween()
			await tween.tween_property(light, "light_energy", random, 0.5)
		await get_tree().create_timer(0.5).timeout
func _process(delta: float) -> void:
	pass
