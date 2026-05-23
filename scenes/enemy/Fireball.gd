extends Area3D

@export var speed = 10
@export var damage = 20
var player_damage: float = 5.0
var dir


func _ready():
	pass
	
func _process(delta):
	global_position += dir * speed * delta


func _on_body_entered(body):
	print("Fireball hit someting")
	print(body)

	if body.is_in_group("player"):
		print("body is player")
		body.take_damage(5.0)
		queue_free()

	elif !body.is_in_group("player") and !body.is_in_group("enemy"):
		queue_free()
		
