extends Area3D

@export var speed = 10
@export var damage = 500
var dir


func _process(delta):
	global_position += dir * speed * delta


func _on_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(damage)
		queue_free()
