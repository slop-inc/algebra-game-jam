extends CanvasLayer

@onready var top_bar = $Control/TopBar
@onready var bottom_bar = $Control/Bottombar
@onready var blood = $Control/DiddyBlud
var top_max = -420
var bottom_max = 420

# Pass 1.0 for full health
# Pass 0.0 for death
func set_bar_percentage(percentage: float) -> void:
	var bottom_tween = get_tree().create_tween()
	await bottom_tween.tween_property(bottom_bar, "position:y", bottom_max * percentage, 2)
	var top_tween = get_tree().create_tween()
	await top_tween.tween_property(top_bar, "position:y", top_max * percentage, 2)

func bloody():
	blood.modulate.a = 0.75
	var tween = get_tree().create_tween()
	tween.tween_property(blood, "modulate:a", 0.0, 3)

func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
