extends CanvasLayer

@onready var text_container = $Control/Control/VBoxContainer
var current_text = 0
var can_advance = true
@onready var amount_of_labels = 4 #text_container.get_child_count()
var text_array = [ ]

func _advance() -> void:
	if !can_advance:
		return
	if current_text >= amount_of_labels:
		get_tree().change_scene_to_file("res://scenes/rooms/game.tscn")
		return
	
	can_advance = false
	
	var label = text_array[0]
	text_array.pop_front()
	var should_text = label.get_text()
	label.set_text("")
	label.visible = true
	var future_text = ""
	for i in should_text:
		if i == "^":
			await get_tree().create_timer(0.5).timeout
			continue
		$AudioStreamPlayer2D.play()
		future_text += i
		label.set_text(future_text)
		await get_tree().create_timer(0.05).timeout
		
	current_text += 1
	can_advance = true

func _ready() -> void:
	for i in text_container.get_child_count():
		if text_container.get_child(i) is Label:
			text_array.append(text_container.get_child(i))
	pass

func _process(_delta: float) -> void:
	pass
