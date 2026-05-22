extends Node3D

@onready var fader = $Camera3D/CanvasLayer/Fader

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_start_pressed() -> void:
	var tween = get_tree().create_tween()
	fader.visible = true
	await tween.tween_property(fader, "modulate:a", 1, 2).finished
	get_tree().change_scene_to_file("res://scenes/ui/cutscene_start.tscn")
