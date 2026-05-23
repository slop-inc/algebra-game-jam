extends Area3D

@export var speed = 10
@export var damage = 20
var player_damage: float = 5.0
var dir

var is_from_player: bool = false

func _ready():
	print(is_from_player)

func _process(delta):
	global_position += dir * speed * delta


func _on_body_entered(body):
	if body.has_method("take_damage"):
		if body.is_in_group("player") and not is_from_player:
			body.take_damage(player_damage)
			queue_free()
		elif body.is_in_group("enemy") and is_from_player:
			body.take_damage(damage)
			queue_free()
	# TODO: prolaze kroz pod
