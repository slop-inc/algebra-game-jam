extends Node

@export var next_scene_path = "res://path/to/scene.tscn"

@onready var text_container = $Node2D/Control/Control/VBoxContainer
@onready var texture = $Node2D/Control/Control/TextureRect
@onready var fader = $CanvasLayer/ColorRect
var current_text = 0
var can_advance = true
@onready var amount_of_labels: int
var text_array = [ ]
@onready var sound = $AudioStreamPlayer2D2

func _advance() -> void:
	if !can_advance:
		return
	if current_text >= amount_of_labels:
		var tween = get_tree().create_tween()
		await tween.tween_property(fader, "modulate:a", 1, 2).finished
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file(next_scene_path)
		return
	
	can_advance = false
	
	var label = text_array[0]
	text_array.pop_front()
	var should_text = label.get_text()
	label.set_text("")
	label.visible = true
	var future_text = ""
	if label.name == "TriggerLabel":
		var tween = get_tree().create_tween()
		tween.tween_property(texture, "modulate:a", 0.75, 2)
	for i in should_text:
		if i == "^":
			await get_tree().create_timer(0.5).timeout
			continue
		elif i == "[":
			$DoorOpen.play()
			$AudioStreamPlayer2D.pitch_scale = 0.10
			continue
		elif i == "]":
			$DoorOpen.play()
			$AudioStreamPlayer2D.pitch_scale = 0.25
			continue
		$AudioStreamPlayer2D.play()
		future_text += i
		label.set_text(future_text)
		await get_tree().create_timer(0.05).timeout
		
	current_text += 1
	can_advance = true

func _ready() -> void:
	sound.volume_db = 10
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	for i in text_container.get_child_count():
		if text_container.get_child(i) is Label:
			text_array.append(text_container.get_child(i))
	amount_of_labels = len(text_array)

func _process(_delta: float) -> void:
	pass

func _on_button_2_pressed() -> void:
	var tween = get_tree().create_tween()
	await tween.tween_property(fader, "modulate:a", 1, 2).finished
	get_tree().change_scene_to_file(next_scene_path)
