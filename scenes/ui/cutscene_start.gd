extends CanvasLayer

@onready var text_container = $Control/Control/VBoxContainer
var current_text = 0

func _advance() -> void:
	var label = text_container.get_child(current_text)
	var should_text = label.get_text()
	label.set_text("")
	label.visible = true
	var future_text = ""
	for i in should_text:
		future_text += i
		label.set_text(future_text)
		await get_tree().create_timer(0.1).timeout
	current_text += 1

func _ready() -> void:
	var text_array = [ ]
	for i in text_container.get_child_count():
		text_array.append(text_container.get_child(i))
	pass

func _process(_delta: float) -> void:
	pass
