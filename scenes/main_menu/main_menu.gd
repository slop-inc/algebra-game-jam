extends Node3D

var rng = RandomNumberGenerator.new()

@onready var fader = $Camera3D/CanvasLayer/Fader
@onready var ui = $Camera3D/UI

func _ready() -> void:
	while true:
		await get_tree().create_timer(0.5).timeout
		var random = rng.randf_range(0.25, 0.5)
		ui.set_bar_percentage(random)

func _process(delta: float) -> void:
	pass

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_start_pressed() -> void:
	var tween = get_tree().create_tween()
	fader.visible = true
	await tween.tween_property(fader, "modulate:a", 1, 2).finished
	get_tree().change_scene_to_file("res://scenes/ui/cutscene_start.tscn")
