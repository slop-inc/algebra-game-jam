extends State
class_name EnemyDeath
@onready var anim = $"../../cultist"
@onready var agent = self.get_parent().get_parent()
@onready var player = get_tree().get_first_node_in_group("player")
const blood_explosion = preload("res://scenes/enemy/BloodExplosion.tscn")



func Enter():
	#print("Entered Death")
	_die()
	
func _die():
	if agent.explode:
		if agent.is_boss:
			player.end_game()
		var blood_instance = blood_explosion.instantiate()
		get_tree().root.get_child(0).add_child(blood_instance)
		blood_instance.global_position = agent.global_position
		agent.queue_free()
	else:
		if agent.is_boss:
			player.end_game()
		anim._die()
		anim.reparent(get_tree().root.get_child(0))
		agent.queue_free()
