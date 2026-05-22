extends State
class_name EnemyDeath

@onready var agent = self.get_parent().get_parent()
const blood_explosion = preload("res://scenes/enemy/BloodExplosion.tscn")



func Enter():
	print("Entered Death")
	_die()
	
func _die():
	if agent.explode:
		var blood_instance = blood_explosion.instantiate()
		get_tree().root.get_child(0).add_child(blood_instance)
		blood_instance.global_position = agent.global_position
		agent.queue_free()
	else:
		agent.queue_free()
