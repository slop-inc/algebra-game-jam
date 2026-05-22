extends StaticBody3D

var max_health = 100
var health = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = max_health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if health <= 0:
		print("died")
	
func _takeDamage(dmg: int):
	health = health - dmg
	print("got hit")
