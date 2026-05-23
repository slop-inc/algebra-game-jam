extends CanvasLayer

@onready var top_bar = $Control/TopBar
@onready var bottom_bar = $Control/Bottombar
@onready var blood = $Control/DiddyBlud
@onready var avatar = $Control/Avatar
var top_max = -420
var bottom_max = 420

var states = [ ]

# Pass 1.0 for full health
# Pass 0.0 for death
func set_bar_percentage(percentage: float) -> void:
	if percentage < 0.5:
		avatar.texture = states[1]
	elif percentage < 0.25:
		avatar.texture = states[2]
	else:
		avatar.texture = states[0]
	var bottom_tween = get_tree().create_tween()
	await bottom_tween.tween_property(bottom_bar, "position:y", bottom_max * percentage, 2)
	var top_tween = get_tree().create_tween()
	await top_tween.tween_property(top_bar, "position:y", top_max * percentage, 2)

func bloody():
	blood.modulate.a = 0.75
	var tween = get_tree().create_tween()
	tween.tween_property(blood, "modulate:a", 0.0, 3)

func _ready() -> void:
	states.append(load("res://assets/textures/Paper_doll_1.png"))
	states.append(load("res://assets/textures/Paper_doll_2.png"))
	states.append(load("res://assets/textures/Paper_doll_3.png"))
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
