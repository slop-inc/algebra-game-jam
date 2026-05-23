extends State
class_name EnemyAsleep

@onready var agent = self.get_parent().get_parent()

func Enter():
	print("Entered Sleep")
	
	
func Physics_Update(delta):
	_awake()
	

func _awake():
	print("Awoke")
	
	if agent.is_ranged:
		Transitioned.emit(self, "ranged")
	else:
		Transitioned.emit(self, "chase")
func Exit():
	print("Left Sleep")
