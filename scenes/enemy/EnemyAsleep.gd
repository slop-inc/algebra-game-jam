extends State
class_name EnemyAsleep

func _awake():
	Transitioned.emit(self, "EnemyIdle")
