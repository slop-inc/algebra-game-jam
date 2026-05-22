extends State
class_name EnemyDeath

@onready var agent = self.get_parent().get_parent()


func Enter():
	print("Entered Death")
	
func _die():
	if agent.explode:
		self.queue_free()
	else:
		self.queue_free()
